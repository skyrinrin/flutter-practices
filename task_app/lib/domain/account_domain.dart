import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Account {
  final TimeOfDay dailyNotifiTime;
  final Color themeColor;

  Account({required this.dailyNotifiTime, required this.themeColor});

  //JSON変換
  Map<String, dynamic> toJson() => {
    'dailyNotifiTime': dailyNotifiTime,
    'themeColor': themeColor,
  };

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    dailyNotifiTime: json['dailyNotifiTime'] as TimeOfDay,
    themeColor: json['themeColor'] as Color,
  );
}
