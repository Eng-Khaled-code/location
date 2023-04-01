import 'package:flutter/material.dart';
import 'package:location/PL/global/themes/app_colors/light_colors.dart';
import 'package:location/PL/global/themes/text_thems/text_var.dart';

TextTheme lightTextThemes()=>TextTheme(
    titleMedium:mediumTitleTextStyle,
    titleLarge: largeTitleTextStyle,
    titleSmall: smallTitleTextStyle,
    labelSmall: smallTextTextStyle,
    labelMedium: mediumTextTextStyle,
);

TextStyle mediumTitleTextStyle=const TextStyle(
    fontSize:TextVar.mediumFontSize,
    fontWeight:TextVar.textFW,
    fontFamily: TextVar.arabicFontFamily,
    color: LightColors.primary
);

TextStyle smallTitleTextStyle=const TextStyle(
    fontSize:TextVar.smallFontSize,
    fontWeight:TextVar.titleFW,
    fontFamily: TextVar.arabicFontFamily,
    color: LightColors.primary
);
TextStyle largeTitleTextStyle=const TextStyle(
    fontSize:TextVar.largeFontSize,
    fontWeight:TextVar.titleFW,
    fontFamily: TextVar.englishFontFamily,
    color: LightColors.primary
);

TextStyle smallTextTextStyle=const TextStyle(
    fontSize:TextVar.smallFontSize,
    fontWeight:TextVar.textFW,
    fontFamily: TextVar.arabicFontFamily,
    color: LightColors.primary

);

TextStyle mediumTextTextStyle=const TextStyle(
    fontSize:TextVar.mediumFontSize,
    fontWeight:TextVar.textFW,
    fontFamily: TextVar.arabicFontFamily,
    color: LightColors.primary
);
