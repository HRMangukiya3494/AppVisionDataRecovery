import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/model/PermissionService.dart';
import 'package:photo_recovery/views/routes/AppRoutes.dart';
import 'package:photo_recovery/views/utils/Prefrences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initPref();
  await PermissionService.checkAndRequestPermissions();
  final permissionStatus = await requestExternalStoragePermission();

  switch (permissionStatus) {
    case AppPermissionStatus.Granted:
      log('Permission granted');
      break;
    case AppPermissionStatus.Denied:
      log('Permission denied');
      break;
    case AppPermissionStatus.Restricted:
      log('Permission restricted');
      break;
    case AppPermissionStatus.PermanentlyDenied:
      log('Permission permanently denied');
      break;
    case AppPermissionStatus.Unknown:
      log('Unknown permission status');
      break;
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      const MyApp(),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppRoutes.routes,
    );
  }
}
