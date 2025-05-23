import 'package:flutter/material.dart';
import 'package:task_app/task_card.dart';
import 'add_task.dart';

class TaskPageValue extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Text('今日(3)', style: TextStyle(fontSize: 20)),
          // ),
          Text('今日(3)', style: TextStyle(fontSize: 20)),
          SizedBox(height: 16),
          Column(children: [TaskCard(), TaskCard()]),

          // Positioned(top: 42, right: 0, left: 0, child: TaskCard()),
          // Positioned(child: TaskCard()),
        ],
      ),
    );
  }
}
