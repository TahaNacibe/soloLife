import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: const Color(0xff424242),
    secondary: Colors.black,
    tertiary: const Color(0xFF427CFF),
    shadow: Colors.grey,
  ),
  iconTheme:const IconThemeData(
    color:Colors.white,
  ),
  shadowColor: Colors.grey,
  appBarTheme:const AppBarTheme(
    elevation: 0,
  ),
  bottomAppBarTheme:BottomAppBarTheme(
    color: const Color(0xff424242),
    shadowColor: Colors.black.withOpacity(.4)
  ),
  bottomSheetTheme:BottomSheetThemeData(
    backgroundColor: const Color(0x40cccccc),
    shadowColor: Colors.black.withOpacity(.4)
  ),
  drawerTheme:DrawerThemeData(
    backgroundColor: Colors.black.withOpacity(.5),
    shadowColor: Colors.black,
    scrimColor:Colors.black.withOpacity(.2),
    elevation: 5,
  ),
);