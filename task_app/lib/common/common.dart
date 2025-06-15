import 'package:flutter/material.dart';

class Common {
  // 注意書きスナックバー
  static final warningSnackBar = SnackBar(
    content: Text(
      '入力していない項目があります',
      style: TextStyle(fontSize: 20),
      selectionColor: Color.fromARGB(0, 218, 50, 50),
    ),
  );
}
