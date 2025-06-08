import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/provider/provider.dart';
// import 'package:task_app/provider/provider.dart';
import 'package:task_app/repository/repository.dart';
import 'task_card.dart';
import 'task_genre.dart';
import 'add_task_window.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/domain.dart';
import 'package:task_app/Infrastructure/storage.dart';
// import 'package:provider/provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  //with TickerProviderStateMixin があった
  late TabController _tabController;
  List<String> _tabs = ['タブ1', 'タブ2'];
  // final storage = Storage();

  // 実行時最初に行われる処理

  // late Application application;

  @override
  void initState() {
    super.initState();
    _createController(); //タブコントローラー最初の作成
    // final repository = ref.watch(repositoryProvider);

    // repository.getTasks().then((loadedTasks) {
    //   setState(() {
    //     tasks = loadedTasks;
    //   });
    // });
    // application = Application(repository);
  } //必要ないかも？

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

  // @override
  // void dispose() {
  //   _tabController.dispose(); //タブコントローラーの破棄
  //   super.dispose();
  // }

  // // タスクの追加
  // void _addTask(String title, String label, String date, String time) {
  //   setState(() {
  //     tasks.add(Task(title: title, label: label, date: date, time: time));
  //   });
  //   storage.saveTasks(tasks);
  //   print(tasks);
  // }

  // // タスクの削除
  // void deleteTask(int index) {
  //   setState(() {
  //     tasks.removeAt(index);
  //   });
  //   storage.saveTasks(tasks);
  // }

  @override
  Widget build(BuildContext context) {
    // List<Task> tasks = ref.watch(taskProvider);
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
