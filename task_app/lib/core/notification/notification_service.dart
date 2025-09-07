import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzData.initializeTimeZones(); //timezoneの初期化

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
    // await _requestPermissions();
  }

  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local), // 必ずtzで包む
      const NotificationDetails(
        android: AndroidNotificationDetails('main_channel', 'Main Channel'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode:
          AndroidScheduleMode.inexact, //通知時刻はアバウトで省電力アイドリングモードでは動作しない
      matchDateTimeComponents: DateTimeComponents.time, // 毎日同じ時刻にも可能
    );
  }

  // ここから

  Future<void> scheduleDaily({
    required int id, // 通知ID (ユニーク)
    required String title,
    required String body,
    required TimeOfDay time, // Flutter の TimeOfDay を渡すと使いやすい
    String? payload,
  }) async {
    final scheduled = _nextInstanceOfTime(time.hour, time.minute);

    // 通知の見た目/振る舞い定義
    const androidDetails = AndroidNotificationDetails(
      'daily_channel_id', // チャンネルID（Android）
      'Daily Notifications', // チャンネル名
      channelDescription: 'Daily notification channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 毎日同じ時刻に繰り返す
      payload: payload,
    );
  }

  // 次に来る指定時刻（ローカルタイム）を返す
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now) || scheduled.isAtSameMomentAs(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  Future<void> cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> pending() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  //
}
