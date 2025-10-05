import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/Infrastructure/convert.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/account_domain.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/domain/task_domain.dart';
import 'package:task_app/provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'storage.dart';

// ラベル用の保存ロジックも作る

class StorageImpl implements Storage {
  // データ保存
  static const _themeColorKey = 'themeColor';
  static const _notifiTimeKey = 'notifiTime';
  static const _taskKey = 'tasks';
  static const _labelKey = 'labels';

  ConvertSomeThing _converter = ConvertSomeThing();

  @override
  Future<void> saveAccount(Account account) async {
    final prefs = await SharedPreferences.getInstance();
    final hexColor = _converter.ColorToHex(account.themeColor);
    final time = _converter.timeOfDayToString(account.dailyNotifiTime);
    await prefs.setString(_themeColorKey, hexColor);
    await prefs.setString(
      _notifiTimeKey,
      time,
    ); //dateTimeをStringではなくDateTimeで保持する
  }

  @override
  Future<Account> loadAccount() async {
    final sample = Account(
      dailyNotifiTime: TimeOfDay(hour: 9, minute: 0),
      themeColor: const Color.fromARGB(66, 63, 147, 216),
    );

    final prefs = await SharedPreferences.getInstance();

    final hexColor = prefs.getString(_themeColorKey);
    final notifiTimeStr = prefs.getString(_notifiTimeKey);
    final notifiTime = notifiTimeStr != null
        ? _converter.stringToTimeOFDay(notifiTimeStr)
        : const TimeOfDay(hour: 9, minute: 0);

    if (hexColor == null) {
      return sample;
    }

    final color = _converter.hexToColor(hexColor);

    return Account(dailyNotifiTime: notifiTime, themeColor: color);
  }

  // タスクの保存
  @override
  Future<void> saveTasks(List<Task> tasks) async {
    print('saveTasks called: ${tasks.length}');
    final prefs = await SharedPreferences.getInstance();
    final List<String> taskList = tasks
        .map((task) => jsonEncode(task.toJson()))
        .toList();
    await prefs.setStringList(_taskKey, taskList);

    // データ確認用 必ず消す
    print('保存した内容: ${prefs.getStringList(_taskKey)}');
  }

  // タスクのロード
  @override
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.clear(); // 絶対消す
    final List<String>? taskList = prefs.getStringList(_taskKey);
    if (taskList == null) return [];

    return taskList.map((taskStr) {
      final json = jsonDecode(taskStr);
      // print('ロードした内容: ${Task.fromJson(json)}');
      print('ロードした内容: $json}');
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
    final List<String> labelList = labels
        .map((label) => jsonEncode(label.toJson()))
        .toList();
    await prefs.setStringList(_labelKey, labelList);
  }

  // ラベルのロード
  @override
  Future<List<Label>> loadLabels() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? labelList = prefs.getStringList(_labelKey);
    // if (labelList == null) return [];
    List<Label> loadedLabels = [];

    if (labelList != null) {
      loadedLabels = labelList
          .map((labelStr) {
            try {
              final json = jsonDecode(labelStr);
              return Label.fromJson(json);
            } catch (e) {
              print('不正なラベルデータ: $e');
              return null;
            }
          })
          .whereType<Label>()
          .toList();
    }

    // "未選択"ラベルが存在しないならば追加
    bool hasDefault = loadedLabels.any((label) => label.name == '未選択');
    if (!hasDefault) {
      loadedLabels.insert(
        0,
        Label(
          name: '未選択',
          id: '000',
          order: 0,
          color: Colors.black,
          isExpanded: false,
        ),
      );
      await saveLabels(loadedLabels);
    }
    return loadedLabels;
  }
}
