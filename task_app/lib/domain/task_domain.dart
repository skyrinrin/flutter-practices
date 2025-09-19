import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String formatDate(DateTime selectedDate) {
  final month = selectedDate.month.toString().padLeft(2, '0');
  final day = selectedDate.day.toString().padLeft(2, '0');
  return '$month/$day';
}

// 時間のフォーマット
String formatTime(TimeOfDay selectedTime) {
  return selectedTime.toString().substring(10, 15);
}

class Task {
  String id;
  int notifiId;
  int order;
  String title;
  bool isDone;
  String label;
  bool isNotice;
  String deadLineDate;
  String deadLineTime;
  String madeDate;
  String madeTime;

  Task({
    required this.id,
    required this.notifiId,
    required this.order,
    required this.title,
    this.isDone = false,
    required this.label,
    this.isNotice = false,
    required this.deadLineDate,
    required this.deadLineTime,
    required this.madeDate,
    required this.madeTime,
  });

  Task copyWith({
    String? id,
    int? notifiId,
    String? title,
    bool? isDone,
    String? label,
    bool? isNotice,
    String? deadLineDate,
    String? deadLineTime,
    String? madeDate,
    String? madeTime,
  }) {
    return Task(
      id: id ?? this.id,
      notifiId: notifiId ?? this.notifiId,
      order: order,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      label: label ?? this.label,
      isNotice: isNotice ?? this.isNotice,
      deadLineDate: deadLineDate ?? this.deadLineDate,
      deadLineTime: deadLineTime ?? this.deadLineTime,
      madeDate: madeDate ?? this.madeDate,
      madeTime: madeTime ?? this.madeTime,
    );
  }

  //JSON型に変換
  Map<String, dynamic> toJson() => {
    'id': id,
    'notifiId': notifiId,
    'order': order,
    'title': title,
    'isDone': isDone,
    'label': label,
    'isNotice': isNotice,
    'deadLineDate': deadLineDate,
    'deadLineTime': deadLineTime,
    'madeDate': madeDate,
    'madeTime': madeTime,
  };

  //JSON型からMap型に変換
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    notifiId: json['notifiId'] as int,
    order: json['order'] as int,
    title: json['title'] as String,
    isDone: json['isDone'] as bool,
    label: json['label'] as String,
    isNotice: json['isNotice'] as bool,
    deadLineDate: json['deadLineDate'] as String,
    deadLineTime: json['deadLineTime'] as String,
    madeDate: json['madeDate'] as String,
    madeTime: json['madeTime'] as String,
  );
}
