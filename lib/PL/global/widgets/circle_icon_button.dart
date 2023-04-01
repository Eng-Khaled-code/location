import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  const CircleIconButton({Key? key,this.icon=Icons.menu,@required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: Colors.blue)),
        child: IconButton(icon: Icon(icon),onPressed:
            onTap
        ));
  }
}
