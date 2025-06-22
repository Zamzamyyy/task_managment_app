import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
const Color pinkClr = Color(0xFF9F44D3);  // Vibrant purple
const Color yellowClr = Color(0xFF00F0FF);    // Electric cyan
const Color bluishClr = Color(0xFFFF2E88);     // Bright hot pink

// const Color bluishClr = Color(0xFF4e5ae8);
// const Color yellowClr = Color(0xFFFFB746);
// const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
Color darkHeaderClr = Color(0xFF424242);

class Themes{
  static final light = ThemeData(
    // appbar colour
    appBarTheme: AppBarTheme(
      backgroundColor: primaryClr,
    ),
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    // appbar colour
      appBarTheme: AppBarTheme(
          backgroundColor: darkGreyClr
      ),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkHeaderClr
  );
}
TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode?Colors.grey[400]:Colors.grey,



      )
  );
}
TextStyle get titleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Get.isDarkMode?Colors.grey[400]:Colors.black,

      )
  );
}
TextStyle get subTitleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Get.isDarkMode?Colors.grey[100]:Colors.grey[600],

      )
  );
}
TextStyle get headingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Get.isDarkMode?Colors.white:Colors.black,
      )
  );
}