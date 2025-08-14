import 'package:flutter/material.dart';

class NotifiTimePicker {
  Future<void> _selectNotifiTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {}
  }
}
