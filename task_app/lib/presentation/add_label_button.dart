import 'package:flutter/material.dart';
import 'add_label_window.dart';

class AddLabelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void popAddLabelWindow() {
      showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => AddLabelWindow(),
      );
    }

    return InkWell(
      onTap: () => popAddLabelWindow(),

      child: Container(
        // height: 100,

        // width: 200,
        decoration: BoxDecoration(
          // color: Colors.redAccent,
          borderRadius: BorderRadius.circular(100),
        ),

        // child: Stack(
        //   children: [
        //     Icon(Icons.add, size: 40),
        //     Text('ラベルを追加', style: TextStyle(fontSize: 20)),
        //   ],
        // ),
        child: Column(
          children: [
            Icon(Icons.add, size: 40),
            Text(
              'ラベルを追加',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(100, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
