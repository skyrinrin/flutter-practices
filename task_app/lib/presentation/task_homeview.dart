import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/domain/task_domain.dart';
import 'package:task_app/presentation/add_label_button.dart';
import 'package:task_app/presentation/add_label_window.dart';
import 'package:task_app/presentation/appbar.dart';
import 'package:task_app/presentation/task_date_views.dart';
import 'package:task_app/presentation/task_label_views.dart';
import 'package:task_app/presentation/toggle_button.dart';
import 'package:task_app/provider/provider.dart';

// Refが使えるようにconsumer化した
class TaskHomeview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // タスク追加ウィンドウの表示
    // void popAddLabelWindow() {
    //   showModalBottomSheet(
    //     backgroundColor: Colors.white,
    //     context: context,
    //     builder: (context) => AddLabelWindow(),
    //   );
    // }

    Application app = ref.read(applicationProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          Appbar(),
          TaskDateViews(number: 0),
          TaskDateViews(number: 1),
          TaskDateViews(number: 2),
          SizedBox(height: 40),
          TaskLabelViews(),
          SizedBox(height: 44),
          AddLabelButton(),
          SizedBox(height: 150),

          //データ全消しボタン 後で絶対消す！
          ElevatedButton(onPressed: app.clearData, child: Text('全消し')),

          //通知実装用サンプルボタン
          ElevatedButton(
            onPressed: () {
              app.sendNotifi();
            },
            child: Text('サンプル'),
          ),

          ElevatedButton(
            onPressed: () {
              final tasks = ref.watch(tasksProvider);
              app.convertDateTime(tasks.first.date, tasks.first.time);
            },
            child: Text('convert'),
          ),

          SizedBox(height: 100),
        ],
      ),
    );
  }
}
