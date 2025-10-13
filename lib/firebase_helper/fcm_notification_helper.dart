import 'package:firebase_messaging/firebase_messaging.dart';

class FcmNotificationHelper {
  FcmNotificationHelper._();
  static final FcmNotificationHelper fcmNotificationHelper =  FcmNotificationHelper._();
  static final instance = FcmNotificationHelper._internal();
  FcmNotificationHelper._internal();
  Future<void>  requestNotificationPermissions()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
       alert: true,
       badge: true,
       sound: true,
      );
    print('Permission: ${settings.authorizationStatus}');
  }


  Future<void> initFcm()async{

   final fcmToken = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $fcmToken');
  }
}