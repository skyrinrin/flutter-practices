import 'package:flutter/material.dart';
import 'package:task_app/domain/task_domain.dart';

class TaskDetail extends StatefulWidget {
  TaskDetail({super.key, task});
  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Widget _cardFrame() {
    return Container(
      height: 280,
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF8FC3FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ), //ここの色は各自変更
            height: 280,
            width: 20,
          ),
          _cardValue(),
        ],
      ),
    );
  }

  Widget _cardValue() {
    return Stack(children: [Positioned(child: Text('サンプル'))]);
  }

  @override
  Widget build(BuildContext context) {
    // return SimpleDialog(
    // backgroundColor: Colors.white,
    // children: [
    return Center(
      // height: 300,
      // width: 500
      // margin: EdgeInsets.all(50),
      // color: Colors.amber,
      child: _cardFrame(),
    );
    //   ],
    // );
  }
}
