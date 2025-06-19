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
  // List<bool> isExpandedList = [];

  // @override
  // void initState() {
  //   super.initState();
  //   final tasks = ref.read(tasksProvider);
  //   final labels = ref.read(labelsProvider);
  //   isExpandedList = List.generate(
  //     labels.length,
  //     (_) => false,
  //   ); //仮 tasks.lengthにする
  // }

  //
  // Widget sampleWidget(bool _isExpanded) {
  //   return ExpansionPanelList(
  //     expansionCallback: (int index, bool isExpanded) {
  //       setState(() {
  //         _isExpanded = !_isExpanded;
  //       });
  //     },
  //     children: [
  //       ExpansionPanel(
  //         isExpanded: _isExpanded,
  //         headerBuilder: (BuildContext context, bool isExpanded) {
  //           return ListTile(
  //             title: Text(isExpanded ? 'Tap to close' : 'Tap to expand'),
  //           );
  //         },
  //         body: ListTile(
  //           title: Text('Expanded!'),
  //           subtitle: Text('Here is the content'),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  //

  Widget labelExpansionPanel(
    List<Task> tasks,
    List<Label> labels,
    // List<bool> isExpandedList,
    // bool isExpanded,
  ) {
    // bool isExpanded = false;
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          ref.read(labelsProvider.notifier).toggleLabel(index);
        });
      },
      children: List.generate(labels.length, (index) {
        return ExpansionPanel(
          isExpanded: labels[index].isExpanded,
          headerBuilder: (context, isExpanded) {
            return ListTile(title: Text(labels[index].name));
          },

          body: Container(
            margin: EdgeInsets.only(right: 16, left: 16),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: tasks.length, //ここも数が変わる
              itemBuilder: (BuildContext context, int index) {
                return TaskCard(
                  task: tasks[index], //ここでフィルタリングしたデータを表示しないといけない
                );
              },
            ),
          ),
          // height: 300,
        );
      }),
      // children: [
      //   ExpansionPanel(
      //     headerBuilder: (BuildContext context, bool isExpanded) {
      //       return ListTile(title: Text(labelNames[index]));
      //     },

      //     body: SizedBox(
      //       height: 300,
      //       child: ListView.builder(
      //         shrinkWrap: true,
      //         itemBuilder: (BuildContext context, int index) {
      //           return Container(
      //             height: 100,
      //             width: 100,
      //             child: Text('$index'),
      //           );

      //           TaskCard(task: tasks[index]);
      //         },
      //       ),
      //     ),
      //   ),
      // ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   List<Task> tasks = ref.watch(tasksProvider);

  //   ///サンプル
  //   // return Container(
  //   //   color: Colors.blue,
  //   //   height: 1000,
  //   //   // height: double.infinity,
  //   //   width: double.infinity,
  //   //   // child: labelExpansionPanel(tasks, 'サンプル'),
  //   //   child:
  //   return ListView(
  //     shrinkWrap: true,
  //     children: [
  //       // labelExpansionPanel(tasks, 'サンプル1', isExpandedList[0]),
  //       // sampleWidget(isExpandedList[1]),
  //       ExpansionPanelList(
  //         expansionCallback: (int index, bool isExpanded) {
  //           setState(() {
  //             isExpandedList[index] = !isExpanded;
  //           });
  //         },
  //         children: List.generate(3, (index) {
  //           return ExpansionPanel(
  //             headerBuilder: (context, isExpanded) {
  //               return ListTile(title: Text('ラベル$index'));
  //             },

  //             body: //ここから
  //                 Text('サンプル'),
  //           );
  //         }),
  //       ),

  //       ExpansionPanelList(
  //         expansionCallback: (int index, bool isExpanded) {
  //           setState(() {
  //             print('動く前${isExpandedList[index]}');
  //             isExpandedList[index] = !isExpandedList[index];
  //             print('動いてる${isExpandedList[index]}');
  //           });
  //         },
  //         children: [
  //           ExpansionPanel(
  //             headerBuilder: (BuildContext context, bool isExpanded) {
  //               return ListTile(
  //                 title: Text(isExpanded ? 'Tap to close' : 'Tap to expand'),
  //               );
  //             },
  //             body: ListTile(
  //               title: Text('Expanded!'),
  //               subtitle: Text('Here is the content'),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  //   // child: sampleWidget(),
  //   // );
  // }

  // ラベルリストが更新されたときに実行 didChangeDependenciesを理解しておく
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final labels = ref.watch(labelsProvider);

  //   if (labels.length > isExpandedList.length) {
  //     final additional = List.generate(
  //       labels.length - isExpandedList.length,
  //       (_) => false,
  //     );
  //     setState(() {
  //       isExpandedList.addAll(additional);
  //       print(
  //         'isExpandedが追加されました: isExpanded:${isExpandedList.length} : labels ${labels.length} ',
  //       );
  //     });
  //   }
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final labels = ref.watch(labelsProvider);

  //   // ラベル数が変わったときだけリストを増やす
  //   if (labels.length > isExpandedList.length) {
  //     setState(() {
  //       isExpandedList.addAll(
  //         List.generate(labels.length - isExpandedList.length, (_) => false),
  //       );
  //       print(
  //         'isExpandedが追加されました: isExpanded:${isExpandedList.length} : labels ${labels.length} ',
  //       );
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = ref.watch(tasksProvider);
    // List<String> labelNames = ref.watch(labelsNameProvider);
    List<Label> labels = ref.watch(labelsProvider);
    // List<bool> isExpandedList = ref.watch(isExpandedListProvider);

    return ListView(
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(), //親にスクロールを任せる
      children: [
        labelExpansionPanel(tasks, labels),

        // //
        // ExpansionPanelList(
        //   expansionCallback: (int index, bool isExpanded) {
        //     setState(() {
        //       labels[index].isExpanded = !labels[index].isExpanded;
        //     });
        //   },
        //   children: List.generate(labels.length, (index) {
        //     return ExpansionPanel(
        //       headerBuilder: (context, isExpanded) {
        //         return ListTile(title: Text(labels[index].name));
        //       },

        //       body:
        //       // height: 300,
        //       ListView.builder(
        //         shrinkWrap: true,
        //         itemCount: tasks.length, //ここも数が変わる
        //         itemBuilder: (BuildContext context, int index) {
        //           return TaskCard(
        //             task: tasks[index], //ここでフィルタリングしたデータを表示しないといけない
        //           );
        //         },
        //       ),
        //     );
        //   }),
        // ),
        // //

        // ExpansionPanelList(
        //   expansionCallback: (int index, bool isExpanded) {
        //     setState(() {
        //       isExpandedList[index] = !isExpandedList[index];
        //     });
        //   },
        //   children: List.generate(3, (index) {
        //     return ExpansionPanel(
        //       headerBuilder: (context, isExpanded) {
        //         return ListTile(title: Text('ラベル$index'));
        //       },
        //       body: Padding(
        //         padding: const EdgeInsets.all(16.0),
        //         child: Text('サンプル'),
        //       ),
        //       isExpanded: isExpandedList[index], // ✅ 必須
        //     );
        //   }),
        // ),
      ],
    );
  }
}
 

// isExpandedの管理が必要