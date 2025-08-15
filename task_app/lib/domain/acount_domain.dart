import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Acount {
  final TimeOfDay dailyNotifiTime;
  final Color themeColor;

  Acount({required this.dailyNotifiTime, required this.themeColor});

  //JSON変換
  Map<String, dynamic> toJson() => {
    'dailyNotifiTime': dailyNotifiTime,
    'themeColor': themeColor,
  };

  factory Acount.fromJson(Map<String, dynamic> json) => Acount(
    dailyNotifiTime: json['dailyNotifiTime'] as TimeOfDay,
    themeColor: json['themeColor'] as Color,
  );
}
