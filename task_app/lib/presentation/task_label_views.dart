import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/presentation/task_card.dart';
import 'package:task_app/domain/task_domain.dart';
import 'package:task_app/provider/provider.dart';

class TaskLabelViews extends ConsumerStatefulWidget {
  @override
  ConsumerState<TaskLabelViews> createState() => _TaskLabelViewsState();
}

class _TaskLabelViewsState extends ConsumerState<TaskLabelViews> {
  late double listWidth;
  Widget labelExpansionPanel(Map labelsTasks, Application app) {
    return ExpansionPanelList(
      // materialGapSize: 0,
      expansionCallback: (int id, bool isExpanded) {
        setState(() {
          ref.read(labelsProvider.notifier).toggleLabel(id);
        });
      },
      children: labelsTasks.entries.map((entry) {
        final Label label = entry.key;
        final List<Task> tasks = entry.value;
        //
        double panel_height = tasks.length * 104 + 64;
        bool _isVisibility = false;
        if (tasks.isEmpty) {
          //ここら辺の処理はapplication層で任せるべきかも...
          panel_height = 60;
          _isVisibility = true;
        }
        Color color = label.color.withAlpha(200);

        return ExpansionPanel(
          backgroundColor: color,
          isExpanded: label.isExpanded,
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(
                label.name,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              trailing: IconButton(
                onPressed: () {
                  //ここに処理
                  app.removeLabel(label);
                },
                icon: Icon(Icons.settings, size: 25),
              ),
            );
          },

          body: Container(
            width: double.infinity,
            color: Colors.white,

            // color: Colors.white,
            height: panel_height,
            // height: 1000,
            // margin: EdgeInsets.only(top: -10),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: tasks.isEmpty
                ? Text(
                    '挑戦できるタスクはありません',
                    style: TextStyle(color: Colors.black87),
                  )
                :
                  //
                  // Expanded(
                  //   child:
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext, int index) {
                      return TaskCard(
                        task: tasks[index],
                        key: ValueKey(tasks[index].id),
                      );
                    },
                  ), //ここは絶対あとから追加する
          ),

          // TaskCard(task: task),

          // return Container(
          //   color: Colors.amber,
          //   height: panel_height,
          //   // width: listWidth,
          //   // margin: EdgeInsets.symmetric(vertical: 0),
          //   padding: EdgeInsets.symmetric(horizontal: 8), //検討が必要
          //   child: ListView.builder(
          //     physics: NeverScrollableScrollPhysics(),
          //     itemCount: tasks.length,
          //     itemBuilder: (BuildContext, int index) {
          //       return TaskCard(
          //         task: tasks[index],
          //         key: ValueKey(tasks[index].id),
          //       );
          //     },
          //   ), //ここは絶対あとから追加する
          //   // TaskCard(task: task),
          // );
          //

          // Column(
          //     children: tasks.map((task) {
          //       return Expanded(
          //         child: ListView.builder(
          //           physics: NeverScrollableScrollPhysics(),
          //           itemCount: tasks.length,
          //           itemBuilder: (BuildContext, int index) {
          //             return TaskCard(
          //               task: tasks[index],
          //               key: ValueKey(tasks[index].id),
          //             );
          //           },
          //         ), //ここは絶対あとから追加する
          //       );

          //       // TaskCard(task: task),

          //       // return Container(
          //       //   color: Colors.amber,
          //       //   height: panel_height,
          //       //   // width: listWidth,
          //       //   // margin: EdgeInsets.symmetric(vertical: 0),
          //       //   padding: EdgeInsets.symmetric(horizontal: 8), //検討が必要
          //       //   child: ListView.builder(
          //       //     physics: NeverScrollableScrollPhysics(),
          //       //     itemCount: tasks.length,
          //       //     itemBuilder: (BuildContext, int index) {
          //       //       return TaskCard(
          //       //         task: tasks[index],
          //       //         key: ValueKey(tasks[index].id),
          //       //       );
          //       //     },
          //       //   ), //ここは絶対あとから追加する
          //       //   // TaskCard(task: task),
          //       // );
          //     }).toList(),
          //   ),
          // ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    listWidth = MediaQuery.of(context).size.width - 32;
    // List<Task> tasks = ref.watch(tasksProvider);
    // List<Label> labels = ref.watch(labelsProvider);
    Application app = ref.read(applicationProvider);
    final labelsTasks = ref.watch(labelsTasksProvider);

    return labelExpansionPanel(labelsTasks, app);
  }
}
