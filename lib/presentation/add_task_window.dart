import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/main.dart';
import 'package:task_app/domain/domain.dart';
import 'package:task_app/provider/provider.dart';

class AddTaskWindow extends ConsumerStatefulWidget {
  // final void Function(String title, String label, String date, String time)
  // onAddTask;

  // AddTaskWindow({required this.onAddTask});
  // final Application application;

  const AddTaskWindow({super.key});

  @override
  ConsumerState<AddTaskWindow> createState() => _AddTaskWindowState();
}

class _AddTaskWindowState extends ConsumerState<AddTaskWindow> {
  final TextEditingController _controller = TextEditingController();

  //追加ボタンが押された際の処理 HomePage層でsetStateを実行するためにコールバック
  // void _pushedAddButton() {
  //   // widget.onAddTask(
  //   //   _controller.text,
  //   //   selectedLabel,
  //   //   strSelectedDate,
  //   //   strSelectedTime,
  //   // );
  //   // Navigator.pop(context);
  // }

  //追加ボタンが押された際の処理 UI的に適切に描画されない可能性がある　（HomePage層でsetStateをしないといけない）
  // void _pushedAddButton(
  //   int id,
  //   String title,
  //   String label,
  //   String date,
  //   String time,
  // ) async {
  //   await app.addTask(id, title, label, date, time);
  //   Navigator.pop(context);
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 通知設定有効無効
  bool _isNotice = true;

  // 日付、時間を格納する変数
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  String strSelectedDate = DateTime.now()
      .toString()
      .substring(5, 10)
      .replaceAll('-', '/')
      .padLeft(2, '0');
  String strSelectedTime = TimeOfDay.now().toString().substring(10, 15);
  // String selectedDate = DateTime.now()
  //     .toString()
  //     .substring(5, 10)
  //     .replaceAll('-', '/');

  // ラベルを格納する変数
  String _selectedLabel = '未選択';

  // 日付選択ウィジェット
  Future<void> selectDate(BuildContext context, WidgetRef ref) async {
    // DateTime? picked = ref.watch(selectedDateProvider);

    DateTime? picked = await showDatePicker(
      context: context,
      // 初期日付
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate = picked;
      strSelectedDate = formattedDate(selectedDate);
    }
  }

