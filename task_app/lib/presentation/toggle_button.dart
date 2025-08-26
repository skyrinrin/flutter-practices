import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_app/application/application.dart';

class ToggleButton extends StatefulWidget {
  final String id;
  final Application app;

  ToggleButton(this.id, this.app);

  @override
  _ToggleButtonState createState() => _ToggleButtonState(this.id, this.app);
}

// 8/27 isDoneを扱えるのがapp.toggleTaskしかないためisDone専用のproviderを用意するなどする必要があるかも...

class _ToggleButtonState extends State<ToggleButton>
    with SingleTickerProviderStateMixin {
  final id;
  late bool isDone;
  final Application app;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  _ToggleButtonState(this.id, this.app);

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
      // ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    ]).animate(_controller);
    _isClaered();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    // ref.watch()
    isDone = app.toggleTask(id);

    isDone = !isDone;
    _isClaered();
    // _clear_motion();
  }

  void _clear_motion() {
    _controller.forward(from: 0.0);
    // app.toggleTask(id);
  }

  void _isClaered() {
    if (isDone) {
      setState(() {
        _clear_motion();
      });
    } else {
      print('タスクがミカンです');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 35),
            ),
          );
        },
      ),
    );
  }
}
