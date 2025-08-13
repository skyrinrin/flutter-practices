import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:provider/provider.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/domain/task_domain.dart';
import 'package:task_app/provider/provider.dart';

class TaskCard extends ConsumerStatefulWidget {
  Task task;
  TaskCard({required this.task});
  @override
  ConsumerState<TaskCard> createState() => _TaskCardState(task: task);
}

class _TaskCardState extends ConsumerState<TaskCard> {
  Task task;

  _TaskCardState({required this.task});

  late Application app;
  // late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    app = ref.read(applicationProvider);
    _id = widget.task.id;
    _order = widget.task.order;
    _taskTitle = widget.task.title;
    label = widget.task.label;
    _date = widget.task.date;
    _time = widget.task.time;
    _isDone = widget.task.isDone; //もしかしたらこれかも？
    _colorChange();
  }

  // タスク未・済 ボタンが押下されたときの処理
  void _pushedToggleButton() {
    _isDone = app.toggleTask(_id);
    _colorChange();
  }

  void _colorChange() {
    setState(() {
      if (_isDone) {
        _isDoneColor = Color(0xFF4484EC);
      } else {
        _isDoneColor = Color(0xFF969696);
      }
    });
  }

  // カード要素の変数群
  late String _id;
  late int _order;
  late String _taskTitle;
  late String label;
  late String _date;
  late String _time;
  late bool _isDone;

  // タスクテキストウィジェット
  Widget _taskTitleText(double mediaWidth) {
    return Container(
      width: mediaWidth - 168,
      child: Text(
        _taskTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  // 時間・日付・ラベルテキスト
  Widget _dateTimeLabelText() {
    return Row(
      children: [
        Text(_date),
        SizedBox(width: 8),
        Container(
          height: 12,
          width: 1,
          decoration: BoxDecoration(color: Colors.black),
        ),
        SizedBox(width: 8),
        Text(_time),
        SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(color: Color(0xFF6bde89)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // タスクの未・済 変更ボタン
  Color _isDoneColor = Color(0xFF969696);
  Widget _isTaskButton() {
    return InkWell(
      onTap: () => _pushedToggleButton(),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: _isDoneColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(Icons.check, color: Colors.white, size: 38),
      ),
    );
  }

  // タスクカードの中身ウィジェット
  Widget _taskCardScreen(double mediaWidth) {
    return Container(
      height: 92 - 16,
      width: mediaWidth - 44, //両端 16・2 + 青線 12
      color: Color.fromARGB(0, 22, 22, 29),
      child: Stack(
        children: [
          // ここに要素
          Positioned(
            left: 12,
            child: Container(
              // color: Colors.red,
              width: mediaWidth - 144, //両端 16・2 + 青線 12 + 100
              child: Row(
                children: [
                  Icon(Icons.sticky_note_2, color: Color(0xFF969696)),
                  _taskTitleText(mediaWidth),
                ],
              ),
            ),
          ),

          Positioned(bottom: 12, left: 12, child: _dateTimeLabelText()),

          // タスク未・済
          Positioned(right: 12, child: _isTaskButton()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Label> labels = ref.watch(labelsProvider);
    Label label = labels.where((label) => label.name == task.label).first;
    final double mediaWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      height: 92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(100, 0, 0, 0),
            offset: Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),

      child: Stack(
        children: [
          // 横の青線
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 12,
              decoration: BoxDecoration(
                color: label.color, //ここがカラー
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
          ),
          // ここから要素
          Positioned(top: 16, left: 12, child: _taskCardScreen(mediaWidth)),
        ],
      ),
    );
  }
}
