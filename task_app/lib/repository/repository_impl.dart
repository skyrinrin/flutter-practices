import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/domain/task_domain.dart';
import 'dart:convert';
import 'package:task_app/Infrastructure/storage.dart';

import 'package:task_app/repository/repository.dart';

class RepositoryImpl implements Repository {
  final Storage storage;

  RepositoryImpl({required this.storage});

  List<Task> _cachedTasks = []; //タスクのキャッシュ

  // 正しく保存されない場合、キャッシュ部分に問題がある可能性あり

  //タスクの追加
  @override
  Future<void> addTask(Task task) async {
    _cachedTasks.add(task);
    await storage.saveTasks(_cachedTasks);
  }

  // // タスクの取得
  // @override
  // Future<List<Task>> getTasks() async {
  //   _cachedTasks = await storage.loadTasks();
  //   return _cachedTasks;
  // }

  //

  Future<void> toggleTaskDone(int id) async {
    if (id != -1) {
      _cachedTasks[id].isDone = !_cachedTasks[id].isDone;
    }
    storage.saveTasks(_cachedTasks);
  }

  // タスクの保存
  @override
  Future<void> saveTasks(List<Task> tasks) async {
    await storage.saveTasks(tasks);
  }

  // // タスクのロード
  // @override
  // Future<List<Task>> loadTasks() async {
  //   return await storage.loadTasks();
  // }

  // タスクのロード
  @override
  Future<List<Task>> loadTasks() async {
    List<Task> tasks = await storage.loadTasks();
    return tasks;
  }

  // ラベルのキャッシュ
  List<Label> _cachedLabels = [];
  // 正しく保存されない場合、キャッシュ部分に問題がある可能性あり
  // 現在ラベルが2重に保存される（Notifier側の処理が行われていない＝整合性に著しい欠陥あり）

  // ラベルの追加
  @override
  Future<void> addLabel(Label label) async {
    _cachedLabels.add(label);
    await storage.saveLabels(_cachedLabels);
  }

  // ラベルの保存
  @override
  Future<void> saveLabels(List<Label> labels) async {
    await storage.saveLabels(labels);
  }

  // ラベルのロード
  @override
  Future<List<Label>> loadLabels() async {
    return await storage.loadLabels();
  }
}
