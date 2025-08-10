import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/Infrastructure/storage.dart';
import 'package:task_app/core/notification/notification_service.dart';
import 'package:task_app/domain/label_domain.dart';
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
  List<Label> get labels => ref.read(labelsProvider);

  // 初期化処理
  Future<void> init() async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.clear();

    final labels = await repository.loadLabels();
    ref.read(labelsProvider.notifier).updateLabels(labels);

    final tasks = await repository.loadTasks();
    ref.read(tasksProvider.notifier).updateTasks(tasks);

    // labels.clear();
    // tasks.clear();
  }

  // 通知を送信する 実験なので後で消す
  void sendNotifi() {
    NotificationService().showScheduledNotification(
      id: 1,
      title: 'サンプル',
      body: 'あああああああああああああああああああああああああああああああああああああああああああああああ',
      scheduledTime: DateTime.now().add(Duration(minutes: 1)), //1分後に通知を送信
    );
    print('通知を送信しました');
  }

  // データ全消し スタックしたときだけ使う！
  void clearData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // repository.saveTasks;
    print('削除');
  }

  Map<Label, List<Task>> labelsTasks(List<Task> tasks, List<Label> labels) {
    final result = <Label, List<Task>>{};
    for (var label in labels) {
      result[label] = tasks.where((task) => task.label == label.name).toList();
    }
    return result;
  }

  int getNextId(List list) {
    if (list.isEmpty) return 0;
    final maxId = list
        .map((element) => element.id)
        .reduce((a, b) => a > b ? a : b); //三項演算子とreduce関数を使ってる よくわかってない
    return maxId + 1;
  }

  Future<void> addTask(
    // int id,
    String title,
    String label,
    String date,
    String time,
  ) async {
    // final tasks = ref.read(taskProvider);
    final task = Task(
      id: getNextId(tasks),
      title: title,
      label: label,
      date: date,
      time: time,
    );
    await repository.addTask(task);

    // TaskNotifierの状態も更新(プロバイダーのStateも同期)
    ref.read(tasksProvider.notifier).addTask(task);
  }

  Future<void> addLabel(String name, Color color) async {
    final label = Label(
      name: name,
      id: getNextId(labels),
      color: color,
      isExpanded: false,
    ); //ここのcolorのところを変更する
    final labelsIds = ref.read(labelIdProvider);

    if (!labelsIds.contains(label.id)) {
      await repository.addLabel(label);

      // LabelNotifierの状態も更新(プロバイダーのStateも同期)
      ref.read(labelsProvider.notifier).addLabel(label);
      print('ラベル保存完了');
    } else {
      print('すでに同じラベルがあります');
      // スナックバーの表示
    }
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

  //日付ウィジェットの処理

  //日付によってタイトルの内容を変える
  // String getDateListsTitle(int number) {
  //       if (number == 0) {
  //     selectedTasks = ref.watch(todayTasksProvider);
  //     _listTitle = '今日(${selectedTasks.length})';
  //   }
  //   if (number == 1) {
  //     selectedTasks = ref.watch(tomorrowTasksProvider);
  //     _listTitle = '明日(${selectedTasks.length})';
  //   }
  //   if (number == 2) {
  //     selectedTasks = ref.watch(otherTasksProvider);
  //     _listTitle = 'その他(${selectedTasks.length})';
  // }

  // 日付ごとリストの日付を判別する
  (List<Task>, String) getDateKind(int number) {
    if (number == 0) {
      List<Task> tasks = ref.watch(todayTasksProvider);
      return (tasks, '今日(${tasks.length})');
    }
    if (number == 1) {
      List<Task> tasks = ref.watch(tomorrowTasksProvider);
      return (tasks, '明日(${tasks.length})');
    }
    if (number == 2) {
      List<Task> tasks = ref.watch(otherTasksProvider);
      return (tasks, 'その他(${tasks.length})');
    }
    return ([], 'Error');
  }

  //タスクの数からリストの高さとリストビューの拡大縮小を管理・取得
  (double, bool) getDateListsHightBool(List<Task> tasks) {
    if (tasks.isEmpty) {
      return (160, false);
    } else {
      return ((tasks.length + 1.5) * 104, false);
    }
  }
}
//   double getDateListsHeight(List<Task> tasks) {
//     if (tasks.isEmpty) {
//       return 160;
//     } else {
//       return (tasks.length + 1.5) * 104;
//     }
//   }
// }

// アプリケーション層にnotifier系を入れる
class TaskNotifier extends StateNotifier<List<Task>> {
  Repository repository;
  TaskNotifier(this.repository) : super([]); //親クラスに空のリストを渡す

  // タスクのロード
  void loadTasks() async {
    List<Task> _loadedData = await repository.loadTasks();
    state = _loadedData;
    print('タスク一覧(本家): ${state}');
  }

  // タスクの追加
  void addTask(Task task) {
    state = [...state, task]; //もともとのリストにtaskを追加
    print('タスク一覧(本家): ${state}');
  }

  // リストのアップデート
  void updateTasks(List<Task> tasks) {
    state = tasks;
  }
}

class LabelsTasksNotifier extends StateNotifier<List<Label>> {
  Repository repository;
  LabelsTasksNotifier(this.repository)
    : super([
        Label(name: '未選択', id: 1, color: Colors.black, isExpanded: false),
      ]);

  void loadLabels() async {
    List<Label> data = [
      Label(name: '未選択', id: 1, color: Colors.black, isExpanded: false),
    ];
    List<Label> _loadedData = await repository.loadLabels();
    data.addAll(_loadedData);
    state = data;
  }

  // ジャンル追加
  void addLabel(Label label) {
    // すでに同じ名前のジャンルがないかチェック
    if (!state.contains(label)) {
      state = [...state, label];
    }
  }

  // リストのアップデート
  void updateLabels(List<Label> labels) {
    state = labels;
  }

  void toggleLabel(int index) {
    final newList = [...state];
    newList[index].isExpanded = !newList[index].isExpanded;
    state = newList;
  }
}
