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

  void _pushedToggleButton(int index) {
    setState(() {
      app.toggleTask(index);
    });
  }

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
