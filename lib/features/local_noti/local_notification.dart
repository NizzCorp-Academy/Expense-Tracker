import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showRepeatingNotification() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'repeating_channel_id', // Unique channel ID
    'Repeating Notifications', // Channel name
    channelDescription: 'Notification shown every interval',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin.periodicallyShow(
    0, // Notification ID
    'Reminder', // Title
    'This is a repeating notification', // Body
    RepeatInterval.everyMinute, // Other options: hourly, daily, weekly
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Ensures delivery during Doze
  );
}


Future<void> scheduleDailyExpenseNotification(int amount) async {
  final androidDetails = AndroidNotificationDetails(
    'daily_expense_channel',
    'Daily Expense Summary',
    channelDescription: 'Daily summary of your expenses',
    importance: Importance.max,
    priority: Priority.high,
  );

  final notificationDetails = NotificationDetails(android: androidDetails);

  final now = tz.TZDateTime.now(tz.local);
  final scheduleTime = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    20, // 8 PM
  );

  final adjustedTime =
      scheduleTime.isBefore(now) ? scheduleTime.add(const Duration(days: 1)) : scheduleTime;

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Daily Expense Summary',
    'You spent ₹$amount today.',
    adjustedTime,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exact,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}