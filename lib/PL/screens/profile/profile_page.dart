
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/widgets/circle_icon_button.dart';
import 'package:location/PL/global/widgets/image_widget.dart';
import 'package:location/PL/screens/profile/name_address_widget.dart';
import 'package:location/PL/screens/profile/password_dialog.dart';
import 'package:location/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../../global/themes/text_thems/text_var.dart';
import 'phone_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});


  @override
  Widget build(BuildContext context) {
    UserProvider userProvider=Provider.of<UserProvider>(context);
    return  Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _profileAppBar(context),
        body:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                   ImageWidget(url: userModel!.image!,isProfile: true,type:userModel!.image==""?"assets":"network" ,),
                  const SizedBox(height: 4.0),
                  userProvider.isBrandLoading ? const CupertinoActivityIndicator() : Text("${userModel!.brand}",style:const TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 25,fontFamily: TextVar.englishFontFamily)),
                  userProvider.isUsernameLoading ? const CupertinoActivityIndicator() : Text("${userModel!.userName}"),
                  Text( userModel!.email! ),
                  const Divider(),
                  const SizedBox(height: 10.0),
                  const NameAddressBrandWidget(),
                  const Divider(),
                  const PhoneWidget(),
                  const Divider(),

                ],
              ),
            ),
          ),
        ));
  }

 AppBar _profileAppBar(BuildContext context) {
    return AppBar(title:const Text("تحديث البيانات الشخصية" ),
      leading: CircleIconButton(onTap: ()=>Navigator.pop(context),icon: Icons.arrow_back,),
      actions: [CircleIconButton(onTap: (){
        showDialog(context: context, builder: (context)=>const PasswordDialog());

      },icon: Icons.password)],
      bottom:const PreferredSize(
          preferredSize: Size.fromHeight(15.0), // here the desired height
          child:Divider(color: Colors.blue,)) ,
    );
  }
}
