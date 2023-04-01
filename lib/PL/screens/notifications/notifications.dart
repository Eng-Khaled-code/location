import 'package:flutter/material.dart';
import 'package:location/PL/global/widgets/circle_icon_button.dart';
import 'package:location/PL/screens/notifications/notify_list.dart';
class NotificationPage extends StatelessWidget {

  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _appBar(context),
        body:const NotifyList()
      ),
    );
  }


  AppBar _appBar(BuildContext context) {
    return AppBar(title:const Text("الإشعارات"),
      leading: CircleIconButton(onTap: ()=>Navigator.pop(context),icon: Icons.arrow_back,),
      bottom:const PreferredSize(
          preferredSize: Size.fromHeight(15.0), // here the desired height
          child:Divider(color: Colors.blue,)) ,
    );
  }}
