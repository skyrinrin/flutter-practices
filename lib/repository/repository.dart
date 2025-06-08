import 'package:task_app/domain/domain.dart';

abstract class Repository {
  Future<void> addTask(Task task);
  // Future<List<Task>> getTasks();
  Future<void> saveTasks(List<Task> tasks);
}