  // 時間選択ウィジェット
  Future<void> _selectTime(BuildContext context, WidgetRef ref) async {
    // TimeOfDay? picked = ref.watch(selectedTimeProvider);

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      selectedTime = picked;
      strSelectedTime = formattedTime(selectedTime);
    }
  }

  // ラベル選択ウィジェット
  DropdownButton _selectLabel(BuildContext context, WidgetRef ref) {
    // _selectedLabel = ref.watch(selectedLabelProvider);

    return DropdownButton<String>(
      items: [
        DropdownMenuItem<String>(child: Text('未選択'), value: '未選択'),
        DropdownMenuItem<String>(child: Text('ラベル1'), value: 'ラベル1'),
        DropdownMenuItem<String>(child: Text('ラベル2'), value: 'ラベル2'),
        DropdownMenuItem<String>(child: Text('プログラミング'), value: 'プログラミング'),
      ],
      onChanged: (String? value) {
        _selectedLabel = value ?? '未選択';
      },
      value: _selectedLabel,
    );
  }

  // 日付時間選択画面ウィジェットスクリーン
  Widget _selectDataTimeScreen(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, left: 12),
      height: 100,
      width: 300,
      color: Color(0xFFebebeb),
      // color: Color.fromARGB(0, 0, 0, 3),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Text('日時設定', style: TextStyle(fontSize: 18)),
          ),
          Positioned(
            top: 30,
            child: InkWell(
              onTap: () => selectDate(context, ref),
              child: Container(
                child: Text(strSelectedDate, style: TextStyle(fontSize: 22)),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 70,
            child: InkWell(
              onTap: () => _selectTime(context, ref),
              child: Container(
                child: Text(strSelectedTime, style: TextStyle(fontSize: 22)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ラベル選択ウィジェットスクリーン
  Widget _selectLabelScreen(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          // top: 140,
          // left: 212,
          child: Text('ラベルを選択', style: TextStyle(fontSize: 18)),
        ),
        Positioned(
          // left: 212,
          top: 30,
          // height: 0,
          // width: 120,
          child: Container(
            padding: EdgeInsets.only(left: 10),
            height: 50,
            width: 200,
            color: Color(0xFFEBEBEB),
            child: _selectLabel(context, ref),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.read(applicationProvider);
    // final selectedDate = ref.watch(selectedDateProvider);
    // final seelctedTime = ref.watch(selectedTimeProvider);

    return Container(
      height: 320,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 28,
            left: 32,
            child: Text('タスクを追加', style: TextStyle(fontSize: 26)),
          ),
          Positioned(
            top: 28,
            right: 16,
            child: GestureDetector(
              onTap: () async {
                await app.addTask(
                  _controller.text,
                  _selectedLabel,
                  strSelectedDate,
                  strSelectedTime,
                );
                Navigator.pop(context);
              },
              child: Container(
                height: 35,
                width: 75,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text("追加", style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
          Positioned(
            top: 74,
            left: 32,
            child: Container(
              height: 40,
              width: 240,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'タスク名',
                  filled: true,
                  fillColor: Color(0xFFebebeb),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 34,
            height: 120,
            width: 160,
            child: Container(
              // color: Colors.blue,
              child: Stack(
                children: [
                  Positioned(
                    top: 3,

                    child: Icon(
                      Icons.notifications,
                      color: Colors.grey,
                      size: 28,
                    ),
                  ),
                  Positioned(
                    left: 30,
                    child: Text('通知', style: TextStyle(fontSize: 22)),
                  ),
                  Positioned(
                    top: -1,
                    left: 72,
                    child: Transform.scale(
                      scale: 0.8,

                      // child: CupertinoSwitch(
                      //   value: _isNotice,
                      //   onChanged:
                      //       (isNotice) => setState(() => _isNotice = isNotice),
                      // ),
                    ),
                  ),
                  Positioned(
                    top: 38,
                    child: _selectDataTimeScreen(context),
                    // Container(
                    //     padding: EdgeInsets.only(top: 8, left: 12),
                    //     height: 100,
                    //     width: 300,
                    //     color: Color(0xFFebebeb),
                    //     // color: Color.fromARGB(0, 0, 0, 3),
                    //     child: Stack(
                    //       children: [
                    //         Positioned(
                    //           top: 0,
                    //           child: Text('日時設定', style: TextStyle(fontSize: 18)),
                    //         ),
                    //         Positioned(
                    //           top: 30,
                    //           child: InkWell(
                    //             onTap: () => selectDate(context, ref),
                    //             child: Container(
                    //               child: Text(
                    //                 strSelectedDate,
                    //                 style: TextStyle(fontSize: 22),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         Positioned(
                    //           top: 30,
                    //           left: 70,
                    //           child: InkWell(
                    //             onTap: () => _selectTime(context, ref),
                    //             child: Container(
                    //               child: Text(
                    //                 strSelectedTime,
                    //                 style: TextStyle(fontSize: 22),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            height: 100,
            width: 150,
            top: 150,
            left: 208,
            child: _selectLabelScreen(context),
            // Stack(
            //   children: [
            //     Positioned(
            //       // top: 140,
            //       // left: 212,
            //       child: Text('ラベルを選択', style: TextStyle(fontSize: 18)),
            //     ),
            //     Positioned(
            //       // left: 212,
            //       top: 30,
            //       // height: 0,
            //       // width: 120,
            //       child: Container(
            //         padding: EdgeInsets.only(left: 10),
            //         height: 50,
            //         width: 200,
            //         color: Color(0xFFEBEBEB),
            //         child: _selectLabel(context, ref),
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}
