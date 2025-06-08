import 'package:task_app/domain/domain.dart';

abstract class Storage {
  Future<void> saveTasks(List<Task> tasks);
  Future<List<Task>> loadTasks();
  Future<void> clearTasks();
}
