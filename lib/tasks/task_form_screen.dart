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
  String selectedCategory = "Work"; // Default category

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      selectedCategory = widget.task!.category;
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Task Title"),
            ),
            SizedBox(height: 16),
            Text("Category",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedCategory,
              items: ["Work", "Personal", "Shopping", "Others"]
                  .map((category) =>
                      DropdownMenuItem(value: category, child: Text(category)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
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
                    category: selectedCategory,
                    completed: false,
                  ));
                } else {
                  // Update existing task
                  await taskService.updateTask(Task(
                    id: widget.task!.id,
                    title: titleController.text,
                    category: selectedCategory,
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
