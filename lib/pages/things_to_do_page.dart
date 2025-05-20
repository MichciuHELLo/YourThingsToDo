import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:your_things_to_do/data/database.dart';
import 'package:your_things_to_do/util/alert_data.dart';
import 'package:your_things_to_do/util/delete_alert_dialog_box.dart';
import 'package:your_things_to_do/util/dialog_box.dart';
import 'package:your_things_to_do/util/task.dart';
import 'package:your_things_to_do/util/todo_tile.dart';

import '../data/globalVariables.dart' as globals;
import '../util/subTask.dart';

class ThingsToDoPage extends StatefulWidget {
  ScrollController scrollController;

  ThingsToDoPage({
    required this.scrollController,
    super.key,
  });

  @override
  State<ThingsToDoPage> createState() => _ThingsToDoPageState();
}

class _ThingsToDoPageState extends State<ThingsToDoPage> {
  final _myBox = Hive.box("mybox");
  ToDoDataBase db = ToDoDataBase();
  final _controller = TextEditingController();
  List<TextEditingController> _controllers = [];
  AlertData _alertData = new AlertData(1,1,1,1,1,1,'Never');

  late String taskHintText;

  @override
  void initState() {
    // db.loadData();
    // db.loadSettings();

    // TODO to delete
    // print("length: " + db.toDoList.length.toString());
    // for(int i=0; i<db.toDoList.length; i++) {
    //   print("element " + i.toString() + ": " + db.toDoList[i].toJson().toString());
    // }
    // db.toDoList.clear();
    // print("length: " + db.toDoList.length.toString());
    // db.toDoList.add(Task("Błąd podczas edycji nazwy głównej taska. Valid index 0. Błąd się pojawia tylko gdy task ma subtask.", false, false, [], AlertData(1,1,1,1,1,1,'Never')));
    // db.toDoList.add(Task("Poprawić widok dodawania taska. Widok jest brzydki i źle dopasowany do ekranu.", false, false, [], AlertData(1,1,1,1,1,1,'Never')));
    // db.toDoList.add(Task("Wprowadzić przypomienia zadania na podstawie dat.", false, false, [SubTask("Przychodzą powiadomienia", false)], AlertData(1,1,1,1,1,1,'Never')));
    // db.toDoList.add(Task("Ustawić ikone aplikacji", false, false, [], AlertData(1,1,1,1,1,1,'Never')));
    // db.toDoList.add(Task("Poprawić kolory aplikacji w innych niż fiolet", false, false, [], AlertData(1,1,1,1,1,1,'Never')));
    // db.toDoList.add(Task("Gdy się usunie wszystkie subtaski wywala błąd", false, false, [], AlertData(1,1,1,1,1,1,'Never')));
    // db.toDoList.add(Task("Data alarmu powinna być zczytywana z DB a jeśli brak to dzień dzisiejszy", false, false, [], AlertData(1,1,1,1,1,1,'Never')));
    // db.updateDataBase();
    // print("length: " + db.toDoList.length.toString());
    // for(int i=0; i<db.toDoList.length; i++) {
    //   print("element " + i.toString() + ": " + db.toDoList[i].toJson().toString());
    // }
    // TODO to delete

    db.loadData();

    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    }
    db.loadData();
    if (db.toDoList.isEmpty) { //  TODO check if it works - remove all tasks and restart an app
      db.createInitialData();
    }


    // db.settingsList.clear();
    // _myBox.put("SETTINGS", db.settingsList);
    List list = _myBox.get('SETTINGS');
    // list.clear();
    // if (_myBox.get('SETTINGS') == null || _myBox.get('SETTINGS') == []) {
    if (_myBox.get('SETTINGS') == null) {
      print("_myBox.get('SETTINGS') == null");
      db.createInitialSettings();
    }
    db.loadSettings();
    // db.settingsList.clear();
    if (db.settingsList.isEmpty) {
      print("db.settingsList.isEmpty");
      db.createInitialSettings();
    }

    switch (db.settingsList[0]) {
      case 0: // ENGLISH
        taskHintText = "Add a new Task";
        break;
      case 1: // POLISH
        taskHintText = "Dodaj nowe zadanie";
        break;
    }

    globals.changeColors(db.settingsList[1]);

