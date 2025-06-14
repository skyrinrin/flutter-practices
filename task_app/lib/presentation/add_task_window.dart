import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/main.dart';
import 'package:task_app/domain/task_domain.dart';
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 日付、時間を格納する変数
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  String strSelectedDate = DateTime.now()
      .toString()
      .substring(5, 10)
      .replaceAll('-', '/')
      .padLeft(2, '0');
  String strSelectedTime = TimeOfDay.now().toString().substring(10, 15);

  // ラベルを格納する変数
  String _selectedLabel = '未選択';

  // ボタン押下後の処理
  void _pushedAddButton(Application app) async {
    if (_controller.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(_warningSnackBar);
    } else {
      await app.addTask(
        _controller.text,
        _selectedLabel,
        strSelectedDate,
        strSelectedTime,
      );
      print(
        '現在保存したタスク: ${_controller.text} $_selectedLabel $strSelectedDate $strSelectedTime',
      );
    }
    Navigator.pop(context);
  }

  // テスト用ダミーデータ
  void _testPushedAddButton(Application app) async {
    for (int i = 0; i < 10; i++) {
      await app.addTask('このタスクはサンプルです。', 'Sample', '06/08', '11:41');
    }
    Navigator.pop(context);
  }

  // 日付選択ウィジェット
  Future<void> selectDate(BuildContext context, WidgetRef ref) async {
    DateTime? picked = await showDatePicker(
      context: context,
      // 初期日付
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        strSelectedDate = formattedDate(selectedDate);
      });
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
      setState(() {
        selectedTime = picked;
        strSelectedTime = formattedTime(selectedTime);
      });
    }
  }

  // ラベル選択ウィジェット
  DropdownButton _selectLabel(BuildContext context, WidgetRef ref) {
    List<String> labelsNames = ref.watch(labelsNameProvider);

    // List<String> dropdownItems = [labels.first.name];

    // void addLabelsNames() {
    //   List<String> labelNames = [];
    //   for (int i = 0; i < labels.length; i++) {
    //     labelNames.add(labels[i].name);
    //   }
    //   List<String> sample = labels.map((e) => labels.first.name).toList();
    //   dropdownItems = labelNames;
    // }

    return DropdownButton<String>(
      // items: [
      //   DropdownMenuItem<String>(child: Text('未選択'), value: '未選択'),
      //   // DropdownMenuItem<String>(child: Text('ラベル1'), value: 'ラベル1'),
      //   // DropdownMenuItem<String>(child: Text('ラベル2'), value: 'ラベル2'),
      //   // DropdownMenuItem<String>(child: Text('プログラミング'), value: 'プログラミング'),
      // ],
      items:
          labelsNames.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedLabel = value ?? '未選択';
        });
      },
      value: _selectedLabel,
    );
  }

  // 注意書きスナックバー
  final _warningSnackBar = SnackBar(
    content: Text(
      '入力していない項目があります',
      style: TextStyle(fontSize: 20),
      selectionColor: Color.fromARGB(0, 218, 50, 50),
    ),
  );

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
              onTap: () => _pushedAddButton(app),
              // Navigator.pop(context);
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
                  Positioned(top: 38, child: _selectDataTimeScreen(context)),
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
          ),
        ],
      ),
    );
  }
}
