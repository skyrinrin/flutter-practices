import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/presentation/task_genre.dart';

class TaskHomeview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TaskGenre(number: 0),
          TaskGenre(number: 1),
          TaskGenre(number: 2),
        ],
      ),
    );
  }
}
