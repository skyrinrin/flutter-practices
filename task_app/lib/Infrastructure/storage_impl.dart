import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/domain/task_domain.dart';
import 'dart:convert';
import 'storage.dart';

// ラベル用の保存ロジックも作る

class StorageImpl implements Storage {
  // データ保存
  static const _taskKey = 'tasks';
  static const _labelKey = 'labels';
  // List<
  // List<Task> tasks = []; //タスクリスト！

  // タスク

  // タスクの保存
  @override
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> taskList =
        tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_taskKey, taskList);
  }

  // タスクのロード
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

  // //タスクの削除
  // @override
  // Future<void> clearTasks() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(_taskKey);
  // }

  // ラベル

  // ラベルの保存
  @override
  Future<void> saveLabels(List<Label> labels) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> labelList =
        labels.map((label) => jsonEncode(label.toJson())).toList();
    await prefs.setStringList(_labelKey, labelList);
  }

  // ラベルのロード
  @override
  Future<List<Label>> loadLabels() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? labelList = prefs.getStringList(_labelKey);
    if (labelList == null) return [];

    return labelList.map((labelStr) {
      final json = jsonDecode(labelStr);
      return Label.fromJson(json);
    }).toList();
  }
}
