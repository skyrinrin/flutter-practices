import 'package:flutter/widgets.dart';

class Acount {
  final DateTime dailyNotifiTime;
  final Color themeColor;

  Acount({required this.dailyNotifiTime, required this.themeColor});

  //JSON変換
  Map<String, dynamic> toJson() => {
    'dailyNotifiTime': dailyNotifiTime,
    'themeColor': themeColor,
  };

  factory Acount.fromJson(Map<String, dynamic> json) => Acount(
    dailyNotifiTime: json['dailyNotifiTime'] as DateTime,
    themeColor: json['themeColor'] as Color,
  );
}
