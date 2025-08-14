// いらない

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:task_app/presentation/help_alertdialogs.dart';
import 'package:task_app/presentation/notifi_settings_dialog.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  //
  Future<void> _selectNotifiTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {}
  }
  //

  @override
  Widget build(BuildContext context) {
    TimeOfDay _selectedTime = TimeOfDay.now();
    return SimpleDialog(
      backgroundColor: Colors.white,
      // title: Text('設定', style: TextStyle(fontSize: 24)),
      alignment: Alignment.topRight,

      children: [
        // レイアウト要検討!
        // SimpleDialogOption(
        //   child: ListTile(

        //     title: Text('通知', style: TextStyle(fontSize: 22))),
        // ),
        SimpleDialogOption(
          // child: Text('テーマカラー')),

          //
          child: ListTile(
            onTap: () => _selectNotifiTime(context),
            // tileColor: Colors.amber,
            title: Text('通知時刻:   $_selectedTime'),

            trailing: Container(
              // color: Colors.amber,
              width: 70,

              child: Stack(
                children: [
                  //大きさやレイアウトを調節する
                  Positioned(
                    right: 20,
                    top: 4,
                    child: IconButton(
                      icon: Icon(Icons.help, size: 18),
                      onPressed: () {
                        //ここを押したら案内が表示されるようにする
                        showDialog(
                          context: context,
                          builder: (_) {
                            return NotifiTimeHelpDialog();
                          },
                        );
                      },
                    ),
                  ),
                  // SizedBox(width: 12),
                  Positioned(
                    // right: -12,
                    right: 0,
                    top: 20,
                    child: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                ],
              ),
            ),

            // onTap: () {
            //   showDialog(
            //     context: context,
            //     builder: (_) {
            //       return NotifiSettingsDialog();
            //     },
            //   );
            // },
          ),
        ),

        //
        SimpleDialogOption(child: ListTile(title: Text('テーマカラー'))),
      ],
    );
  }
}
