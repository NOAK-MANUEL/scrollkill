import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scrollkill/components/cardPlan.dart';
import 'package:scrollkill/components/newGoal.dart';
import 'package:scrollkill/models/goalModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  Future<List<GoalModal>> getSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("goals");

    if (data == null) return [];

    final List<GoalModal> schedules = [];

    for (final info in data) {
      try {
        final decoded = jsonDecode(info);
        schedules.add(GoalModal.fromJson(decoded));
      } catch (e) {
        debugPrint("Invalid schedule skipped: $info");
      }
    }

    return schedules;
  }


  Future<void> saveData(List<GoalModal> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final data = userData.map((data) => jsonEncode(data.toJson())).toList();
    await prefs.setStringList("goals", data);
    setState(() {});
  }Future<void> editSchedule(GoalModal userData) async {
    final prefs = await SharedPreferences.getInstance();
    final index = userSchedules.indexWhere((data)=>data.id == userData.id);
    if(index == -1){
      return;
    }
    userSchedules[index]= userData;
    final data = userSchedules.map((data) => jsonEncode(data.toJson())).toList();
    await prefs.setStringList("goals", data);
    setState(() {});
  }

  final List<GoalModal> userSchedules = [];

  Future<void> storeData(GoalModal userData) async {
    userSchedules.add(userData);
    await saveData(userSchedules);
  }




  Future<void> deleteSchedule(DateTime id) async {
    userSchedules.removeWhere((schedule) => schedule.id == id);
    await saveData(userSchedules);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Goal deleted'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
    if (!mounted) return;
  }


  Future<void> _loadSchedules() async {
    final data = await getSchedules();
    setState(() {
      userSchedules..clear()..addAll(data);
    });
  }
  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Goals")),
      body: SafeArea(
        child: ListView.separated(
          itemBuilder: (ctx, index) {
            final currentSchedule = userSchedules[index];

            return CardPlan(currentSchedule: currentSchedule,wrapper: ()=>NewGoal(onEdit: editSchedule,editContent: currentSchedule,), deleteSchedule: deleteSchedule,);
          },
          separatorBuilder: (_,_) => SizedBox(height: 10),
          itemCount: userSchedules.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        showModalBottomSheet(
          context: context,
          enableDrag: true,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (ctx) => NewGoal(onSave: storeData),
        );
      }, child: Icon(Icons.add),),
    );
  }
}
