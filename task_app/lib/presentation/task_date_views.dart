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
  late List<Task> selectedTasks;
  late String listTitle;
  double listHeight = 280;
  Icon _icon = Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 40);

  bool isOpened = false;
  bool isVisibility = false;
  bool isListening = false;

  // @override
  // void initState() {
  //   super.initState();

  //   // build完了後にref.listenを仕込む
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     removeListener = ref.listenManual<List<Task>>(tasksProvider, (
  //       previous,
  //       next,
  //     ) {
  //       if (previous == null || next.length > previous.length) {
  //         setState(() => isOpened = false);
  //       }
  //     });
  //     print('listenerが発火しました');
  //   });
  // }

  // @override
  // void dispose() {
  //   // リスナー解除
  //   removeListener();
  //   super.dispose();
  // }
  // Application app = ref.watch(applicationProvider);
  // int number = widget.number;
  // selectedTasks = app.getDateKind(widget.number).$1;
  // _listTitle = app.getDateKind(number).$2;

  // _listHeight = app.getDateListsHightBool(selectedTasks).$1;
  // _isVisibility = app.getDateListsHightBool(selectedTasks).$2;

  // initStateではrefを呼び出せないためinitStateの直後のdidChangeDependenciesを使う
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    app = ref.watch(applicationProvider);
    int number = widget.number;
    selectedTasks = app.getDateKind(widget.number).$1;
    listTitle = app.getDateKind(number).$2;

    listHeight = app.getDateListsHightBool(selectedTasks).$1;
    isVisibility = app.getDateListsHightBool(selectedTasks).$2;

    isOpend_false();

    // 初回だけリッスンを設定
    // if (!isListening) {
    //   isListening = true;

    //   ref.listen<List<Task>>(tasksProvider, (previous, next) {
    //     // タスク追加時だけ閉じる
    //     if (previous == null || next.length > previous.length) {
    //       setState(() => isOpened = false);
    //     }
    //   });
    // }
  }

  void isOpend_true() {
    selectedTasks = app.getDateKind(widget.number).$1;
    if (selectedTasks.isEmpty) {
      listHeight = 160;
      isVisibility = true;
    } else {
      isVisibility = false;
      listHeight = app.getDateListsHightBool(selectedTasks).$1;
      if (listHeight <= 280) {
        listHeight = 280;
        print('小さい');
      }
    }
    _icon = Icon(Icons.keyboard_arrow_up, color: Colors.black, size: 40);
    print('発火: ${isOpened}:${listHeight}');
  }

  void isOpend_false() {
    listHeight = 280;
    _icon = Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 40);
    print('発火: ${isOpened}:${listHeight}');
  }

  void _pushedMoreSeeButton(Application app) {
    // void _pushedMoreSeeButton(List<Task> selectedTasks, Application app) {
    isOpened = !isOpened;
    if (isOpened == true) {
      //6/08  ボタンを教えてからのウィジェットサイズの調整とテキストの表示・非表示から始める
      setState(() {
        isOpend_true();
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

        // else (_momentlyHeight <= 280) {   //なぜかエラーを吐く
        //   _momentlyHeight = 280;
        // };
        // _listHeight = _momentlyHeight;

        // setState(() {

        // });

        // _icon = Icon(Icons.keyboard_arrow_up, color: Colors.black, size: 40);
        // print('発火: ${isOpened}:${listHeight}');
      });
    } else {
      setState(() {
        isOpend_false();
      });
      // setState(() {
      //   if (selectedTasks.isEmpty) {
      //     listHeight = 160;
      //     isVisibility = true;
      //   } else {
      //     isVisibility = false;
      //     selectedTasks = app.getDateKind(widget.number).$1;
      //     listHeight = app.getDateListsHightBool(selectedTasks).$1;
      //   }
      //   _icon = Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 40);
      //   print('発火: ${isOpened}:${listHeight}');
      // });
    }
  }

  // Widget _moreSeeButton(List<Task> selectedTasks, Application app) {
  Widget _moreSeeButton() {
    return GestureDetector(
      onTap: () => {_pushedMoreSeeButton(app)},
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              // width: 100,
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
    // //値の変化を検知
    // ref.listen<List<Task>>(tasksProvider, (previous, next) {
    //   if (previous == null || next.length > previous.length) {
    //     setState(() {
    //       isOpened = false;
    //       print('listenが発火しました!');
    //     });
    //   }
    // });

    listWidth = MediaQuery.of(context).size.width - 32;

    // List<Task> tasks = ref.watch(tasksProvider);
    // List<Task> todayTasks = ref.watch(todayTasksProvider);
    // List<Task> tomorrowTasks = ref.watch(tomorrowTasksProvider);
    // List<Task> otherTasks = ref.watch(otherTasksProvider);

    // int number = widget.number;
    // List<Task> selectedTasks = [];
    // String _listTitle = '';

    final app = ref.watch(applicationProvider);

    ref.listen<List<Task>>(app.getDateKindProvider(widget.number), (
      previous,
      next,
    ) {
      listHeight = app.getDateListsHightBool(next).$1;
      print('listener: $listHeight');
    });
    // final tasks = ref.watch(tasksProvider);

    final (selectedTasks, listTitle) = app.getDateKind(widget.number);

    // listHeight = app.getDateListsHightBool(selectedTasks).$1;
    isVisibility = app.getDateListsHightBool(selectedTasks).$2;

    // double listHeight = app.getDateListsHightBool(selectedTasks).$1;
    // bool isVisibility = app.getDateListsHightBool(selectedTasks).$2;

    // if (number == 0) {
    //   selectedTasks = ref.watch(todayTasksProvider);
    //   _listTitle = '今日(${selectedTasks.length})';
    // }
    // if (number == 1) {
    //   selectedTasks = ref.watch(tomorrowTasksProvider);
    //   _listTitle = '明日(${selectedTasks.length})';
    // }
    // if (number == 2) {
    //   selectedTasks = ref.watch(otherTasksProvider);
    //   _listTitle = 'その他(${selectedTasks.length})';
    // }

    // selectedTasks = app.getDateKind(number).$1;
    // _listTitle = app.getDateKind(number).$2;

    // _listHeight = app.getDateListsHightBool(selectedTasks).$1;
    // _isVisibility = app.getDateListsHightBool(selectedTasks).$2;

    if (selectedTasks.isEmpty) {
      isVisibility = true;
      listHeight = 100;
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
          // color: Colors.amber,
          // padding: EdgeInsets.only(top: 24, left: 16, right: 16),
          margin: EdgeInsets.only(top: 24, left: 16, right: 16),
          child: Stack(
            children: [
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Text('今日(3)', style: TextStyle(fontSize: 20)),
              // ),
              Text(listTitle, style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              Stack(
                children: [
                  _cardsView(context, selectedTasks),
                  Positioned(bottom: 0, child: _moreSeeButton()),
                ],
              ),

              // Positioned(top: 42, right: 0, left: 0, child: TaskCard()),
              // Positioned(child: TaskCard()),
            ],
          ),
        );
  }
}
