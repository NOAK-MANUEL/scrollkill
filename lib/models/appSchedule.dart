

import 'package:flutter/material.dart';
import 'package:scrollkill/models/userSchedule.dart';

class AppSchedule extends UserSchedule {
  AppSchedule({
    required super.id,
    required super.title,
    required super.periods,
    required super.startDate,
    required super.endDate,
    super.description,
    required this.app
  });


    String app;


    @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "app": app
    };
  }
  static TimeOfDay timeOfDayFromJson(Map<String, dynamic> json) {
    return TimeOfDay(
      hour: json['hour'],
      minute: json['minute'],

    );
  }


  factory AppSchedule.fromJson(Map<String, dynamic> json){
    return AppSchedule(id:DateTime.parse( json["id"]),title: json["title"], periods: json["periods"],app: json["app"],startDate:timeOfDayFromJson( json["startDate"]) , endDate: timeOfDayFromJson(json["endDate"]));
  }

}
