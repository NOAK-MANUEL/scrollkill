import 'dart:async';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';

class GetInstalledApps extends StatefulWidget {
  GetInstalledApps({
    super.key,
    required this.appList,
     this.appsNotAllowed,
    this.app

  });

  final List<AppInfo> appList;
  final List<String>? appsNotAllowed;
   String? app;

  @override
  State<GetInstalledApps> createState() => _GetInstalledAppsState();
}

class _GetInstalledAppsState extends State<GetInstalledApps> {
  List<AppInfo> filteredApps = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    filteredApps = _filterSystemApp(widget.appList);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  List<AppInfo> _filterSystemApp(List<AppInfo> apps) {
    return apps
        .where((app) => app.name.toLowerCase() != "scrollkill")
        .toList();
  }

  void _onSearch(String query) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      final normalized = query.toLowerCase().trim();

      setState(() {
        if (normalized.length < 2) {
          filteredApps = _filterSystemApp(widget.appList);
        } else {
          filteredApps = widget.appList
              .where((app) =>
          app.name.toLowerCase().trim().contains(normalized) &&
              app.name.toLowerCase() != "scrollkill")
              .toList();
        }
      });
    });
  }

  void _toggleApp(String packageName) {
    setState(() {
      if(widget.appsNotAllowed != null) {
        widget.appsNotAllowed!.contains(packageName)
            ? widget.appsNotAllowed!.remove(packageName)
            : widget.appsNotAllowed!.add(packageName);
      }else{
        widget.app = packageName;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: _onSearch,
          decoration: const InputDecoration(
            hintText: "Search apps",
            prefixIcon: Icon(Icons.search),
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: ListView.builder(
            itemCount: filteredApps.length,
            itemBuilder: (context, index) {
              final app = filteredApps[index];
              final isBlocked = widget.appsNotAllowed != null?
              widget.appsNotAllowed!.contains(app.packageName): widget.app == app.packageName;

              return ListTile(
                leading: app.icon != null
                    ? Image.memory(app.icon!, width: 32, height: 32)
                    : const Icon(Icons.apps),
                title: Text(app.name),
                trailing: IconButton(
                  icon: Icon(
                    isBlocked ? Icons.lock : Icons.lock_open,
                  ),
                  onPressed: () => _toggleApp(app.packageName),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
