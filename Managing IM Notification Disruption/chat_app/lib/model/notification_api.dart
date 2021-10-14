// ignore_for_file: prefer_const_constructors

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

/**
 * CODE FROM: https://www.youtube.com/watch?v=bRy5dmts3X8 
 */

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future init({bool initScheduled = false}) async {
    final settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: IOSInitializationSettings(),
    );
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        //TODO change channel details and notification importance
        'channelId',
        'channelName',
        channelDescription: 'channelDescription',
        //importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }
}
