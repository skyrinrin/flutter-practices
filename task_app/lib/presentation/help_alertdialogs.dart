import 'package:flutter/material.dart';

// class HelpAlertdialogs {}

class NotifiTimeHelpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('通知時刻'),
      content: Text(
        '毎日指定した時刻に通知を送信します。\n（それとは別にタスクの制限時間前に通知を送信します。）',
      ), //内容がわかりづらいかも...
    );
  }
}
