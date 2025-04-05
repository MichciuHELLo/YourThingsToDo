import 'package:hive/hive.dart';

@HiveType(typeId: 1, adapterName: "SubTaskAdapter")
class SubTask extends HiveObject {

  @HiveField(0)
  String name;

  @HiveField(1)
  bool completed;

  SubTask(this.name, this.completed);

  factory SubTask.fromJson(Map<dynamic, dynamic> json) {
    return SubTask(
      json['name'] as String,
      json['completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'completed': completed,
    };
  }
}