import 'package:flutter/material.dart';
import 'package:task_app/domain/task_domain.dart';

class TaskDetail extends StatefulWidget {
  TaskDetail({super.key, task});
  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      // backgroundColor: Colors.white,
      children: [
        Container(
          // height: 100,
          // width: 100,
          margin: EdgeInsets.all(100),
          color: Colors.white,
          child: Text('サンプル'),
        ),
      ],
    );
  }
}
