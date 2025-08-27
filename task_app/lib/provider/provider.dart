import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/Infrastructure/storage.dart';
import 'package:task_app/Infrastructure/storage_impl.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/account_domain.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/domain/task_domain.dart';
import 'package:task_app/repository/repository.dart';
import 'package:task_app/repository/repository_impl.dart';
import 'package:task_app/common/common.dart';

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

// アカウント
final accountUseCaseProvider = Provider(
  (ref) => AccountUseCase(ref.read(repositoryProvider)),
);

final accountNotifierProvider = AsyncNotifierProvider<AccountNotifier, Account>(
  AccountNotifier.new,
);

class AccountNotifier extends AsyncNotifier<Account> {
  @override
  Future<Account> build() async {
    final useCase = ref.read(accountUseCaseProvider);
    return await useCase.getAccount();
  }

  Future<void> updateNotificationTime(TimeOfDay time) async {
    final useCase = ref.read(accountUseCaseProvider);
    await useCase.updateNotificationTime(time);
    state = AsyncData(
      Account(
        dailyNotifiTime: time,
        themeColor: state.value?.themeColor ?? Common.primaryColor,
      ),
    );
  }

  Future<void> updateThemeColor(Color color) async {
    final useCase = ref.read(accountUseCaseProvider);
    await useCase.updateThemeColor(color);
    state = AsyncData(
      Account(
        dailyNotifiTime:
            state.value?.dailyNotifiTime ?? TimeOfDay(hour: 9, minute: 0),
        themeColor: color,
      ),
    );
  }
}

// タスクリスト (状態管理（UI表示用）)
final tasksProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  // final app = ref.read(applicationProvider);
  final repository = ref.read(repositoryProvider);
  return TaskNotifier(repository);
});

// final togglesProvider = Provider<List<bool>>((ref) {
//   final allTasks = ref.watch(tasksProvider);
//   List<bool> toggles = [];
//   for (int i = 0; i < allTasks.length; i++) {
//     toggles.add(allTasks[i].isDone);
//   }
//   return toggles;
// });

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
    // print("今日のタスク一覧: ${tasks[0].date} ${tasks.length}");
    // print("タスク一覧: ${allTasks} ${allTasks.length}");
  } else {
    // print("今日のタスク一覧: null");
    // print("タスク一覧: ${allTasks} ${allTasks.length}");
  }

  List<Task> result = tasks.toSet().toList();

  return result;
});

// 明日のタスク
final tomorrowTasksProvider = Provider<List<Task>>((ref) {
  final allTasks = ref.watch(tasksProvider);
  final tomorrow = Common.tomorrow;
  List<Task> tasks = allTasks.where((task) => task.date == tomorrow).toList();
  if (tasks.isNotEmpty) {
    // print("明日のタスク一覧: ${tasks[0].date} ${tasks.length}");
    // print("タスク一覧: ${allTasks} ${allTasks.length}");
  } else {
    // print("明日のタスク一覧: null");
    // print("タスク一覧: ${allTasks} ${allTasks.length}");
  }

  List<Task> result = tasks.toSet().toList();
  return result;
});

// その他のタスク
final otherTasksProvider = Provider<List<Task>>((ref) {
  List<Task> tasks = [];
  final allTasks = ref.watch(tasksProvider);
  tasks = [...allTasks];

  final today = Common.today;
  final tomorrow = Common.tomorrow;

  tasks.removeWhere((task) => task.date == tomorrow || task.date == today);
  // print('その他のタスク: $tasks');
  // print("タスク一覧: ${allTasks} ${tasks.length}");

  List<Task> result = tasks.toSet().toList();
  return result;
});
