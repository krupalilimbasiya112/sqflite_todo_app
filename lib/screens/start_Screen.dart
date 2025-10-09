import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite_login_app/common/common_widgets.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 160.r,
                      backgroundImage: AssetImage("assets/images/bank.jpg"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.r),
                      child: CommonWidgets.commonText(name: "Dhanlab",fontSize: 27.sp,fontWeight: FontWeight.w700,color: Color(0xff00224B)),
                    ),
                    CommonWidgets.commonText(name: "Your personal finance educator",color: Color(0xff00224B),fontSize: 18.5.sp,fontWeight:  FontWeight.w700),
                    SizedBox(height: 50.h,),
                    CommonWidgets.commonButtons(
                        name: "Get Started",
                        widget: Container(),
                        boxColor: Color(0xff00224B),
                        height: 42.h,
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        onTap: (){
                          Navigator.pushNamed(context, 'sign_up_screen');
                      }
                    )
                  ],
                ),
              ),
            ),
          ),

        ),
      ),
    );
  }
}
