
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

goTo({@required BuildContext? context,@required Widget? to}){
  Navigator.push(context!, MaterialPageRoute(builder: (context)=>to!));
}