import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class SharedTheme {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFC0001F),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFDAD7),
    onPrimaryContainer: Color(0xFF410004),
    secondary: Color(0xFF0061A6),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD2E4FF),
    onSecondaryContainer: Color(0xFF001C37),
    tertiary: Color(0xFF566500),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFD5EF53),
    onTertiaryContainer: Color(0xFF181E00),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFFFBFF),
    onBackground: Color(0xFF201A1A),
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF201A1A),
    surfaceVariant: Color(0xFFF5DDDB),
    onSurfaceVariant: Color(0xFF534342),
    outline: Color(0xFF857371),
    onInverseSurface: Color(0xFFFBEEEC),
    inverseSurface: Color(0xFF362F2E),
    inversePrimary: Color(0xFFFFB3AE),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFC0001F),
    outlineVariant: Color(0xFFD8C2C0),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFB3AE),
    onPrimary: Color(0xFF68000C),
    primaryContainer: Color(0xFF930015),
    onPrimaryContainer: Color(0xFFFFDAD7),
    secondary: Color(0xFFA0CAFF),
    onSecondary: Color(0xFF003259),
    secondaryContainer: Color(0xFF00497E),
    onSecondaryContainer: Color(0xFFD2E4FF),
    tertiary: Color(0xFFB9D238),
    onTertiary: Color(0xFF2C3400),
    tertiaryContainer: Color(0xFF414C00),
    onTertiaryContainer: Color(0xFFD5EF53),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF201A1A),
    onBackground: Color(0xFFEDE0DE),
    surface: Color(0xFF201A1A),
    onSurface: Color(0xFFEDE0DE),
    surfaceVariant: Color(0xFF534342),
    onSurfaceVariant: Color(0xFFD8C2C0),
    outline: Color(0xFFA08C8B),
    onInverseSurface: Color(0xFF201A1A),
    inverseSurface: Color(0xFFEDE0DE),
    inversePrimary: Color(0xFFC0001F),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFFFB3AE),
    outlineVariant: Color(0xFF534342),
    scrim: Color(0xFF000000),
  );

  static const primaryColor = Color(0xFFED1B2F);
  static const secondaryColor = Color(0xFF006CB8);
  static const tertiaryColor = Color(0xFFACC42A);

  static const successColor = Color(0xFF249689);
  static const errorColor = Color(0xFFFF5963);
  static const warningColor = Color(0xFFF9CF58);
  static const infoColor = Color(0xFF1307B2);

  static final _primaryTextStyle = GoogleFonts.outfit().fontFamily;
  static final _secondaryTextStyle = GoogleFonts.readexPro().fontFamily;

  static const thin = FontWeight.w100;
  static const extraLight = FontWeight.w200;
  static const light = FontWeight.w300;
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
  static const extraBold = FontWeight.w800;
  static const black = FontWeight.w900;

  static final _textThemeStyle = TextTheme(
    bodyLarge: TextStyle(fontFamily: _secondaryTextStyle),
    bodyMedium: TextStyle(fontFamily: _secondaryTextStyle),
    bodySmall: TextStyle(fontFamily: _secondaryTextStyle),
    labelLarge: TextStyle(fontFamily: _secondaryTextStyle),
    labelMedium: TextStyle(fontFamily: _secondaryTextStyle),
    labelSmall: TextStyle(fontFamily: _secondaryTextStyle),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    fontFamily: _primaryTextStyle,
    textTheme: _textThemeStyle,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    fontFamily: _primaryTextStyle,
    textTheme: _textThemeStyle,
  );
}
