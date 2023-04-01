import 'package:flutter/material.dart';
import 'package:location/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../../global/global_variables/global_variables.dart';
import '../../global/widgets/custom_text_field.dart';
class PasswordDialog extends StatefulWidget {
  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
   final _formKey=GlobalKey<FormState>();
   bool show=false;
   int tries=0;
   String oldPassword="";
   String newPassword="";

  @override
  Widget build(BuildContext context) {

    return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title:const Text("تغيير كلمة المرور"),
              content: Form(
                key: _formKey,
                child:
               SingleChildScrollView(
                 child: Column(
                   children:[
                     show==false?CustomTextField(
                      label: "كلمة المرور القديمة",
                      onSave: (value){
                         oldPassword=value;
                      }, onTap: () {  },
                     icon:Icons.lock    ):
                   CustomTextField(
                       label: "كلمة المرور الجديدة",
                         onSave: (value){
                           setState(() {
                             newPassword=value;
                           });
                         }, onTap: () {  },
                         icon:Icons.lock ),
                     const SizedBox(height: 20),
                     ElevatedButton(onPressed: (){

                       _formKey.currentState!.save();
                       if(_formKey.currentState!.validate())
                       {
                         if(show)
                         {

                           Provider.of<UserProvider>(context,listen: false)
                               .updateUserFields(key:"password", value:newPassword);
                           Navigator.pop(context);
                         }

                         if(userModel!.password==oldPassword)
                         {
                           setState(() {
                             show= true;
                           });
                         }
                         else
                         {
                           setState(() {tries<3?tries++:(){};});
                         }
                        }

                     }, child: SizedBox(width:double.infinity,child: Text(show?"تغيير":tries==3?"تخطيت العدد المسموح حاول لاحقا":"تحقق ${tries==0?"":"'يتبقي ${3-tries} محاولة'"}",textAlign: TextAlign.center,))),

                   ],
                 ),
               )),

            ),
    );

}

}
