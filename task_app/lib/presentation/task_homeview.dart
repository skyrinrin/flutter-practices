import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/application/application.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/presentation/task_genre.dart';
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
    Application app = ref.read(applicationProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          // TaskGenre(number: 0),
          // TaskGenre(number: 1),
          // TaskGenre(number: 2),
          // TaskGenreList(), //ここにラベルリストがある

          // テスト用
          ElevatedButton(
            onPressed: () {
              // ここにコード
              app.addLabel('テスト', 1, '234');

              // ラベル追加用ウィジェットを作りそちらに処理を任せる
            },
            child: Text('テスト'),
          ),
        ],
      ),
    );
  }
}
