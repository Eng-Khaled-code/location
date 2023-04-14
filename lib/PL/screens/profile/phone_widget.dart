import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/PL/global/firebase_var_ref/phone_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/screens/profile/profile_custom_dialog.dart';
import 'package:location/models/phone_model.dart';
import 'package:location/provider/user_provider.dart';
import 'package:provider/provider.dart';

class PhoneWidget extends StatelessWidget {
  const PhoneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (context, userProvider, _) => Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: const EdgeInsets.all(5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_addPhoneRow(context), _phoneList(context)])));
  }

  Row _addPhoneRow(BuildContext context) {
    return Row(
      children: [
        const Text(
          "ارقام التليفون",
        ),
        const SizedBox(width: 15),
        IconButton(
            icon: const Icon(Icons.add_ic_call_rounded),
            onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ProfileCustomDialog(
                      type: "phone",
                      addOrUpdateOrDelete: "add",
                      fieldValue: "",
                      fieldId: ""),
                ))
      ],
    );
  }


  Container _phoneList(BuildContext context) {
    Stream myStream = FirebaseFirestore.instance
        .collection(PhoneRef.phoneCollectionRef)
        .where(PhoneRef.userId, isEqualTo: userModel!.userId)
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
                    ? const Text("لايوجد")
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
      onTap: () => showDialog(
          context: context,
          builder: (context) => ProfileCustomDialog(
              type: "phone",
              addOrUpdateOrDelete: "update",
              fieldValue: phoneModel.number,
              fieldId: phoneModel.phoneId)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.only(left: 10),
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: const Icon(
                Icons.close,
                color: Colors.red,
              ),
              onTap: () {
                if (length == 1) {
                  Fluttertoast.showToast(
                      msg: "يجب ان يكون لديك علي الاقل رقم تليفون");
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => ProfileCustomDialog(
                          type: "phone",
                          addOrUpdateOrDelete: "delete",
                          fieldValue: phoneModel.number,
                          fieldId: phoneModel.phoneId));
                }
              },
            ),
            Text(
              phoneModel.number!,
            ),
          ],
        ),
      ),
    );
  }
}
