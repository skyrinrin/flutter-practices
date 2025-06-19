import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TaskHomeView());
  }
}

class TaskHomeView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(child: Column(children: [TaskLabelViews()]));
  }
}
// class TaskHomeView extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SingleChildScrollView(child: Column(children: [TaskLabelViews()]));
//   }
// }

class TaskLabelViews extends ConsumerStatefulWidget {
  @override
  ConsumerState<TaskLabelViews> createState() => _TaskLabelViewsState();
}

class _TaskLabelViewsState extends ConsumerState<TaskLabelViews> {
  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    //     final tasks = ref.read(tasksProvider);
    isExpandedList = List.generate(3, (_) => false); //仮 tasks.lengthにする
  }

  Widget labelExpansionPanel(
    //     List<Task> tasks,
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

                //                 TaskCard(task: tasks[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //     List<Task> tasks = ref.watch(tasksProvider);

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), //親にスクロールを任せる
      children: [
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              isExpandedList[index] = !isExpandedList[index];
            });
          },
          children: List.generate(3, (index) {
            return ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return ListTile(title: Text('ラベル$index'));
              },
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('サンプル'),
              ),
              isExpanded: isExpandedList[index], // ✅ 必須
            );
          }),
        ),
      ],
    );
  }
}

// isExpandedの管理が必要

//// riverpodを使わない ////

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: TaskHomeView());
//   }
// }

// class TaskHomeView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(child: Column(children: [TaskLabelViews()]));
//   }
// }
// // class TaskHomeView extends ConsumerWidget {
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     return SingleChildScrollView(child: Column(children: [TaskLabelViews()]));
// //   }
// // }

// class TaskLabelViews extends StatefulWidget {
//   @override
//   _TaskLabelViewsState createState() => _TaskLabelViewsState();
// }

// class _TaskLabelViewsState extends State<TaskLabelViews> {
//   List<bool> isExpandedList = [];
//   bool _isExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     //     final tasks = ref.read(tasksProvider);
//     isExpandedList = List.generate(3, (_) => false); //仮 tasks.lengthにする
//   }

//   Widget labelExpansionPanel(
//     //     List<Task> tasks,
//     String labelName,
//     bool isExpanded,
//   ) {
//     // bool isExpanded = false;
//     return ExpansionPanelList(
//       expansionCallback: (int index, bool isExpanded) {
//         setState(() {
//           _isExpanded = !_isExpanded;
//         });
//       },
//       children: [
//         ExpansionPanel(
//           isExpanded: _isExpanded,
//           headerBuilder: (BuildContext context, bool isExpanded) {
//             return ListTile(title: Text(labelName));
//           },

//           body: SizedBox(
//             height: 300,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemBuilder: (BuildContext context, int index) {
//                 return Container(
//                   height: 100,
//                   width: 100,
//                   child: Text('$index'),
//                 );

//                 //                 TaskCard(task: tasks[index]);
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     //     List<Task> tasks = ref.watch(tasksProvider);

//     return ListView(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(), //親にスクロールを任せる
//       children: [
//         ExpansionPanelList(
//           expansionCallback: (int index, bool isExpanded) {
//             setState(() {
//               _isExpanded = !_isExpanded;
//             });
//           },
//           children: List.generate(3, (index) {
//             return ExpansionPanel(
//               headerBuilder: (context, isExpanded) {
//                 return ListTile(title: Text('ラベル$index'));
//               },
//               body: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text('サンプル'),
//               ),
//               isExpanded: _isExpanded, // ✅ 必須
//             );
//           }),
//         ),
//         ExpansionPanelList(
//           expansionCallback: (int index, bool isExpanded) {
//             setState(() {
//               isExpandedList[index] = !isExpandedList[index];
//             });
//           },
//           children: List.generate(3, (index) {
//             return ExpansionPanel(
//               headerBuilder: (context, isExpanded) {
//                 return ListTile(title: Text('ラベル$index'));
//               },
//               body: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text('サンプル'),
//               ),
//               isExpanded: isExpandedList[index], // ✅ 必須
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }
