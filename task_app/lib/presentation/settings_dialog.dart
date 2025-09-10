// いらない

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/domain/account_domain.dart';
import 'package:task_app/presentation/help_alertdialogs.dart';
import 'package:task_app/presentation/notifi_settings_dialog.dart';
import 'package:task_app/provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingsView extends ConsumerStatefulWidget {
  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  // late Color _selectedColor = Colors.white;

  // @override
  // void initState() {
  //   super.initState();
  //   initColorSet();
  // final account = ref.watch(accountNotifierProvider.notifier);
  // }

  // void initColorSet() async {
  //   final useCase = ref.read(accountUseCaseProvider);
  //   Account account = await useCase.getAccount();

  //   _selectedColor = account.themeColor;
  //   print('テーマカラー: $account');
  // }

  //
  Future<void> _selectNotifiTime(BuildContext context) async {
    final _account = ref.read(accountNotifierProvider);
    TimeOfDay _notifiTime =
        _account.value?.dailyNotifiTime ?? TimeOfDay(hour: 9, minute: 0);
    // TimeOfDay _selectedTime = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          _notifiTime == TimeOfDay(hour: 9, minute: 0)
              ? TimeOfDay(hour: 9, minute: 0)
              : _notifiTime,
    );
    if (picked != null) {
      await ref
          .read(accountNotifierProvider.notifier)
          .updateNotificationTime(picked);
    }
  }
  //

  String convertTime(TimeOfDay time) {
    return time.toString().substring(10, 15);
  }

  Widget notifiTimeText() {
    final account = ref.watch(accountNotifierProvider);
    return account.when(
      data:
          (account) => Text('通知時刻:   ${convertTime(account.dailyNotifiTime)}'),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('error: $e'),
    );
  }

  // addLabelWindowと被っているため再利用すべきかも
  // あとレイアウトがキモイ

  // カラーピッカー
  Widget _colorPicker() {
    final accountAsync = ref.watch(accountNotifierProvider);
    return accountAsync.when(
      data:
          (account) => BlockPicker(
            pickerColor: account.themeColor,
            onColorChanged: (Color color) async {
              // setState(() async {
              await ref
                  .read(accountNotifierProvider.notifier)
                  .updateThemeColor(color);
              // });
            },
          ),
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }

  // カラー選択ダイアログ
  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('色を選択してください'),
          content: SingleChildScrollView(child: _colorPicker()),
        );
      },
    );
  }

  Widget _selectColorWidget() {
    final accountAync = ref.watch(accountNotifierProvider);
    return accountAync.when(
      data:
          (account) => Container(
            // color: Colors.amber,
            width: 70,
            // height: 80,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.palette, size: 18),
                        onPressed: () => _showColorPickerDialog(),
                      ),
                      GestureDetector(
                        onTap: () => _showColorPickerDialog(),
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: account.themeColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      loading: () => CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final account = ref.watch(accountNotifierProvider);
    // final selectedTime = account.
    // final _selectedTime = ref.watch(notifiTimeProvider);
    // TimeOfDay _selectedTime = TimeOfDay.now();
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
            // title: Text('通知時刻:   ${convertTime(_selectedTime)}'),
            title: notifiTimeText(),
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
        SimpleDialogOption(
          child: ListTile(
            title: Text('テーマカラー'),
            trailing: _selectColorWidget(),
          ),
        ),
      ],
    );
  }
}
