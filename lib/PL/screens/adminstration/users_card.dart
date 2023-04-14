// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:location/PL/global/firebase_var_ref/user_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/widgets/methoods.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../provider/user_provider.dart';
import '../../global/widgets/custom_alert_dialog.dart';
import '../../global/widgets/phone_widget.dart';
import '../../global/widgets/user_identification.dart';
import 'add_user.dart';

class UserCard extends StatelessWidget {
  UserCard({Key? key, this.model}) : super(key: key);
  final UserModel? model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        (model!.type == UserRef.providerRef &&
                    userModel!.type == UserRef.adminRef) ||
                userModel!.type != UserRef.adminRef
            ? goTo(
                context: context,
                to: AddUser(
                  addOrUpdate: "تعديل",
                  name: model!.userName,
                  address: model!.address,
                  brand: model!.brand,
                  userId: model!.userId,
                ))
            : () {};
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _topRow(context),
              _dataWidget(),
            ],
          ),
        ),
      ),
    );
  }

  _topRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserIdentification(
            name: model!.userName,
            image: model!.image,
            date: DateTime.fromMicrosecondsSinceEpoch(
                    int.tryParse(model!.userId!)!)
                .toString()),
        statusWidget(context),
      ],
    );
  }

  Padding _dataWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${model!.email!}\n  ${model!.brand!}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(
              "العنوان : ${model!.address}",
              style: const TextStyle(
                color: Colors.grey,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          PhoneListWidget(
            userId: model!.userId,
            name: model!.userName,
          )
        ],
      ),
    );
  }

  IconButton statusWidget(BuildContext context) {
    return IconButton(
        onPressed: () => _showActionDialogDialog(context),
        icon: Icon(
            model!.status == "مغلق" ? Icons.visibility_off : Icons.visibility));
  }

  void _showActionDialogDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        text: model!.status == "مفتوح"
            ? "هل تريد إيقاف حساب هذا المستخدم"
            : "هل تريد تشغيل حساب هذا المستخدم",
        title: "تأكيد",
        onPress: () {
          Navigator.pop(context);
          Provider.of<UserProvider>(context, listen: false).updateUserStatus(
              userId: model!.userId,
              status: model!.status == "مفتوح" ? "مغلق" : "مفتوح");
        },
      ),
      barrierDismissible: true,
    );
  }
}
