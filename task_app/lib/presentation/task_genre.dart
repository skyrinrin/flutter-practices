import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/presentation/task_card.dart';
import 'package:task_app/domain/domain.dart';
import 'package:task_app/provider/provider.dart';

class TaskPageValue extends ConsumerWidget {
  // カードのリストビューウィジェット
  Widget _cardsView(BuildContext context, List<Task> tasks) {
    return Container(
      // color: Colors.amber,
      height: MediaQuery.of(context).size.height - 200,

      padding: EdgeInsets.only(bottom: 12, right: 4, left: 4, top: 0),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return TaskCard(task: tasks[index]);
        },
      ),
    );
  }

  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> tasks = ref.watch(taskProvider);
    return Container(
      margin: EdgeInsets.only(top: 24, left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Text('今日(3)', style: TextStyle(fontSize: 20)),
          // ),
          Text('今日(3)', style: TextStyle(fontSize: 20)),
          SizedBox(height: 16),
          Column(
            children: [
              // TaskCard(
              //   task: Task(
              //     id: 0,
              //     title: 'task_genreサンプル',
              //     label: 'sample',
              //     date: '06/08',
              //     time: '12:00',
              //   ),
              // ),
              _cardsView(context, tasks),
            ],
          ),

          // Positioned(top: 42, right: 0, left: 0, child: TaskCard()),
          // Positioned(child: TaskCard()),
        ],
      ),
    );
  }
}
