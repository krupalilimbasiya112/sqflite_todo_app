import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this,duration: Duration(seconds: 10));

    animation = CurvedAnimation(parent: animationController, curve: Curves.linear);
    animationController.repeat();

    Timer(Duration(seconds: 10), () {
      Navigator.pushNamed(context, 'start_screen');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding:  EdgeInsets.only(left: 12.r,right: 12.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                RotationTransition(
                  turns: animation,
                  child: CircleAvatar(
                    radius: 160.r,
                    backgroundImage: AssetImage("assets/images/bank_logo.jpg"),
                  ),
                ),
                ],
              ),
            ),
          ),

        ),
      ),
    );
  }
}
