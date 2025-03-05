import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_controller.dart';
import '../auth/login_screen.dart';
import '../theme/theme_provider.dart';
import 'task_controller.dart';
import 'task_form_screen.dart';
import 'task_model.dart';
import 'task_service.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Manager",
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedCategory,
                items: ["All", "Work", "Personal", "Shopping", "Others"]
                    .map((category) => DropdownMenuItem(
                        value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              Switch(
                value: ref.watch(themeProvider),
                onChanged: (value) =>
                    ref.read(themeProvider.notifier).toggleTheme(value),
              ),
            ],
          ),
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                final filteredTasks = selectedCategory == "All"
                    ? tasks
                    : tasks
                        .where((task) => task.category == selectedCategory)
                        .toList();

                if (filteredTasks.isEmpty) {
                  return Center(child: Text("No tasks available"));
                }
                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.category),
                      leading: Checkbox(
                        value: task.completed,
                        onChanged: (value) {
                          TaskService().updateTask(
                            Task(
                              id: task.id,
                              title: task.title,
                              category: task.category,
                              completed: value ?? false,
                            ),
                          );
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TaskFormScreen(task: task),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              TaskService().deleteTask(task.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text("Error: ${err.toString()}")),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TaskFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
