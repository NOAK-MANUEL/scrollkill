import 'dart:typed_data';

enum Intervals { hourly, daily }

class MonitoringApp {
  MonitoringApp({
    required this.packageName,
    this.scrollCounts = 20,
    this.restTime = 40,
    this.interval = Intervals.hourly,
    this.focusMode = true,
    this.screenLimit=20,

  }):id = DateTime.now();


   DateTime id;
  String packageName;
  int scrollCounts;
   int restTime;
  Intervals interval;
  bool focusMode;

   int? screenLimit;

  Map<String, dynamic> toJson() => {
    "packageName": packageName,
    "scrollCounts": scrollCounts,
    "interval": interval.name,
    "focusMode": focusMode,
    "restTime": restTime,
    "screenLimit": screenLimit,
  };

  factory MonitoringApp.fromJson(Map<String, dynamic> json) => MonitoringApp(
    packageName: json["packageName"],
    scrollCounts: json["scrollCounts"],
    restTime: json[" restTime"],
    focusMode: json["focusMode"],
    screenLimit: json["screenLimit"],
    interval: Intervals.values.firstWhere((value)=>value.name == json["interval"]),
  );

  void update(String key, dynamic value) {
    switch (key) {
      case 'packageName':
        packageName = value as String;
        break;
      case 'scrollCount':
        scrollCounts = value;
        break;
      case 'restTime':
        restTime = value;
        case 'focusMode':
        focusMode = value;
        case 'screenLimit':
        screenLimit = value;
        break;
        case 'interval':
        interval = value;
        break;
    }
  }
}
