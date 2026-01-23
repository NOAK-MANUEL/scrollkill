import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollkill/screens/homeScreen.dart';
import 'package:scrollkill/states/settingState.dart';
import 'package:scrollkill/theme/scrollKillTheme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create:(_)=> SettingProvider()),
      ChangeNotifierProvider(create:(_)=> AppMonitoredProvider()),
    ],
    child: MaterialApp(
      theme: ScrollKillTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: HomeScreen()),
    ),
  ));
}

