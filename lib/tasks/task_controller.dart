import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'task_model.dart';
import 'task_service.dart';

final taskProvider = StreamProvider<List<Task>>((ref) {
  return TaskService().getTasks();
});
