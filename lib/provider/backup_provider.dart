import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/PL/global/firebase_var_ref/backup_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/services/backup_services.dart';

class BackupProvider with ChangeNotifier
{

  String selectedType="الكل";
  String? selectedDate="";

  bool isLoading=false;
  final BackupServices backupServices=BackupServices();

  Stream<QuerySnapshot<Map<String, dynamic>>> backupsStream(){
    Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
    if(selectedType=="بحث"){
      stream =
          FirebaseFirestore
              .instance
              .collection(BackupRef.collectionRef)
              .where(BackupRef.userIdRef,isEqualTo: userModel!.userId)
              .where(BackupRef.dateRef,isEqualTo:selectedDate)
              .get()
              .asStream();

    }
    else if(selectedType=="الكل"){
    stream =
    FirebaseFirestore
        .instance
        .collection(BackupRef.collectionRef)
        .where(BackupRef.userIdRef,isEqualTo: userModel!.userId)
        .get()
        .asStream();

    }
    else if(int.tryParse(selectedType)! < 13)
    {
      //is month
      stream =
          FirebaseFirestore
              .instance
              .collection(BackupRef.collectionRef)
              .where(BackupRef.userIdRef,isEqualTo: userModel!.userId)
              .where(BackupRef.monthRef,isEqualTo: DateTime.now().month)
              .where(BackupRef.yearRef,isEqualTo:DateTime.now().year )
              .get()
              .asStream();
    }
    else
    {
      //is year

      stream =
          FirebaseFirestore
              .instance
              .collection(BackupRef.collectionRef)
              .where(BackupRef.userIdRef,isEqualTo: userModel!.userId,)
              .where(BackupRef.yearRef,isEqualTo:DateTime.now().year )
              .get()
              .asStream();
    }

    return stream;
  }

  refresh(){
    notifyListeners();
  }
  setType(String type){
    selectedType=type;
    notifyListeners();
  }

  setDate(String date){
    selectedDate=date;
    notifyListeners();
  }

  Future<void> addBackup()async{
    try {
      await backupServices.addBackupServices();
      notifyListeners();
    }
    catch(ex)
    {
      Fluttertoast.showToast(msg:ex.toString());
      notifyListeners();
    }

  }


  Future<void> deleteBackup({String? backupId})async{
    try {
      await backupServices.deleteBackupServices(backId: backupId);
      notifyListeners();
    }
    catch(ex)
    {
      Fluttertoast.showToast(msg:ex.toString())  ;
      notifyListeners();
    }

  }
}