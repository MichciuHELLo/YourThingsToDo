import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:your_things_to_do/util/sub_todo_tile.dart';

import '../data/database.dart';

import 'package:your_things_to_do/data/globalVariables.dart' as globals;

class ToDoTile extends StatefulWidget {
  final String taskName;
  final bool taskCompleted;
  final bool taskOpened;
  Function(bool?)? onChanged;
  Function() onOpened;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext)? editFunction;
  final int parentIndex;

  ToDoTile(
      {super.key,
      required this.taskName,
      required this.taskCompleted,
      required this.taskOpened,
      required this.onChanged,
      required this.onOpened,
      required this.editFunction,
      required this.deleteFunction,
      required this.parentIndex});

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  ToDoDataBase db = ToDoDataBase();

  int? getLengthOfSubTasks() {
    db.loadData();
    if (db.toDoList[widget.parentIndex].subTasks == null) {
      return 0;
    } else {
      return db.toDoList[widget.parentIndex].subTasks?.length;
    }
  }

  void checkBoxChanged(bool? value, int index) {
    db.loadData();
    setState(() {
      db.toDoList[widget.parentIndex].subTasks![index].completed =
          !db.toDoList[widget.parentIndex].subTasks![index].completed;
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 25.0, top: 25.0, right: 25.0, bottom: 15.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: widget.editFunction,
              icon: Icons.edit,
              backgroundColor: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: widget.deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            // color: Colors.purple,
            color: globals.appColorMain,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(width: 0.6, color: Colors.black)),
                    value: widget.taskCompleted,
                    onChanged: widget.onChanged,
                    // activeColor: Colors.deepPurple,
                    activeColor: globals.appColorCheckbox,
                    checkColor: globals.appColorCheck,
                  ),
                  Expanded(
                    child: Text(
                      style: TextStyle(
                          color: globals.appColorText,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: widget.taskCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                      decorationThickness: 2),
                      widget.taskName,
                    ),
                  ),
                  Visibility(
                    visible: getLengthOfSubTasks() == 0 ? false : true,
                    child: IconButton(
                      onPressed: widget.onOpened,
                      icon: widget.taskOpened
                          ? const Icon(Icons.keyboard_arrow_down)
                          : const Icon(Icons.keyboard_arrow_left),
                      // color: Colors.black,
                      color: globals.appColorText,
                    ),
                  )
                ],
              ),
              Visibility(
                visible: widget.taskOpened,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    // color: Colors.purple[400],
                    color: globals.appColorSub,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: getLengthOfSubTasks(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return SubToDoTile(
                        subTaskName: db
                            .toDoList[widget.parentIndex].subTasks![index].name,
                        subTaskCompleted: db.toDoList[widget.parentIndex]
                            .subTasks![index].completed,
                        subTaskOnChanged: (value) =>
                            checkBoxChanged(value, index),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
