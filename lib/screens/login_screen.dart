import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite_login_app/common/common_widgets.dart';
import 'package:sqflite_login_app/common/input.dart';
import 'package:sqflite_login_app/database/database_helper.dart';
import 'package:sqflite_login_app/modal/data_modal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = false;
  bool isLoggedIn = false;
  GlobalKey<FormState> key = GlobalKey();

  //-------------------login user method---------------------
  void loginUser() async {
    DataModal dataModal = DataModal(email: emailController.text, password: passwordController.text);
   // var response = await DatabaseHelper.databaseHelper.loginUser(dataModal);
    var response = DatabaseHelper.databaseHelper.loginUser(dataModal);
   print("response : ${response}");
   if(response != null){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: CommonWidgets.commonText(name: "Login successfully...", fontWeight: FontWeight.w600,color: Colors.white),backgroundColor: Color(0xff00224B),));
     Navigator.pushNamed(context, 'home_screen',arguments: {'email': emailController.text, 'password': passwordController.text});
   }else{
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: CommonWidgets.commonText(name: "Invalid password or credentials...", fontWeight: FontWeight.w600,color: Colors.white)));

    // if(response == true){
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: CommonWidgets.commonText(name: "Login successfully...", fontWeight: FontWeight.w600,color: Colors.white)));
    // }else{
    //   setState(() {
    //     isLoggedIn = true;
    //   });
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: CommonWidgets.commonText(name: "Invalid password or credentials...", fontWeight: FontWeight.w600,color: Colors.white)));
    }
    emailController.clear();
    passwordController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //---------------bank image---------------------
                CircleAvatar(
                  radius: 160.r,
                  backgroundImage: AssetImage("assets/images/bank.jpg"),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15.r,right: 15.r),
                  padding: EdgeInsets.only(top: 20.r, bottom: 20.r,left: 15.r,right: 15.r),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.r),),
                      boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 5, spreadRadius: 0,)]
                  ),
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        //----------------- login user text-------------------
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.r),
                          child: CommonWidgets.commonText(name: "Welcome back!",fontSize: 19.sp,fontWeight: FontWeight.w700,color: Color(0xff00224B)),
                        ),
                        CommonWidgets.commonText(name: "login to your existing account",color: Colors.black.withOpacity(0.5),fontSize: 14.sp,fontWeight:  FontWeight.w700),
                        SizedBox(height: 18.h,),
                        //-------------------email filed-----------------------
                        CommonInputField(
                          controller: emailController,
                          hintText: "Enter email",
                          prefixIcon: CommonWidgets.commonIcons(icon: Icons.email_outlined,color: Color(0xff00224B),size: 23.h),
                          validator: (val){
                            if(val!.isEmpty || !val.contains('@')){
                              return "please enter a valid email...";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.h,),
                        //----------------------password filed---------------------
                        CommonInputField(
                          controller: passwordController,
                          hintText: "Enter password",
                          obscureText: !isVisible,
                          prefixIcon: CommonWidgets.commonIcons(icon: Icons.lock_open_sharp,color: Color(0xff00224B),size: 23.h),
                          suffixIcon: CommonWidgets.commonIcons(icon: isVisible ? Icons.visibility : Icons.visibility_off ,color: Color(0xff00224B),size: 23.h),
                          validator: (val){
                            if(val!.isEmpty || val.length < 6){
                              return "please enter valid password...";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 40.h,),
                        //-----------------login button------------------------------
                        CommonWidgets.commonButtons(
                          name: "Login",
                          widget: Container(),
                          boxColor: Color(0xff00224B),
                          height: 43.h,
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          onTap: (){
                            if(key.currentState!.validate()){
                              loginUser();

                            }
                          },
                        ),
                        SizedBox(height: 12.h,),
                        //---------------------------sign up text-----------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonWidgets.commonText(name: "Don't have an account? ",color: Color(0xff00224B),fontSize: 14.sp,fontWeight: FontWeight.w700),
                            GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, 'sign_up_screen');
                                },
                                child: CommonWidgets.commonText(name: "Sign up",color: Color(0xff00224B),fontSize: 14.sp,fontWeight:  FontWeight.w700,textDecoration: TextDecoration.underline,decorationColor: Color(0xff00224B))),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

        ),
      ),
    );
  }
}
