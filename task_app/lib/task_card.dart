import 'package:flutter/material.dart';
import 'add_task.dart';

class TaskCard extends StatefulWidget {
  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}
