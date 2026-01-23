import 'package:flutter/material.dart';

class UserSchedule {
   UserSchedule({
    required this.id,
    required this.title,
    required this.periods,
    required this.startDate,
    required this.endDate,
     this.hardFocus,
      this.blockScreen,
    this.description,
    List<String >? appsNotAllowed ,
  }):appsNotAllowed = appsNotAllowed ?? [];

  final DateTime id;
   String title;
  List<int> periods;
  TimeOfDay startDate;
  TimeOfDay endDate;
   bool? hardFocus;
   bool? blockScreen;
   String? description;
  List<String> appsNotAllowed;

  Map<String, dynamic> timeOfDayToJson(TimeOfDay? time) {
    return {
      'hour': time?.hour,
      'minute': time?.minute,
    };
  }
  static TimeOfDay timeOfDayFromJson(Map<String, dynamic> json) {
    return TimeOfDay(
      hour: json['hour'],
      minute: json['minute'],

    );
  }


   // void update(String key, dynamic value) {
   //   switch (key) {
   //     case 'title':
   //       title = value as String;
   //       break;
   //     case 'startDate':
   //       startDate = value;
   //       break; case 'endDate':
   //       startDate = value;
   //       break;
   //     case 'blockScreen':
   //       blockScreen = value;
   //     case 'focusMode':
   //       focusMode = value;
   //     case 'screenLimit':
   //       screenLimit = value;
   //       break;
   //     case 'interval':
   //       interval = value;
   //       break;
   //   }
   // }



   Map<String, dynamic> toJson() => {"id": id.toIso8601String(),"title": title, "periods": periods, "startDate":timeOfDayToJson( startDate), "endDate": timeOfDayToJson( endDate), "hardFocus": hardFocus,"description":description,"blockScreen":blockScreen,"appsNotAllowed": appsNotAllowed};

  factory UserSchedule.fromJson(Map<String, dynamic> json){
    return UserSchedule(id:DateTime.parse( json["id"]),title: json["title"], periods: json["periods"], startDate: timeOfDayFromJson( json["startDate"]), endDate: timeOfDayFromJson(json["endDate"]),hardFocus: json["hardFocus"], description: json["description"], blockScreen: json["blockScreen"],appsNotAllowed: json["appsNotAllowed"]);
  }
}
