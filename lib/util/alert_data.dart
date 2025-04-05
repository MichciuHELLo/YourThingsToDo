import 'package:hive/hive.dart';

@HiveType(typeId: 2, adapterName: "AlertDataAdapter")
class AlertData extends HiveObject {
  @HiveField(0)
  int dayOfAlert;

  @HiveField(1)
  int monthOfAlert;

  @HiveField(2)
  int yearOfAlert;

  @HiveField(3)
  int hourOfAlert;

  @HiveField(4)
  int minuteOfAlert;

  @HiveField(5)
  int repeatEveryAlert;

  @HiveField(6)
  String repeatEveryWhatAlert;

  AlertData(this.dayOfAlert, this.monthOfAlert, this.yearOfAlert, this.hourOfAlert, this.minuteOfAlert, this.repeatEveryAlert, this.repeatEveryWhatAlert);

  factory AlertData.fromJson(Map<dynamic, dynamic> json) {
    return AlertData(
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