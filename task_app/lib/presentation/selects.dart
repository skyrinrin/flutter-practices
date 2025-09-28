import 'package:flutter/material.dart';

class Selects {
  // 日付選択ウィジェット
  Future<DateTime> selectDate(
    BuildContext context,
    DateTime nowDeadLineDate,
  ) async {
    final _nowDate = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: _nowDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      return picked;
    } else {
      return nowDeadLineDate;
    }
  }

  Future<TimeOfDay> selectTime(BuildContext context, TimeOfDay nowTime) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: nowTime,
    );
    if (picked != null) {
      return picked;
    } else {
      return nowTime;
    }
  }
}
