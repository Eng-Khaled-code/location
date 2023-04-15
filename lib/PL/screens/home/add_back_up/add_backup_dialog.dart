import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../models/user_model.dart';
import '../../../../provider/backup_provider.dart';
import 'card.dart';

// ignore: must_be_immutable
class AddBackupDialog extends StatefulWidget {
  const AddBackupDialog({super.key,this.backupType});
  final String? backupType;
  @override
  State<AddBackupDialog> createState() => _AddBackupDialogState();
}

class _AddBackupDialogState extends State<AddBackupDialog> {
  String currentUserId = "";
  String username = "";
  String userImage = "";
  String brand = "";
  @override
  Widget build(BuildContext context) {
    BackupProvider backupProvider = Provider.of<BackupProvider>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text("إضافة BackUp"),
          content: SizedBox(
            height: 200,
            width: 200,
            child: StreamBuilder(
                stream: backupProvider.usersStream(widget.backupType!),
                builder: (context, snapshot) => !snapshot.hasData
                    ? const CupertinoActivityIndicator()
                    : snapshot.data!.size == 0
                        ? const Text("لايوجد")
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.size,
                            itemBuilder: (context, position) {
                              UserModel userModel = UserModel.fromSnapshot(
                                  snapshot.data!.docs[position].data());
                              return DialogCard(
                                userModel: userModel,
                                currentUserId: currentUserId,
                                ontap: () => setState(() {
                                  currentUserId = userModel.userId!;
                                  userImage = userModel.image!;
                                  username = userModel.userName!;
                                  brand = userModel.brand!;
                                }),
                              );
                            },
                          )),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (currentUserId != "") {
                    Navigator.pop(context);
                    Provider.of<BackupProvider>(context, listen: false)
                        .addBackup(
                      otherUserId: currentUserId,
                      name: username,
                      backupType: widget.backupType,
                      image: userImage,
                      brand: brand,
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: "يجب ان تختار شخص",
                        toastLength: Toast.LENGTH_LONG);
                  }
                },
                child: const Text("اضافة")),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("الغاء"))
          ],
        ));
  }
}
