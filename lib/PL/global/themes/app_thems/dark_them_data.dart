
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/PL/global/global_variables/fonts_ref.dart';
import 'package:location/PL/global/themes/app_colors/dark_colors.dart';
import '../../global_variables/global_variables.dart';
import '../text_thems/dark_text_themes.dart';

ThemeData darkThemeData()=>ThemeData(
    primaryColor:DarkColors.primary ,
    brightness: Brightness.dark,
    accentColor:  DarkColors.accent,
    dividerColor: DarkColors.divider,
    textTheme: darkTextThemes(),
    appBarTheme:_appBarTheme(),
    cupertinoOverrideTheme:const CupertinoThemeData(brightness: Brightness.dark),
    scaffoldBackgroundColor: DarkColors.background,
    fontFamily: FontsRef.myFontFamilyArabRef,
    inputDecorationTheme: InputDecorationTheme(errorStyle: smallTextTextStyle),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
    cardTheme:_cardTheme()
);

CardTheme _cardTheme()=> CardTheme(shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(40), // if you need this
   /* side: BorderSide(
        color: Colors.grey.withOpacity(0.2),
        width: 3,
    ),*/
));
AppBarTheme _appBarTheme()=>const AppBarTheme(
    elevation: 0.0,
    color:DarkColors.background ,
    centerTitle: true,
    iconTheme:  IconThemeData(color: DarkColors.primary),
);