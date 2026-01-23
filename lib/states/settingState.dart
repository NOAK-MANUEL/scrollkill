import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:scrollkill/functions/getApps.dart';
import 'package:scrollkill/models/monitoringApp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  Intervals defaultInterval = Intervals.hourly;
  int screenLimit = 20;
  int restLimit = 40;
  bool blockScreen = false;
  bool trackScreen = true;
  bool _loaded = false;


  final List<AppInfo> apps = [];

  void changeInterval(Intervals interval) {
    interval = interval;
    notifyListeners();
  }

  void setScreenLimit(int limit) {
    screenLimit = limit;
    notifyListeners();
  }

  void setRestLimit(int limit) {
    restLimit = limit;
    notifyListeners();
  }


  void setBlockScreen(bool data) {
    blockScreen = data;
    notifyListeners();
  }

  void setTrackScreen(bool data) {
    trackScreen = data;
    notifyListeners();
  }





  Future<void> loadApps() async {
    if (_loaded) return ;

    final values = await getInstalledApps();
    apps.addAll(values);
    _loaded = true;
    notifyListeners();
  }




  void addMainApps(List<AppInfo> apps) {
    apps.addAll(apps);
    notifyListeners();
  }
}
class AppMonitoredProvider extends ChangeNotifier {



  final List<MonitoringApp> appsMonitored = [];



  void addMonitoringApp(String name) {
    appsMonitored.add(MonitoringApp(packageName: name));
    notifyListeners();
  }
  void removeMonitoringApp(String packageName) {
    appsMonitored.removeWhere(
          (e) => e.packageName == packageName,
    );
    notifyListeners();
  }


  void editMonitoringApp(DateTime id, String key, dynamic value) {
    final app = appsMonitored.firstWhere((app) => app.id == id);
    app.update(key, value);
    notifyListeners();
  }

  void saveApp() async{
    if(appsMonitored.isEmpty){
      return;
    }

    final pref = await SharedPreferences.getInstance();

    final sedApps = appsMonitored.map((app)=> jsonEncode(app.toJson())).toList();

    await pref.setStringList("monitoringApps", sedApps);
  }


  Future<void> getMonitoringApps ()async{
    if(appsMonitored.isNotEmpty){
      return;
    }

    final pref = await SharedPreferences.getInstance();
    final data = pref.getStringList("monitoringApps");

    if(data == null) return;


    final apps= data.map((app)=> MonitoringApp.fromJson(jsonDecode(app))).toList();
    appsMonitored.addAll(apps);

    notifyListeners();

  }




}
