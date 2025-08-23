import 'package:flutter/material.dart';

class Common {
  // 初期テーマカラー
  static Color primaryColor = Color.fromARGB(66, 63, 147, 216);

  // 注意書きスナックバー
  static final warningSnackBar = SnackBar(
    content: Text(
      '入力していない項目があります',
      style: TextStyle(fontSize: 20),
      selectionColor: Color.fromARGB(0, 218, 50, 50),
    ),
  );

  static final today = DateTime.now()
      .toString()
      .substring(5, 10)
      .replaceAll('-', '/')
      .padLeft(2, '0'); //どのような形式で日付が保存されるのかわからない

  static final tomorrow = DateTime.now()
      .add(const Duration(days: 1))
      .toString()
      .substring(5, 10)
      .replaceAll('-', '/')
      .padLeft(2, '0'); //どのような形式で日付が保存されるのかわからない
}
