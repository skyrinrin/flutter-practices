import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/domain/domain.dart';
import 'dart:convert';
import 'storage.dart';

// 問題あり！データの整合性が無い

class StorageImpl implements Storage {
  // データ保存
  static const _taskKey = 'tasks';
  List<Task> tasks = []; //タスクリスト！

  @override
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> taskList =
        tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_taskKey, taskList);
  }

  // データのロード
  @override
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? taskList = prefs.getStringList(_taskKey);
    if (taskList == null) return [];

    return taskList.map((taskStr) {
      final json = jsonDecode(taskStr);
      return Task.fromJson(json);
    }).toList();
  }

  //タスクの削除
  @override
  Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_taskKey);
  }
}
