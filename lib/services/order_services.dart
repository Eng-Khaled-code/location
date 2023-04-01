import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/PL/global/firebase_var_ref/backup_ref.dart';
import 'package:location/PL/global/firebase_var_ref/order_ref.dart';
import 'package:location/PL/global/firebase_var_ref/user_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';

import '../PL/global/firebase_var_ref/notify_ref.dart';
class OrdersServices
{
  final FirebaseFirestore firestore=FirebaseFirestore.instance;
 
  addOrderServices({Map<String,dynamic>? data ,String? backupDate,})async{
    final batch = firestore.batch();
     var orderDoc=firestore.collection(OrderRef.ordersCollectionRef).doc(data![OrderRef.orderId]);

     batch.set(orderDoc, data);

    var backUpDoc=firestore.collection(BackupRef.collectionRef).doc(data[OrderRef.backupId]);
    batch.update(backUpDoc, {
      BackupRef.ordersCountRef:FieldValue.increment(1),
      BackupRef.waitingCountRef:FieldValue.increment(1),
      BackupRef.priceRef:FieldValue.increment(data[OrderRef.price])
    });

    var notification=firestore.collection(NotifyRef.notifyCollectionRef);
    
    QuerySnapshot<Map<String,dynamic>> admins=await firestore.collection(UserRef.userCollectionRef)
        .where(UserRef.type,isEqualTo: UserRef.adminRef).get();

    for (var element in admins.docs) {

    String userId=  element.get(UserRef.userId);
    String token=  element.get(UserRef.token);
    String date=DateTime.now().microsecondsSinceEpoch.toString();
    var doc= notification.doc(date);

    Map<String,dynamic> notifyData={
      NotifyRef.date:date,
      NotifyRef.fromName:userModel!.userName,
      NotifyRef.fromId:userModel!.userId,
      NotifyRef.fromImage:userModel!.image,
      NotifyRef.content:"${"تم إضافة طلب جديد يإسم "+data[OrderRef.customerName]} العنوان : "+data[OrderRef.address],
      NotifyRef.contentId:data[OrderRef.backupId],
      NotifyRef.status:NotifyRef.notOpenedRef,
      NotifyRef.type:NotifyRef.orderRef,
      NotifyRef.notifyId:date,
      NotifyRef.toId:userId,
      NotifyRef.backupDate:backupDate

    };

     batch.set(doc,notifyData);

     //sending push notification here
    sendNotificationToAdmin(token);

    }

    await batch
         .commit()
         .then((value){
           Fluttertoast.showToast(msg: "تم إضافة الطلب بنجاح");
         });
  }

  sendNotificationToAdmin(String token){

    ;
  }

  updateOrderServices({Map<String,dynamic>? data ,String? backupDate,double? oldPrice})async{
    final batch = firestore.batch();
    var updateDoc=firestore.collection(OrderRef.ordersCollectionRef).doc(data![OrderRef.orderId]);
    batch.update(updateDoc,data);
    var updateBackUpDoc=firestore.collection(BackupRef.collectionRef).doc(data[OrderRef.backupId]);
    double newPrice=-oldPrice!+data[OrderRef.price];
    batch.update(updateBackUpDoc, {
     BackupRef.priceRef:FieldValue.increment(newPrice),
    });


    var notification=firestore.collection(NotifyRef.notifyCollectionRef);

    QuerySnapshot<Map<String,dynamic>> admins=await firestore.collection(UserRef.userCollectionRef)
        .where(UserRef.type,isEqualTo: UserRef.adminRef).get();

    for (var element in admins.docs) {

      String userId=  element.get(UserRef.userId);
      String token=  element.get(UserRef.token);
      String date=DateTime.now().microsecondsSinceEpoch.toString();
      var doc= notification.doc(date);

      Map<String,dynamic> notifyData={
        NotifyRef.date:date,
        NotifyRef.fromName:userModel!.userName,
        NotifyRef.fromId:userModel!.userId,
        NotifyRef.fromImage:userModel!.image,
        NotifyRef.content:"تم تعديل الطلب "+data[OrderRef.customerName]+" العنوان : "+data[OrderRef.address],
        NotifyRef.contentId:data[OrderRef.backupId],
        NotifyRef.status:NotifyRef.notOpenedRef,
        NotifyRef.type:NotifyRef.orderRef,
        NotifyRef.notifyId:date,
        NotifyRef.toId:userId,
        NotifyRef.backupDate:backupDate

      };

      batch.set(doc,notifyData);

      //sending push notification here
      sendNotificationToAdmin(token);

    }


    await batch
        .commit()
        .then((value) =>Fluttertoast.showToast(msg: "تم تعديل الطلب بنجاح"));
  }
  
  deleteOrderServices({String? orderId,String? backupDate,String? backupId,double? price,String? customerName,String? address})async{
    final batch = firestore.batch();
    var addDoc=firestore.collection(OrderRef.ordersCollectionRef).doc(orderId);

    batch.delete(addDoc);

    var updateBackUpDoc= firestore.collection(BackupRef.collectionRef).doc(backupId);
     batch.update(updateBackUpDoc, {
       BackupRef.ordersCountRef:FieldValue.increment(-1),
       BackupRef.waitingCountRef:FieldValue.increment(-1) ,
       BackupRef.priceRef:FieldValue.increment(-price!)
     });

    var notification=firestore.collection(NotifyRef.notifyCollectionRef);

    QuerySnapshot<Map<String,dynamic>> admins=await firestore.collection(UserRef.userCollectionRef)
        .where(UserRef.type,isEqualTo: UserRef.adminRef).get();

    for (var element in admins.docs) {

      String userId=  element.get(UserRef.userId);
      String token=  element.get(UserRef.token);
      String date=DateTime.now().microsecondsSinceEpoch.toString();
      var doc= notification.doc(date);

      Map<String,dynamic> notifyData={
        NotifyRef.date:date,
        NotifyRef.fromName:userModel!.userName,
        NotifyRef.fromId:userModel!.userId,
        NotifyRef.fromImage:userModel!.image,
        NotifyRef.content:"تم حذف الطلب ${customerName!} العنوان : ${address!}",
        NotifyRef.contentId:backupId,
        NotifyRef.status:NotifyRef.notOpenedRef,
        NotifyRef.type:NotifyRef.orderRef,
        NotifyRef.notifyId:date,
        NotifyRef.toId:userId,
        NotifyRef.backupDate:backupDate
      };

      batch.set(doc,notifyData);

      //sending push notification here
      sendNotificationToAdmin(token);

    }


    await batch.commit()
        .then((value) =>Fluttertoast.showToast(msg: "تم حذف الطلب بنجاح"));
  }
  
  
  
}