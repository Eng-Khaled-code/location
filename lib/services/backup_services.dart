import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/PL/global/firebase_var_ref/backup_ref.dart';
import 'package:location/PL/global/firebase_var_ref/user_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
class BackupServices
{
  final FirebaseFirestore firestore=FirebaseFirestore.instance;
 
  addBackupServices({String? otherUserId,String? image ,String?name,String? brand
   ,String? backupType})async{
    DateTime dateTime=DateTime.now();
    String docId=dateTime.microsecondsSinceEpoch.toString();
    String date=dateTime.toString().substring(0,10);
    
    //لو انا في تطبيق المورد اذا ال id الاساسي هو proId والموزع هو ال supId
    //لو انا في تطبيق الموزع اذا ال id الاساسي هو proId والمندوب هو ال supId
 
    Map<String,dynamic> data={
      BackupRef.backupIdRef:docId,   
      BackupRef.backupType:backupType,
      BackupRef.providerId:userModel!.userId,
      BackupRef.providerName:userModel!.userName,
      BackupRef.providerImage:userModel!.image,
      BackupRef.providerBrand:userModel!.brand,
      BackupRef.supplierIdRef:otherUserId,
      BackupRef.userImage:image,
      BackupRef.username:name,
      BackupRef.waitingCountRef:0,
      BackupRef.priceRef:0.0,
      BackupRef.payedRef:0.0,
      BackupRef.ordersCountRef:0,
      BackupRef.canceledCountRef:0,
      BackupRef.deliveredCountRef:0,
      BackupRef.partialCountRef:0,
      BackupRef.dateRef:date,
      BackupRef.monthRef:dateTime.month,
      BackupRef.yearRef:dateTime.year,
      UserRef.brand:brand
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