// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneGalleryThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  MaterialColor myColor = MaterialColor(0xFFFFCB37, color);
  static const Map<int, Color> color = {
    50: Color.fromRGBO(255, 203, 55, .1),
    100: Color.fromRGBO(255, 203, 55, .2),
    200: Color.fromRGBO(255, 203, 55, .3),
    300: Color.fromRGBO(255, 203, 55, .4),
    400: Color.fromRGBO(255, 203, 55, .5),
    500: Color.fromRGBO(255, 203, 55, .6),
    600: Color.fromRGBO(255, 203, 55, .7),
    700: Color.fromRGBO(255, 203, 55, .8),
    800: Color.fromRGBO(255, 203, 55, .9),
    900: Color.fromRGBO(255, 203, 55, 1),
  };

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
        disabledColor: Colors.black45,
        primaryColorDark: Colors.green[700],
        primaryColorLight: colorScheme.primaryVariant,
        secondaryHeaderColor: Colors.grey[400],
        errorColor: Colors.red[700],
        colorScheme: colorScheme,
        textTheme: _textTheme,
        cardTheme: CardTheme(
          elevation: 0,
          shadowColor: colorScheme.secondary,
          color: colorScheme.onBackground,
        ),
        primaryColor: colorScheme.primary,
        appBarTheme: AppBarTheme(
          textTheme: _textTheme.apply(bodyColor: Colors.black),
          color: colorScheme.onBackground,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black54),
          actionsIconTheme: IconThemeData(color: Colors.black54),
        ),
        iconTheme: IconThemeData(color: Colors.grey, opacity: 1),
        canvasColor: colorScheme.onBackground,
        scaffoldBackgroundColor: colorScheme.onBackground,
        highlightColor: Colors.transparent,
        accentColor: colorScheme.secondary,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          splashColor: colorScheme.secondary,
          elevation: 4,
        ),
        focusColor: focusColor,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.alphaBlend(
            _lightFillColor.withOpacity(0.80),
            _darkFillColor,
          ),
          contentTextStyle: _textTheme.subtitle1.apply(color: _darkFillColor),
        ),
        buttonColor: colorScheme.primary,
        buttonTheme: ButtonThemeData(
          splashColor: colorScheme.secondary,
        ));
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFFffd541),
    // Color(0xFF097770),
    primaryVariant: Color(0xFF3c8ef0),
    secondary: Color(0xFFe6e6e6),
    secondaryVariant: Color(0xFF16b937),
    background: Color(0xFFfffeeb),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static final TextTheme _textTheme = TextTheme(
      headline4: GoogleFonts.cabin(fontWeight: _bold, fontSize: 20.0),
      caption: GoogleFonts.oswald(fontWeight: _bold, fontSize: 16.0),
      headline5: GoogleFonts.oswald(fontWeight: _medium, fontSize: 16.0),
      subtitle1: GoogleFonts.cabin(fontWeight: _medium, fontSize: 16.0),
      overline:
          GoogleFonts.cabin(fontWeight: FontWeight.normal, fontSize: 12.0),
      bodyText1: GoogleFonts.cabin(fontWeight: _regular, fontSize: 14.0),
      subtitle2: GoogleFonts.cabin(fontWeight: _medium, fontSize: 14.0),
      bodyText2: GoogleFonts.cabin(fontWeight: _regular, fontSize: 16.0),
      headline6: GoogleFonts.cabin(fontWeight: _bold, fontSize: 15.0),
      headline1:
          GoogleFonts.cabin(fontWeight: FontWeight.normal, fontSize: 10.0),
      headline2: GoogleFonts.cabin(fontWeight: FontWeight.bold, fontSize: 20.0),
      headline3: GoogleFonts.cabin(fontWeight: _bold, fontSize: 13),
      button: GoogleFonts.cabin(
        fontWeight: _semiBold,
        fontSize: 14.0,
      ));
}

class TabletGalleryThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  MaterialColor myColor = MaterialColor(0xFFFFCB37, color);
  static const Map<int, Color> color = {
    50: Color.fromRGBO(255, 203, 55, .1),
    100: Color.fromRGBO(255, 203, 55, .2),
    200: Color.fromRGBO(255, 203, 55, .3),
    300: Color.fromRGBO(255, 203, 55, .4),
    400: Color.fromRGBO(255, 203, 55, .5),
    500: Color.fromRGBO(255, 203, 55, .6),
    600: Color.fromRGBO(255, 203, 55, .7),
    700: Color.fromRGBO(255, 203, 55, .8),
    800: Color.fromRGBO(255, 203, 55, .9),
    900: Color.fromRGBO(255, 203, 55, 1),
  };

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
        disabledColor: Colors.black45,
        primaryColorDark: Colors.green[700],
        primaryColorLight: colorScheme.primaryVariant,
        secondaryHeaderColor: Colors.grey[400],
        errorColor: Colors.red[700],
        colorScheme: colorScheme,
        textTheme: _textTheme,
        cardTheme: CardTheme(
          elevation: 0,
          shadowColor: colorScheme.secondary,
          color: colorScheme.onBackground,
        ),
        primaryColor: colorScheme.primary,
        appBarTheme: AppBarTheme(
          textTheme: _textTheme.apply(bodyColor: Colors.black),
          color: colorScheme.onBackground,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black54),
          actionsIconTheme: IconThemeData(color: Colors.black54),
        ),
        iconTheme: IconThemeData(color: Colors.grey, opacity: 1),
        canvasColor: colorScheme.onBackground,
        scaffoldBackgroundColor: colorScheme.onBackground,
        highlightColor: Colors.transparent,
        accentColor: colorScheme.secondary,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          splashColor: colorScheme.secondary,
          elevation: 4,
        ),
        focusColor: focusColor,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.alphaBlend(
            _lightFillColor.withOpacity(0.80),
            _darkFillColor,
          ),
          contentTextStyle: _textTheme.subtitle1.apply(color: _darkFillColor),
        ),
        buttonColor: colorScheme.primary,
        buttonTheme: ButtonThemeData(
          splashColor: colorScheme.secondary,
        ));
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFFffd541),
    // Color(0xFF097770),
    primaryVariant: Color(0xFF3c8ef0),
    secondary: Color(0xFFe6e6e6),
    secondaryVariant: Color(0xFF16b937),
    background: Color(0xFFfffeeb),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static final TextTheme _textTheme = TextTheme(
      headline4: GoogleFonts.cabin(fontWeight: _bold, fontSize: 20.0),
      caption: GoogleFonts.oswald(fontWeight: _bold, fontSize: 20.0),
      headline5: GoogleFonts.oswald(fontWeight: _medium, fontSize: 26.0),
      subtitle1: GoogleFonts.cabin(fontWeight: _medium, fontSize: 26.0),
      overline:
          GoogleFonts.cabin(fontWeight: FontWeight.normal, fontSize: 21.0),
      bodyText1: GoogleFonts.cabin(fontWeight: _regular, fontSize: 24.0),
      subtitle2: GoogleFonts.cabin(fontWeight: _medium, fontSize: 16.0),
      bodyText2: GoogleFonts.cabin(fontWeight: _regular, fontSize: 26.0),
      headline6: GoogleFonts.cabin(fontWeight: _bold, fontSize: 26.0),
      headline1: GoogleFonts.cabin(fontSize: 15.0),
      headline2: GoogleFonts.cabin(fontWeight: FontWeight.bold, fontSize: 38.0),
      headline3: GoogleFonts.cabin(fontWeight: _bold, fontSize: 18.0),
      button: GoogleFonts.cabin(
        fontWeight: _semiBold,
        fontSize: 22.0,
      ));
}
