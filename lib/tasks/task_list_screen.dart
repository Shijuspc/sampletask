import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_controller.dart';
import '../auth/login_screen.dart';
import '../theme/theme_provider.dart';
import 'task_controller.dart';
import 'task_form_screen.dart';
import 'task_service.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  String selectedCategory = "All";
  Set<String> selectedTasks = {};

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Manager",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
        ),
        actions: [
          Text(
            "Dark mode",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Transform.scale(
            scale: 0.6,
            child: Switch(
              activeColor: Colors.black,
              value: ref.watch(themeProvider),
              onChanged: (value) =>
                  ref.read(themeProvider.notifier).toggleTheme(value),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
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
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(8)),
                child: SizedBox(
                  width: 150,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    menuWidth: 180,
                    value: selectedCategory,
                    dropdownColor:
                        Theme.of(context).inputDecorationTheme.fillColor,
                    style: Theme.of(context).textTheme.bodyMedium,
                    items: ["All", "Work", "Personal", "Shopping", "Others"]
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down,
                        color: Colors.blue), // Custom dropdown icon
                    underline: Container(
                      height: 0,
                      color: Colors.blue, // Underline color
                    ),
                    borderRadius:
                        BorderRadius.circular(8), // Rounded dropdown menu
                  ),
                ),
              ),
              if (selectedTasks.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: deleteSelectedTasks, // Delete selected tasks
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
                    final isSelected = selectedTasks.contains(task.id);

                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.category),
                      leading: Checkbox(
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedTasks.add(task.id);
                            } else {
                              selectedTasks.remove(task.id);
                            }
                          });
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

  void deleteSelectedTasks() {
    for (String taskId in selectedTasks) {
      TaskService().deleteTask(taskId);
    }
    setState(() {
      selectedTasks.clear();
    });
  }
}
