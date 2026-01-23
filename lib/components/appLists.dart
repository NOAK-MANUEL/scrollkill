import 'dart:async';

import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:provider/provider.dart';
import 'package:scrollkill/components/appListSaveButton.dart';
import 'package:scrollkill/components/appsSelectedForMonitoring.dart';
import 'package:scrollkill/components/checkAppButton.dart';
// import 'package:scrollkill/functions/getApps.dart';
import 'package:scrollkill/models/monitoringApp.dart';
import 'package:scrollkill/states/settingState.dart';

class AppLists extends StatefulWidget {
  const AppLists({super.key});

  @override
  State<AppLists> createState() => _AppListsState();
}

class _AppListsState extends State<AppLists> {
  Timer? _debounce;
  List<AppInfo> visibleApps=[];

  void onSearch(String value, List<AppInfo> apps) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        visibleApps = value.length < 2
            ? apps
            : apps
                  .where(
                    (app) =>
                        app.name.toLowerCase().contains(value) &&
                        app.name != "ScrollKill",
                  )
                  .toList();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingProvider>().loadApps();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SettingProvider>();
    final apps = context.watch<SettingProvider>().apps;
    final displayApps = visibleApps.isNotEmpty ? visibleApps : apps;



    return displayApps.isNotEmpty ? Column(
      children: [
        TextField(
          onChanged: (value) {
            onSearch(value, apps);
          },

          decoration: InputDecoration(hintText: "Search App"),
        ),

        SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 450),
          child:ListView.builder(
            itemCount: displayApps.length,
            itemBuilder: (context, index) {
              final app = displayApps[index];


              return ListTile(
                leading: app.icon != null
                    ? Image.memory(
                  app.icon!,
                  width: 32,
                  gaplessPlayback: true,
                  cacheWidth: 64,
                )
                    : const Icon(Icons.apps),
                title: Text(app.name),
                subtitle: Text(app.packageName),
                trailing: CheckAppButton(app: app) ,
              );
            },
          )
        ),

        SizedBox(height: 20),

        AppListSaveButton()
      ],
    ) : Center(child: CircularProgressIndicator(),);
  }
}
