import 'dart:async';
import 'package:assist/Network/network_binding.dart';
import 'package:assist/app_constants/app_colors.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/firebase/notification.dart';
import 'package:assist/ui/splash_screen.dart';
import 'package:assist/utils/common_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'package:timezone/data/latest.dart' as tzdata;
import 'app_constants/themes.dart';

// mobile notification k liye h tool h
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', //id
  'High Importance Notifications', // title
  importance: Importance.high,
  playSound: true,
);
// yeh background function h
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  AndroidNotification? androidNotification = message.notification?.android;

  if (notification != null && androidNotification != null) {
    printMessage("main.dart file",
        'Message also contained a notification: ${message.notification}');
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          color: blueColor,
          playSound: true,
        )));
  }
}

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // function ko inislize karta taki code run ho
  tzdata.initializeTimeZones();
  // startTokenRefreshTimer();
  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  // await Firebase.initializeApp();
  await GetStorage.init();

  //listen Foreground  message
  // FirebaseNotification().listenMessage(); // app open h to msg listen karta h

  //listen Background message
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: white12,
      statusBarBrightness: Brightness.dark));
  /*debugRepaintRainbowEnabled = true;
  debugPaintBaselinesEnabled = true; */ // these two lines are add in code to check app on debug mode and by help of this we can improve over app performance

  runApp(ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          // ye hteme and nagigation ko control karta h
          scrollBehavior: const ScrollBehavior(),
          debugShowCheckedModeBanner: false,
          initialBinding: NetworkBinding(),
          title: label247,
          home: SplashScreen(),
          theme: Themes.light,
          darkTheme: Themes.dark,
        );
      }));
}
