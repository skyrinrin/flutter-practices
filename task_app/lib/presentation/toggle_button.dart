// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:task_app/application/application.dart';

// class ToggleButton extends StatefulWidget {
//   final String id;
//   final Application app;

//   ToggleButton(this.id, this.app);

//   @override
//   _ToggleButtonState createState() => _ToggleButtonState(this.id, this.app);
// }

// // 8/27 isDoneを扱えるのがapp.toggleTaskしかないためisDone専用のproviderを用意するなどする必要があるかも...

// class _ToggleButtonState extends State<ToggleButton>
//     with SingleTickerProviderStateMixin {
//   final id;
//   late bool isDone;
//   final Application app;
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;

//   _ToggleButtonState(this.id, this.app);

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );

//     _scaleAnimation = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 30),
//       TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.1), weight: 40),
//       TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 30),
//       // ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
//     ]).animate(_controller);
//     isDone = app.getToggle(id);
//     _isCleard();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _onTap() {
//     // ref.watch()
//     isDone = app.toggleTask(id);
//     // isDone = app.getToggle(id);

//     // isDone = !isDone;
//     _isCleard();
//     // _clear_motion();
//   }

//   // void _clear_motion() {
//   //   _controller.forward(from: 0.0);
//   //   // app.toggleTask(id);
//   // }

//   void _isCleard() {
//     if (isDone) {
//       setState(() {
//         // _clear_motion();
//         _controller.forward(from: 0.0);
//       });
//     } else {
//       print('タスクがミカンです: $id');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _onTap,
//       child: AnimatedBuilder(
//         animation: _scaleAnimation,
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _scaleAnimation.value,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 color: isDone ? Colors.blue : Colors.grey,
//                 shape: BoxShape.circle,
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 8,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: const Icon(Icons.check, color: Colors.white, size: 35),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/provider/provider.dart';

class ToggleButton extends ConsumerStatefulWidget {
  final String _id;
  const ToggleButton(this._id, {super.key});

  @override
  ConsumerState<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends ConsumerState<ToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.1), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 30),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    final app = ref.read(applicationProvider);
    print('onTap ${widget._id}');
    final isDone = app.toggleTask(widget._id);

    if (isDone) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('toggleButton: ${widget._id}');
    final app = ref.watch(applicationProvider);
    final isDone = app.getToggle(widget._id);

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isDone ? Colors.blue : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 35),
            ),
          );
        },
      ),
    );
  }
}
