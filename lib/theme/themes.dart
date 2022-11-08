import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeColors {
  final MaterialColor primarySwatch;
  final Color primaryColor;
  final Color secondaryColor;

  ThemeColors({
    required this.primarySwatch,
    required this.primaryColor,
    required this.secondaryColor,
  });
}

class AppTheme {
  final int _primaryInt = 0xFF6a3189;
  final int _secondaryInt = 0xFFEE7CAE;

  ThemeColors get lightColors => ThemeColors(
        primaryColor: Color(_primaryInt),
        primarySwatch: MaterialColor(
          _primaryInt,
          const <int, Color>{
            50: Color(0xFF6a3189),
            100: Color(0xff5f2c7b),
            200: Color(0xff55276e),
            300: Color(0xff4a2260),
            400: Color(0xff401d52),
            500: Color(0xff351945),
            600: Color(0xff2a1437),
            700: Color(0xff200f29),
            800: Color(0xff150a1b),
            900: Color(0xff0b050e),
          },
        ),
        secondaryColor: Color(_secondaryInt),
      );

  ThemeColors get darkColors => lightColors;

  ThemeData get lightTheme => ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        primaryColor: lightColors.primaryColor,
        primarySwatch: lightColors.primarySwatch,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: lightColors.primaryColor,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(),
        ).apply(
          displayColor: Colors.black,
        ),
      );

  ThemeData get darkTheme => lightTheme;
}

extension AppThemeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  ThemeData get theme => Theme.of(this);

  ThemeColors get themeColors {
    final AppTheme appTheme = Provider.of<AppTheme>(this);
    if (isDarkMode) {
      return appTheme.darkColors;
    } else {
      return appTheme.lightColors;
    }
  }
}
