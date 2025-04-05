// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

import 'package:hive/hive.dart';
import 'package:your_things_to_do/util/alert_data.dart';

import '../util/subTask.dart';
import '../util/task.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      fields[0] as String,
      fields[1] as bool,
      fields[2] as bool,
      (fields[3] as List?)?.cast<SubTask>(),
      fields[4] as AlertData
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.completed)
      ..writeByte(2)
      ..write(obj.opened)
      ..writeByte(3)
      ..write(obj.subTasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TaskAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
