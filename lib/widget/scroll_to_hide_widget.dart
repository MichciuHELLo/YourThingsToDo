import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../data/database.dart';

class ScrollToHideWidget extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final Duration duration;

  const ScrollToHideWidget({
    Key? key,
    required this.child,
    required this.scrollController,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  State<ScrollToHideWidget> createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  ToDoDataBase db = ToDoDataBase();
  bool isVisible = true;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(listen);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(listen);

    super.dispose();
  }

  void listen() {
    final direction = widget.scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  void show() {
    if (!isVisible) setState(() => isVisible = true);
  }

  void hide() {
    db.loadData();
    if (isVisible && db.toDoList.length > 6) setState(() => isVisible = false);
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: widget.duration,
    height: isVisible ? kBottomNavigationBarHeight : 0,
    child: Wrap(children: [widget.child]),
  );
}
