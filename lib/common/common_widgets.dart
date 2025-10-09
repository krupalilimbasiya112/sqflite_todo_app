import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonWidgets {

  // ========================================All Common Buttons==================================
  static Widget commonButtons({required String name,GestureTapCallback? onTap, double? height, double? width, EdgeInsetsGeometry? padding, BorderRadius? radius,double? fontSize, Color? color, Color? boxColor, required Widget widget, double? sizedBoxWidth, Border? border, FontWeight? fontWeight,List<BoxShadow>? boxShadow}){
    return GestureDetector(
     onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.only(left: 10.r,right: 10.r),
        height: height,
        width: width,
        decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.all(Radius.circular(3.r)),
          border: border,
          boxShadow: boxShadow ?? [],
        ),
        child: Center(
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget,
                SizedBox(width: sizedBoxWidth,),
                Text(name, style: GoogleFonts.nunitoSans(textStyle: TextStyle(fontSize: fontSize ,color: color,fontWeight: fontWeight)))
              ]
            )
        ),
      ),
    );
  }

  // ===================================== All Common text====================================
  static Widget commonText({required String name, double? fontSize, Color? color, FontWeight? fontWeight,int? maxLines, TextOverflow? overflow, TextDecoration? textDecoration, Color? decorationColor}){
    return Text(
      name,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.nunitoSans(textStyle: TextStyle(fontSize: fontSize,color: color,fontWeight: fontWeight,decoration: textDecoration,decorationColor: decorationColor)),);
  }

  // ========================================All Common Icons==================================
  static Widget commonIcons({GestureTapCallback? onTap, IconData? icon, Color? color, double? size}){
    return InkWell(
      onTap: onTap,
      child: Icon(icon,color: color,size: size,),
    );
  }

  // ========================================All Common IconButton==================================
  static Widget commonIconButton({required GestureTapCallback onPressed, IconData? icon, Color? color, double? size}){
    return IconButton(
      splashColor: Colors.transparent,
      onPressed: onPressed,
      icon: Icon(icon,color: color,size: size,),
    );
  }

  static Widget commonDrawerListTile(
      {IconData? icon, required String text, Color? color, double? fontSize, double? iconSize ,FontWeight? fontWeight, GestureTapCallback? onTap}){
    return  GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon,size: iconSize,),
          SizedBox(width: 5,),
          CommonWidgets.commonText(name: text, fontSize: fontSize,fontWeight: fontWeight),
        ],
      ),
    );
  }

}