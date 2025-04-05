import 'package:flutter/material.dart';

import 'my_button.dart';

import '../data/globalVariables.dart' as globals;

class DeleteAlertDialogBox extends StatelessWidget {
  VoidCallback onYes;
  VoidCallback onNo;

  DeleteAlertDialogBox({
    super.key,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // backgroundColor: Colors.purple,
      backgroundColor: globals.appColorMain,
      content: SizedBox(
          height: 140,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Are you sure you want to delete this Thing To Do?",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: globals.appColorText
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  MyButton(
                    name: "Delete",
                    onPressed: onYes,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  MyButton(
                    name: "Cancel",
                    onPressed: onNo,
                  )
                ])
              ])),
    );
  }
}
