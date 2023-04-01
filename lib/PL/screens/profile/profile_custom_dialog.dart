
import 'package:flutter/material.dart';
import 'package:location/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../global/widgets/custom_text_field.dart';
class ProfileCustomDialog extends StatelessWidget {
  final String? addOrUpdateOrDelete;
  final String? type;
  final String? fieldValue;
  final String? fieldId;

   ProfileCustomDialog({Key? key,this.addOrUpdateOrDelete,this.type,this.fieldId,this.fieldValue}) : super(key: key);
  final _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

  UserProvider userProvider =Provider.of<UserProvider>(context);

  String title=
  type=="phone"&&addOrUpdateOrDelete=="add"
      ?
  "إضافة رقم تليفون جديد"
      :
  type=="phone"&&addOrUpdateOrDelete=="update"
      ?
  "تعديل رقم التليفون"
      :
  type=="phone"&&addOrUpdateOrDelete=="delete"
      ?
  "حذف رقم التليفون"
      :
  type=="username"
      ?
  "الاسم"
      :type=="address"
      ?
  "العنوان":"العلامة التجارية";
  String deleteText=type=="phone"?"هل تريد حذف  $fieldValue":"";
  String finalValue="";

    return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title:Text(title),
              content: Form(
                key: _formKey,
                child: addOrUpdateOrDelete=="delete"
                  ?
              Text(deleteText)
                  :
               CustomTextField(
                  initialValue: fieldValue,
                  label:type=="phone"? "رقم التليفون"
                      :
                  type=="username"
                      ?
                  "الاسم"
                      :
                  type=="address"
                      ?
                  "العنوان":"العلامة التجارية",
                  onSave: (value){
                    finalValue=value;
                  }, onTap: () {  },
                 icon: type=="phone"?Icons.phone:type=="username"?Icons.person:type=="address"?Icons.location_on_rounded:Icons.branding_watermark_outlined,),
              ),

              actions: actions(userProvider, finalValue, context)
            ),
    );

}

List<Widget> actions(UserProvider userProvider,String finalValue,BuildContext context){
    return [
      TextButton(onPressed: ()=>Navigator.pop(context), child:const Text("إلغاء")),
      TextButton(onPressed: (){

        _formKey.currentState!.save();

        if((addOrUpdateOrDelete=="delete")||_formKey.currentState!.validate()){

          if (type == "phone") {
            userProvider.phoneOperations(
              type: addOrUpdateOrDelete,
              phoneId: fieldId,
              number: finalValue,
            );
          }
          else
          {
            userProvider.updateUserFields(key:type,value:finalValue);
          }
          Navigator.pop(context);
        }
      }, child: const Text("موافق"),),
    ];
}
}
