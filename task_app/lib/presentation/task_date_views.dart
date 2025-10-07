import 'dart:io';
// import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/presentation/task_card.dart';
import 'package:task_app/domain/task_domain.dart';
import 'package:task_app/provider/provider.dart';

class TaskDateViews extends ConsumerStatefulWidget {
  int number;
  TaskDateViews({super.key, required this.number});

  @override
  ConsumerState<TaskDateViews> createState() => _TaskDateViewsState();
}

class _TaskDateViewsState extends ConsumerState<TaskDateViews> {
  //もっと見るウィジェット
  late Application app;
  late final removeListener;
  late double listWidth;
  // late List<Task> selectedTasks;
  List<Task> doneTasks = [];
  List<Task> notDoneTasks = [];
  // late List<Task> doneTasks;
  // late List<Task> notDoneTasks;
  late String listTitle;
  double donelistHeight = 150;
  double notDonelistHeight = 150;
  Icon _icon = Icon(
    Icons.keyboard_arrow_down,
    color: const Color.fromARGB(255, 92, 91, 91),
    size: 40,
  );

  bool isOpened = false;
  // bool isVisibility = false;
  bool isListening = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    app = ref.watch(applicationProvider);
    int number = widget.number;
    doneTasks = app.getDateKind(widget.number).$1;
    notDoneTasks = app.getDateKind(widget.number).$2;
    listTitle = app.getDateKind(number).$3;

    donelistHeight = getListHeight(doneTasks);
    notDonelistHeight = getListHeight(notDoneTasks);
    // isVisibility = false;

