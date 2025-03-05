import 'package:cloud_firestore/cloud_firestore.dart';

import '../notifications/fcm_service.dart';
import 'task_model.dart';

class TaskService {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) async {
    DocumentReference docRef = await _taskCollection.add(task.toMap());
    await docRef.update({'id': docRef.id});

    FCMService().showNotification("New Task", task.title);
  }

  Future<void> updateTask(Task task) async {
    await _taskCollection.doc(task.id).update(task.toMap());

    FCMService().showNotification("Update Task", task.title);
  }

  Future<void> deleteTask(String id) async {
    await _taskCollection.doc(id).delete();

    FCMService().showNotification("Deleted Task", id);
  }

  Stream<List<Task>> getTasks() {
    return _taskCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
              (doc) => Task.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
