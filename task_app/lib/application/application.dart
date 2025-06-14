import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/Infrastructure/storage.dart';
import 'package:task_app/provider/provider.dart';
import 'package:task_app/repository/repository.dart';
import 'package:task_app/domain/task_domain.dart';
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

  // タスクをラベル分けする

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

// アプリケーション層にnotifier系を入れる
class TaskNotifier extends StateNotifier<List<Task>> {
  Application app;
  TaskNotifier(this.app) : super([]); //親クラスに空のリストを渡す

  // // タスクのロード   永続化処理はstorageのみで行う
  // void loadTasks() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final jsonList = prefs.getStringList('tasks') ?? [];
  //   final loadedTasks =
  //       jsonList.map((e) => Task.fromJson(json.decode(e))).toList();
  //   state = loadedTasks;
  // } //これをどこかで呼び出す

  // タスクのロード
  void laodTasks() async {}

  // タスクの追加
  void addTask(Task task) {
    state = [...state, task]; //もともとのリストにtaskを追加
  }

  // リストのアップデート
  void updateTasks(List<Task> tasks) {
    state = tasks;
  }
}
