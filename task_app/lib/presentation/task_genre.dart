import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/presentation/task_card.dart';
import 'package:task_app/domain/domain.dart';
import 'package:task_app/provider/provider.dart';

class TaskGenre extends ConsumerStatefulWidget {
  int number;
  TaskGenre({super.key, required this.number});

  @override
  ConsumerState<TaskGenre> createState() => _TaskGenreState();
}

class _TaskGenreState extends ConsumerState<TaskGenre> {
  @override
  void initState() {
    super.initState();
    chooseKind();
  }

  // ウィジェットの種類の識別
  void chooseKind() {
    int number = widget.number;

    if (number == 0) {
      _listTitle = '今日()';
    }
    if (number == 1) {
      _listTitle = '明日()';
    }
    if (number == 2) {
      _listTitle = 'その他()';
    }
  }

  String _listTitle = '';

  //もっと見るウィジェット
  late double _listWidth;
  double _listHeight = 280;
  Icon _icon = Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 40);

  bool _isOpened = false;

  void _pushedMoreSeeButton() {
    _isOpened = !_isOpened;
    if (_isOpened == true) {
      setState(() {
        _listHeight = 2000;
        _icon = Icon(Icons.keyboard_arrow_up, color: Colors.black, size: 40);
        print('発火: ${_isOpened}:${_listHeight}');
      });
    } else {
      setState(() {
        _listHeight = 280;
        _icon = Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 40);
        print('発火: ${_isOpened}:${_listHeight}');
      });
    }
  }

  Widget _moreSeeButton() {
    return GestureDetector(
      onTap: _pushedMoreSeeButton,
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

  Widget build(BuildContext context) {
    List<Task> tasks = ref.watch(tasksProvider);
    _listWidth = MediaQuery.of(context).size.width - 32;
    return Container(
      padding: EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Text('今日(3)', style: TextStyle(fontSize: 20)),
          // ),
          Text(_listTitle, style: TextStyle(fontSize: 20)),
          SizedBox(height: 16),
          Stack(
            children: [
              _cardsView(context, tasks),
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
