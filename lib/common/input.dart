import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_login_app/common/colors.dart';
import 'package:sqflite_login_app/common/common_text_style.dart';

class CommonInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? textStyle;

  const CommonInputField({
    Key? key,
    this.controller,
    this.title,
    required this.hintText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;
    return Padding(
      padding: EdgeInsets.only(left: 14.r,right: 14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(title ?? '',style: textStyle ?? CommonTextStyle.textStyle(fontWeight: FontWeight.w700,fontSize: 16.sp,color: CommonColor.navyBlueColor) ),
          SizedBox(height: 6.h,),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: CommonColor.navyBlueColor),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(isPortrait ? 2.w : 2.w),),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), offset: Offset(0, 2), blurRadius: 8, spreadRadius: 0,),],
            ),
            child: TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              obscureText: obscureText,
              onChanged: onChanged,
              cursorHeight: isPortrait ? 20.h : 40.h,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: isPortrait ? 10.w : 6.w,),
                hintText: hintText,
                hintStyle: CommonTextStyle.textStyle(fontSize: 14.5.sp,fontWeight: FontWeight.w600,color: CommonColor.navyBlueColor),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(isPortrait ? 5.w : 3.w),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
