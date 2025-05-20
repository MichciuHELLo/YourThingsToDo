import 'package:hive/hive.dart';
import 'package:your_things_to_do/util/subTask.dart';

import 'alert_data.dart';

@HiveType(typeId: 0, adapterName: "TaskAdapter")
class Task extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool completed;

  @HiveField(2)
  bool opened;

  @HiveField(3)
  List<SubTask>? subTasks;

  // @HiveField(4)
  // bool alertSet;

  @HiveField(4)
  AlertData alertData;

  // Task(this.name, this.completed, this.opened, this.subTasks, this.alertSet, this.alertData);
  Task(this.name, this.completed, this.opened, this.subTasks, this.alertData);

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    return Task(
      json['name'] as String,
      json['completed'] as bool,
      json['opened'] as bool,
      (json['subTasks'] as List<dynamic>?)?.map((e) =>
          SubTask.fromJson(e as Map<dynamic, dynamic>)).toList(),
      // json['alertSet'] as bool,
      AlertData.fromJson(json['alertData'] as Map<dynamic, dynamic>)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'completed': completed,
      'opened': opened,
      'subTasks': subTasks?.map((e) => e.toJson()).toList(),
      // 'alertSet': alertSet,
      'alertData': alertData.toJson()
    };
  }
}
