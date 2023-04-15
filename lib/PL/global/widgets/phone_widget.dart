import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/phone_model.dart';
import '../firebase_var_ref/phone_ref.dart';
import 'custom_alert_dialog.dart';

class PhoneListWidget extends StatelessWidget {
  const PhoneListWidget({super.key, this.userId, this.name});
  final String? userId;
  final String? name;
  @override
  Widget build(BuildContext context) {
    return _phoneList(context);
  }

  onPress(BuildContext context, String number) {
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
            text: "$name\n$number",
            title: "اتصال",
            onPress: () async =>
                await launchUrl(Uri(scheme: "tel", path: number))),
        barrierDismissible: true);
  }

  Container _phoneList(BuildContext context) {
    Stream myStream = FirebaseFirestore.instance
        .collection(PhoneRef.phoneCollectionRef)
        .where(PhoneRef.userId, isEqualTo: userId)
        .snapshots();
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 40,
        padding: const EdgeInsets.all(5),
        child: StreamBuilder(
            stream: myStream,
            builder: (context, snapshot) => !snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting
                ? const CupertinoActivityIndicator()
                : snapshot.data!.size == 0
                    ? const Text(" لا يوجد ارقام")
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, position) {
                          PhoneModel phoneModel = PhoneModel.fromSnapshot(
                              snapshot.data!.docs[position].data());
                          int length = snapshot.data!.size;
                          return _phoneCard(phoneModel, context, length);
                        },
                      )));
  }

  InkWell _phoneCard(PhoneModel phoneModel, BuildContext context, int length) {
    Color borderColor = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;
    return InkWell(
      onTap: () => onPress(context,phoneModel.number!),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(5),
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor)),
        child: Text(
          phoneModel.number!,
        ),
      ),
    );
  }
}
