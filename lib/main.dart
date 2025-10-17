import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_login_app/database/database_helper.dart';
import 'package:sqflite_login_app/firebase_helper/fcm_notification_helper.dart';
import 'package:sqflite_login_app/firebase_options.dart';
import 'package:sqflite_login_app/screens/create_new_list.dart';
import 'package:sqflite_login_app/screens/home_screen.dart';
import 'package:sqflite_login_app/screens/login_screen.dart';
import 'package:sqflite_login_app/screens/sign_up_screen.dart';
import 'package:sqflite_login_app/screens/start_Screen.dart';
import 'firebase_helper/local_notification_helper.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'modal/task_modal.dart';

void main()async{
   WidgetsFlutterBinding.ensureInitialized();
   await Hive.initFlutter();
   Hive.registerAdapter(TaskModalAdapter());
   final document = await getApplicationDocumentsDirectory();
   await Hive.initFlutter(document.path);
  await LocalNotificationHelper.localNotificationHelper.initLocalNotifications();
  tz.initializeTimeZones();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmNotificationHelper.fcmNotificationHelper.requestNotificationPermissions();
  await FcmNotificationHelper.fcmNotificationHelper.initFcm();

  // TaskModal taskModal = TaskModal();
  // DateTime date = DateFormat.Hm().parse(taskModal.startTime.toString());
  // final myTime = DateFormat("HH:mm").format(date);
  FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
    final title = remoteMessage.notification?.title ?? "No Title";
    final rawBody = remoteMessage.notification?.body ?? "No Body";

    LocalNotificationHelper.localNotificationHelper.showSimpleNotification(
      id: title,
      title: rawBody,
    //  LocalNotificationHelper.localNotificationHelper.scheduleNotification(title, rawBody, 13, 04
    );

    // LocalNotificationHelper.localNotificationHelper.scheduleNotification(
    //     int.parse(myTime.toString().split(":")[0]),
    //     int.parse(myTime.toString().split(":")[1]),
    //     taskModal);

  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isLoggedIn;

  void checkUserLogin()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
   bool loginUser =  preferences.getBool("isLoggedIn") ?? false;

   setState(() {
     isLoggedIn = loginUser;
   });
  }

  @override
  void initState() {

    super.initState();
    initDatabase();
    checkUserLogin();

  }

  void initDatabase() async{
    await DatabaseHelper.databaseHelper.initDB();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 802),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          // '/': (context) => SplashScreen(),
          'start_screen': (context) => StartScreen(),
          'sign_up_screen': (context) => SignUpScreen(),
          'login_screen': (context) => LoginScreen(),
          'home_screen': (context) => HomeScreen(),
          'create_new_list': (context) => CreateNewList()
        },
        home: HomeScreen(),
          // home: isLoggedIn == null
          //     ? SafeArea(child: const Scaffold(body: Center(child: CircularProgressIndicator())))
          //     : (isLoggedIn! ? HomeScreen() : LoginScreen())

      ),
    );
  }
}
