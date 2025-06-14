import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/domain/task_domain.dart';

abstract class Repository {
  Future<void> addTask(Task task);
  // Future<List<Task>> getTasks();
  Future<void> saveTasks(List<Task> tasks);
  Future<List<Task>> loadTasks();
  Future<void> saveLabels(List<Label> labels);
  Future<List<Label>> loadLabels();
}
