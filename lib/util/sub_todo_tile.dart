import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/globalVariables.dart' as globals;

// class SubToDoTile extends StatelessWidget {
class SubToDoTile extends StatelessWidget {
  final String subTaskName;
  final bool subTaskCompleted;
  Function(bool?)? subTaskOnChanged;

  SubToDoTile({
    super.key,
    required this.subTaskName,
    required this.subTaskCompleted,
    required this.subTaskOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(width: 0.6, color: Colors.black)),
          value: subTaskCompleted,
          onChanged: subTaskOnChanged,
          // activeColor: Colors.deepPurple,
          activeColor: globals.appColorCheckbox,
          checkColor: globals.appColorCheck,
        ),
        Expanded(
          child: Text(
              style: TextStyle(
                  color: globals.appColorText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: subTaskCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationThickness: 2),
              subTaskName
          ),
        ),
      ],
    );
  }
}
