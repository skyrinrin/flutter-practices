import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/Infrastructure/storage.dart';
import 'package:task_app/Infrastructure/storage_impl.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/domain/task_domain.dart';
import 'package:task_app/repository/repository.dart';
import 'package:task_app/repository/repository_impl.dart';
import 'package:task_app/common/common.dart';

// タスクリスト用
// class TaskNotifier extends StateNotifier<List<Task>> {
//   Application app;
//   TaskNotifier(this.app) : super([]); //親クラスに空のリストを渡す

//   repositoy = ref.read(repositoryProvider);

//   // // タスクのロード   永続化処理はstorageのみで行う
//   // void loadTasks() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final jsonList = prefs.getStringList('tasks') ?? [];
//   //   final loadedTasks =
//   //       jsonList.map((e) => Task.fromJson(json.decode(e))).toList();
//   //   state = loadedTasks;
//   // } //これをどこかで呼び出す

//   // タスクのロード
//   void laodTasks() async {

//   }

//   // タスクの追加
//   void addTask(Task task) {
//     state = [...state, task]; //もともとのリストにtaskを追加
//   }

//   // リストのアップデート
//   void updateTasks(List<Task> tasks) {
//     state = tasks;
//   }
// }

// // ラベル（ジャンル分け）用
// class LabelsTasksNotifier extends StateNotifier<Map<String, List<Task>>> {
//   LabelsTasksNotifier() : super({});

//   void loadLabels() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = prefs.getStringList('labels') ?? [];
//     final loadLabels =
//         jsonList.map((e) => Label.fromJson(json.decode(e))).toList();
//     state = loadedTasks
//   }

//   // ジャンル追加
//   void addLabel(String labelName) {
//     // すでに同じ名前のジャンルがないかチェック
//     if (!state.containsKey(labelName)) {
//       state = {...state, labelName: []};
//     }
//   }

//   // ラベル（ジャンル）にタスクを追加する
//   void addTaskToLabel(String labelName, Task task) {
//     final currentTasks = state[labelName] ?? [];
//     final updateList = [...currentTasks, task];

//     state = {...state, labelName: updateList};
//   }

//   // ラベルを削除する
//   void removeLabel(String labelName) {
//     final newState = Map<String, List<Task>>.from(state);
//     newState.remove(labelName);
//     state = newState;
//   }
// }

// プロバイダーの定義
final storageProvider = Provider<Storage>((ref) => StorageImpl());

// リポジトリ
final repositoryProvider = Provider<Repository>((ref) {
  final storage = ref.read(storageProvider);
  return RepositoryImpl(storage: storage);
});

// アプリケーション
final applicationProvider = Provider<Application>((ref) {
  final repository = ref.read(repositoryProvider);

  return Application(ref, repository);
});

// タスクリスト (状態管理（UI表示用）)
final tasksProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  // final app = ref.read(applicationProvider);
  final repository = ref.read(repositoryProvider);
  return TaskNotifier(repository);
});

// // タスクラベルリスト
// final labelsTaskProvider =
//     StateNotifierProvider<LabelsTasksNotifier, Map<String, List<Task>>>((ref) {
//       final repository = ref.read(repositoryProvider);
//       return LabelsTasksNotifier(repository);
//     });

// ラベルリスト
final labelsProvider = StateNotifierProvider<LabelsTasksNotifier, List<Label>>((
  ref,
) {
  final repository = ref.read(repositoryProvider);
  return LabelsTasksNotifier(repository);
});

// ラベルの名前リスト
final labelsNameProvider = Provider<List<String>>((ref) {
  final labels = ref.watch(labelsProvider);
  return labels.map((label) => label.name).toList();
});

// ラベルのIDリスト
final labelIdProvider = Provider<List<String>>((ref) {
  final labels = ref.watch(labelsProvider);
  return labels.map((label) => label.id).toList();
});

// // ラベルビューのisExpandedのリスト
// final isExpandedListProvider = Provider<List<bool>>((ref) {
//   final labels = ref.watch(labelsProvider);
//   return List.generate(labels.length, (_) => false);
// });

// ラベルごとに仕分けたタスクのリスト
final labelsTasksProvider = Provider<Map<Label, List<Task>>>((ref) {
  final app = ref.read(applicationProvider);
  final tasks = ref.watch(tasksProvider);
  final labels = ref.watch(labelsProvider);
  return app.labelsTasks(tasks, labels);
});

// 今日のタスク
final todayTasksProvider = Provider<List<Task>>((ref) {
  final allTasks = ref.watch(tasksProvider);
  final today = Common.today;
  List<Task> tasks = allTasks.where((task) => task.date == today).toList();
  if (tasks.isNotEmpty) {
    print("今日のタスク一覧: ${tasks[0].date} ${tasks.length}");
    print("タスク一覧: ${allTasks} ${allTasks.length}");
  } else {
    print("今日のタスク一覧: null");
    print("タスク一覧: ${allTasks} ${allTasks.length}");
  }

  List<Task> result = tasks.toSet().toList();

  return result;

  // return ref.watch(tasksProvider);

  // final allTasks = ref.watch(tasksProvider);
  // final today = DateTime.now()
  //     .toString()
  //     .substring(5, 10)
  //     .replaceAll('-', '/')
  //     .padLeft(2, '0'); //どのような形式で日付が保存されるのかわからない
  // return allTasks.where((task) => task.date == today).toList();
});

// 明日のタスク
final tomorrowTasksProvider = Provider<List<Task>>((ref) {
  final allTasks = ref.watch(tasksProvider);
  final tomorrow = Common.tomorrow;
  List<Task> tasks = allTasks.where((task) => task.date == tomorrow).toList();
  if (tasks.isNotEmpty) {
    print("明日のタスク一覧: ${tasks[0].date} ${tasks.length}");
    print("タスク一覧: ${allTasks} ${allTasks.length}");
  } else {
    print("明日のタスク一覧: null");
    print("タスク一覧: ${allTasks} ${allTasks.length}");
  }

  List<Task> result = tasks.toSet().toList();
  return result;
  // return ref.watch(tasksProvider);
});

// その他のタスク
final otherTasksProvider = Provider<List<Task>>((ref) {
  List<Task> tasks = [];
  final allTasks = ref.watch(tasksProvider);
  tasks = [...allTasks];

  final today = Common.today;
  final tomorrow = Common.tomorrow;

  tasks.removeWhere((task) => task.date == tomorrow || task.date == today);
  print('その他のタスク: $tasks');
  print("タスク一覧: ${allTasks} ${tasks.length}");

  List<Task> result = tasks.toSet().toList();
  return result;
  // return [];
});
