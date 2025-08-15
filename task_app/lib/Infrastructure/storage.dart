import 'package:flutter/material.dart';
import 'package:task_app/domain/acount_domain.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/domain/task_domain.dart';

abstract class Storage {
  // String timeOfDayToString(TimeOfDay time);
  // TimeOfDay stringToTimeOFDay(String timeString);
  Future<void> saveAcount(Acount acount);
  Future<Acount> loadAcount();
  Future<void> saveTasks(List<Task> tasks);
  Future<List<Task>> loadTasks();
  // Future<void> clearTasks();
  Future<void> saveLabels(List<Label> labels);
  Future<List<Label>> loadLabels();
  // クリア処理を入れるか検討すべき
}
