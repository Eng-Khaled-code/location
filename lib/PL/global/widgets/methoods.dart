
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

goTo({@required BuildContext? context,@required Widget? to}){
  Navigator.push(context!, MaterialPageRoute(builder: (context)=>to!));
}

String getMonthAsString({@required String? text}) {
   String month="";

   if(text=="1")
   {
     month="يناير";
   }
   else if(text=="2")
   {
     month="فبراير";
   }
   else if(text=="3")
   {
     month="مارس";
   }
   else if(text=="4")
   {
     month="ابريل";
   }
   else if(text=="5")
   {
     month="مايو";
   }
   else if(text=="6")
   {
     month="يونيه";
   }
   else if(text=="7")
   {
     month="يوليو";
   }
   else if(text=="8")
   {
     month="أغسطس";
   }
   else if(text=="9")
   {
     month="سبتمبر";
   }
   else if(text=="10")
   {
     month="أكتوبر";
   }
   else if(text=="11")
   {
     month="نوفمبر";
   }
   else
   {
     month="ديسمبر";
   }

   return month;
  }