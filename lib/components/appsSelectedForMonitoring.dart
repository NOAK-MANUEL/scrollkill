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
  TextEditingController screenLimitController = TextEditingController(text: "20");
  TextEditingController restTimeController = TextEditingController(text: "40");


  void callSave(SettingProvider provider, AppMonitoredProvider appProvider)async {
    await provider.saveSettings(int.tryParse(restTimeController.text),
        int.tryParse(screenLimitController.text));
    await appProvider.saveApp();

    if (!mounted) return;
    Navigator.pop(context);


  }

    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppMonitoredProvider>().getMonitoringApps();
      screenLimitController = TextEditingController(text:  context.watch<SettingProvider>().screenLimit.toString());
      restTimeController = TextEditingController(text:  context.watch<SettingProvider>().restTime.toString());

    });
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.read<SettingProvider>();
    final appProvider = context.read<AppMonitoredProvider>();

       List<MonitoringApp>  monitoringApps = context.watch<AppMonitoredProvider>().appsMonitored;

    bool blockScreen =  context.watch<SettingProvider>().blockScreen;
    bool focusMode =  context.watch<SettingProvider>().focusMode;
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
                    provider.setBlockScreen(value);
                  }, title: Text("Block Screen"), subtitle: Text("Set a default setting for all apps and block screen when timer reached to avoid distractions"),),
                  SwitchListTile(value: trackScreen, onChanged: (value){
                    provider.setTrackScreen(value);

                  }, title: Text("Track Screen Time"),subtitle: Text("Track screen time of every apps and set a limit"),),

                  if (blockScreen)
                    contentCard(
                      SwitchListTile(value: focusMode, onChanged: (value){
                        provider.setFocusMode(value);
                      },title: Text("Focus Mode"), subtitle: Text("Completely avoid any distraction"),),
                    ),
                ],
              )
            ),
            SizedBox(height: 20,),
        
        
            if(blockScreen)
              ...[

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("Set Screen Limit",style: Theme.of(context).textTheme.titleSmall,),
                              Spacer(),
                              numberField(screenLimitController)
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text("Set Rest Time", style: Theme.of(context).textTheme.titleSmall,),
                              Spacer(),
                              numberField(restTimeController)
                            ],
                          ),
                        ],
                      ),
                    )


              ],

            if(!blockScreen)
              ...monitoringApps.map((app)=>AppsSelectedForMonitoringList(app: app,)),
        
        
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 100,child: OutlinedButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel"))),
                  Spacer(),
                  SizedBox(width: 150,
                    child: ElevatedButton(onPressed: (){
                       callSave(provider, appProvider);
                    }, child: Text("Save")),
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
