import 'package:flutter/material.dart';
import 'package:location/PL/global/themes/app_colors/dark_colors.dart';
import 'package:location/PL/global/themes/text_thems/text_var.dart';

TextTheme darkTextThemes()=>TextTheme(
    titleMedium: _mediumTitleTextStyle,
    titleLarge: _largeTitleTextStyle,
    titleSmall: _smallTitleTextStyle,
    labelSmall: smallTextTextStyle,
    labelMedium: _mediumTextTextStyle
);

TextStyle _mediumTitleTextStyle=const TextStyle(
    fontSize:TextVar.mediumFontSize,
    fontWeight:TextVar.textFW,
    fontFamily: TextVar.arabicFontFamily,
    color: DarkColors.primary
);

TextStyle _smallTitleTextStyle=const TextStyle(
    fontSize:TextVar.smallFontSize,
    fontWeight:TextVar.titleFW,
    fontFamily: TextVar.arabicFontFamily,
    color: DarkColors.primary
);
TextStyle _largeTitleTextStyle=const TextStyle(
    fontSize:TextVar.largeFontSize,
    fontWeight:TextVar.titleFW,
    fontFamily: TextVar.englishFontFamily,
    color: DarkColors.primary

);

TextStyle smallTextTextStyle=const TextStyle(
    fontSize:TextVar.smallFontSize,
    fontWeight:TextVar.textFW,
    fontFamily: TextVar.arabicFontFamily,
    color: DarkColors.primary

);

TextStyle _mediumTextTextStyle=const TextStyle(
    fontSize:TextVar.mediumFontSize,
    fontWeight:TextVar.textFW,
    fontFamily: TextVar.arabicFontFamily,
    color: DarkColors.primary

);
