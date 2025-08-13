import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      // title: Text('設定', style: TextStyle(fontSize: 24)),
      alignment: Alignment.topRight,

      children: [SimpleDialogOption(child: Text('通知時刻:'))],
    );
  }
}
