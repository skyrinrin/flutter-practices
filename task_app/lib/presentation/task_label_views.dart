import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/presentation/task_card.dart';
import 'package:task_app/domain/task_domain.dart';
import 'package:task_app/provider/provider.dart';

class TaskLabelViews extends ConsumerStatefulWidget {
  @override
  ConsumerState<TaskLabelViews> createState() => _TaskLabelViewsState();
  // Widget expansionTaskWidget(String labelName, List<Task> tasks) {
  //   return ExpansionPanelList(
  //     children: [
  //       ExpansionPanel(
  //         headerBuilder: (BuildContext context, bool isExpanded) {
  //           return ListTile(
  //             title: Text(labelName),
  //           ); //リストタイルを使うのとテキストを使うのの違いが判らない
  //         },
  //         body: ListView.builder(
  //           itemCount: tasks.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             return TaskCard(task: tasks[index]);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final labelsTasks = ref.watch(labelsNameProvider);

  //   return expansionTaskWidget(
  //     labelsTasks
  //         .entries
  //         .first
  //         .key, //次にすること： タスクを追加したときにラベルにジャンル分けすること、そしてその時間関係をしっかりしてnullエラーが起こらないようにする
  //     labelsTasks.entries.first.value,
  //   );
  // }
}

class _TaskLabelViewsState extends ConsumerState<TaskLabelViews> {
  //
  Widget sampleWidget() {
    bool _isExpanded = false;
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          isExpanded: _isExpanded,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(isExpanded ? 'Tap to close' : 'Tap to expand'),
            );
          },
          body: ListTile(
            title: Text('Expanded!'),
            subtitle: Text('Here is the content'),
          ),
        ),
      ],
    );
  }

  //

  Widget labelExpansionPanel(
    List<Task> tasks,
    String labelName,
    bool isExpanded,
  ) {
    // bool isExpanded = false;
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(title: Text(labelName));
          },

          body: SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 100,
                  width: 100,
                  child: Text('$index'),
                );

                TaskCard(task: tasks[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = ref.watch(tasksProvider);
    bool isExpanded = false;

    return Container(
      color: Colors.blue,
      height: 1000,
      // height: double.infinity,
      width: double.infinity,
      // child: labelExpansionPanel(tasks, 'サンプル'),
      child: ListView(
        shrinkWrap: true,
        children: [
          labelExpansionPanel(tasks, 'サンプル1', isExpanded),
          sampleWidget(),
        ],
      ),
      // child: sampleWidget(),
    );
  }
}
 

// isExpandedの管理が必要