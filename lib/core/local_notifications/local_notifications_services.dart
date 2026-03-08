import 'dart:async';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationsServices {
  static final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int _notificationId = 100;

  static const List<String> chatbotHelperMessage = [
    "Understand your ECG in a simple and clear way.",
    "Get easy tips to improve your heart health.",
    "Learn how stress, rest, and activity affect your heart rate.",
    "Discover small daily habits that help you feel better.",
    "Stay hydrated — drink 8 glasses of water daily for steady heart rhythms.",
    "Walk 30 minutes every day to strengthen your heart and improve ECG readings.",
    "Eat more heart-friendly foods: leafy greens, nuts, berries & fatty fish.",
    "Practice 5-minute deep breathing to lower stress and calm your heart rate.",
    "Sleep 7–9 hours every night — good rest gives you a cleaner ECG.",
    "Cut down on salt and processed foods to keep your blood pressure healthy.",
    "Track your ECG regularly so you can see your progress over time.",
    "Maintain a healthy weight — even losing 5 kg makes a big difference to your heart.",
  ];

  // Initialize notifications
  static Future<void> init() async {
    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Create Android channel
    const AndroidNotificationChannel channel =
        AndroidNotificationChannel(
      'hydration_channel',
      'Hydration Reminders',
      description: 'Daily heart care reminders at 10 AM',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Permission check
  static Future<bool> _requestPermission() async {
    final androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted =
        await androidImplementation?.requestNotificationsPermission();

    return granted ?? false;
  }

  static Future<void> _requestExactAlarmPermission() async {
    final androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestExactAlarmsPermission();
  }

  // Cancel all notifications
  static Future<void> cancelNotifications() async {
    await flutterLocalNotificationsPlugin.cancel(_notificationId);
  }

  // Get random message
  static String _getRandomMessage() {
    final random = Random();
    return chatbotHelperMessage[
        random.nextInt(chatbotHelperMessage.length)];
  }

  // Show notification now and then daily at 10 AM
  static Future<void> showNotificationFirstThenDaily10AM() async {
    final bool granted = await _requestPermission();
    if (!granted) return;

    await _requestExactAlarmPermission();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'hydration_channel',
      'Hydration Reminders',
      channelDescription: 'Daily heart care reminders at 10 AM',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      _notificationId,
      "Heart Care Reminder ❤️",
      _getRandomMessage(),
      details,
    );
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime daily10AM =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);

    if (daily10AM.isBefore(now)) {
      daily10AM = daily10AM.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      _notificationId,
      "Heart Care Reminder ❤️",
      _getRandomMessage(),
      daily10AM,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // repeats daily
    );
  }
}