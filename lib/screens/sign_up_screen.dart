import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite_login_app/common/common_widgets.dart';
import 'package:sqflite_login_app/common/input.dart';
import 'package:sqflite_login_app/database/database_helper.dart';
import 'package:sqflite_login_app/modal/data_modal.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = false;

  //-------------sign up user method-----------------
  void signUpUsers()async{
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    DataModal dataModal = DataModal(email: email, password: password, name: name);

    await DatabaseHelper.databaseHelper.signUpUser(dataModal);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: CommonWidgets.commonText(name: "Sign up successFully",color: Colors.white,fontWeight: FontWeight.w600),backgroundColor: Color(0xff00224B)));
    Navigator.pushNamed(context, 'home_screen',arguments: {'name': name, 'email': email, 'password': password});

    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                //------------------bank image------------------
                CircleAvatar(
                  radius: 160.r,
                  backgroundImage: AssetImage("assets/images/bank.jpg"),
                ),
                //-------------white sign up card----------------------
                Container(
                  margin: EdgeInsets.only(left: 15.r,right: 15.r),
                  padding: EdgeInsets.only(top: 20.r, bottom: 20.r,left: 15.r,right: 15.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.r),),
                    boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, 2), blurRadius: 5, spreadRadius: 0,)]
                  ),
                  child: Column(
                    children: [
                      //-----------------new account text-----------------------
                      Padding(
                        padding: EdgeInsets.only(bottom: 3.r),
                        child: CommonWidgets.commonText(name: "Let's Get Started",fontSize: 19.sp,fontWeight: FontWeight.w700,color: Color(0xff00224B)),
                      ),
                      CommonWidgets.commonText(name: "Create new account",color: Colors.black.withOpacity(0.5),fontSize: 14.sp,fontWeight:  FontWeight.w700),
                      SizedBox(height: 18.h,),
                      //--------------name filed--------------------
                      CommonInputField(
                        controller: nameController,
                        hintText: "Enter name",
                        prefixIcon: CommonWidgets.commonIcons(icon: Icons.person_outline_sharp,color: Color(0xff00224B)),
                        validator: (val){
                          if(val!.isEmpty){
                            return "please enter first name...";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h,),
                      //-----------------email filed------------------
                      CommonInputField(
                        controller: emailController,
                        hintText: "Enter email",
                        prefixIcon: CommonWidgets.commonIcons(icon: Icons.email_outlined,color: Color(0xff00224B),size: 23.h),
                        validator: (val){
                          if(val!.isEmpty || val.contains('@')){
                            return "please enter a valid email...";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15.h,),
                      //-----------------password filed----------------
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
                      //----------------sign up button------------------
                      CommonWidgets.commonButtons(
                        name: "Sign up",
                        widget: Container(),
                        boxColor: Color(0xff00224B),
                        height: 45.h,
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        onTap: signUpUsers
                      ),
                      SizedBox(height: 12.h,),
                      //-----------------already login text--------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonWidgets.commonText(name: "Already have an account? ",color: Color(0xff00224B),fontSize: 14.sp,fontWeight:  FontWeight.w700),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, 'login_screen');
                            },
                              child: CommonWidgets.commonText(name: "Sign in",color: Color(0xff00224B),fontSize: 14.sp,fontWeight:  FontWeight.w700,textDecoration: TextDecoration.underline,decorationColor: Color(0xff00224B))),
                        ],
                      )
                    ],
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
