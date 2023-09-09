import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class local_notifs{
  final FlutterLocalNotificationsPlugin notificationsPlugin=FlutterLocalNotificationsPlugin();
  Future<void> initNotifications()async{
    AndroidInitializationSettings initializationSettingsAndroid= const AndroidInitializationSettings("images");
    // var initializationSettingIOS=DarwinInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    //   onDidReceiveLocalNotification: (int id,String? title,String? body,String? payload)async{}
    // );
    var initializationSettings=InitializationSettings(
      android:  initializationSettingsAndroid,
    );
    await notificationsPlugin.initialize(initializationSettings,
    onDidReceiveNotificationResponse:(NotificationResponse notificationResponse)async{

    }
    );
  }
  Future show_notifs({int id=0,String? title,String? body,String? payload}) async {
    return notificationsPlugin.show(id, title, body, await notificationDetails());

  }

  notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails("channelId", "channelName"),
    );
  }
}