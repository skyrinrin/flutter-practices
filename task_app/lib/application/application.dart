import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/Infrastructure/storage.dart';
import 'package:task_app/domain/label_domain.dart';
import 'package:task_app/provider/provider.dart';
import 'package:task_app/repository/repository.dart';
import 'package:task_app/domain/task_domain.dart';
// import 'package:provider/provider.dart';

class Application {
  final Ref ref;
  // List<Task> tasks;
  final Repository repository;
  Application(this.ref, this.repository);

  List<Task> get tasks => ref.read(tasksProvider);
  List<Label> get labels => ref.read(labelsProvider);

  int getNextId(List list) {
    if (list.isEmpty) return 0;
    final maxId = list
        .map((element) => element.id)
        .reduce((a, b) => a > b ? a : b); //三項演算子とreduce関数を使ってる よくわかってない
    return maxId + 1;
  }

  // ColorをString型に変換 あまりよくロジックがわかっていないし推奨されていないvalueを使っている
  // String encodeHexColor(Color color) {
  //   final colorStr = color.value.toRadixString(16).toString();
  //   if (colorStr.length == 8) {
  //     final hexcolor = colorStr.substring(2);
  //     final transparent = colorStr.substring(0, 2);
  //     if (transparent == "ff") {
  //       // return "#" + hexcolor; //返すhexCodeから'#'をなくす
  //       return hexcolor;
  //     } else {
  //       return hexcolor + transparent;
  //       // return "#" + hexcolor + transparent;
  //     }
  //   } else {
  //     return colorStr + "00";
  //     // return "#" + colorStr + "00";
  //   }
  // }

  // // String型のカラーコードをColor型に変換
  // Color decodeHexColor(String colorCode) {
  //   String colorStr = '0xFF$colorCode';
  //   // int colorInt = int.parse(colorStr);
  //   int colorInt = int.parse(colorCode);
  //   print('作成したカラーコード: $colorInt');
  //   return Color(colorStr);
  // }

  Future<void> addTask(
    // int id,
    String title,
    String label,
    String date,
    String time,
  ) async {
    // final tasks = ref.read(taskProvider);
    final task = Task(
      id: getNextId(tasks),
      title: title,
      label: label,
      date: date,
      time: time,
    );
    await repository.addTask(task);

    // TaskNotifierの状態も更新(プロバイダーのStateも同期)
    ref.read(tasksProvider.notifier).addTask(task);
  }

  Future<void> addLabel(String name, Color color) async {
    final label = Label(
      name: name,
      id: getNextId(labels),
      color: color,
      isExpanded: false,
    ); //ここのcolorのところを変更する
    final labelsIds = ref.read(labelIdProvider);

    if (!labelsIds.contains(label.id)) {
      await repository.addLabel(label);

      // LabelNotifierの状態も更新(プロバイダーのStateも同期)
      ref.read(labelsProvider.notifier).addLabel(label);
      print('ラベル保存完了');
    } else {
      print('すでに同じラベルがあります');
      // スナックバーの表示
    }
  }

  // タスクをラベル分けする

  // Future<List<Task>> getTasks() async {
  //   return repository.getTasks();
  // }

  // タスクの達成状態を管理する
  void toggleTask(int index) {
    //List<Task> tasks, tasksをグローバルに取得する
    final updatedTasks = [...tasks];
    updatedTasks[index] = updatedTasks[index].copyWith(
      //テストをsharedの方でする
      isDone: !updatedTasks[index].isDone,
    );
    ref.read(tasksProvider.notifier).updateTasks(updatedTasks);
    // repository.saveTasks(tasks);
  }

  // タスクを得る
  Task getTask(int index) {
    return tasks[index];
  }

  // // タスクの削除
  // void deleteTask(int index) {
  //   setState(() {
  //     tasks.removeAt(index);
  //   });
  //   storage.saveTasks(tasks);
  // }
}

// アプリケーション層にnotifier系を入れる
class TaskNotifier extends StateNotifier<List<Task>> {
  // // Application app;
  // TaskNotifier(this.app) : super([]); //親クラスに空のリストを渡す
  // Application app;
  Repository repository;
  TaskNotifier(this.repository) : super([]); //親クラスに空のリストを渡す

  // タスクのロード
  void laodTasks() async {
    List<Task> _loadedData = await repository.loadTasks();
    state = _loadedData;
  }

  // タスクの追加
  void addTask(Task task) {
    state = [...state, task]; //もともとのリストにtaskを追加
  }

  // リストのアップデート
  void updateTasks(List<Task> tasks) {
    state = tasks;
  }
}

// ラベル（ジャンル分け）用
// class LabelsTasksNotifier extends StateNotifier<Map<String, List<Label>>> {
class LabelsTasksNotifier extends StateNotifier<List<Label>> {
  Repository repository;
  LabelsTasksNotifier(this.repository)
    : super([
        Label(name: '未選択', id: 1, color: Colors.black, isExpanded: false),
      ]);

  // void loadLabels() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final jsonList = prefs.getStringList('labels') ?? [];
  //   final loadLabels =
  //       jsonList.map((e) => Label.fromJson(json.decode(e))).toList();
  //   state = loadedTasks
  // }

  void loadLabels() async {
    List<Label> _loadedData = await repository.loadLabels();
    state = _loadedData;
  }

  // ジャンル追加
  void addLabel(Label label) {
    // すでに同じ名前のジャンルがないかチェック
    if (!state.contains(label)) {
      state = [...state, label];
    }
  }

  void toggleLabel(int index) {
    final newList = [...state];
    newList[index].isExpanded = !newList[index].isExpanded;
    state = newList;
  }

  // // ラベル（ジャンル）にタスクを追加する
  // void addTaskToLabel(String labelName, Task task) {
  //   final currentTasks = state[labelName] ?? [];
  //   final updateList = [...currentTasks, task];

  //   state = {...state, labelName: updateList};
  // }

  // // ラベルを削除する
  // void removeLabel(String id) {
  //   final newState = Map<String, List<Label>>.from(state);
  //   newState.remove(labelName);
  //   state = newState;
  // }
}



// 恐らくこのコードはリストを永続化しないように管理しようとしているためMap型で定義している
// ラベル型を作るためこのコードは恐らく不要？

// // ラベル（ジャンル分け）用  
// // class LabelsTasksNotifier extends StateNotifier<Map<String, List<Label>>> {
// class LabelsTasksNotifier extends StateNotifier<Map<String, List<Label>>> {
//   Repository repository;
//   LabelsTasksNotifier(this.repository) : super({});

//   // void loadLabels() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final jsonList = prefs.getStringList('labels') ?? [];
//   //   final loadLabels =
//   //       jsonList.map((e) => Label.fromJson(json.decode(e))).toList();
//   //   state = loadedTasks
//   // }

//   void loadLabels() async {
//     List<Label> _loadedData = await repository.loadLabels();
//     state = _loadedData;
//   }

//   // ジャンル追加
//   void addLabel(String labelName) {
//     // すでに同じ名前のジャンルがないかチェック
//     if (!state.containsKey(labelName)) {
//       state = {...state, labelName: []};
//     }
//   }

//   // ラベル（ジャンル）にタスクを追加する
//   void addTaskToLabel(String labelName, Task task) {
//     final currentTasks = state[labelName] ?? [];
//     final updateList = [...currentTasks, task];

//     state = {...state, labelName: updateList};
//   }

//   // ラベルを削除する
//   void removeLabel(String labelName) {
//     final newState = Map<String, List<Task>>.from(state);
//     newState.remove(labelName);
//     state = newState;
//   }
// }
