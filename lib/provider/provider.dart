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
final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  final app = ref.read(applicationProvider);
  return TaskNotifier(app);
});

//UI関係プロバイダー(数が増えてきたらファイルを分けるべき) 追記 結局必要なかった...
// final selectedDateProvider = StateProvider<DateTime?>((ref) => null); //日付選択変数
// final selectedTimeProvider = StateProvider<TimeOfDay?>((ref) => null); //時間選択変数
// final selectedLabelProvider = StateProvider<String?>((ref) => null); //ラベル選択変数
