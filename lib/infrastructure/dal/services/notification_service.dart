// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

enum NotificationType { show, zonedSchedule }

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationService {
  static Future<void> init() async {
    bool? isPermissionGranted = false;
    if (Platform.isAndroid) {
      isPermissionGranted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
    if (Platform.isIOS) {
      isPermissionGranted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    if (isPermissionGranted == true) {
      var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
          debugPrint('DarwinInitializationSettings onDidReceiveLocalNotification: $payload');
        },
      );
      var initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: notificationReceive,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
    } else {
      await init();
    }
  }

  static Future<void> showNotification(
      {NotificationType? type,
      required int notifId,
      String? title,
      String? body,
      tz.TZDateTime? datetimeForSchedule,
      String? payload}) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      icon: '@mipmap/ic_launcher',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    switch (type) {
      case NotificationType.show:
        await flutterLocalNotificationsPlugin.show(notifId, title, body, notificationDetails, payload: payload);
        break;
      // case NotificationType.zonedSchedule:
      //   break;
      default:
        await flutterLocalNotificationsPlugin.zonedSchedule(
          notifId,
          title,
          body,
          datetimeForSchedule ?? tz.TZDateTime.now(tz.local),
          notificationDetails,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          payload: payload,
        );
    }
  }

  static Future<bool> isThisNotificationExist(int notifId) async {
    List<PendingNotificationRequest> notifPendings =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return notifPendings.where((element) => element.id == notifId).isNotEmpty;
  }

  static Future<List<PendingNotificationRequest>> notifPendings() =>
      flutterLocalNotificationsPlugin.pendingNotificationRequests();

  static Future<List<ActiveNotification>> notificationActive() =>
      flutterLocalNotificationsPlugin.getActiveNotifications();

  static Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails() =>
      flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  static Future<void> turnOffNotification(int notifId) => flutterLocalNotificationsPlugin.cancel(notifId);

  static Future<void> turnOffAllNotification() => flutterLocalNotificationsPlugin.cancelAll();
}

/// will triggered when notification action is clicked on background
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  debugPrint('wkwkwkwkwkwkwk');
}

void notificationReceive(NotificationResponse notificationResponse) {
  debugPrint('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.payload != null) {}
}
