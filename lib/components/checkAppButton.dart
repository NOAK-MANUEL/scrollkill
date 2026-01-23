import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:provider/provider.dart';
import 'package:scrollkill/states/settingState.dart';

class CheckAppButton extends StatefulWidget {
  const CheckAppButton({super.key, required this.app});

  final AppInfo app;

  @override
  State<CheckAppButton> createState() => _CheckAppButtonState();
}

class _CheckAppButtonState extends State<CheckAppButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppMonitoredProvider>().getMonitoringApps();
    });
  }
  @override
  Widget build(BuildContext context) {
    final isChecked = context.select<AppMonitoredProvider, bool>(
      (p) => p.appsMonitored.any((e) => e.packageName == widget.app.packageName),
    );
    final provider = context.read<AppMonitoredProvider>();
    return isChecked
        ? IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              provider.removeMonitoringApp(widget.app.packageName);
            },
            icon: Icon(Icons.lock),
          )
        : IconButton(
            onPressed: () {
              provider.addMonitoringApp(widget.app.packageName);
            },
            icon: Icon(Icons.lock_open),
          );
  }
}
