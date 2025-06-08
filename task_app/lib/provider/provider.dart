import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/Infrastructure/storage.dart';
import 'package:task_app/Infrastructure/storage_impl.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/domain.dart';
import 'package:task_app/repository/repository.dart';
import 'package:task_app/repository/repository_impl.dart';

// StateNotifierを使って状態管理
class TaskNotifier extends StateNotifier<List<Task>> {
  Application app;
  TaskNotifier(this.app) : super([]); //親クラスに空のリストを渡す

  // タスクの追加
  void addTask(Task task) {
    state = [...state, task]; //もともとのリストにtaskを追加
  }

  // リストのアップデート
  void updateTasks(List<Task> tasks) {
    state = tasks;
  }
}

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
  final app = ref.read(applicationProvider);
  return TaskNotifier(app);
});

// 今日のタスク
final todayTasksProvider = Provider<List<Task>>((ref) {
  final allTasks = ref.watch(tasksProvider);
  final today = DateTime.now()
      .toString()
      .substring(5, 10)
      .replaceAll('-', '/')
      .padLeft(2, '0'); //どのような形式で日付が保存されるのかわからない
  return allTasks.where((task) => task.date == today).toList();
});

// 明日のタスク
final tomorrowTasksProvider = Provider<List<Task>>((ref) {
  final allTasks = ref.watch(tasksProvider);
  final tomorrow = DateTime.now()
      .add(const Duration(days: 1))
      .toString()
      .substring(5, 10)
      .replaceAll('-', '/')
      .padLeft(2, '0'); //どのような形式で日付が保存されるのかわからない
  return allTasks.where((task) => task.date == tomorrow).toList();
});

// その他のタスク
final otherTasksProvider = Provider<List<Task>>((ref) {
  return List<Task>.empty(); //後で実装する
});
