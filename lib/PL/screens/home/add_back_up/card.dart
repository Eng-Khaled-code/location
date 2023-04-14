import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';
import '../../../global/widgets/user_identification.dart';

class DialogCard extends StatelessWidget {
  const DialogCard({super.key, this.userModel, this.ontap,this.currentUserId});
  final UserModel? userModel;
  final Function? ontap;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ontap!(),
      child: Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color:
                      currentUserId == userModel!.userId!
                          ? Colors.blue
                          : Colors.grey)),
          child: UserIdentification(
            image: userModel!.image,
            name: userModel!.userName,
            date: userModel!.brand,
            formatedDate: true,
          )),
    );
  }

}
