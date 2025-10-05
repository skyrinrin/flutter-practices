import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/domain/task_domain.dart';
import 'dart:math';

import 'package:task_app/presentation/selects.dart';
import 'package:task_app/provider/provider.dart';

class TaskDetail extends ConsumerStatefulWidget {
  Task task;
  Color sideColor;
  TaskDetail({super.key, required this.task, required this.sideColor});
  @override
  ConsumerState<TaskDetail> createState() =>
      _TaskDetailState(task: this.task, sideColor: this.sideColor);
}

class _TaskDetailState extends ConsumerState<TaskDetail> {
  Task task;
  Color sideColor;
  _TaskDetailState({required this.task, required this.sideColor});
  Offset _titlePosition = Offset(0, 0);
  Selects _selects = Selects();

  Widget _taskDetailCard() {
    return Container(
      height: 320,
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                color: sideColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ), //ここの色は各自変更
              height: 320,
              width: 20,
            ),
          ),
          Positioned(
            right: 44,
            top: 40,
            child: IconButton(
              onPressed: () {
                //ここに関数
              },
              icon: Icon(Icons.delete, color: Color(0xFF969696), size: 28),
            ),
          ),
          Align(alignment: Alignment.center, child: _cardValue()),
          // Container(
          //   // color: Colors.amber,
          //   height: 320,
          //   width: 320,
          //   child: Positioned(child: _cardFold()),
          // ),
          // Align(alignment: Alignment.bottomRight, child: _cardFold()),
          Positioned(bottom: -15, right: -15, child: _cardFold()),
          // Positioned(bottom: -17, right: -17, child: _cardFold()),
          Positioned(bottom: -30, right: -30, child: _cardFoldShadow()),
        ],
      ),
    );
  }

  final GlobalKey _titleKey = GlobalKey();

  void _getTitlePosition() {
    final renderBox = _titleKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    _titlePosition = renderBox.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    ); //画面上の位置
    print('Widgetの場所: $_titlePosition');
  }

  Widget _cardValue() {
    return Container(
      // color: Colors.blueAccent,
      height: 240,
      width: 204,
      child: Stack(
        children: [
          Positioned(bottom: 12, child: _taskDetailValues()),
          Positioned(
            top: 8,
            key: _titleKey,
            child: GestureDetector(
              onLongPress: () => _showTitleOverlay(),
              onLongPressEnd: (details) => _hideTitleOverlay(),
              child: Container(
                // color: Colors.amber,
                width: 172,
                child: Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold, //太字に
                    color: Color(0xFF6B6868),
                  ),
                ),
              ),
            ),
          ),
          _titleMore(),

          // ここから
          // Positioned(
          //   top: 52,
          //   left: 8,
          //   child: Text(
          //     '期限     :  09/17 15:22',
          //     style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
          //   ),
          // ),
          // Positioned(
          //   top: 80,
          //   left: 8,
          //   child: Text(
          //     'ラベル  :  未選択',
          //     style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
          //   ),
          // ),
          // Positioned(
          //   top: 108,
          //   left: 8,
          //   child: Text(
          //     'メモ      : ',
          //     style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
          //   ),
          // ),
          //ここまでをボーダーと一緒のContainerに入れる
        ],
      ),
    );
  }

  Widget _taskDetailValues() {
    return Container(
      height: 180,
      width: 204,
      // color: Colors.amber,
      child: Stack(
        children: [Positioned(top: 4, child: _texts()), _textBorders()],
      ),
    );
  }

  DropdownButton _selectLabel() {
    print('起動 select');
    List<String> labelsNames = ref.watch(labelsNameProvider);

    return DropdownButton<String>(
      items:
          labelsNames.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
      onChanged: (String? value) async {
        //ここから
        final app = ref.read(applicationProvider);
        await app.updateTasks(task.copyWith(label: value ?? task.label));
        setState(() {
          task.label = value ?? task.label;
        });
      },
      value: task.label,
    );
  }

  Widget _texts() {
    return Container(
      // color: Colors.amber,
      height: 180,
      width: 204,
      padding: EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '  期限     :  ',
                maxLines: 1,
                style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
              ),
              GestureDetector(
                onTap: () {
                  _editTaskDate();
                  _updateMadeDateTime();
                },
                child: Text(
                  '${task.deadLineDate} ',
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _editTaskTime();
                  _updateMadeDateTime();
                },
                child: Text(
                  ' ${task.deadLineTime}',
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),

          Container(
            width: 200,
            child: GestureDetector(
              onTap: () {
                //
                print('起動Gesture');
                _selectLabel();
                _updateMadeDateTime();
                //
              },
              child: Text(
                '  ラベル  :  ${task.label}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
              ),
            ),
          ),
          SizedBox(height: 4),

          Text(
            '  メモ      : ',
            style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                '  最終変更 :  ',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B6868)),
              ),
              Text(
                '${task.madeDate}  ${task.madeTime}',
                style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _textBorders() {
    return Container(
      // color: Colors.amber,
      height: 180,
      width: 204,
      child: Stack(
        children: [
          // Text('sample'),
          // Text('data'),
          // Container(height: 180, width: 200),
          Positioned(top: 1, child: _dottedBorder()),
          Positioned(top: 0, child: _dottedBorder()),
          Positioned(top: 28, child: _dottedBorder()),
          Positioned(top: 56, child: _dottedBorder()),
          Positioned(top: 84, child: _dottedBorder()),
          Positioned(top: 112, child: _dottedBorder()),
          Positioned(top: 140, child: _dottedBorder()),
          Positioned(top: 168, child: _dottedBorder()),
        ],
      ),
    );
  }

  Widget _dottedBorder() {
    return DottedBorder(
      options: RectDottedBorderOptions(
        color: Color(0xFF969696),
        strokeWidth: 2,
        dashPattern: [4, 4],

        padding: EdgeInsets.only(bottom: 0, right: 0.5),
      ),

      child: Container(height: 0, width: 204),
    );
  }

  Widget _cardFoldShadow() {
    return Transform.rotate(
      angle: pi / 4,
      child: Container(
        // color: Colors.amber,
        color: Color(0xFF757575),
        height: 60,
        width: 60,
      ),
    );
  }

  Widget _cardFold() {
    return Container(color: Color(0xFFD9D9D9), height: 60, width: 60);
  }

  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();

  void _showTitleOverlay() {
    _getTitlePosition();
    _overlayPortalController.toggle();
    // Future.delayed(
    //   const Duration(seconds: 3),
    // ).then((_) => _overlayPortalController.hide());
  }

  void _hideTitleOverlay() {
    _overlayPortalController.toggle();
  }

  String _fromDateTimeToString(DateTime date) {
    return date.toString().substring(5, 10).replaceAll('-', '/');
  }

  String _fromTimeOfDayToString(TimeOfDay time) {
    return time.toString().substring(10, 15);
  }

  void _updateMadeDateTime() async {
    final app = ref.read(applicationProvider);
    final _nowDate = DateTime.now();
    final _nowDateStr = _fromDateTimeToString(_nowDate);
    final _nowTime = TimeOfDay.now();
    final _nowTimeStr = _fromTimeOfDayToString(_nowTime);
    await app.updateTasks(
      task.copyWith(madeDate: _nowDateStr, madeTime: _nowTimeStr),
    );
    setState(() {
      task.madeDate = _nowDateStr;
      task.madeTime = _nowTimeStr;
    });
  }

  void _editTaskDate() async {
    final app = ref.read(applicationProvider);
    final _nowDateStr = app.convertDateTime(
      task.deadLineDate,
      task.deadLineTime,
    );
    final _nowDate = DateTime(
      _nowDateStr.$1,
      _nowDateStr.$2[0],
      _nowDateStr.$2[1],
      _nowDateStr.$3,
      _nowDateStr.$4,
    );
    print('タスク詳細: nowDate : $_nowDate');

    final _editedDate = await _selects.selectDate(context, _nowDate);
    // _thisTask.first.deadLineDate = _editedDate.toString().substring(5, 10);
    final _updatedDate = _fromDateTimeToString(_editedDate);

    await app.updateTasks(task.copyWith(deadLineDate: _updatedDate));
    setState(() {
      task.deadLineDate = _updatedDate;
    });
    app.sendTasksNotifi(task);

    //全体的にコードが汚い気がする
  }

  void _editTaskTime() async {
    final app = ref.read(applicationProvider);
    final _nowTimeStr = app.convertDateTime(
      task.deadLineDate,
      task.deadLineTime,
    );
    final _nowTime = TimeOfDay(hour: _nowTimeStr.$3, minute: _nowTimeStr.$4);
    final _editTime = await _selects.selectTime(context, _nowTime);
    final _updateTime = _fromTimeOfDayToString(_editTime);
    await app.updateTasks(task.copyWith(deadLineTime: _updateTime));
    setState(() {
      task.deadLineTime = _updateTime;
    });
    app.sendTasksNotifi(task);
  }

  Widget _titleMore() {
    return OverlayPortal(
      controller: _overlayPortalController,
      overlayChildBuilder: (context) {
        return Positioned(
          top: _titlePosition.dy,
          left: _titlePosition.dx,

          child: Material(
            elevation: 4.0,
            child: Container(
              width: 180, //ここの長さも検討が必要
              // height: 60, //ここの高さも検討が必要
              padding: EdgeInsets.all(8),
              color: Colors.white,
              child: Text(
                '${task.title}',
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFF6B6868),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final _task = widget.task;
    // final _sideColor = widget.sideColor; //
    // return SimpleDialog(
    // backgroundColor: Colors.white,
    // children: [
    return Center(
      // height: 300,
      // width: 500
      // margin: EdgeInsets.all(50),
      // color: Colors.amber,
      child: _taskDetailCard(),
    );
    //   ],
    // );
  }
}
