import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'package:numberpicker/numberpicker.dart';

import '../data/database.dart';
import 'delete_alert_dialog_box.dart';
import 'my_button.dart';

import '../data/globalVariables.dart' as globals;

StreamController<bool> streamController = StreamController<bool>.broadcast();

class DialogBox extends StatefulWidget {
  String hintText;
  final controller;
  List<TextEditingController> controllers;
  VoidCallback onSave;
  VoidCallback onCancel;
  final Function(bool isControllersEmpty, int parentIndex) onDeleteSubtask;
  bool advancedSettings;
  final Stream<bool> stream;
  final int parentIndex;

  DialogBox({
    super.key,
    required this.hintText,
    required this.controller,
    required this.controllers,
    required this.onSave,
    required this.onCancel,
    required this.onDeleteSubtask,
    required this.advancedSettings,
    required this.stream,
    required this.parentIndex,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  ToDoDataBase db = ToDoDataBase();
  bool isButtonEnabled = false;
  bool taskExists = false;
  bool advancedSettings = false;
  bool alarmDateSettings = false;
  bool alarmHourSettings = false;
  int subTaskCount = 0;
  double mainSizedBoxHeight = 200;
  double subTaskTextFormHeight = 64.3;
  double subTaskSizedBoxHeight = 0;
  List<int> controllersIndexToRemove = [];

  late String taskMultiplicationAlert;
  late String extraSettings;
  late String subtaskHintText;
  late String buttonSaveName;
  late String buttonCancelName;

  late String alarmStartDate;
  late String alarmStartHour;
  late String alarmDay;
  late String alarmWeek;
  late String alarmMonth;
  late String alarmYear;
  late String alarmHour;
  late String alarmMinute;
  late String alarmNever;
  late String alarmRepeatEvery;

  int _pickedDay = DateTime.now().day;
  int _pickedMonth = DateTime.now().month;
  int _pickedYear = DateTime.now().year;

  int _pickedHour = DateTime.now().hour;
  int _pickedMinute = DateTime.now().minute;

  String _dropdownValue = 'Never';
  int _pickedEvery = 1;
  // List<String> everyTimeList = ['Everyday', 'Every week', 'Every month', 'Every year'];

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_checkInput);
    _checkInput();
    widget.stream.listen((taskExists) {
      setTaskExists(taskExists);
    });
    advancedSettings = widget.advancedSettings;

    if (advancedSettings) {
      advancedSettings = !advancedSettings;
      advancedSettingsCheckBoxChanged();
      setSubTaskSizedBoxHeight(widget.controllers.length);
    }
    subTaskCount = countSubTask();



    db.loadSettings();
    switch (db.settingsList[0]) {
      case 0: // ENGLISH
        taskMultiplicationAlert = "YourThingToDo with this name already exists!";
        extraSettings = "Extra settings";
        subtaskHintText = "Add a SubTask";
        buttonSaveName = "Save";
        buttonCancelName = "Cancel";
        alarmStartDate = 'Alarm start date';
        alarmStartHour = 'Alarm start hour';
        alarmDay = 'Day';
        alarmWeek = 'Week';
        alarmMonth = 'Month';
        alarmYear = 'Year';
        alarmHour = 'Hour';
        alarmMinute = 'Minute';
        alarmNever = 'Never';
        alarmRepeatEvery = 'Repeat every: ';
        break;
      case 1: // POLISH
        taskMultiplicationAlert = "Zadanie z tą nazwą już istnieje!";
        extraSettings = "Ustawienia zaawansowane";
        subtaskHintText = "Dodaj podzadanie";
        buttonSaveName = "Zapisz";
        buttonCancelName = "Cofnij";
        alarmStartDate = 'Data alarmu';
        alarmStartHour = 'Godzina alarmu';
        alarmDay = 'Dzień';
        alarmWeek = 'Tydzień';
        alarmMonth = 'Miesiąc';
        alarmYear = 'Rok';
        alarmHour = 'Godzina';
        alarmMinute = 'Minuta';
        alarmNever = 'Nigdy';
        alarmRepeatEvery = 'Powtórz co: ';
        break;
    }


  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkInput);
    widget.controllers.clear();
    super.dispose();
  }

  int countSubTask() {
    return widget.controllers.length;
  }

  void _checkInput() {
    setState(() {
      isButtonEnabled = widget.controller.text.isNotEmpty;
    });
  }

  void setTaskExists(bool exists) {
    if (mounted) {
      setState(() {
        taskExists = exists;
      });
    }
  }

  void advancedSettingsCheckBoxChanged() {
    setState(() {
      advancedSettings = !advancedSettings;
      double newTaskMenuHeight = 0;
      if (advancedSettings) {
        if (subTaskCount > 0) {
          // newTaskMenuHeight = (321 - subTaskTextFormHeight) +
          newTaskMenuHeight = (324.3 - subTaskTextFormHeight) +
              subTaskCount * subTaskTextFormHeight;
        } else {
          newTaskMenuHeight = 260;
        }

        if (newTaskMenuHeight > 500) {
          mainSizedBoxHeight = 500;
        } else {
          mainSizedBoxHeight = newTaskMenuHeight;
        }
      } else {
        mainSizedBoxHeight = 200;
      }
      if (alarmDateSettings) {
        mainSizedBoxHeight += 302;
      }
      if (alarmDateSettings && !advancedSettings) {
        mainSizedBoxHeight -= 302;
      }
    });
  }

  void alarmDateSettingsCheckBoxChanged() {

    _pickedDay = DateTime.now().day;
    _pickedMonth = DateTime.now().month;
    _pickedYear = DateTime.now().year;

    setState(() {
      if (alarmDateSettings) {
        alarmDateSettings = !alarmDateSettings;
        mainSizedBoxHeight -= 302;
      } else {
        alarmDateSettings = !alarmDateSettings;
        mainSizedBoxHeight += 302;
      }
    });
  }

  void alarmHourSettingsCheckBoxChanged() { // TODO delete - no usage

    _pickedHour = DateTime.now().hour;
    _pickedMinute = DateTime.now().minute;

    setState(() {
      alarmHourSettings = !alarmHourSettings;
    });
  }

  void setSubTaskSizedBoxHeight(int subTaskCount) {
    setState(() {
      double newSubtaskMenuHeight = subTaskTextFormHeight * subTaskCount;
      if (newSubtaskMenuHeight > 225) {
        subTaskSizedBoxHeight = 225;
      } else {
        subTaskSizedBoxHeight = newSubtaskMenuHeight;
      }

      mainSizedBoxHeight += newSubtaskMenuHeight;
      if (mainSizedBoxHeight > 500 && !alarmDateSettings) {
        mainSizedBoxHeight = 500;
      }
      if (mainSizedBoxHeight > 820 && alarmDateSettings) {
        mainSizedBoxHeight = 820;
      }
    });
  }

  void addNewSubTask() {
    widget.controllers.add(TextEditingController());
    setState(() {
      subTaskCount++;
      double newSubtaskMenuHeight = subTaskTextFormHeight * subTaskCount;
      if (newSubtaskMenuHeight > 225) {
        subTaskSizedBoxHeight = 225;
      } else {
        subTaskSizedBoxHeight = newSubtaskMenuHeight;
      }

      mainSizedBoxHeight += subTaskTextFormHeight;
      if (mainSizedBoxHeight > 500 && !alarmDateSettings) {
        mainSizedBoxHeight = 500;
      }
      if (mainSizedBoxHeight > 820 && alarmDateSettings) {
        mainSizedBoxHeight = 820;
      }
    });
  }

  void deleteSubtask(int parentIndex, int subTaskIndex) {
    db.loadData();

    bool doesSubtaskExistsInDatabase;
    try {
      db.toDoList[parentIndex].subTasks?[subTaskIndex];
      doesSubtaskExistsInDatabase = true;
    } on RangeError {
      doesSubtaskExistsInDatabase = false;
    }

    showDialog(
        context: context,
        builder: (context) {
          return DeleteAlertDialogBox(
              onYes: () {
                setState(() {
                  widget.controllers.removeAt(subTaskIndex);
                  subTaskCount = countSubTask();
                  if (doesSubtaskExistsInDatabase) {
                    db.toDoList[parentIndex].subTasks?.removeAt(subTaskIndex);
                  }
                });

                if (subTaskCount + 1 < 4) {
                  // size down DialogBox
                  double newSubtaskMenuHeight =
                      subTaskTextFormHeight * subTaskCount;
                  if (newSubtaskMenuHeight > 225) {
                    subTaskSizedBoxHeight = 225;
                  } else {
                    subTaskSizedBoxHeight = newSubtaskMenuHeight;
                  }
                  mainSizedBoxHeight -= subTaskTextFormHeight;
                } else if (subTaskCount + 1 == 4) {
                  subTaskSizedBoxHeight = subTaskTextFormHeight * subTaskCount;
                  mainSizedBoxHeight -= 47.1;
                }
                db.updateDataBase();

                if (widget.controllers.isEmpty) {
                  widget.onDeleteSubtask(true, widget.parentIndex);
                } else {
                  widget.onDeleteSubtask(false, widget.parentIndex);
                }

                Navigator.of(context).pop();
              },
              onNo: cancelNewTask);
        });
  }

  void cancelNewTask() {
    Navigator.of(context).pop();
    // _controller.clear();
    // _controllers.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // backgroundColor: Colors.purple,
      backgroundColor: globals.appColorMain,
      content: SingleChildScrollView(
        child: SizedBox(
          height: mainSizedBoxHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                visible: taskExists,
                child: Text(
                  taskMultiplicationAlert,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.red[200]
                      color: globals.appColorAlert
                  ),
                ),
              ),
              TextFormField(
                controller: widget.controller,
                style: TextStyle(
                    color: globals.appColorText,
                    fontWeight: FontWeight.bold
                ),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                      color: globals.appColorText
                  ),
                ),
              ),
        
              // TODO create notifications on dates
              // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              //   Checkbox(
              //     activeColor: globals.appColorCheckbox,
              //     checkColor: globals.appColorCheck,
              //     value: alarmSettings,
              //     onChanged: (value) => alarmSettingsCheckBoxChanged(),
              //   ),
              //   Text(
              //     'Alarm Settings',
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       color: globals.appColorText,
              //     ),
              //   ),
              // ]),
              // Visibility(
              //     visible: alarmSettings,
              //     child: Column(
              //
              //       // TODO option to point at what date start the reminder
              //
              //       // TODO option how often to reminder - every: hour, day, week, month, year - at what hour
              //
              //       // TODO notifications works
              //
              //     )
              // ),
        
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Checkbox(
                  activeColor: globals.appColorCheckbox,
                  checkColor: globals.appColorCheck,
                  value: advancedSettings,
                  onChanged: (value) => advancedSettingsCheckBoxChanged(),
                ),
                Text(
                  extraSettings,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: globals.appColorText,
                  ),
                ),
              ]),
              Visibility(
                  visible: advancedSettings,
                  child: Column(
                    children: [
        
                      // TODO create notifications on dates
        
                      // TODO option to point at what date start the reminder
                      Row(
                        children: [
                          Text(
                            alarmStartDate,
                            style: const TextStyle(fontWeight: FontWeight.bold)
                          ),
                          Checkbox(
                              value: alarmDateSettings,
                              onChanged: (value) => alarmDateSettingsCheckBoxChanged()
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Visibility(
                              visible: alarmDateSettings,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(alarmDay, style: TextStyle(fontWeight: FontWeight.bold)),
                                      NumberPicker(
                                        minValue: 1,
                                        maxValue: DateTime(DateTime.now().year, _pickedMonth + 1, 0).day,
                                        value: _pickedDay > DateTime(DateTime.now().year, _pickedMonth + 1, 0).day ? DateTime(DateTime.now().year, _pickedMonth + 1, 0).day : _pickedDay,
                                        itemHeight: 24,
                                        itemWidth: 80,
                                        onChanged: (value) => setState(() => _pickedDay = value),
                                        selectedTextStyle: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 20
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(alarmMonth, style: TextStyle(fontWeight: FontWeight.bold)),
                                      NumberPicker(
                                        minValue: 1,
                                        maxValue: 12,
                                        value: _pickedMonth,
                                        itemHeight: 24,
                                        itemWidth: 80,
                                        onChanged: (value) => setState(() => _pickedMonth = value),
                                        selectedTextStyle: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 20
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(alarmYear, style: TextStyle(fontWeight: FontWeight.bold)),
                                      NumberPicker(
                                        minValue: 1,
                                        maxValue: 4000,
                                        value: _pickedYear,
                                        itemHeight: 24,
                                        itemWidth: 80,
                                        onChanged: (value) => setState(() => _pickedYear = value),
                                        selectedTextStyle: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 20
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                          ),
                          Visibility(
                              visible: alarmDateSettings,
                              child: Column(
                                children: [
                                  const SizedBox(height: 25),
                                  // Text(
                                  //   alarmStartHour,
                                  //   style: const TextStyle(
                                  //       fontWeight: FontWeight.bold,
                                  //       fontSize: 16
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(alarmHour, style: TextStyle(fontWeight: FontWeight.bold),),
                                          NumberPicker(
                                            minValue: 01,
                                            maxValue: 24,
                                            value: _pickedHour,
                                            itemHeight: 24,
                                            itemWidth: 80,
                                            onChanged: (value) => setState(() => _pickedHour = value),
                                            selectedTextStyle: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 20
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(alarmMinute, style: const TextStyle(fontWeight: FontWeight.bold),),
                                          NumberPicker(
                                            minValue: 00,
                                            maxValue: 59,
                                            value: _pickedMinute,
                                            itemHeight: 24,
                                            itemWidth: 80,
                                            onChanged: (value) => setState(() => _pickedMinute = value),
                                            selectedTextStyle: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 20
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // TODO option how often to reminder - every: hour, day, week, month, year - at what hour
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      Text(alarmRepeatEvery,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Visibility(
                                        visible: _dropdownValue != 'Nigdy' && _dropdownValue != 'Never' ? true : false, // TODO repair
                                        child: NumberPicker(
                                          minValue: 1,
                                          maxValue: 999,
                                          value: _pickedEvery,
                                          itemHeight: 24,
                                          itemWidth: 35,
                                          onChanged: (value) => setState(() => _pickedEvery = value),
                                          selectedTextStyle: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 20
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      DropdownButton<String> (
                                        dropdownColor: globals.appColorSub,
                                        value: _dropdownValue,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _dropdownValue = newValue!;
                                          });
                                        },
                                        items: [
                                          DropdownMenuItem(
                                              value: 'Never',
                                              child: Text(alarmNever)
                                          ),
                                          DropdownMenuItem(
                                              value: 'Everyday',
                                              child: Text(alarmDay)
                                          ),
                                          DropdownMenuItem(
                                              value: 'Everyweek',
                                              child: Text(alarmWeek)
                                          ),
                                          DropdownMenuItem(
                                              value: 'Everyyear',
                                              child: Text(alarmYear)
                                          ),
                                        ],
                                      )
                                    ]
                                  ),
                                  // Row(
                                  //   children: [
                                      // Visibility(
                                      //   visible: _dropdownValue != 'Never' ? true : false,
                                      //   child: NumberPicker(
                                      //     minValue: 1,
                                      //     maxValue: 999,
                                      //     value: _pickedEvery,
                                      //     itemHeight: 24,
                                      //     itemWidth: 80,
                                      //     onChanged: (value) => setState(() => _pickedEvery = value),
                                      //     selectedTextStyle: const TextStyle(
                                      //         color: Colors.green,
                                      //         fontSize: 20
                                      //     ),
                                      //   ),
                                      // ),
                                      // DropdownButton<String> (
                                      //   dropdownColor: globals.appColorSub,
                                      //   value: _dropdownValue,
                                      //   onChanged: (String? newValue) {
                                      //     setState(() {
                                      //       _dropdownValue = newValue!;
                                      //     });
                                      //   },
                                      //   items: const [
                                      //     DropdownMenuItem(
                                      //       value: 'Never',
                                      //         child: Text('Never')
                                      //     ),
                                      //     DropdownMenuItem(
                                      //         value: 'Everyday',
                                      //         child: Text('day')
                                      //     ),
                                      //     DropdownMenuItem(
                                      //         value: 'Everyweek',
                                      //         child: Text('week')
                                      //     ),
                                      //     DropdownMenuItem(
                                      //         value: 'Everyyear',
                                      //         child: Text('year')
                                      //     ),
                                      //   ],
                                      // )
                                  //   ],
                                  // )
                                ],
                              )
                          )
                        ],
                      ),
        
        
        
                      // TODO notifications works
        
        
                      SizedBox(
                        width: double.maxFinite,
                        height: subTaskSizedBoxHeight,
                        child: ListView.builder(
                            itemCount: subTaskCount,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: widget.controllers[index],
                                        // style: FontWeight.bold,
                                        style: TextStyle(color: globals.appColorText),
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                          ),
                                          hintText: subtaskHintText,
                                          // hintStyle: TextStyle(color: globals.appColorText)
                                          hintStyle: TextStyle(
                                              color: globals.appColorText,
                                              fontWeight: FontWeight.w100
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => {
                                        deleteSubtask(widget.parentIndex, index),
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        // color: Colors.grey[500],
                                        color: globals.appColorDelete,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      // SubTaskTextForm(),
                      Row(children: [
                        IconButton(
                            onPressed: addNewSubTask,
                            icon: Icon(
                              Icons.add_circle,
                              // color: Colors.purple[200],
                              // color: globals.appColorSub,
                              color: globals.appColorCheckbox,
                            )),
                        Text(subtaskHintText, style: TextStyle(color: globals.appColorText),),
                      ])
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(
                    name: buttonSaveName,
                    onPressed: isButtonEnabled ? widget.onSave : null,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  MyButton(
                    name: buttonCancelName,
                    onPressed: widget.onCancel,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
