import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AddTaskWindow extends StatefulWidget {
  @override
  _AddTaskWindowState createState() => _AddTaskWindowState();
}

class _AddTaskWindowState extends State<AddTaskWindow> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 通知設定有効無効
  bool _isNotice = true;

  // 日付、時間を格納する変数
  String

  // 日付選択ウィジェットの設定
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      // 初期日付
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text = "${picked.year}/${picked.month}/${picked.day}";
    }
  }

  // 時間選択ウィジェットの設定
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() {
        // 選択された時刻を変数に格納
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
              onTap: () {
                // ここに関数指定
              },
              child: Container(
                height: 40,
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text("追加", style: TextStyle(fontSize: 20)),
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

                      child: CupertinoSwitch(
                        value: _isNotice,
                        onChanged:
                            (isNotice) => setState(() => _isNotice = isNotice),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 38,
                    child: Container(
                      padding: EdgeInsets.only(top: 8, left: 12),
                      height: 100,
                      width: 300,
                      color: Color(0xFFebebeb),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            child: Text('日時設定', style: TextStyle(fontSize: 18)),
                          ),
                          Positioned(
                            top: 30,
                            child: InkWell(
                              onTap: () => _selectDate(context),
                              child: Container(
                                child: Text(
                                  '05/18',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            left: 70,
                            child: InkWell(
                              onTap: () => _selectTime(context),
                              child: Container(
                                child: Text(
                                  selectedTime.toString().substring(10, 15),
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
