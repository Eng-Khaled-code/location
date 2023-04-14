import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/PL/global/firebase_var_ref/backup_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/services/backup_services.dart';

import '../PL/global/firebase_var_ref/user_ref.dart';

class BackupProvider with ChangeNotifier {
  String selectedType = "الكل";
  String? selectedDate = "";

  bool isLoading = false;
  final BackupServices backupServices = BackupServices();

  Stream<QuerySnapshot<Map<String, dynamic>>> backupsStream(int currentIndex) {
    String userField = currentIndex==0?( userModel!.type == UserRef.providerRef
        ? BackupRef.providerId:BackupRef.supplierIdRef ):(
          userModel!.type == UserRef.supplierRef
        ? BackupRef.providerId:BackupRef.supplierIdRef 
        );

    Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
    if (selectedType == "بحث") {
      stream = FirebaseFirestore.instance
          .collection(BackupRef.collectionRef)
          .where(userField, isEqualTo: userModel!.userId)
          .where(BackupRef.dateRef, isEqualTo: selectedDate)
          .get()
          .asStream();
    } else if (selectedType == "الكل") {
      stream = FirebaseFirestore.instance
          .collection(BackupRef.collectionRef)
          .where(userField, isEqualTo: userModel!.userId)
          .get()
          .asStream();
    } else if (int.tryParse(selectedType)! < 13) {
      //is month
      stream = FirebaseFirestore.instance
          .collection(BackupRef.collectionRef)
          .where(userField, isEqualTo: userModel!.userId)
          .where(BackupRef.monthRef, isEqualTo: DateTime.now().month)
          .where(BackupRef.yearRef, isEqualTo: DateTime.now().year)
          .get()
          .asStream();
    } else {
      //is year
      stream = FirebaseFirestore.instance
          .collection(BackupRef.collectionRef)
          .where(
            userField,
            isEqualTo: userModel!.userId,
          )
          .where(BackupRef.yearRef, isEqualTo: DateTime.now().year)
          .get()
          .asStream();
    }

    return stream;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> usersStream(String backupType) {
        
    Stream<QuerySnapshot<Map<String, dynamic>>> usersStream;
    if(backupType==BackupRef.supplierBackup)
    {
      usersStream= 
    FirebaseFirestore.instance
        .collection(UserRef.userCollectionRef)
        .where(UserRef.type,isEqualTo: UserRef.supplierRef)
        .get()
        .asStream();
    }
     else
     {
      usersStream= 
    FirebaseFirestore.instance
        .collection(UserRef.userCollectionRef)
        .where(UserRef.adminId,isEqualTo: userModel!.userId)
        .get()
        .asStream();}
    return usersStream;
  }

  refresh() {
    notifyListeners();
  }

  setType(String type) {
    selectedType = type;
    notifyListeners();
  }

  setDate(String date) {
    selectedDate = date;
    notifyListeners();
  }

  Future<void> addBackup({String? otherUserId,String? image ,String? backupType,String?name,String? brand }) async {
    try {
      await backupServices.addBackupServices(backupType: backupType,brand:brand,otherUserId: otherUserId,image: image,name: name);
      notifyListeners();
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.toString());
      notifyListeners();
    }
  }

  Future<void> deleteBackup({String? backupId}) async {
    try {
      await backupServices.deleteBackupServices(backId: backupId);
      notifyListeners();
    } catch (ex) {
      Fluttertoast.showToast(msg: ex.toString());
      notifyListeners();
    }
  }
}
