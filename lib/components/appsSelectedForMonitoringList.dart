import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:provider/provider.dart';
import 'package:scrollkill/components/contentCard.dart';
import 'package:scrollkill/models/monitoringApp.dart';
import 'package:scrollkill/states/settingState.dart';

class AppsSelectedForMonitoringList extends StatefulWidget {
  const AppsSelectedForMonitoringList({super.key, required this.app});
  final MonitoringApp app;



  @override
  State<AppsSelectedForMonitoringList> createState() =>
      _AppsSelectedForMonitoringListState();
}

class _AppsSelectedForMonitoringListState
    extends State<AppsSelectedForMonitoringList> {
   TextEditingController? scrollController;
  TextEditingController? restController;
  TextEditingController? screenController;






  @override
  void dispose() {
    scrollController?.dispose();
    restController?.dispose();
    screenController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentApp = widget.app;

    scrollController = TextEditingController(text: currentApp.scrollCounts.toString());
    restController = TextEditingController(text: currentApp.restTime.toString());
    screenController = TextEditingController(text:currentApp.screenLimit.toString());
    final trackScreen =
    context.select<SettingProvider, bool>((p) => p.trackScreen);

    final provider = context.read<AppMonitoredProvider>();

    final installedApp =
    context.select<SettingProvider, AppInfo>(
          (p) => p.apps.singleWhere(
            (app) => app.packageName == currentApp.packageName,
      ),
    );


    return installedApp == null ? SizedBox.shrink(): Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          contentCard(
            ListTile(
              leading: installedApp.icon != null
                  ? Image.memory(installedApp.icon!, width: 28)
                  : const Icon(Icons.apps),
              title: Text(installedApp.name,
                  style: const TextStyle(fontSize: 18)),
              trailing: Switch(
                value: currentApp.focusMode,
                onChanged: (value) {
                  provider.editMonitoringApp(
                    currentApp.id,
                    "focusMode",
                    value,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value ? "Focus Mode Activated": "Focus Mode Deactivated")));
                },
              ),
            ),

          ),


          contentCard(
              Column(
                children: [
                  settingRow(
                    icon: Icons.swipe,
                    label: "Scroll",
                    child: numberField(scrollController!),
                  ),

                  settingRow(
                    icon: Icons.coffee,
                    label: "Rest",
                    child: numberField(restController!),
                  ),

                  settingRow(
                    icon: Icons.schedule,
                    label: "Interval",
                    child: Container(
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1,color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Intervals>(
                          value: context.select<SettingProvider, Intervals>(
                                  (p) => p.defaultInterval),
                          items: const [
                            DropdownMenuItem(value: Intervals.hourly, child: Text("Hourly")),
                            DropdownMenuItem(value: Intervals.daily, child: Text("Daily")),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            provider.editMonitoringApp(currentApp.id, "interval", value);
                          },
                        ),
                      ),
                    ),
                  ),

                  if (trackScreen)
                    settingRow(
                      icon: Icons.phone_android,
                      label: "Screen Time",
                      child: numberField(screenController!),
                    ),
                ],
              )
          ),
        ],
      ),
    );
  }

  }

Widget settingRow({
  required IconData icon,
  required String label,
  required Widget child,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Icon(icon,),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const Spacer(),
        child,
      ],
    ),
  );
}
