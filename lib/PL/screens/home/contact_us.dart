import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/models/phone_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/firebase_var_ref/phone_ref.dart';
class ContactUs extends StatelessWidget {
  const ContactUs({Key? key,this.userType="main_admin"}) : super(key: key);
  final String? userType;  @override
  Widget build(BuildContext context) {
  
  Stream adminPhonesStream=FirebaseFirestore.instance.collection(PhoneRef.phoneCollectionRef)
      .where(PhoneRef.userId,isEqualTo: userType=="main_admin"?"njNVqFSCfbRz6dp7gSDl":userModel!.adminId).get().asStream();
  return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
        shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
    title:const Text("للتواصل مع المسئول"),
    content:SizedBox(
      height: 150,
      width: 200,
      child: StreamBuilder(
      stream: adminPhonesStream,
      builder:(context,snapshot)=>
      !snapshot.hasData||snapshot.connectionState==ConnectionState.waiting?
      const CupertinoActivityIndicator()
          :
      snapshot.data!.size==0?const Text("لايوجد"):
    
      ListView.builder(
      itemCount: snapshot.data!.size,
      shrinkWrap: true,
      itemBuilder: (context,position){
      PhoneModel phoneModel=PhoneModel.fromSnapshot(snapshot.data!.docs[position].data());
      return _phoneCard(phoneModel.number!);},)),
    )));
  }


  Widget _phoneCard(String number) {
   return InkWell(
     onTap: ()async=> await launchUrl(Uri(scheme: "tel", path: number)),
     child: SizedBox(
   
       child: Column(
         children: [
           Text(number),
           const Divider()
         ],
       ),
     ),
   );
  }
}
