import 'package:flutter/material.dart';

class ConvertSomeThing {
  Color hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; //アルファ（透明度）が無ければFFを追加
    }
    return Color(int.parse(hex, radix: 16));
  }

  String ColorToHex(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0')}';

  // //タスクの日時用

  // String dateTimeToString(DateTime dateTime) {
  //   return dateTime.toIso8601String();
  // }

  // DateTime stringToDateTime(String dateTimeString) {
  //   return DateTime.parse(dateTimeString);
  // }

  // アカウントの通知時刻用
  String timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay stringToTimeOFDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
