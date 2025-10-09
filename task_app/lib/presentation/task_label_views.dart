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
  Widget labelExpansionPanel(Map labelsTasks, Application app) {
    return ExpansionPanelList(
      expansionCallback: (int id, bool isExpanded) {
        setState(() {
          ref.read(labelsProvider.notifier).toggleLabel(id);
        });
      },
      children: labelsTasks.entries.map((entry) {
        final Label label = entry.key;
        final List<Task> labelTasks = entry.value;
        //
        double panel_height = labelTasks.length * 104 + 24;
        bool _isVisibility = false;
        if (labelTasks.isEmpty) {
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
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: labelTasks.isEmpty
                ? Text(
                    '挑戦できるタスクはありません',
                    style: TextStyle(color: Colors.black87),
                  )
                : Column(
                    children: labelTasks.map((task) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: null, //ここは絶対あとから追加する
                        // TaskCard(task: task),
                      );
                    }).toList(),
                  ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // List<Task> tasks = ref.watch(tasksProvider);
    // List<Label> labels = ref.watch(labelsProvider);
    Application app = ref.read(applicationProvider);
    final labelsTasks = ref.watch(labelsTasksProvider);

    return labelExpansionPanel(labelsTasks, app);
  }
}
