import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:provider/provider.dart';
import 'package:scrollkill/components/contentCard.dart';
import 'package:scrollkill/functions/getApps.dart';
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
    final trackScreen =
    context.select<SettingProvider, bool>((p) => p.trackScreen);

    final provider = context.read<AppMonitoredProvider>();
    final currentApp = widget.app;

    final installedApp =
    context.select<SettingProvider, AppInfo>(
          (p) => p.apps.singleWhere(
            (app) => app.packageName == currentApp.packageName,
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: installedApp.icon != null
                ? Image.memory(installedApp.icon!, width: 40)
                : const Icon(Icons.apps),
            title: Text(installedApp.name,
                style: const TextStyle(fontSize: 20)),
            trailing: Switch(
              value: currentApp.focusMode,
              onChanged: (value) {
                provider.editMonitoringApp(
                  currentApp.id,
                  "focusMode",
                  value,
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          contentCard(
            Column(
              children: [
                Row(
                  children: [
                    const Text("Scroll"),
                    const SizedBox(width: 10),
                    _numberField(scrollController!),
                    const SizedBox(width: 24),
                    const Text("Rest"),
                    const SizedBox(width: 10),
                    _numberField(restController!),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Text("Interval"),
                    const SizedBox(width: 10),
                    DropdownButton<Intervals>(
                      value: context.select<SettingProvider, Intervals>(
                              (p) => p.defaultInterval),
                      items: const [
                        DropdownMenuItem(
                          value: Intervals.hourly,
                          child: Text("hourly"),
                        ),
                        DropdownMenuItem(
                          value: Intervals.daily,
                          child: Text("daily"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        provider.editMonitoringApp(
                          currentApp.id,
                          "interval",
                          value,
                        );
                      },
                    ),

                    const Spacer(),

                    if (trackScreen) ...[
                      const Text("Screen Time"),
                      const SizedBox(width: 10),
                      _numberField(screenController!),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _numberField(TextEditingController controller) {
    return SizedBox(
      width: 100,
      height: 40,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          isDense: true,
        ),
        onChanged: (value) {
          // optional: sync back to model
        },
      ),
    );
  }
}