    super.initState();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            hintText: taskHintText,
            controller: _controller,
            controllers: _controllers,
            alertData: _alertData,
            onSave: saveNewTask,
            onCancel: cancelNewTask,
            onDeleteSubtask: deleteSubtask,
            advancedSettings: false,
            stream: streamController.stream,
            parentIndex: 999999,
          );
        });
  }

  void saveNewTask() {
    db.loadData();
    if (_controller.text.isNotEmpty) {
      bool taskExists = checkExistenceOfTask(_controller.text);
      if (!taskExists) {
        setState(() {
          List<SubTask> subTaskList = [];
          if (_controllers.isNotEmpty) {
            for (var subTaskName in _controllers) {
              if (subTaskName.text.isNotEmpty) {
                subTaskList.add(SubTask(subTaskName.text, false));
              }
            }
          }
          db.toDoList.add(Task(_controller.text, false, false, subTaskList, _alertData));
          print("New task!");
          print('${_controller.text}, false, false, $subTaskList, ${_alertData.dayOfAlert}.${_alertData.monthOfAlert}.${_alertData.yearOfAlert} | ${_alertData.hourOfAlert}:${_alertData.minuteOfAlert} | ${_alertData.repeatEveryAlert}-${_alertData.repeatEveryWhatAlert}');
        });
        Navigator.of(context).pop();
        _controller.clear();
        // _controllers.clear();
        db.updateDataBase();
      } else {
        streamController.add(taskExists);
      }
    }
  }

  void editFunction(int index) {
    TextEditingController taskName =
        TextEditingController(text: db.toDoList[index].name);

    print('EDIT CHECK: ${db.toDoList[index].name} - ${db.toDoList[index].alertData.dayOfAlert}.${db.toDoList[index].alertData.monthOfAlert}.${db.toDoList[index].alertData.yearOfAlert} | ${db.toDoList[index].alertData.hourOfAlert}:${db.toDoList[index].alertData.minuteOfAlert} | ${db.toDoList[index].alertData.repeatEveryAlert}-${db.toDoList[index].alertData.repeatEveryWhatAlert}');

    List<SubTask>? subTaskList = getSubTasks(taskName.text);
    bool advancedSettingsChecked = false;
    if (subTaskList!.isNotEmpty) {
      advancedSettingsChecked = true;
    }

    for (var subTask in subTaskList) {
      TextEditingController subTaskName =
          TextEditingController(text: subTask.name);
      _controllers.add(subTaskName);
    }

    AlertData alertData = AlertData(
        db.toDoList[index].alertData.dayOfAlert,
        db.toDoList[index].alertData.monthOfAlert,
        db.toDoList[index].alertData.yearOfAlert,
        db.toDoList[index].alertData.hourOfAlert,
        db.toDoList[index].alertData.minuteOfAlert,
        db.toDoList[index].alertData.repeatEveryAlert,
        db.toDoList[index].alertData.repeatEveryWhatAlert
    );

    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            hintText: "",
            controller: taskName,
            controllers: _controllers,
            alertData: alertData,
            onSave: () => editOldTask(taskName, index, subTaskList, alertData),
            onCancel: cancelNewTask,
            onDeleteSubtask: deleteSubtask,
            advancedSettings: advancedSettingsChecked,
            stream: streamController.stream,
            parentIndex: index,
          );
        });
  }

  void editOldTask(TextEditingController taskName, int index, List<SubTask> subTaskList, AlertData alertData) {
    print('new name: ${taskName.text}');
    print('EDITing CHECK: ${db.toDoList[index].name} - ${alertData.dayOfAlert}.${alertData.monthOfAlert}.${alertData.yearOfAlert} | ${alertData.hourOfAlert}:${alertData.minuteOfAlert} | ${alertData.repeatEveryAlert}-${alertData.repeatEveryWhatAlert}');
    if (taskName.text.isNotEmpty) {
      bool taskExists = checkExistenceOfTask(taskName.text);
      if (!taskExists || taskName.text == db.toDoList[index].name) {
        // CHECK IF MAIN TASK NAME IS OK
        setState(() {
          db.toDoList[index].name = taskName.text;
          if (_controllers.isNotEmpty) {
            List<SubTask>? subTaskList = db.toDoList[index].subTasks;
            if (subTaskList!.isNotEmpty) {
              for (int i = 0; i < subTaskList.length; i++) {
                if (subTaskList[i].name != _controllers[i].text &&
                    _controllers[i].text.isNotEmpty) {
                  // EDIT OLD SUBTASKS
                  subTaskList[i].name = _controllers[i].text;
                }
              }
              if (subTaskList.length < _controllers.length) {
                // ADD NEW SUBTASKS
                for (int i = subTaskList.length; i < _controllers.length; i++) {
                  if (_controllers[i].text.isNotEmpty) {
                    subTaskList.add(SubTask(_controllers[i].text, false));
                  }
                }
              }
            } else {
              for (int i = 0; i < _controllers.length; i++) {
                if (_controllers[i].text.isNotEmpty) {
                  subTaskList.add(SubTask(_controllers[i].text, false));
                }
              }
            }
            db.toDoList[index].subTasks = subTaskList;
          }

          print("its now");
          db.toDoList[index].alertData.dayOfAlert = alertData.dayOfAlert;
          db.toDoList[index].alertData.monthOfAlert = alertData.monthOfAlert;
          db.toDoList[index].alertData.yearOfAlert = alertData.yearOfAlert;
          db.toDoList[index].alertData.hourOfAlert = alertData.hourOfAlert;
          db.toDoList[index].alertData.minuteOfAlert = alertData.minuteOfAlert;
          db.toDoList[index].alertData.repeatEveryAlert = alertData.repeatEveryAlert;
          db.toDoList[index].alertData.repeatEveryWhatAlert = alertData.repeatEveryWhatAlert;

          print('EDITed CHECK: ${db.toDoList[index].name} - ${db.toDoList[index].alertData.dayOfAlert}.${db.toDoList[index].alertData.monthOfAlert}.${db.toDoList[index].alertData.yearOfAlert} | ${db.toDoList[index].alertData.hourOfAlert}:${db.toDoList[index].alertData.minuteOfAlert} | ${db.toDoList[index].alertData.repeatEveryAlert}-${db.toDoList[index].alertData.repeatEveryWhatAlert}');

        });
        Navigator.of(context).pop();
        _controller.clear();
        _controllers.clear();
        db.updateDataBase();
      } else {
        streamController.add(taskExists);
      }
    }
  }

  List<SubTask>? getSubTasks(String taskName) {
    db.loadData();
    List<Task> taskList = db.toDoList;

    Task task = taskList.where((element) => element.name == taskName).first;

    if (task.subTasks!.isNotEmpty) {
      return task.subTasks;
    } else {
      return [];
    }
  }

  void cancelNewTask() {
    Navigator.of(context).pop();
    _controller.clear();
  }

  void checkBoxChanged(bool? value, int index) {
    db.loadData();
    setState(() {
      db.toDoList[index].completed = !db.toDoList[index].completed;
    });
    db.updateDataBase();
  }

  void checkTaskOpened(int index) {
    db.loadData();
    setState(() {
      db.toDoList[index].opened = !db.toDoList[index].opened;
    });
    db.updateDataBase();
  }

  bool checkExistenceOfTask(String taskName) {
    db.loadData();
    var list = db.toDoList;
    for (int i = 0; i < list.length; i++) {
      if (list[i].name == taskName) {
        return true;
      }
    }
    return false;
  }

  void deleteTask(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return DeleteAlertDialogBox(
              onYes: () {
                setState(() {
                  db.toDoList.removeAt(index);
                });
                db.updateDataBase();
                Navigator.of(context).pop();
              },
              onNo: cancelNewTask);
        });
  }

  void deleteSubtask(bool isControllersEmpty, int taskIndex) {
    if (isControllersEmpty && db.toDoList[taskIndex].opened == true) {
      checkTaskOpened(taskIndex);
    }
    _controller.clear();
    setState(() {});
  }

  int getLengthOfTasks() {
    db.loadData();
    return db.toDoList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.purple[200],
      backgroundColor: globals.appColorSub,
      appBar: AppBar(
        title: Text("Your Things To Do",
            style: TextStyle(
              color: globals.appColorText,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            )),
        centerTitle: true,
        // backgroundColor: Colors.purple,
        backgroundColor: globals.appColorMain,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
        elevation: 10,
        // shadowColor: Colors.purple[200],
        shadowColor: globals.appColorSub,
      ),
      floatingActionButton: FloatingActionButton.small(
          // backgroundColor: Colors.purple,
          backgroundColor: globals.appColorMain,
          onPressed: createNewTask,
          child: Icon(
            Icons.add,
            // color: Colors.black,
            color: globals.appColorText,
          )),
      body: ListView.builder(
          controller: widget.scrollController,
          itemCount: getLengthOfTasks(),
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: db.toDoList[index].name,
              taskCompleted: db.toDoList[index].completed,
              onChanged: (value) => checkBoxChanged(value, index),
              editFunction: (context) => editFunction(index),
              deleteFunction: (context) => deleteTask(index),
              taskOpened: db.toDoList[index].opened,
              onOpened: () => checkTaskOpened(index),
              parentIndex: index,
            );
          }),
    );
  }
}
