import 'package:hive_flutter/hive_flutter.dart';
import 'package:your_things_to_do/util/alert_data.dart';
import 'package:your_things_to_do/util/subTask.dart';
import 'package:your_things_to_do/util/task.dart';

class ToDoDataBase {
  final _myBox = Hive.box('mybox');

  /*
    List toDoList is build like this:
    1st parameter is String name of a task,
    2nd parameter is boolean if task is checked as completed,
    3rd parameter is boolean if subtasks have been open,
    4th parameter is list of SubTask where:
      1st parameter is String name of a task,
      2nd parameter is boolean if task is checked as completed
    5th parameter is AlertData where:
      1th parameter is boolean if alarm was set
      2st parameter is int dayOfAlert
      3nd parameter is int monthOfAlert
      4rd parameter is int yearOfAlert
      5th parameter is int hourOfAlert
      6th parameter is int minuteOfAlert
      7th parameter is int repeatEveryAlert
      8th parameter is String *ENUM?* that tells how often repeat alert (Never/Everyday/Everyweek/Everyyear)
   */

  List<Task> toDoList = [];

  void createInitialData() {
    print("createInitialData...");
    toDoList = [
      Task("Add new Things To Do!", false, false, [SubTask("And maybe some more :D", false), SubTask("Have fun <3", true)], AlertData(false, 1,1,1,1,1,1,'Never'))
    ];

    // settingsList = ["English", "Dark"];

    updateDataBase();
  }

  void loadData() {
    print("loadData...");
    var rawData = _myBox.get('TODOLIST');
    print("loaded Data: " + rawData.toString());

    if (rawData != null) {
      List<dynamic> rawList = rawData as List<dynamic>;
      toDoList = rawList.map((e) => Task.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    // settingsList = _myBox.get('SETTINGS');
  }

  void updateDataBase() {
    print("update");
    _myBox.put("TODOLIST", toDoList.map((task) => task.toJson()).toList());
    // _myBox.put("SETTINGS", settingsList);
  }

  /*
    List settingsList is build like this:
    1st parameter is int languageIndex of a app language of a languageList in _SettingsPageState,
    2nd parameter is String name of a app background color,
  */

  List settingsList = [];

  void createInitialSettings() {
    print("createInitialSettings");
    settingsList = [0, 'Dark'];
    updateSettings();
  }

  void loadSettings() {
    print("loadSettings...");
    settingsList = _myBox.get('SETTINGS');
    print("loadSettings: " + settingsList.toString());
  }

  void updateSettings() {
    print("updateSettings...");
    _myBox.put("SETTINGS", settingsList);
    print("updateSettings: " + settingsList.toString());
  }
}
