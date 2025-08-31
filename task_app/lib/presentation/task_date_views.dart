import 'dart:io';
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
  late List<Task> doneTasks;
  late List<Task> notDoneTasks;
  late String listTitle;
  double listHeight = 280;
  Icon _icon = Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 40);

  bool isOpened = false;
  bool isVisibility = false;
  bool isListening = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    app = ref.watch(applicationProvider);
    int number = widget.number;
    doneTasks = app.getDateKind(widget.number).$1;
    notDoneTasks = app.getDateKind(widget.number).$2;
    listTitle = app.getDateKind(number).$3;

    listHeight = app.getDateListsHightBool(doneTasks, notDoneTasks).$1;
    isVisibility = app.getDateListsHightBool(doneTasks, notDoneTasks).$2;

    isOpened_false();
  }

  void isOpened_true() {
    // selectedTasks = app.getDateKind(widget.number).$1;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    doneTasks = app.getDateKind(widget.number).$1;
    notDoneTasks = app.getDateKind(widget.number).$2;
    // });

    if (doneTasks.isEmpty && notDoneTasks.isEmpty) {
      listHeight = 160;
      isVisibility = true;
    } else {
      isVisibility = false;
      listHeight = app.getDateListsHightBool(doneTasks, notDoneTasks).$1;
      if (listHeight <= 280) {
        //ここの280という数値も見直すべき
        listHeight = 280;
        // print('小さい');
      }
    }
    _icon = Icon(Icons.keyboard_arrow_up, color: Colors.black, size: 40);

    // listHeight = 500;
    // print('発火: ${isOpened}:${listHeight}');
  }

  void isOpened_false() {
    listHeight = 280;
    _icon = Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 40);
    // print('発火: ${isOpened}:${listHeight}');
  }

  void _pushedMoreSeeButton() {
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
  Widget _cardsView(BuildContext context, List<Task> tasks) {
    return Container(
      // color: Colors.amber,
      height: listHeight,

      width: listWidth,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          print(
            'cardsViewが呼び出された ${tasks[index].id}, ${tasks.length} : $index ',
          );
          return TaskCard(task: tasks[index], key: ValueKey(tasks[index].id));
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    listWidth = MediaQuery.of(context).size.width - 32;

    final app = ref.watch(applicationProvider);

    ref.listen<List<Task>>(app.getDateKindProvider(widget.number), (
      // 8/13 ここの処理ですべて（今日、明日、その他）のlistHeightの高さを変えてしまうためエラーが起こる可能性あり...(現在はif処理で開かれているもの以外は高さを変えないようにしている)
      previous,
      next,
    ) {
      if (isOpened) {
        listHeight = (next.length + 1.5) * 104;
      } else {
        listHeight = 280;
      }
    });

    final (doneTasks, notDoneTasks, listTitle) = app.getDateKind(widget.number);

    isVisibility = app.getDateListsHightBool(doneTasks, notDoneTasks).$2;

    if (doneTasks.isEmpty && notDoneTasks.isEmpty) {
      isVisibility = true;
      listHeight = 100;
    }

    return (doneTasks.isEmpty && notDoneTasks.isEmpty)
        ? Container(
          height: 140,

          margin: EdgeInsets.only(top: 24, left: 16, right: 16),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(listTitle, style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 16),
              Positioned(
                left: 5,
                top: 40,
                child: Container(child: Text('挑戦できるタスクはありません')),
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
                    children: [
                      _cardsView(context, notDoneTasks),
                      Text('完了済み(${doneTasks.length})'),
                      _cardsView(context, doneTasks),
                    ],
                  ),
                  Positioned(bottom: 0, child: _moreSeeButton()),
                ],
              ),
            ],
          ),
        );
  }
}
