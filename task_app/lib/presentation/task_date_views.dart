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
  late double _listWidth;
  double _listHeight = 280;
  Icon _icon = Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 40);

  bool _isOpened = false;
  bool _isVisibility = false;

  void _pushedMoreSeeButton(List<Task> selectedTasks, Application app) {
    _isOpened = !_isOpened;
    if (_isOpened == true) {
      //6/08  ボタンを教えてからのウィジェットサイズの調整とテキストの表示・非表示から始める
      setState(() {
        // if (selectedTasks.isEmpty) {
        //   _listHeight = 160;
        //   _isVisibility = true;
        // } else {
        //   // if (selectedTasks.length * 104 < 280) {
        //   //   _listHeight = 280;
        //   // } else {
        //   //   _listHeight = (selectedTasks.length + 2) * 104;
        //   // }
        //   _listHeight =
        //       (selectedTasks.length + 1.5) *
        //       104; //余白を作るためにカードの高さ(104)にカード0.5個分の高さを足す 1.5となっているのはlengthが0から数えられるので1つ目の数が0になってしまうから

        //   _isVisibility = false;
        // }

        _listHeight = app.getDateListsHeight(selectedTasks);
        // else (_momentlyHeight <= 280) {   //なぜかエラーを吐く
        //   _momentlyHeight = 280;
        // };
        // _listHeight = _momentlyHeight;
        _icon = Icon(Icons.keyboard_arrow_up, color: Colors.black, size: 40);
        print('発火: ${_isOpened}:${_listHeight}');
      });
    } else {
      setState(() {
        if (selectedTasks.isEmpty) {
          _listHeight = 160;
          _isVisibility = true;
        } else {
          _isVisibility = false;
          _listHeight = 280;
        }
        _icon = Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 40);
        print('発火: ${_isOpened}:${_listHeight}');
      });
    }
  }

  Widget _moreSeeButton(List<Task> selectedTasks, Application app) {
    return GestureDetector(
      onTap: () => {_pushedMoreSeeButton(selectedTasks, app)},
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              // width: 100,
              width: _listWidth,
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
      height: _listHeight,

      width: _listWidth,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return TaskCard(task: tasks[index]);
        },
      ),
    );
  }
  // // カードのリストビューウィジェット
  // Widget _cardsView(BuildContext context, List<Task> tasks) {
  //   return Stack(
  //     children: [
  //       Visibility(visible: _isVisibility, child: Text('挑戦できるタスクはありません')),
  //       Container(
  //         // color: Colors.amber,
  //         height: _listHeight,

  //         width: _listWidth,
  //         child: ListView.builder(
  //           physics: NeverScrollableScrollPhysics(),
  //           itemCount: tasks.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             return TaskCard(task: tasks[index]);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget build(BuildContext context) {
    _listWidth = MediaQuery.of(context).size.width - 32;

    // List<Task> tasks = ref.watch(tasksProvider);
    // List<Task> todayTasks = ref.watch(todayTasksProvider);
    // List<Task> tomorrowTasks = ref.watch(tomorrowTasksProvider);
    // List<Task> otherTasks = ref.watch(otherTasksProvider);

    int number = widget.number;
    List<Task> selectedTasks = [];
    String _listTitle = '';

    Application app = ref.watch(applicationProvider);

    if (number == 0) {
      selectedTasks = ref.watch(todayTasksProvider);
      _listTitle = '今日(${selectedTasks.length})';
    }
    if (number == 1) {
      selectedTasks = ref.watch(tomorrowTasksProvider);
      _listTitle = '明日(${selectedTasks.length})';
    }
    if (number == 2) {
      selectedTasks = ref.watch(otherTasksProvider);
      _listTitle = 'その他(${selectedTasks.length})';
    }

    if (selectedTasks.isEmpty) {
      _isVisibility = true;
      _listHeight = 100;
    }

    // return Container(
    //   padding: EdgeInsets.only(top: 24, left: 16, right: 16),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       // Align(
    //       //   alignment: Alignment.topLeft,
    //       //   child: Text('今日(3)', style: TextStyle(fontSize: 20)),
    //       // ),
    //       Text(_listTitle, style: TextStyle(fontSize: 20)),
    //       SizedBox(height: 16),
    //       Stack(
    //         children: [
    //           _cardsView(context, selectedTasks),
    //           Positioned(bottom: 0, child: _moreSeeButton(selectedTasks)),
    //         ],
    //       ),

    //       // Positioned(top: 42, right: 0, left: 0, child: TaskCard()),
    //       // Positioned(child: TaskCard()),
    //     ],
    //   ),
    // );

    return selectedTasks.isEmpty
        ? Container(
          // color: Colors.amber,
          height: 140,

          margin: EdgeInsets.only(top: 24, left: 16, right: 16),
          // padding: EdgeInsets.only(top: 24, left: 16, right: 16),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(_listTitle, style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 16),
              Positioned(
                left: 5,
                top: 40,
                child: Container(child: Text('挑戦できるタスクはありません')),
              ),
              Positioned(bottom: 0, child: _moreSeeButton(selectedTasks, app)),
            ],
          ),
        )
        : Container(
          // color: Colors.amber,
          // padding: EdgeInsets.only(top: 24, left: 16, right: 16),
          margin: EdgeInsets.only(top: 24, left: 16, right: 16),
          child: Stack(
            children: [
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Text('今日(3)', style: TextStyle(fontSize: 20)),
              // ),
              Text(_listTitle, style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              Stack(
                children: [
                  _cardsView(context, selectedTasks),
                  Positioned(
                    bottom: 0,
                    child: _moreSeeButton(selectedTasks, app),
                  ),
                ],
              ),

              // Positioned(top: 42, right: 0, left: 0, child: TaskCard()),
              // Positioned(child: TaskCard()),
            ],
          ),
        );
  }
}
