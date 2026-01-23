import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

Future<List<AppInfo>> getInstalledApps() async {
  return await InstalledApps.getInstalledApps(
    withIcon: true,
    excludeSystemApps: false,
  );
}