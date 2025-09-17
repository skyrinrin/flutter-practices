import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:task_app/domain/task_domain.dart';
import 'dart:math';

class TaskDetail extends StatefulWidget {
  TaskDetail({super.key, task});
  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Widget _cardFrame() {
    return Container(
      height: 320,
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF8FC3FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ), //ここの色は各自変更
              height: 320,
              width: 20,
            ),
          ),
          Positioned(
            right: 44,
            top: 40,
            child: IconButton(
              onPressed: () {
                //ここに関数
              },
              icon: Icon(Icons.delete, color: Color(0xFF969696), size: 26),
            ),
          ),
          Align(alignment: Alignment.center, child: _cardValue()),
          // Container(
          //   // color: Colors.amber,
          //   height: 320,
          //   width: 320,
          //   child: Positioned(child: _cardFold()),
          // ),
          // Align(alignment: Alignment.bottomRight, child: _cardFold()),
          Positioned(bottom: -15, right: -15, child: _cardFold()),
          // Positioned(bottom: -17, right: -17, child: _cardFold()),
          Positioned(bottom: -30, right: -30, child: _cardFoldShadow()),
        ],
      ),
    );
  }

  Widget _cardValue() {
    return Container(
      // color: Colors.blueAccent,
      height: 240,
      width: 204,
      child: Stack(
        children: [
          Positioned(bottom: 12, child: _taskDetailValues()),
          Positioned(
            top: 8,
            child: Text(
              'タイトル', //長くなってしまった場合の処理も考えておく 三点リーダー
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold, //太字に
                color: Color(0xFF6B6868),
              ),
            ),
          ),

          // ここから
          // Positioned(
          //   top: 52,
          //   left: 8,
          //   child: Text(
          //     '期限     :  09/17 15:22',
          //     style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
          //   ),
          // ),
          // Positioned(
          //   top: 80,
          //   left: 8,
          //   child: Text(
          //     'ラベル  :  未選択',
          //     style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
          //   ),
          // ),
          // Positioned(
          //   top: 108,
          //   left: 8,
          //   child: Text(
          //     'メモ      : ',
          //     style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
          //   ),
          // ),
          //ここまでをボーダーと一緒のContainerに入れる
        ],
      ),
    );
  }

  Widget _taskDetailValues() {
    return Container(
      height: 180,
      width: 204,
      // color: Colors.amber,
      child: Stack(
        children: [Positioned(top: 4, child: _texts()), _textBorders()],
      ),
    );
  }

  Widget _texts() {
    return Container(
      // color: Colors.amber,
      height: 180,
      width: 204,
      padding: EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '  期限     :  09/17 15:22',
            style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
          ),
          SizedBox(height: 6),

          Text(
            '  ラベル  :  未選択',
            style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
          ),
          SizedBox(height: 4),

          Text(
            '  メモ      : ',
            style: TextStyle(fontSize: 16, color: Color(0xFF6B6868)),
          ),
        ],
      ),
    );
  }

  Widget _textBorders() {
    return Container(
      // color: Colors.amber,
      height: 180,
      width: 204,
      child: Stack(
        children: [
          // Text('sample'),
          // Text('data'),
          // Container(height: 180, width: 200),
          Positioned(top: 1, child: _dottedBorder()),
          Positioned(top: 0, child: _dottedBorder()),
          Positioned(top: 28, child: _dottedBorder()),
          Positioned(top: 56, child: _dottedBorder()),
          Positioned(top: 84, child: _dottedBorder()),
          Positioned(top: 112, child: _dottedBorder()),
          Positioned(top: 140, child: _dottedBorder()),
          Positioned(top: 168, child: _dottedBorder()),
        ],
      ),
    );
  }

  Widget _dottedBorder() {
    return DottedBorder(
      options: RectDottedBorderOptions(
        color: Color(0xFF969696),
        strokeWidth: 2,
        dashPattern: [4, 4],

        padding: EdgeInsets.only(bottom: 0, right: 0.5),
      ),

      child: Container(height: 0, width: 204),
    );
  }

  Widget _cardFoldShadow() {
    return Transform.rotate(
      angle: pi / 4,
      child: Container(
        // color: Colors.amber,
        color: Color(0xFF757575),
        height: 60,
        width: 60,
      ),
    );
  }

  Widget _cardFold() {
    return Container(color: Color(0xFFD9D9D9), height: 60, width: 60);
  }

  @override
  Widget build(BuildContext context) {
    // return SimpleDialog(
    // backgroundColor: Colors.white,
    // children: [
    return Center(
      // height: 300,
      // width: 500
      // margin: EdgeInsets.all(50),
      // color: Colors.amber,
      child: _cardFrame(),
    );
    //   ],
    // );
  }
}
