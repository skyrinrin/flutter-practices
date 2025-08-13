import 'package:flutter/material.dart';
import 'package:task_app/presentation/settings_view.dart';

class Appbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,

      color: const Color.fromARGB(66, 63, 147, 216),
      child: Stack(
        children: [
          Positioned(
            right: 16,
            bottom: 16,
            child: IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (_) {
                    return SettingsView();
                  },
                );
              },
              icon: Icon(Icons.more_vert, size: 32),
            ),
          ),

          //必要なウィジェットがあればここから追加
        ],
      ),
    );
  }
}
