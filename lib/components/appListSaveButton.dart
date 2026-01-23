import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollkill/components/appsSelectedForMonitoring.dart';
import 'package:scrollkill/models/monitoringApp.dart';
import 'package:scrollkill/states/settingState.dart';

class AppListSaveButton extends StatelessWidget {
  const AppListSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    List<MonitoringApp> monitoringApps = context
        .watch<AppMonitoredProvider>()
        .appsMonitored;
    return  monitoringApps.isNotEmpty ? ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          useSafeArea: true,
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,

          context: context,
          builder: (ctx) => AppsSelectedForMonitoring(),
        );
      },
      child: Text("Set Scroll Limit"),
    ):SizedBox.shrink();
  }
}
