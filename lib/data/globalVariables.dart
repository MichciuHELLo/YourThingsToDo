library my_prj.globals;

import 'package:flutter/material.dart';

bool isLoggedIn = false;

late Color appColorMain;
late Color appColorSub;
late Color appColorText;
late Color appColorCheckbox;
late Color appColorCheck;
late Color appColorAlert;
late Color appColorDelete;
late Color appColorIcon;

void changeColors(String colorMode) {
  switch (colorMode) {
    case 'Dark':
      appColorMain = Colors.grey.shade900;
      appColorSub = Colors.grey.shade800;
      appColorText = Colors.white;
      // appColorCheckbox = Colors.grey.shade900;
      appColorCheckbox = Colors.white;
      appColorCheck = Colors.black;
      appColorAlert = Colors.red;
      appColorDelete = Colors.grey.shade500;
      appColorIcon = Colors.grey;
      break;
    case 'Light':
      appColorMain = Colors.grey.shade200;
      appColorSub = Colors.grey.shade300;
      appColorText = Colors.black;
      appColorCheckbox = Colors.grey.shade500;
      appColorCheck = Colors.black;
      appColorAlert = Colors.red;
      appColorDelete = Colors.grey.shade500;
      appColorIcon = Colors.grey;
      break;
    case 'Purple':
      appColorMain = Colors.deepPurple;
      appColorSub = Colors.deepPurple.shade300;
      appColorText = Colors.black;
      // appColorCheckbox = Colors.blueGrey;
      appColorCheckbox = Colors.deepPurple.shade400;
      appColorCheck = Colors.white;
      appColorAlert = Colors.red;
      appColorDelete = Colors.grey.shade500;
      appColorIcon = Colors.deepPurple.shade300;
      break;
    case 'Yellow':
      appColorMain = Colors.yellow;
      appColorSub = Colors.yellow.shade200;
      appColorText = Colors.black;
      appColorCheckbox = Colors.deepPurple;
      appColorCheck = Colors.black;
      appColorAlert = Colors.red;
      appColorDelete = Colors.grey.shade500;
      appColorIcon = Colors.yellow.shade700;
      break;
  }
}