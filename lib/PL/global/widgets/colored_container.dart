import 'package:flutter/material.dart';
import 'package:location/PL/global/themes/text_thems/text_var.dart';

import '../themes/app_colors/dark_colors.dart';
import '../themes/app_colors/light_colors.dart';
class ColoredContainer extends StatelessWidget {
  final String? content;
  const ColoredContainer({Key? key,this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor=Theme.of(context).brightness==Brightness.light?LightColors.coloredContainer:DarkColors.coloredContainer;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: backgroundColor),
      padding: const EdgeInsets.all(5.0),
      child: Text(
        content!,
        style: const TextStyle(
            color: Colors.white,
            fontFamily: TextVar.arabicFontFamily),),
    );
  }
}
