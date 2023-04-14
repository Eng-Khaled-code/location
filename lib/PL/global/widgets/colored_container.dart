import 'package:flutter/material.dart';
import 'package:location/PL/global/themes/text_thems/text_var.dart';

class ColoredContainer extends StatelessWidget {
  final String? content;
  const ColoredContainer({Key? key,this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          content!,
          style: const TextStyle(
              fontFamily: TextVar.arabicFontFamily),),
      ),
    );
  }
}
