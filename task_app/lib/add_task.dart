import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Task {
  String title;

  bool isDone;

  Task({required this.title, this.isDone = false});

  //JSON型に変換
  Map<String, dynamic> toJson() => {'title': title, 'isDone': isDone};

  //JSON型からMap型に変換
  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(title: json['title'], isDone: json['isDone']);
}

// データ保存
class TaskStorage {
  static const _taskKey = 'tasks';

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> taskList =
        tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_taskKey, taskList);
  }

  // データのロード
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
  Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_taskKey);
  }
}
