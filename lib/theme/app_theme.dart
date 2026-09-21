import 'package:flutter/material.dart';

/// Tata Usaha Ledger — professional theme for school admin work.
/// Grounded in the admin room: buku induk, papan tulis, stempel.
/// One bold move: the deep board-green header band. Everything else quiet.
class AppTokens {
  AppTokens._();

  // Core palette — 6 named values
  static const board = Color(0xFF1E3D32); // papan tulis, primary
  static const boardDeep = Color(0xFF152A23); // pressed / header depth
  static const chalk = Color(0xFFF5F5EF); // cool paper, background
  static const ink = Color(0xFF1B2420); // text
  static const muted = Color(0xFF5D6B62); // secondary text
  static const rule = Color(0xFFDDE0D6); // ledger rules
  static const stamp = Color(0xFFA63A2C); // stempel, destructive only
  static const mustard = Color(0xFFB98A1D); // kunyit, focus + markers

  // Jurusan spines — encode information, not decoration
  static const pplg = Color(0xFF1E3D32);
  static const fm = Color(0xFFB98A1D);
  static const ak = Color(0xFF4A6FA5);

  static Color spineFor(String jurusan) {
    switch (jurusan) {
      case 'PPLG':
        return pplg;
      case 'FM':
        return fm;
      case 'AK':
        return ak;
      default:
        return muted;
    }
  }
}

ThemeData buildLedgerTheme() {
  final base = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppTokens.chalk,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppTokens.board,
      primary: AppTokens.board,
      secondary: AppTokens.mustard,
      surface: Colors.white,
      error: AppTokens.stamp,
    ),
  );
  final defaultText = base.textTheme;

  return base.copyWith(
    textTheme: defaultText.copyWith(
      displaySmall: defaultText.displaySmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: AppTokens.ink,
      ),
      titleLarge: defaultText.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: AppTokens.ink,
      ),
      bodyMedium: defaultText.bodyMedium?.copyWith(
        color: AppTokens.ink,
        height: 1.5,
      ),
      bodySmall: defaultText.bodySmall?.copyWith(
        color: AppTokens.muted,
        height: 1.5,
      ),
      labelLarge: defaultText.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppTokens.chalk,
      foregroundColor: AppTokens.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: AppTokens.muted, fontSize: 14),
      labelStyle: const TextStyle(color: AppTokens.muted, fontSize: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTokens.rule, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTokens.board, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTokens.stamp, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTokens.stamp, width: 1.8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTokens.board,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppTokens.board,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppTokens.board,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppTokens.rule, width: 1),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppTokens.rule,
      thickness: 1,
      space: 1,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTokens.rule),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
  );
}

/// Gaya angka ledger untuk NIS — tanpa unduh font.
/// Memakai angka tabular bawaan sistem supaya ringan.
TextStyle nisStyle({double size = 13, Color color = AppTokens.muted}) {
  return TextStyle(
    fontSize: size,
    color: color,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
