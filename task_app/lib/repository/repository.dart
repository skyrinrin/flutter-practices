import 'package:task_app/domain/account_domain.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/domain/task_domain.dart';

abstract class Repository {
  Future<void> addTask(Task task);
  Future<void> removeTask(Task task);
  Future<void> updateTasks();
  Future<void> addLabel(Label label);
  Future<void> removeLabel(Label label);
  Future<void> saveAccount(Account account);
  Future<Account> loadAccount();
  Future<void> saveTasks(List<Task> tasks);
  Future<List<Task>> loadTasks();
  Future<void> saveLabels(List<Label> labels);
  Future<List<Label>> loadLabels();
}
