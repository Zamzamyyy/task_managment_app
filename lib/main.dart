import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_managment_app/screens/home_screen.dart';
import 'package:task_managment_app/themes/notifications.dart';
import 'package:task_managment_app/themes/theme_toggle.dart';

import 'db/db_Helper.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.initDb();
  await GetStorage.init();

  final notifyHelper = NotifyHelper();
  await notifyHelper.initializeNotification();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final ThemeServices _themeServices = ThemeServices();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Use GetMaterialApp, not MaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Theme Switcher',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeServices.theme, // Use stored theme
      home: HomePage(),
    );
  }
}
