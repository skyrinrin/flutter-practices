import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/domain/account_domain.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/domain/task_domain.dart';
import 'dart:convert';
import 'package:task_app/Infrastructure/storage.dart';

import 'package:task_app/repository/repository.dart';

class RepositoryImpl implements Repository {
  final Storage storage;

  RepositoryImpl({required this.storage});

  @override
  Future<void> saveAccount(Account account) async {
    await storage.saveAccount(account);
  }

  @override
  Future<Account> loadAccount() async {
    return await storage.loadAccount();
  }

  List<Task> _cachedTasks = []; //タスクのキャッシュ

  // タスクの追加
  @override
  Future<void> addTask(Task task) async {
    _cachedTasks.add(task);
    await saveTasks(_cachedTasks); //ここ変更した(保存でエラーが出たらこれかも...)
  }

  @override
  Future<void> removeTask(Task task) async {
    _cachedTasks.remove(task);
    await saveTasks(_cachedTasks);
  }

  @override
  Future<void> updateTasks() async {
    await saveTasks(_cachedTasks);
  }

  //

  Future<void> toggleTaskDone(int id) async {
    if (id != -1) {
      _cachedTasks[id].isDone = !_cachedTasks[id].isDone;
    }
    saveTasks(_cachedTasks);
  }

  // タスクの保存
  @override
  Future<void> saveTasks(List<Task> tasks) async {
    await storage.saveTasks(tasks);
  }

  // タスクのロード
  @override
  Future<List<Task>> loadTasks() async {
    // List<Task> tasks = await storage.loadTasks();
    // return tasks;
    _cachedTasks = await storage.loadTasks();
    return _cachedTasks;
  }

  // ラベルのキャッシュ
  List<Label> _cachedLabels = [];

  // ラベルの追加
  @override
  Future<void> addLabel(Label label) async {
    _cachedLabels.add(label);
    print('ここまでできてるRepository');
    await saveLabels(_cachedLabels);
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
