import 'package:flutter/material.dart';

class AppTheme {
  // Kenyan flag inspired colors
  static const Color primaryGreen = Color(0xFF006B3C);
  static const Color primaryRed = Color(0xFFCE1126);
  static const Color primaryBlack = Color(0xFF000000);
  static const Color primaryWhite = Color(0xFFFFFFFF);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: Colors.grey[50],

    appBarTheme: AppBarTheme(
      backgroundColor: primaryWhite,
      foregroundColor: primaryBlack,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: primaryBlack,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: primaryWhite,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryGreen;
        }
        return Colors.grey[400];
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryGreen.withOpacity(0.3);
        }
        return Colors.grey[300];
      }),
    ),

    textTheme: TextTheme(
      headlineMedium: TextStyle(
        color: primaryBlack,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
      titleLarge: TextStyle(
        color: primaryBlack,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        color: primaryBlack,
        fontSize: 16,
        fontFamily: 'Roboto',
      ),
      bodyMedium: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
        fontFamily: 'Roboto',
      ),
    ),

    colorScheme: ColorScheme.light(
      primary: primaryGreen,
      secondary: primaryRed,
      surface: primaryWhite,
      background: Colors.grey[50]!,
      error: primaryRed,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: Color(0xFF121212),

    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: primaryWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: primaryWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Color(0xFF1E1E1E),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryGreen;
        }
        return Colors.grey[600];
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryGreen.withOpacity(0.3);
        }
        return Colors.grey[700];
      }),
    ),

    textTheme: TextTheme(
      headlineMedium: TextStyle(
        color: primaryWhite,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
      titleLarge: TextStyle(
        color: primaryWhite,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        color: primaryWhite,
        fontSize: 16,
        fontFamily: 'Roboto',
      ),
      bodyMedium: TextStyle(
        color: Colors.grey[400],
        fontSize: 14,
        fontFamily: 'Roboto',
      ),
    ),

    colorScheme: ColorScheme.dark(
      primary: primaryGreen,
      secondary: primaryRed,
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      error: primaryRed,
    ),
  );
}
