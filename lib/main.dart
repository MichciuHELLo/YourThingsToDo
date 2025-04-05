import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:your_things_to_do/data/subTask.g.dart';
import 'package:your_things_to_do/pages/navigate_page.dart';
import 'package:your_things_to_do/todelete/counter_page.dart';
import 'package:your_things_to_do/todelete/first_page.dart';
import 'package:your_things_to_do/todelete/home_page.dart';
import 'package:your_things_to_do/todelete/test_settings_page.dart';
import 'package:your_things_to_do/todelete/welcome_page.dart';
import 'package:flutter/services.dart';

import 'data/task.g.dart';

void main() async {

  // ORIENTATION OPTIONS
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  // DATABASE INITIALIZATION
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(SubTaskAdapter());
  await Hive.openBox('mybox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  double high = 100;
  double wigh = 100;
  int times = 0;

  void userTapped() {
    high+=10;
    wigh+=10;
    times++;
    print("User tapped! high: " + high.toString() + "wigh: " + wigh.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ThingsToDoPage(stream: streamController.stream,),
      // home: ThingsToDoPage(),
      home: const NavigatePage(),
      routes: {
        '/firstpage': (context) => FirstPage(),
        '/homepage': (context) => HomePage(),
        '/settingspage': (context) => TestSettingsPage(),
        '/counterpage': (context) => CounterPage(),
        '/welcomepage': (context) => WelcomePage(),
        // '/thingstodopage': (context) => ThingsToDoPage(stream: streamController.stream,),
        // '/thingstodopage': (context) => ThingsToDoPage(),
      },
    );
  }
}
