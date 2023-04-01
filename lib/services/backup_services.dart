import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/PL/global/firebase_var_ref/backup_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
class BackupServices
{
  final FirebaseFirestore firestore=FirebaseFirestore.instance;
 
  addBackupServices()async{
    DateTime dateTime=DateTime.now();
    String docId=dateTime.microsecondsSinceEpoch.toString();
    String date="${dateTime.year}-${dateTime.month}-${dateTime.day}";
    Map<String,dynamic> data={
      BackupRef.backupIdRef:docId,
      BackupRef.userIdRef:userModel!.userId,
      BackupRef.waitingCountRef:0,
      BackupRef.priceRef:0.0,
      BackupRef.payedRef:0.0,
      BackupRef.ordersCountRef:0,
      BackupRef.canceledCountRef:0,
      BackupRef.deliveredCountRef:0,
      BackupRef.partialCountRef:0,
      BackupRef.dateRef:date,
      BackupRef.monthRef:dateTime.month,
      BackupRef.yearRef:dateTime.year
    };

    await firestore.collection(BackupRef.collectionRef).doc(docId).set(data)
        .then((value) =>Fluttertoast.showToast(msg: "تم إضافة ال Backup بنجاح"))
        .catchError((error)=>Fluttertoast.showToast(msg:error.toString()));
  }
  deleteBackupServices({String? backId})async{
    await firestore.collection(BackupRef.collectionRef).doc(backId).delete()
        .then((value) =>Fluttertoast.showToast(msg: "تم حذف ال Backup بنجاح"))
        .catchError((error)=>Fluttertoast.showToast(msg:error.toString()));
  }
}