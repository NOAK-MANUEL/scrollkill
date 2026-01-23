import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scrollkill/components/cardPlan.dart';
import 'package:scrollkill/components/customPopupModel.dart';
import 'package:scrollkill/components/newAppSchedule.dart';
import 'package:scrollkill/components/newSchedule.dart';
import 'package:scrollkill/models/appSchedule.dart';
import 'package:scrollkill/models/userSchedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScheduleScreen extends StatefulWidget {
  const AppScheduleScreen({super.key});

  @override
  State<AppScheduleScreen> createState() => _AppScheduleScreenState();
}

class _AppScheduleScreenState extends State<AppScheduleScreen> {
  Future<List<UserSchedule>> getSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("userSchedules");

    if (data == null) return [];

    return data.map((info) => UserSchedule.fromJson(jsonDecode(info))).toList();
  }

  Future<void> saveData(List<UserSchedule> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final data = userData.map((data) => jsonEncode(data.toJson())).toList();
    await prefs.setStringList("userSchedules", data);
    setState(() {});
  }Future<void> editSchedule(UserSchedule userData) async {
    final prefs = await SharedPreferences.getInstance();
    final index = userSchedules.indexWhere((data)=>data.id == userData.id);
    if(index == -1){
      return;
    }
    userSchedules[index]= userData;
    final data = userSchedules.map((data) => jsonEncode(data.toJson())).toList();
    await prefs.setStringList("userSchedules", data);
    setState(() {});
  }

  final List<UserSchedule> userSchedules = [];

  Future<void> storeData(UserSchedule userData) async {
    userSchedules.add(userData);
    await saveData(userSchedules);
  }




  Future<void> deleteSchedule(DateTime id) async {
    final pref = await SharedPreferences.getInstance();
    userSchedules.removeWhere((schedule) => schedule.id == id);
    await saveData(userSchedules);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Schedule deleted'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
    if (!mounted) return;
  }
  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  void initState() {
    super.initState();
    getSchedules().then((data) => userSchedules.addAll(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Schedules")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    enableDrag: true,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (ctx) => NewSchedule(onSave: storeData),
                  );
                },
                label: Text("Set a new schedule"),
                icon: Icon(Icons.add),
              ),

              SizedBox(height: 20),

              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 600),
                child: ListView.separated(
                  itemBuilder: (ctx, index) {
                    final currentSchedule = userSchedules[index];

                    return CardPlan(currentSchedule: currentSchedule, wrapper: NewAppSchedule, deleteSchedule: deleteSchedule, editSchedule: editSchedule(currentSchedule), );
                  },
    separatorBuilder: (_, __) => SizedBox(height: 20),
                  itemCount: userSchedules.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
