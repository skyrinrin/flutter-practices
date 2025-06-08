import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/Infrastructure/storage.dart';
import 'package:task_app/provider/provider.dart';
import 'package:task_app/repository/repository.dart';
import 'package:task_app/domain/domain.dart';
// import 'package:provider/provider.dart';

class Application {
  final Ref ref;
  // List<Task> tasks;
  final Repository repository;
  Application(this.ref, this.repository);

  List<Task> get tasks => ref.read(tasksProvider);

  Future<void> addTask(
    // int id,
    String title,
    String label,
    String date,
    String time,
  ) async {
    // final tasks = ref.read(taskProvider);
    final task = Task(
      id: tasks.length,
      title: title,
      label: label,
      date: date,
      time: time,
    );
    await repository.addTask(task);

    // TaskNotifierの状態も更新(プロバイダーのStateも同期)
    ref.read(tasksProvider.notifier).addTask(task);
  }

  // Future<List<Task>> getTasks() async {
  //   return repository.getTasks();
  // }

  // タスクの達成状態を管理する
  void toggleTask(int index) {
    //List<Task> tasks, tasksをグローバルに取得する
    final updatedTasks = [...tasks];
    updatedTasks[index] = updatedTasks[index].copyWith(
      //テストをsharedの方でする
      isDone: !updatedTasks[index].isDone,
    );
    ref.read(tasksProvider.notifier).updateTasks(updatedTasks);
    // repository.saveTasks(tasks);
  }

  // タスクを得る
  Task getTask(int index) {
    return tasks[index];
  }

  // // タスクの削除
  // void deleteTask(int index) {
  //   setState(() {
  //     tasks.removeAt(index);
  //   });
  //   storage.saveTasks(tasks);
  // }
}
