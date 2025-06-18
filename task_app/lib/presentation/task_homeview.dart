import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/presentation/add_label_window.dart';
import 'package:task_app/presentation/task_date_views.dart';
import 'package:task_app/presentation/task_label_views.dart';
import 'package:task_app/provider/provider.dart';

// class TaskHomeview extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // TaskGenre(number: 0),
//           // TaskGenre(number: 1),
//           // TaskGenre(number: 2),
//           // TaskGenreList(), //ここにラベルリストがある

//           // テスト用
//           ElevatedButton(
//             onPressed: () {
//               // ここにコード
//                Label(name: 'ラベル1', id: '1', color: Colors.black);

//               // ラベル追加用ウィジェットを作りそちらに処理を任せる
//             },
//             child: Text('テスト'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Refが使えるようにconsumer化した
class TaskHomeview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // タスク追加ウィンドウの表示
    void popAddLabelWindow() {
      showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => AddLabelWindow(),
      );
    }

    // Application app = ref.read(applicationProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          // TaskGenre(number: 0),
          // TaskGenre(number: 1),
          // TaskGenre(number: 2),
          TaskLabelViews(),
          // テスト用
          ElevatedButton(
            onPressed: () {
              // ここにコード
              popAddLabelWindow();
              // app.addLabel('テスト', 10, '234');

              // ラベル追加用ウィジェットを作りそちらに処理を任せる
            },
            child: Text('テスト'),
          ),
        ],
      ),
    );
  }
}
