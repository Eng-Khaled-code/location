import 'package:flutter/material.dart';
import 'package:location/PL/global/global_variables/fonts_ref.dart';
import 'package:location/PL/global/themes/app_colors/light_colors.dart';
import 'package:location/PL/global/themes/text_thems/light_text_themes.dart';

ThemeData lightThemeData() => ThemeData(
      brightness: Brightness.light,
      primaryColor: LightColors.primary,
      appBarTheme: _appBarTheme(),
      scaffoldBackgroundColor: LightColors.background,
      // ignore: deprecated_member_use
      accentColor: LightColors.accent,
      fontFamily: FontsRef.myFontFamilyArabRef,
      textTheme: lightTextThemes(),
      dividerColor: LightColors.divider,
      inputDecorationTheme:
          InputDecorationTheme(errorStyle: smallTextTextStyle),
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
      cardTheme: _cardTheme(),
    );

CardTheme _cardTheme() => CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25), // if you need this
      side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
    ));

AppBarTheme _appBarTheme() => AppBarTheme(
    elevation: 0.0,
    color: LightColors.background,
    centerTitle: true,
    iconTheme: const IconThemeData(color: LightColors.icon),
    titleTextStyle: largeTitleTextStyle);
