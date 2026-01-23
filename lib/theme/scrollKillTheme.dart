import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollkill/theme/color.dart';

class ScrollKillTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: ScrollKillColors.background,
    canvasColor: ScrollKillColors.background,

    colorScheme: ColorScheme.dark(
      primary: ScrollKillColors.primaryRed,
      secondary: ScrollKillColors.primaryRed,
      background: ScrollKillColors.background,
      surface: ScrollKillColors.surface,
      error: ScrollKillColors.primaryRed,
    ),

    // Typography
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).copyWith(
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: ScrollKillColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: ScrollKillColors.textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: ScrollKillColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 15,
        color: ScrollKillColors.textSecondary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 13,
        color: ScrollKillColors.textDisabled,
      ),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: ScrollKillColors.background,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: ScrollKillColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ScrollKillColors.primaryRed,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: ScrollKillColors.divider),
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith(
            (states) => Colors.white,
      ),
      trackColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.selected)
            ? ScrollKillColors.primaryRed
            : ScrollKillColors.divider,
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: ScrollKillColors.divider,
      thickness: 1,
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ScrollKillColors.surface,
      hintStyle: GoogleFonts.inter(
        color: ScrollKillColors.textDisabled,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),

    // Bottom Navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ScrollKillColors.surface,
      selectedItemColor: ScrollKillColors.primaryRed,
      unselectedItemColor: ScrollKillColors.textDisabled,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
