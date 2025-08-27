import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/Infrastructure/storage.dart';
import 'package:task_app/Infrastructure/storage_impl.dart';
import 'package:task_app/core/notification/notification_service.dart';
import 'package:task_app/domain/account_domain.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/provider/provider.dart';
import 'package:task_app/repository/repository.dart';
import 'package:task_app/domain/task_domain.dart';
import 'package:uuid/uuid.dart';

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

  String getUUID() {
    Uuid uuid = Uuid();
    String newUuid = uuid.v4();
    return newUuid;
  }

  int getOrder(List<Task> tasks) {
    int order = tasks.length * 10;
    return order;
  }

  List<Task> sortTasks(List<Task> tasks) {
    tasks.sort((a, b) => a.order.compareTo(b.order));
    return tasks;
  }

  //色の変換をインフラ層以外で使う場合はつかうかも...
  // String getHexCode(Color color) {
  //   String result = '#${color.value.toRadixString(16).padLeft(8, '0')}';
  //   return result;
  // }

  // Color parseHexCode(String hexCode) {
  //   int parsedCode = int.parse(hexCode.toString().replaceFirst('#', ''));
  //   Color result = Color(parsedCode);
  //   return result;
  // }

  Future<void> addTask(
    // int id,
    String title,
    String label,
    String date,
    String time,
  ) async {
    final task = Task(
      id: getUUID(),
      order: getOrder(tasks),
      title: title,
      label: label,
      date: date,
      time: time,
    );
    print('ここまできたApplication');
    await repository.addTask(task);

    // // TaskNotifierの状態も更新(プロバイダーのStateも同期)
    ref.read(tasksProvider.notifier).addTask(task);
  }

  Future<void> addLabel(String name, Color color) async {
    final label = Label(
      name: name,
      id: getUUID(),
      order: getOrder(tasks),
      color: color,
      isExpanded: false,
    ); //ここのcolorのところを変更する
    final labelsIds = ref.read(labelIdProvider);
    final labelsNames = ref.read(labelsNameProvider);

    if (!labelsIds.contains(label.id) && !labelsNames.contains(label.name)) {
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

  // タスクの達成状態を管理する

  bool getToggle(String id) {
    final allTasks = ref.watch(tasksProvider);
    return allTasks.where((task) => task.id == id).first.isDone;
  }

  bool toggleTask(String id) {
    //List<Task> tasks, tasksをグローバルに取得する
    final updatedTasks = [...tasks];

    final index = updatedTasks.indexWhere(
      (task) => task.id == id,
    ); //firstWhereでは直接左辺に代入できないため一度indexを取る
    if (index == -1) return false; //見つからなければ終了

    updatedTasks[index] = updatedTasks[index].copyWith(
      isDone: !updatedTasks[index].isDone,
    );

    repository.saveTasks(updatedTasks);

    ref.read(tasksProvider.notifier).updateTasks(updatedTasks); //Providerに反映
    // repository.saveTasks(tasks);
    return updatedTasks[index].isDone;
  }

  // タスクを得る
  Task getTask(String id) {
    return tasks.firstWhere((task) => task.id == id);
  }

  // // タスクの削除
  // void deleteTask(int index) {
  //   setState(() {
  //     tasks.removeAt(index);
  //   });
  //   storage.saveTasks(tasks);
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

  // 日付ごとリストの日付を判別する
  Provider<List<Task>> getDateKindProvider(int number) {
    if (number == 0) {
      return todayTasksProvider;
    }
    if (number == 1) {
      return tomorrowTasksProvider;
    }
    if (number == 2) {
      return otherTasksProvider;
    }

    return todayTasksProvider; //ここにエラー時のダミーを作るべきかも...（というか0,1,2で管理するのが良くないかも...）
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

// ここだけでなく他のProviderも責務分離すべき
// 毎日の通知時刻ProviderのUseCase
class AccountUseCase {
  final Repository repository;

  AccountUseCase(this.repository);

  Future<Account> getAccount() async {
    return await repository.loadAccount();
  }

  Future<void> updateNotificationTime(TimeOfDay time) async {
    final account = await repository.loadAccount();
    final updated = Account(
      dailyNotifiTime: time,
      themeColor: account.themeColor,
    );
    await repository.saveAccount(updated);
  }

  Future<void> updateThemeColor(Color color) async {
    final account = await repository.loadAccount();
    final updated = Account(
      dailyNotifiTime: account.dailyNotifiTime,
      themeColor: color,
    );
    await repository.saveAccount(updated);
  }
}

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
        Label(
          name: '未選択',
          id: '000',
          order: 0,
          color: Colors.black,
          isExpanded: false,
        ),
      ]);

  void loadLabels() async {
    List<Label> data = [
      Label(
        name: '未選択',
        id: '000',
        order: 0,
        color: Colors.black,
        isExpanded: false,
      ),
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

  void toggleLabel(int id) {
    final newList = [...state];
    Label label = newList[id];
    label.isExpanded = !label.isExpanded;
    state = newList;
  }
}
