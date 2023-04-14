import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/PL/screens/adminstration/users_card.dart';
import '../../../models/user_model.dart';
import '../../global/firebase_var_ref/user_ref.dart';
import '../../global/global_variables/global_variables.dart';
import '../../global/widgets/no_data_card.dart';

class UsersList extends StatelessWidget {
  const UsersList({Key? key, this.userType = "no"}) : super(key: key);
  final String? userType;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: myStream(),
        builder: (context, snapshot) {
          return !snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting
              ? _loadingWidget()
              : snapshot.data!.size == 0
                  ? const NoDataCard(
                      message: "لا يوجد مستخدمين",
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.size,
                      reverse: true,
                      itemBuilder: (context, position) {
                        UserModel userModel = UserModel.fromSnapshot(
                            snapshot.data!.docs[position].data());

                        return UserCard(
                          model: userModel,
                        );
                      });
        });
  }

  Align _loadingWidget() {
    return const Align(
        alignment: Alignment.topCenter, child: CupertinoActivityIndicator());
  }

 Stream myStream() {
    if (userType == "no") {
      return FirebaseFirestore.instance
          .collection(UserRef.userCollectionRef)
          .where(UserRef.adminId, isEqualTo: userModel!.userId)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(UserRef.userCollectionRef)
          .where(UserRef.type, isEqualTo: userType)
          .snapshots();
    }
  }
}
