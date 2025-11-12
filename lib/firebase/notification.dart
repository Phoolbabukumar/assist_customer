import 'package:assist/apis/base_client.dart';
import 'package:assist/app_constants/app_colors.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../utils/common_functions.dart';

class FirebaseNotification {
  var tag = "FirebaseNotification";
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', //id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true,
  );

  var iOSPlatformChannelSpecifics = const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  //

  void configLocalNotification() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: iOSPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  getFCMToken() async {
    configLocalNotification();
    final fcmToken = await firebaseMessaging.getToken();
    printMessage(tag, 'fcmToken$fcmToken');
    //Firebase local notification plugin
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.initialize(iOSPlatformChannelSpecifics);

    saveFCMToken(fcmToken);
  }

  listenMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("msffffff===");
      debugPrint(message.notification?.title);
      debugPrint(message.notification?.body);
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      AppleNotification? appleNotificationIos = message.notification?.apple;

      printMessage(tag, 'Notification Received$notification');
      //1578989c7cf565ada82e5faf578035
      if (notification != null) {
        if (androidNotification != null) {
          debugPrint(notification.title);
          debugPrint(notification.body);
          try {
            flutterLocalNotificationsPlugin
                .show(
                    notification.hashCode,
                    notification.title,
                    notification.body,
                    NotificationDetails(
                      android: AndroidNotificationDetails(
                          channel.id, channel.name,
                          color: blueColor,
                          playSound: true,
                          priority: Priority.high),
                      // iOS: DarwinNotificationDetails()
                    ))
                .onError((error, stackTrace) {
              debugPrint("error ==$error");
              debugPrint("stacktrace ==$stackTrace");
            });
          } catch (e, s) {
            debugPrint(e as String?);
            debugPrint(s as String?);
          }
        }
        if (appleNotificationIos != null) {
          debugPrint("Apple msg show");
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                  /*android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    color: Colors.blue,
                    playSound: true,
                  ),*/
                  iOS: DarwinNotificationDetails(
                presentBadge: true,
                subtitle: notification.title,
              )));
        }
      }
    });
  }

  Future<void> saveFCMToken(String? fcmToken) async {
    var userPhone = global.customerPhoneNumber.toString();
    var userId = global.userId.toString();

    printMessage(tag, 'userPhone..$userPhone $userId');
    BaseClient.get(
            "UID=$userId"
                "&Phone=$userPhone"
                "&FCMToken=$fcmToken",
            "SaveFCMToken")
        .then((value) {
      Get.back();
      printMessage(tag, 'value$value');
    });
  }
}
