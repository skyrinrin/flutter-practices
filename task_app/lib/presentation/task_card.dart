import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:provider/provider.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/domain.dart';
import 'package:task_app/provider/provider.dart';

class TaskCard extends ConsumerStatefulWidget {
  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  late Application app;
  // late List<Task> tasks;

  @override
  void initState() {
    super.initState();
    final app = ref.read(applicationProvider);
    // List<Task> tasks = ref.watch(taskProvider);
  }

  // トグルボタンが押下されたときの処理
  void _pushedToggleButton(int index) {
    setState(() {
      app.toggleTask(index);
    });
  }

  // タスクテキストウィジェット
  Widget _taskTitleText(double mediaWidth) {
    return Container(
      width: mediaWidth - 168,
      child: Text(
        '記事のリライトを進める',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  // 時間・日付・ジャンルテキスト
  Widget _dateTimeGnreText() {
    return Row(
      children: [
        Text('6/08'),
        Container(
          height: 12,
          width: 1,
          decoration: BoxDecoration(color: Colors.black),
        ),
        SizedBox(),
        Text('ブログ', maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  // タスクの未・済 変更ボタン
  Widget _isTaskButton() {
    return InkWell(
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Color(0xFF4484ec),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(Icons.check, color: Colors.white, size: 38),
      ),
    );
  }

  // タスクカードの中身ウィジェット
  Widget _taskCardScreen(double mediaWidth) {
    return Container(
      height: 100,
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

          Positioned(top: 44, left: 12, child: _dateTimeGnreText()),

          // タスク未・済
          Positioned(right: 12, child: _isTaskButton()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                color: Color(0xFF8FC3FF),
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
