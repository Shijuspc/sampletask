class Task {
  String id;
  String title;
  String category;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.completed,
  });

  // Convert Task object to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'completed': completed,
    };
  }

  // Convert Firestore Map to Task object
  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      title: data['title'] ?? 'Untitled Task',
      category: data['category'] ?? 'General',
      completed: data['completed'] ?? false,
    );
  }
}
