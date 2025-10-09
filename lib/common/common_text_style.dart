import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class CommonTextStyle {
  static TextStyle textStyle({double? fontSize,FontWeight? fontWeight,TextDecoration? textDecoration, Color? color,int? maxLines, TextOverflow? overflow,}) {
    return GoogleFonts.nunitoSans(
      textStyle: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
          decoration: textDecoration,
      )
    );
  }


}