    isOpened_false();
  }

  double getListHeight(List<Task> task) {
    return (task.length) * 104 + 40;
  }

  void isOpened_true() {
    // selectedTasks = app.getDateKind(widget.number).$1;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    doneTasks = app.getDateKind(widget.number).$1;
    notDoneTasks = app.getDateKind(widget.number).$2;
    // });

    if (doneTasks.isEmpty && notDoneTasks.isEmpty) {
      donelistHeight = 160;
      notDonelistHeight = 160;
      // isVisibility = true;
    } else {
      // print('ここまで来たよ');
      // isVisibility = false;
      donelistHeight = getListHeight(doneTasks);
      notDonelistHeight = getListHeight(notDoneTasks);
      if (donelistHeight <= 280) {
        //ここの280という数値も見直すべき
        donelistHeight = 280;
        // print('小さい');
      }
      if (notDonelistHeight <= 280) {
        notDonelistHeight = 280;
      }
    }
    _icon = Icon(
      Icons.keyboard_arrow_up,
      color: const Color.fromARGB(255, 92, 91, 91),
      size: 40,
    );

    // listHeight = 500;
    // print('発火: ${isOpened}:${listHeight}');
  }

  void isOpened_false() {
    donelistHeight = getListHeight(doneTasks);
    notDonelistHeight = getListHeight(notDoneTasks);
    if (donelistHeight >= 150 || donelistHeight <= 150) {
      donelistHeight = 150;
    }
    if (notDonelistHeight >= 150 || notDonelistHeight <= 150) {
      notDonelistHeight = 150;
    }

    // donelistHeight = 280;
    // notDonelistHeight = 280;
    _icon = Icon(
      Icons.keyboard_arrow_down,
      color: Color.fromARGB(255, 92, 91, 91),
      size: 40,
    );
    // print('発火: ${isOpened}:${listHeight}');
  }

  toggleIsOpened() {
    isOpened = !isOpened;
    if (isOpened == true) {
      setState(() {
        isOpened_true();
      });
    } else {
      setState(() {
        isOpened_false();
      });
    }
  }

  void _pushedMoreSeeButton() {
    toggleIsOpened();
  }

  Widget _moreSeeButton() {
    return GestureDetector(
      onTap: () => {_pushedMoreSeeButton()},
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              width: listWidth,
              height: 100,
              color: Colors.white,
            ),
          ),

          Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width / 2 - 40,
            child: _icon,
          ),
        ],
      ),
    );
  }

  // カードのリストビューウィジェット
  Widget _cardsView(BuildContext context, List<Task> tasks, double height) {
    return Container(
      // color: Colors.amber,
      height: height,

      // color: Colors.amber,
      width: listWidth,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 16),
        physics: NeverScrollableScrollPhysics(),
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          // print(
          //   'cardsViewが呼び出された ${tasks[index].id}, ${tasks.length} : $index ',
          // );
          return TaskCard(task: tasks[index], key: ValueKey(tasks[index].id));
        },
      ),
    );
  }

  // 達成、未達成テーマウィジェット
  Widget _clearTitle(List<Task> tasks, bool isClear) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.only(left: 8),
      color: Color.fromARGB(255, 126, 196, 236),
      child: Text(
        isClear ? '達成済み(${tasks.length})' : '未達成(${tasks.length})',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget opacityCon() {
    return Visibility(
      visible: !isOpened,
      child: InkWell(
        onTap: () {
          toggleIsOpened();
        },
        child: Opacity(
          opacity: 0.5,
          child: Container(width: listWidth, height: 80, color: Colors.white),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    listWidth = MediaQuery.of(context).size.width - 32;

    final app = ref.read(applicationProvider);
    // final tasks = ref.watch(tasksProvider);

    // ここにあった
    // ref.listen<List<Task>>(tasksProvider, (previous, next) {
    //   print('呼ばれました: taskDateViews');
    //   doneTasks = app.getDateKind(widget.number).$1;
    //   notDoneTasks = app.getDateKind(widget.number).$2;
    // });

    ref.listen<List<Task>>(app.getDateKindProvider(widget.number), (
      // 8/13 ここの処理ですべて（今日、明日、その他）のlistHeightの高さを変えてしまうためエラーが起こる可能性あり...(現在はif処理で開かれているもの以外は高さを変えないようにしている)
      previous,
      next,
    ) {
      if (isOpened) {
        final doneTasks = next.where((task) => task.isDone).toList();
        final notDoneTasks = next
            .where((task) => task.isDone == false)
            .toList();
        donelistHeight = getListHeight(doneTasks);
        notDonelistHeight = getListHeight(notDoneTasks);
        if (donelistHeight <= 280) {
          donelistHeight = 280;
        }
        if (notDonelistHeight <= 280) {
          notDonelistHeight = 280;
        }
      } else {
        donelistHeight = 150;
        notDonelistHeight = 150;
      }
    });

    final (doneTasks, notDoneTasks, listTitle) = app.getDateKind(widget.number);

    // isVisibility = app.getDateListsHightBool(doneTasks, notDoneTasks).$2;
    // isVisibility = false;

    if (doneTasks.isEmpty && notDoneTasks.isEmpty) {
      // isVisibility = true;
      donelistHeight = 100;
      notDonelistHeight = 100;
    }

    return (doneTasks.isEmpty && notDoneTasks.isEmpty)
        ? Container(
            height: 140,

            margin: EdgeInsets.only(top: 24, left: 16, right: 16),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    listTitle,
                    style: TextStyle(fontSize: 20, color: Color(0xFF6B6868)),
                  ),
                ),
                SizedBox(height: 16),
                Positioned(
                  left: 5,
                  top: 40,
                  child: Container(child: Text('挑戦できるタスクがありません')),
                ),
                Positioned(bottom: 0, child: _moreSeeButton()),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 24, left: 16, right: 16),
            child: Stack(
              children: [
                Text(listTitle, style: TextStyle(fontSize: 20)),
                SizedBox(height: 16),
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        _clearTitle(notDoneTasks, false),

                        Stack(
                          children: [
                            Positioned(
                              top: 16,
                              child: Text(
                                '挑戦できるタスクがありません',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 92, 91, 91),
                                ),
                              ),
                            ),
                            Positioned(
                              child: _cardsView(
                                context,
                                notDoneTasks,
                                notDonelistHeight,
                              ),
                            ),
                            Positioned(bottom: 0, child: opacityCon()),
                          ],
                        ),

                        SizedBox(height: 24),
                        _clearTitle(doneTasks, true),
                        Stack(
                          children: [
                            Positioned(
                              top: 16,
                              child: Text(
                                '達成していないタスクに挑戦しましょう！',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 92, 91, 91),
                                ),
                              ),
                            ),
                            _cardsView(context, doneTasks, donelistHeight),
                            Positioned(bottom: 0, child: opacityCon()),
                          ],
                        ),
                        _moreSeeButton(),
                      ],
                    ),
                    // Positioned(bottom: 0, child: _moreSeeButton()),
                  ],
                ),
              ],
            ),
          );
  }
}
