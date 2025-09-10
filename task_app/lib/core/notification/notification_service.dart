import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
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
        ?.requestNotificationsPermission(); //おそらくこれが純正のpermission許可

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

  // 通知ごとに送る通知
  Future<void> tasksSchedule({
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

  //毎日決まった時間に送信する通知
  Future<void> scheduleDaily({
    required int id, // 通知ID (ユニーク)
    required String title,
    required String body,
    required TimeOfDay time, // Flutter の TimeOfDay を渡すと使いやすい
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'scheduled title',
      'scheduled body',
      _scheduledDateAtHourMinute(0, 50), //ここを設定した値になるように代入する
      const NotificationDetails(
        android: AndroidNotificationDetails('main_channel', 'Main Channel'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode:
          AndroidScheduleMode
              .inexact, //permission許可の問題からalearmclock(SCHEDULE_EXACT_ALARMが必要)ではなくinexactにした //通知が正しく送られなかったら変える
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _scheduledDateAtHourMinute(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  void cancelTaskNotifi(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  tz.TZDateTime getTzTime(int year, int month, int day, int hour, int minute) {
    final ans = tz.TZDateTime(tz.local, year, month, day, hour, minute);
    return ans;
  }

  //
}
