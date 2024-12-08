import 'package:flutter/material.dart';

// dark theme data file
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: const Color(0xFF121212), // Dark grey background instead of pure black
    secondary: const Color(0xFF1F1F1F), // Slightly lighter dark grey for contrast
    tertiary: const Color(0xFF427CFF), // Keeping the same tertiary color
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  shadowColor: Colors.grey[700]!.withOpacity(.2),
  appBarTheme:  AppBarTheme(
    backgroundColor: Color(0xFF121212), // Matching the primary color
    shadowColor: Color.fromARGB(255, 49, 49, 49).withOpacity(.4),
  ),
  bottomAppBarTheme:  BottomAppBarTheme(
    color: Color(0xFF121212), // Matching the primary color
    shadowColor: Colors.black.withOpacity(.4),
  ),
  bottomSheetTheme:  BottomSheetThemeData(
    backgroundColor: Color(0xFF121212), // Matching the primary color
    shadowColor: Colors.black.withOpacity(.4),
  ),
  drawerTheme:  DrawerThemeData(
    backgroundColor: Color(0xFF121212), // Matching the primary color
    shadowColor: Colors.black.withOpacity(.4),
    scrimColor: Colors.black.withOpacity(.2),
    elevation: 5,
  ),
  datePickerTheme: DatePickerThemeData(
    // Add specific customization if needed
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.withOpacity(.4),
  ),
  // Set the global cursor color
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white, // Change this to your desired color
  ),
  cardColor: Colors.black,
  navigationBarTheme: NavigationBarThemeData(
    shadowColor: Colors.grey[500]?.withOpacity(0.25)
  )
);
