import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/presentation/task_homeview.dart';
import 'package:task_app/provider/provider.dart';
// import 'package:task_app/provider/provider.dart';
import 'package:task_app/repository/repository.dart';
import 'task_card.dart';
import 'task_date_views.dart';
import 'add_task_window.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/task_domain.dart';
import 'package:task_app/Infrastructure/storage.dart';
// import 'package:provider/provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // タスク追加ウィンドウの表示
  void popAddTaskWindow() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => AddTaskWindow(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: Text('タスク管理アプリ')),
      body: TaskHomeview(),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: popAddTaskWindow,
        backgroundColor: Color(0xFF4484EC),
        child: Icon(Icons.add, color: Colors.white, size: 30),
        tooltip: 'タスクの追加',
      ),
    );
  }
}
