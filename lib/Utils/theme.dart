// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Colors.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    brightness: Brightness.dark,
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: const Color(0xffFDFEFF),
    appBarTheme: lightAppBarTheme,
    iconTheme: const IconThemeData(color: iconLightColor, size: 22),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.dmSans(
          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.dmSans(
        color: Colors.black,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 0.03,
        letterSpacing: -0.72,
      ),
      displayLarge: GoogleFonts.dmSans(
          color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.dmSans(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      displaySmall: GoogleFonts.dmSans(
          color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
      titleLarge: GoogleFonts.dmSans(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
      titleMedium: GoogleFonts.dmSans(color: Colors.grey, fontSize: 14),
      labelSmall: GoogleFonts.dmSans(
        color: Colors.black,
        fontSize: 14,
      ),
      titleSmall: GoogleFonts.dmSans(color: Colors.black, fontSize: 16),
      bodyMedium: GoogleFonts.dmSans(
          color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      bodySmall: GoogleFonts.dmSans(color: const Color(0xff777777), fontSize: 15),
      labelMedium: GoogleFonts.dmSans(
          color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
      headlineSmall: GoogleFonts.dmSans(
        color: Colors.black,
        fontSize: 14,
      ),
      headlineMedium: GoogleFonts.dmSans(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.dmSans(
        color: Colors.black,
        fontSize: 12,
      ),
    ),
    colorScheme: const ColorScheme.light(
        onInverseSurface: lightBottomBar,
        onSecondary: lightForegroundAppBarColor,
        onSurface: safeAreaLightColor,
        onTertiary: textInLightTextField,
        primary: bPrimaryColor,
        secondary: kSecondaryColor,
        error: kErrorColor,
        outline: iconLightColor,
        onPrimaryContainer: lightJobCardColor,
        onTertiaryContainer: lightTextField,
        onSecondaryContainer: lightFilterColor,
        tertiaryContainer: lightContainerColor,
        background: lightBackgroundColor,
        secondaryContainer: circleLightColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    brightness: Brightness.light,
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorLightTheme,
    appBarTheme:
        darkAppBarTheme.copyWith(backgroundColor: kContentColorLightTheme),
    iconTheme: const IconThemeData(color: iconDarkColor, size: 22),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.dmSans(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.dmSans(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      displayLarge: GoogleFonts.dmSans(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.dmSans(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      displaySmall: GoogleFonts.dmSans(
          color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
      titleLarge: GoogleFonts.dmSans(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
      titleMedium:
          GoogleFonts.dmSans(color: const Color(0xffD1D1D1), fontSize: 14),
      labelSmall: GoogleFonts.dmSans(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.dmSans(color: Colors.white, fontSize: 16),
      bodySmall: GoogleFonts.dmSans(color: Colors.grey, fontSize: 15),
      bodyMedium: GoogleFonts.dmSans(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.dmSans(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
      headlineSmall: GoogleFonts.dmSans(
        color: Colors.white,
        fontSize: 14,
      ),
      headlineMedium: GoogleFonts.dmSans(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      labelLarge: GoogleFonts.dmSans(
        color: const Color(0xffF6F8FE),
        fontSize: 12,
      ),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
        onInverseSurface: darkBottomBar,
        onSecondary: darkForegroundAppBarColor,
        onSurface: safeAreaDarkColor,
        primary: bPrimaryColor,
        secondary: kSecondaryColor,
        onTertiary: textInDarkTextField,
        error: kErrorColor,
        onTertiaryContainer: darkTextField,
        outline: iconDarkColor,
        onPrimaryContainer: darkJobCardColor,
        onSecondaryContainer: darkFilterColor,
        tertiaryContainer: darkContainerColor,
        background: darkBackgroundColor,
        secondaryContainer: circleLightColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kContentColorLightTheme,
      selectedItemColor: Colors.white70,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: Colors.transparent);
const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    foregroundColor: Colors.black,
    backgroundColor: Colors.transparent);
