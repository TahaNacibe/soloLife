import 'package:flutter/material.dart';

// light theme data file 
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.white,
    secondary: const Color(0xFFF3F3F3),
    tertiary: const Color(0xFF427CFF),
  ),
  iconTheme:const IconThemeData(
    color:Colors.black,
  ),
  shadowColor: Colors.grey.withOpacity(.4),
  appBarTheme:AppBarTheme(
    backgroundColor: Colors.white,
    shadowColor: Colors.white.withOpacity(.4)
  ),
  bottomAppBarTheme:BottomAppBarTheme(
    color: Colors.white,
    shadowColor: Colors.grey.withOpacity(.4)
  ),
  bottomSheetTheme:BottomSheetThemeData(
    backgroundColor: Colors.white,
    shadowColor: Colors.grey.withOpacity(.4)
  ),
  drawerTheme:DrawerThemeData(
    backgroundColor: Colors.white,
    shadowColor: Colors.grey.withOpacity(.4),
    scrimColor:Colors.white.withOpacity(.2),
    elevation: 5,
  ),
  datePickerTheme: DatePickerThemeData(
    
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.withOpacity(.4),
  ),
   // Set the global cursor color
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white, // Change this to your desired color
  ),
);