import 'package:hive/hive.dart';

@HiveType(typeId: 2, adapterName: "AlertDataAdapter")
class AlertData extends HiveObject {

  @HiveField(0)
  bool isAlarmSet;

  @HiveField(1)
  int dayOfAlert;

  @HiveField(2)
  int monthOfAlert;

  @HiveField(3)
  int yearOfAlert;

  @HiveField(4)
  int hourOfAlert;

  @HiveField(5)
  int minuteOfAlert;

  @HiveField(6)
  int repeatEveryAlert;

  @HiveField(7)
  String repeatEveryWhatAlert;

  AlertData(this.isAlarmSet, this.dayOfAlert, this.monthOfAlert, this.yearOfAlert, this.hourOfAlert, this.minuteOfAlert, this.repeatEveryAlert, this.repeatEveryWhatAlert);

  factory AlertData.fromJson(Map<dynamic, dynamic> json) {
    return AlertData(
      json['isAlarmSet'] as bool,
      json['dayOfAlert'] as int,
      json['monthOfAlert'] as int,
      json['yearOfAlert'] as int,
      json['hourOfAlert'] as int,
      json['minuteOfAlert'] as int,
      json['repeatEveryAlert'] as int,
      json['repeatEveryWhatAlert'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAlarmSet': isAlarmSet,
      'dayOfAlert': dayOfAlert,
      'monthOfAlert': monthOfAlert,
      'yearOfAlert': yearOfAlert,
      'hourOfAlert': hourOfAlert,
      'minuteOfAlert': minuteOfAlert,
      'repeatEveryAlert': repeatEveryAlert,
      'repeatEveryWhatAlert': repeatEveryWhatAlert,
    };
  }
}