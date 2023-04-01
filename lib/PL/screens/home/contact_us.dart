import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/models/phone_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/firebase_var_ref/phone_ref.dart';
class ContactUs extends StatelessWidget {
   ContactUs({Key? key}) : super(key: key);

  Stream adminPhonesStream=FirebaseFirestore.instance.collection(PhoneRef.phoneCollectionRef)
      .where(PhoneRef.userId,isEqualTo: "").get().asStream();
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,

        child: AlertDialog(
        shape:const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
    title:const Text("للتواصل مع المسئول"),
    content:StreamBuilder(
    stream: adminPhonesStream,
    builder:(context,snapshot)=>
    !snapshot.hasData||snapshot.connectionState==ConnectionState.waiting?
    const CupertinoActivityIndicator()
        :
    snapshot.data!.size==0?const Text("لايوجد"):

    ListView.builder(
      shrinkWrap: true,
    itemCount: snapshot.data!.size,
    itemBuilder: (context,position){
    PhoneModel phoneModel=PhoneModel.fromSnapshot(snapshot.data!.docs[position].data());
    return _phoneCard(phoneModel.number!);},))));
  }


  Widget _phoneCard(String number) {
   return InkWell(
     onTap: ()async=> await launchUrl(Uri.parse("tel://$number")),
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
