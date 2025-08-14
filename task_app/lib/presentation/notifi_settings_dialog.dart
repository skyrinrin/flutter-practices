import 'package:flutter/material.dart';

class NotifiSettingsDialog extends StatefulWidget {
  @override
  _NotifiSettingsDialog createState() => _NotifiSettingsDialog();
}

class _NotifiSettingsDialog extends State<NotifiSettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [SimpleDialogOption(child: ListTile(title: Text('時間')))],
    );
  }
}
