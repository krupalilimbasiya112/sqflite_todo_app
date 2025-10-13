import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class LocalNotificationHelper {
  LocalNotificationHelper._();

  static final LocalNotificationHelper localNotificationHelper = LocalNotificationHelper._();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications()async{
    // await configureLocalTimeZone();
    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("mipmap/ic_launcher");

    DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iOSInitializationSettings
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showSimpleNotification({
    required String id,
    required String title,
  })async{

    await initLocalNotifications();
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(id, title,priority: Priority.max,importance: Importance.max);

    DarwinNotificationDetails darwinInitializationSettings = DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinInitializationSettings,
    );

    flutterLocalNotificationsPlugin.show(
        0,
        id,
        title,
        notificationDetails,
        payload: 'Default_Sound'
    );
  }
  Future<dynamic> scheduleNotification(String title, String body , int hour, int minute) async {
    await initLocalNotifications();
    tz.TZDateTime nowTime = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, nowTime.year, nowTime.month, nowTime.day, hour, minute);
   flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        title,
        body,
        scheduleDate,
        NotificationDetails(android: AndroidNotificationDetails("11", title,priority: Priority.max,importance: Importance.max)),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time
    );

    print("Scheduled notification for at $hour:$minute");
  }
  // Future<void> scheduleNotification(String title, String body, DateTime scheduleDate)async{
  //   flutterLocalNotificationsPlugin.zonedSchedule(
  //       1,
  //       title,
  //       body,
  //       tz.TZDateTime.from(scheduleDate, tz.local),
  //       NotificationDetails(android: AndroidNotificationDetails("channel Id", "channel Name",priority: Priority.high,importance: Importance.high),iOS: DarwinNotificationDetails()),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //       matchDateTimeComponents: DateTimeComponents.time,
  //   );
  // }


  convertTimeZone(int hour, int minutes) async{
    tz.TZDateTime nowTime = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, nowTime.year, nowTime.month, nowTime.day, hour, minutes);

    if(scheduleDate.isBefore(nowTime)){
      scheduleDate = scheduleDate.add(Duration(minutes: 1));
    }
    return scheduleDate;
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final TimezoneInfo currentTimeZoneInfo = await FlutterTimezone.getLocalTimezone();
    final String currentTimeZone = currentTimeZoneInfo.identifier;
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    print("currentTimeZone: $currentTimeZone (location name: ${currentTimeZoneInfo.localizedName})");
  }

    Future<void> cancelNotification(int id) async {
      await flutterLocalNotificationsPlugin.cancel(id);
    }
  }