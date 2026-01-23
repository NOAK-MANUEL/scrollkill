import 'package:flutter/material.dart';
import 'package:scrollkill/components/appLists.dart';
import 'package:scrollkill/screens/appSchedulesScreen.dart';
import 'package:scrollkill/screens/goalsScreen.dart';
import 'package:scrollkill/screens/scheduleScreen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(child: Container(
              color: Theme.of(context).primaryColor,
              child: Image.asset("assets/logo.png"),
            )
            ),
            Expanded(
              
              child: ListView(

                children: [
                  ListTile(leading: Icon(Icons.schedule),title: Text("Schedules"),onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ScheduleScreen()));
                  },),
                  ListTile(leading: Icon(Icons.schedule),title: Text("App Schedules"),onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>AppScheduleScreen()));
                  },),
                  ListTile(leading: Icon(Icons.track_changes),title: Text("Goals"),onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>GoalsScreen()));
                  },),
                  ListTile(leading: Icon(Icons.analytics),title: Text("Analytics"),),

                  ListTile(leading: Icon(Icons.money),title: Text("Support"),),
                  ListTile(leading: Icon(Icons.reviews),title: Text("Review"),),
                ],
              ),
            ),
            
            ListTile(leading: Icon(Icons.help), title: Text("Help"),)
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Choose the apps to apply settings", textAlign: TextAlign.center, style: TextStyle(
                fontSize: 17
              ),),
          
              SizedBox(height: 16),
          
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AppLists(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
