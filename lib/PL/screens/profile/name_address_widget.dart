import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/screens/profile/profile_custom_dialog.dart';
import 'package:location/provider/user_provider.dart';
import 'package:provider/provider.dart';

class NameAddressBrandWidget extends StatelessWidget {
  const NameAddressBrandWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<UserProvider>(
        builder: (context, userProvider, _) =>Container(
      alignment:Alignment.centerRight,
      decoration:  BoxDecoration(borderRadius: BorderRadius.circular(10)),
      padding:const EdgeInsets.all(5) ,
      margin:const EdgeInsets.all(5)  ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          _rowWidget("الاسم  ",userProvider,context),
          const Divider(),
          _rowWidget("العنوان",userProvider,context),
          const Divider(),
          _rowWidget("العلامة التجارية",userProvider,context),



        ],),
    ));
  }

  Row _rowWidget(String text,UserProvider userProvider,BuildContext context) {
    bool nameLoad=(text=="الاسم  "&&userProvider.isUsernameLoading),
       addressLoad= (text=="العنوان"&&userProvider.isAddressLoading),
    brand=(text=="العلامة التجارية"&&userProvider.isBrandLoading)
    ,loadCondition=nameLoad||addressLoad||brand;
    return  Row(
      children: [
        Text(text),
        const SizedBox(width :15),

            loadCondition
            ?
            const CupertinoActivityIndicator()
            :
        _nameAddressBrandField(nameOrAddressOrBrand: text=="الاسم  "?"username":text=="العنوان"?"address":"brand",value: text=="الاسم  "?userModel!.userName!:text=="العنوان"?userModel!.address!:userModel!.brand,context: context )
      ],

    );
  }

  InkWell _nameAddressBrandField({String? nameOrAddressOrBrand,String? value,BuildContext? context}) {
    Color borderColor=Theme.of(context!).brightness==Brightness.light?Colors.black:Colors.white;
    return InkWell(
      onTap: ()=>
          showDialog(context: context, builder: (context)=>ProfileCustomDialog(type: nameOrAddressOrBrand,
              addOrUpdateOrDelete: "update",fieldValue:value,fieldId:"")),
      child: Container(
        margin:  const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.only(left: 10,right: 10),
        height: 30,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: borderColor)),
        child: Center(child: Text(value!,)),),
    );

  }
}
