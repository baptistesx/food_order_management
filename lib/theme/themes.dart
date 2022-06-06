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
  final int _primaryInt = 0xFF545afa;
  final int _secondaryInt = 0xFFFAAF19;

  ThemeColors get lightColors => ThemeColors(
        primaryColor: Color(_primaryInt),
        primarySwatch: MaterialColor(
          _primaryInt,
          const <int, Color>{
            50: Color(0xff4c51e1),
            100: Color(0xff4348c8),
            200: Color(0xff3b3faf),
            300: Color(0xff323696),
            400: Color(0xff2a2d7d),
            500: Color(0xff222464),
            600: Color(0xff191b4b),
            700: Color(0xff111232),
            800: Color(0xff080919),
            900: Color(0xff000000),
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
