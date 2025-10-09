import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_login_app/database/database_helper.dart';
import 'package:sqflite_login_app/screens/create_new_list.dart';
import 'package:sqflite_login_app/screens/home_screen.dart';
import 'package:sqflite_login_app/screens/login_screen.dart';
import 'package:sqflite_login_app/screens/sign_up_screen.dart';
import 'package:sqflite_login_app/screens/splash_screen.dart';
import 'package:sqflite_login_app/screens/start_Screen.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper.databaseHelper.initDB();
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
