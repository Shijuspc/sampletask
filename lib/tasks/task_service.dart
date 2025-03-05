import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'task_model.dart';

class TaskService {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) async {
    DocumentReference docRef = await _taskCollection.add(task.toMap());
    await docRef.update({'id': docRef.id});

    // Send FCM notification
    FirebaseMessaging.instance.subscribeToTopic("tasks");
    FirebaseMessaging.instance.sendMessage(
      to: "tasks",
      data: {"title": "New Task Added", "body": task.title},
    );
  }

  Future<void> updateTask(Task task) async {
    await _taskCollection.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _taskCollection.doc(id).delete();
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
