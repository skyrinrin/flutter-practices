// いらない

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:task_app/presentation/notifi_settings_dialog.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
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
            title: Text('通知時刻: '),

            trailing: Container(
              // color: Colors.amber,
              width: 60,
              child: Stack(
                children: [
                  //大きさやレイアウトを調節する
                  Positioned(
                    right: 24,
                    top: 4,
                    child: IconButton(
                      icon: Icon(Icons.help, size: 18),
                      onPressed: () {
                        //ここを押したら案内が表示されるようにする
                      },
                    ),
                  ),
                  // SizedBox(width: 12),
                  Positioned(
                    right: -12,
                    top: 4,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_forward_ios, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return NotifiSettingsDialog();
                },
              );
            },
          ),
        ),

        //
        SimpleDialogOption(child: ListTile(title: Text('テーマカラー'))),
      ],
    );
  }
}
