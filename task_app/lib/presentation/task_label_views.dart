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
    Map labelsTasks,
    Application app,
    // List<bool> isExpandedList,
    // bool isExpanded,
  ) {
    // bool isExpanded = false;

    // List<Task> labelsTasks = [];

    // for (int i = 0; i < tasks.length; i ++) {
    //   if tasks[i].label == labels
    // }

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          ref.read(labelsProvider.notifier).toggleLabel(index);
        });
      },
      // children: List.generate(labels.length, (index) {
      children:
          labelsTasks.entries.map((entry) {
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
              // backgroundColor: Colors.white,
              backgroundColor: color,
              // splashColor: color,
              // highlightColor: color,
              isExpanded: label.isExpanded,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  title: Text(
                    label.name,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              },

              body: Container(
                height: panel_height,
                // height: labelsTasksList.length * 1040,
                // height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.only(top: 16),

                // margin: EdgeInsets.only(top: -10),

                // ここ
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 8),
                      child: Visibility(
                        visible: _isVisibility,
                        child: Text(
                          '挑戦できるタスクはありません',
                          style: TextStyle(
                            color: Color.fromARGB(9100, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    //
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),

                      itemCount: labelTasks.length,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: TaskCard(task: labelTasks[i]),
                        );
                      },
                    ),
                  ],
                ),

                // ここ
                // child: ListView.builder(
                //   physics: NeverScrollableScrollPhysics(),

                //   itemCount: labelTasks.length,
                //   itemBuilder:
                //   // (context, index) => Container(
                //   //   margin: EdgeInsets.only(right: 16, left: 16),
                //   //   child: ListView.builder(
                //   //     physics: NeverScrollableScrollPhysics(),
                //   //     shrinkWrap: true,
                //   //     itemCount: tasks.length, //ここも数が変わる
                //   //     itemBuilder: (BuildContext context, int i) {
                //   //       return TaskCard(
                //   //         // task: tasks[index], //ここでフィルタリングしたデータを表示しないといけない
                //   //         task: labelsTasksList[index], //ここがなんで動いているのかわからない
                //   //       );
                //   //     },
                //   //   ),
                //   // ),
                //   (context, i) {
                //     return Container(
                //       margin: EdgeInsets.symmetric(horizontal: 16),
                //       child: TaskCard(task: labelTasks[i]),
                //     );
                // },
                // ),
              ),

              // height: 300,
            );
          }).toList(),
    );
    // {
    //   // List<List> labelsTasksList = List.generate(labels.length, (list) => []);
    //   // // List<Task> labelsTasks = [];

    //   // for (int j = 0; j < labels.length; j++) {
    //   //   for (int i = 0; i < tasks.length; i++) {
    //   //     if (tasks[i].label == labels[index].name) {
    //   //       labelsTasksList[j].add(tasks[i]);
    //   //       print(
    //   //         'ラベルにタスクが追加されました: ${labels[index].name}: ${labelsTasksList[j]} : タスクの数 : ${labelsTasksList.length}',
    //   //       );
    //   //     } else {
    //   //       print(
    //   //         'どのラベルにも当てはまりませんでした。: ${tasks[i].label} : ${labels[index]}}',
    //   //       );
    //   //     }
    //   //   }
    //   // }

    //   // List<Task> labelsTasksList =
    //   //     tasks.where((task) => task.label == labels[index].name).toList();

    //   // Color color = app.decodeHexColor(labels[index].color);
    //   Color color = labels[index].color.withAlpha(200);

    //   return ExpansionPanel(
    //     // backgroundColor: Colors.white,
    //     backgroundColor: color,
    //     // splashColor: color,
    //     // highlightColor: color,
    //     isExpanded: labels[index].isExpanded,
    //     headerBuilder: (context, isExpanded) {
    //       return ListTile(
    //         title: Text(
    //           labels[index].name,
    //           style: TextStyle(color: Colors.white, fontSize: 18),
    //         ),
    //       );
    //     },

    //     body: Container(
    //       height: labelsTasksList.length * 104 + 24,
    //       // height: labelsTasksList.length * 1040,
    //       // height: double.infinity,
    //       width: double.infinity,
    //       color: Colors.white,
    //       padding: EdgeInsets.only(top: 16),

    //       // margin: EdgeInsets.only(top: -10),
    //       child: ListView.builder(
    //         physics: NeverScrollableScrollPhysics(),

    //         itemCount: labelsTasksList.length,
    //         itemBuilder:
    //         // (context, index) => Container(
    //         //   margin: EdgeInsets.only(right: 16, left: 16),
    //         //   child: ListView.builder(
    //         //     physics: NeverScrollableScrollPhysics(),
    //         //     shrinkWrap: true,
    //         //     itemCount: tasks.length, //ここも数が変わる
    //         //     itemBuilder: (BuildContext context, int i) {
    //         //       return TaskCard(
    //         //         // task: tasks[index], //ここでフィルタリングしたデータを表示しないといけない
    //         //         task: labelsTasksList[index], //ここがなんで動いているのかわからない
    //         //       );
    //         //     },
    //         //   ),
    //         // ),
    //         (context, i) {
    //           return Container(
    //             margin: EdgeInsets.symmetric(horizontal: 16),
    //             child: TaskCard(task: labelsTasksList[i]),
    //           );
    //         },
    //       ),
    //     ),

    //     // height: 300,
    //   );

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
    Application app = ref.read(applicationProvider);
    final labelsTasks = ref.watch(labelsTasksProvider);
    // List<bool> isExpandedList = ref.watch(isExpandedListProvider);

    return labelExpansionPanel(labelsTasks, app);

    // ListView(
    //   shrinkWrap: true,
    //   // physics: NeverScrollableScrollPhysics(), //親にスクロールを任せる
    //   children: [
    //     labelExpansionPanel(tasks, labels),

    //     // //
    //     // ExpansionPanelList(
    //     //   expansionCallback: (int index, bool isExpanded) {
    //     //     setState(() {
    //     //       labels[index].isExpanded = !labels[index].isExpanded;
    //     //     });
    //     //   },
    //     //   children: List.generate(labels.length, (index) {
    //     //     return ExpansionPanel(
    //     //       headerBuilder: (context, isExpanded) {
    //     //         return ListTile(title: Text(labels[index].name));
    //     //       },

    //     //       body:
    //     //       // height: 300,
    //     //       ListView.builder(
    //     //         shrinkWrap: true,
    //     //         itemCount: tasks.length, //ここも数が変わる
    //     //         itemBuilder: (BuildContext context, int index) {
    //     //           return TaskCard(
    //     //             task: tasks[index], //ここでフィルタリングしたデータを表示しないといけない
    //     //           );
    //     //         },
    //     //       ),
    //     //     );
    //     //   }),
    //     // ),
    //     // //

    //     // ExpansionPanelList(
    //     //   expansionCallback: (int index, bool isExpanded) {
    //     //     setState(() {
    //     //       isExpandedList[index] = !isExpandedList[index];
    //     //     });
    //     //   },
    //     //   children: List.generate(3, (index) {
    //     //     return ExpansionPanel(
    //     //       headerBuilder: (context, isExpanded) {
    //     //         return ListTile(title: Text('ラベル$index'));
    //     //       },
    //     //       body: Padding(
    //     //         padding: const EdgeInsets.all(16.0),
    //     //         child: Text('サンプル'),
    //     //       ),
    //     //       isExpanded: isExpandedList[index], // ✅ 必須
    //     //     );
    //     //   }),
    //     // ),
    //   ],
    // );
  }
}
 

// isExpandedの管理が必要