import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? title;
  final String? text;
  final Function()? onPress;

  const CustomAlertDialog(
      {super.key, @required this.title, @required this.text, @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child:AlertDialog(
          title: Text(
            title!,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("إلغاء"))
            ,TextButton(onPressed: onPress, child: const Text("تأكيد"))
          ],
          content: Text(
            text!
          ),
          shape:const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))
          ),
        ));
  }
}
