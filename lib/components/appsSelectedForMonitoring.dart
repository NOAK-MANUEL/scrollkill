import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollkill/components/appsSelectedForMonitoringList.dart';
import 'package:scrollkill/components/contentCard.dart';
import 'package:scrollkill/models/monitoringApp.dart';
import 'package:scrollkill/states/settingState.dart';

class AppsSelectedForMonitoring extends StatefulWidget {
  const AppsSelectedForMonitoring({super.key});


  @override
  State<AppsSelectedForMonitoring> createState() =>
      _AppsSelectedForMonitoringState();
}

class _AppsSelectedForMonitoringState extends State<AppsSelectedForMonitoring> {



  @override
  Widget build(BuildContext context) {

    List<MonitoringApp>  monitoringApps = context.watch<AppMonitoredProvider>().appsMonitored;

    bool blockScreen =  context.watch<SettingProvider>().blockScreen;
    bool trackScreen =  context.watch<SettingProvider>().trackScreen;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "${monitoringApps.length} App${monitoringApps.length != 1 ? "s" : ""} selected for monitoring",
            ),
        
            SizedBox(height: 16,),
        
        
            contentCard(
              Column(
                children: [
                  SwitchListTile(value: blockScreen, onChanged: (value){
                    setState(() {
                      blockScreen = value;
                    });
                  }, title: Text("Block Screen"), subtitle: Text("Set a default setting for all apps and block screen when timer reached to avoid distractions"),),
                  SwitchListTile(value: trackScreen, onChanged: (value){
                    setState(() {
                      trackScreen = value;
                    });
                  }, title: Text("Track Screen Time"),subtitle: Text("Track screen time of every apps and set a limit"),)
                ],
              )
            ),
            SizedBox(height: 20,),
        
        
        
        
            ...monitoringApps.map((app)=>AppsSelectedForMonitoringList(app: app,)),
        
        
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 100,child: OutlinedButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel"))),
                  Spacer(),
                  SizedBox(width: 200,
                    child: ElevatedButton(onPressed: (){
        
                    }, child: Text("Activate Monitoring")),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
