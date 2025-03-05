import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'task_model.dart';
import 'task_service.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? task;

  TaskFormScreen({this.task}); // If task is null, it's an "Add" operation.

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      categoryController.text = widget.task!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.task == null ? "Add Task" : "Edit Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Task Title"),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: "Category"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final taskService = TaskService();
                if (widget.task == null) {
                  // Add new task
                  await taskService.addTask(Task(
                    id: "",
                    title: titleController.text,
                    category: categoryController.text,
                    completed: false,
                  ));
                } else {
                  // Update existing task
                  await taskService.updateTask(Task(
                    id: widget.task!.id,
                    title: titleController.text,
                    category: categoryController.text,
                    completed: widget.task!.completed,
                  ));
                }
                Navigator.pop(context);
              },
              child: Text(widget.task == null ? "Add Task" : "Update Task"),
            ),
          ],
        ),
      ),
    );
  }
}
