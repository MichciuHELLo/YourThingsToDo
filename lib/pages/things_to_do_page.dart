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
    // db.toDoList.add(Task("Zablokowac guzik 'save' gdy jest 0 znakow w textFild", false, false, null));
    // db.toDoList.add(Task("Dodac drzewa taskow!", true, false, null));
    // db.toDoList.add(Task("Dodac ustawienia globane", false, false, [SubTask("Zmiana jezyka", false), SubTask("Zmiana kolorow aplikacji", false)]));
    // db.toDoList.add(Task("Powiadomienia przypominajace o wykonaniu taska", false, false, [SubTask("Przychodzą powiadomienia", false)]));
    // db.toDoList.add(Task("Informacja o bledzie duplikacji taska przy taorzeniu nowego i edycji starego taska", false, false, [SubTask("Przy tworzeniu nowego taska", false), SubTask("Przy edytowaniu starego taska", false)]));
    // db.toDoList.add(Task("Dodac opcje zaawansowane podczas tworzenia nowego taska i edycji starego", false, false, [SubTask("Przy tworzeniu nowego taska", false), SubTask("Przy edytowaniu starego taska", false)]));
    // db.toDoList.add(Task("test main", false, true, [SubTask("test1", false), SubTask("test2", true)]));
    // db.updateDataBase();
    // print("length: " + db.toDoList.length.toString());
    // for(int i=0; i<db.toDoList.length; i++) {
    //   print("element " + i.toString() + ": " + db.toDoList[i].toJson().toString());
    // }
    // TODO to delete

    db.loadData();
    db.toDoList.clear();
    db.updateDataBase();

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
          db.toDoList.add(Task(_controller.text, false, false, subTaskList, AlertData(1,1,1,1,1,1,'Never')));
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

    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            hintText: "",
            controller: taskName,
            controllers: _controllers,
            onSave: () => editOldTask(taskName, index, subTaskList),
            onCancel: cancelNewTask,
            onDeleteSubtask: deleteSubtask,
            advancedSettings: advancedSettingsChecked,
            stream: streamController.stream,
            parentIndex: index,
          );
        });
  }

  void editOldTask(
      TextEditingController taskName, int index, List<SubTask> subTaskList) {
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
