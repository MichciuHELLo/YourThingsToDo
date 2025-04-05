import 'package:flutter/material.dart';

import '../data/globalVariables.dart' as globals;

class MyButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;

  MyButton({super.key, required this.name, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      // color: Colors.purple[200],
      color: globals.appColorSub,
      child: Text(
        name,
        style: TextStyle(
            color: globals.appColorText
        ),
      ),
    );
  }
}
