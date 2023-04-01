import 'package:flutter/material.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/global_variables/screen_controller_ref.dart';
import 'package:location/PL/global/global_variables/theme_ref.dart';
import 'package:location/PL/global/widgets/custom_alert_dialog.dart';
import 'package:location/PL/global/widgets/image_widget.dart';
import 'package:location/PL/global/widgets/methoods.dart';
import 'package:location/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../../../provider/themeProvider.dart';
import '../profile/profile_page.dart';
import 'contact_us.dart';
import 'home_page.dart';
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        children: <Widget>[
          drawerHeader(),
          drawerBodyTile(Icons.home, "الرئيسية", () =>goTo(context: context,to: HomePage())),
          const Divider(),
          drawerBodyTile(Icons.settings, "تحديث البيانات",  ()=>goTo(context: context,to: const ProfilePage())),
          const Divider(),
          drawerBodyTile(Icons.money,  "المعاملات المالية",() {}),
          const Divider(),
          drawerBodyTile(Icons.call, " للتواصل" ,()=>showDialog(context: context, builder: (context)=>ContactUs())),
          const Divider(),
          drawerBodyTile(Icons.mode_night,  "الوضع المظلم" ,() {}),
          const Divider(),
          drawerBodyTile(Icons.arrow_back,  "تسجيل الخروج",
              ()=>onPressLogOut(context)),
          const Divider(),

        ],
      ),
    );
  }

  drawerHeader()=>
     UserAccountsDrawerHeader(
        currentAccountPicture:const ImageWidget(),
       accountEmail: Text("الإيميل : ${userModel!.email!}"),
        accountName: Text("الاسم : ${userModel!.userName!}",) );

  Widget drawerBodyTile(
      IconData icon, String text, Function()? onTap) {
    return ListTile(
      title: Text(text),
      leading: Icon(
        icon,
       // color: color,
      ),
      onTap: onTap,
      trailing: text=="الوضع المظلم"?switchMode():null,
    );
  }

  Consumer switchMode(){

    return Consumer<ThemeProvider>(
        builder: (context, theme, _)=>
            Switch(
                value:theme.themeMode==ThemeRef.dark ,
                onChanged: (value){
            String newValue=value ?ThemeRef.dark:ThemeRef.light;
            theme.setThemeMode(newValue);

        }));
  }

  onPressLogOut(BuildContext context) {

    showDialog(context: context,
      builder: (context)
      => CustomAlertDialog(

        title:"تنبيه",text: "هل تريد تسجيل الخروج بالفعل",
        onPress: (){
            Navigator.pop(context);
            Provider.of<UserProvider>(context,listen: false).logOut();

          },
      )
      ,
      barrierDismissible: true,

    );
  }
}
