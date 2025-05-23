import 'package:flutter/material.dart';
import 'package:task_app/task_card.dart';
import 'add_task_window.dart';
import 'task_genre.dart';
import 'add_task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> _tabs = ['タブ1', 'タブ2'];
  List<Task> tasks = [];
  final storage = TaskStorage();

  // 実行時最初に行われる処理
  @override
  void initState() {
    super.initState();
    _createController(); //タブコントローラー最初の作成
    storage.loadTasks().then((loadedTasks) {
      setState(() {
        tasks = loadedTasks;
      });
    });
  }

  //タブコントローラーの作成
  void _createController() {
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  // タブの追加・アップデート
  void _updateTabs() {
    setState(() {
      _tabs.add('ここに内容');
      _tabController.dispose(); //前のコントローラーを破棄
      _createController(); //新しいコントローラーの作成
    });
  }

  // タスク追加ウィンドウの表示
  void popAddTaskWindow() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => AddTaskWindow(),
    );
  }

  // タブの削除
  void _removeTab() {
    if (_tabs.length <= 1) return;
    setState(() {
      _tabs.removeLast();
      _tabController.dispose();
      _createController();
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); //タブコントローラーの破棄
    super.dispose();
  }

  // タスクの追加
  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
    storage.saveTasks(tasks);
  }

  // タスクの達成状態を管理する
  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
    storage.saveTasks(tasks);
  }

  // タスクの削除
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    storage.saveTasks(tasks);
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        // title: Text('タスク管理アプリ'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tabTitle) => Tab(text: tabTitle)).toList(),
          isScrollable: true, //タブが多かった場合のスクロールの許可
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tabTitle) => TaskPageValue()).toList(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: popAddTaskWindow,
        child: Icon(Icons.add),
        tooltip: 'タスクの追加',
      ),
    );
  }
}
