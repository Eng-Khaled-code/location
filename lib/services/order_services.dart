import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/PL/global/firebase_var_ref/backup_ref.dart';
import 'package:location/PL/global/firebase_var_ref/order_ref.dart';
import 'package:location/PL/global/firebase_var_ref/user_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import '../PL/global/firebase_var_ref/notify_ref.dart';
import 'notify_services.dart';

class OrdersServices {
  final NotifyServices notifyServices = NotifyServices();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addOrderServices(
      {Map<String, dynamic>? data,
      String? notifyUserId}) async {
    final batch = firestore.batch();
    var orderDoc = firestore
        .collection(OrderRef.ordersCollectionRef)
        .doc(data![OrderRef.orderId]);
    batch.set(orderDoc, data);

    var backUpDoc = firestore
        .collection(BackupRef.collectionRef)
        .doc(data[OrderRef.providerBackupId]);
    Map<String, dynamic> backupIncrementation = {
      BackupRef.ordersCountRef: FieldValue.increment(1),
      BackupRef.waitingCountRef: FieldValue.increment(1),
      BackupRef.priceRef: FieldValue.increment(data[OrderRef.price])
    };

    batch.update(backUpDoc, backupIncrementation);

    await batch.commit().then((value) async {
      String? content =
          "تم إضافة طلب جديد بإسم ${data[OrderRef.customerName]} العنوان : ${data[OrderRef.address]}";
      await sendNotify(
          toId: notifyUserId,
          content: content,
          backupId: data[OrderRef.providerBackupId],
          );

      Fluttertoast.showToast(msg: "تم إضافة الطلب بنجاح");
    });
  }

  Future<void> changeOrderStatus(
      {String? orderId,
      String? status,
      String?oldStatus,
      double? proValue,
      double? supValue,
      String? providerBackupId,
      String? supplierBackupId,
      String?notifyUserId,
      String? custName,
      String? custAddress,
      }) async {
    final batch = firestore.batch();
    DocumentReference orderDoc =
        firestore.collection(OrderRef.ordersCollectionRef).doc(orderId);
    batch.update(orderDoc, 
    {
      OrderRef.providerPayed: FieldValue.increment( proValue!),
       OrderRef.supplierPayed: FieldValue.increment( supValue!),
       OrderRef.status: status});
   
    DocumentReference proBackupDoc =
        firestore.collection(BackupRef.collectionRef).doc(providerBackupId!);
    DocumentReference supBackupDoc =
        firestore.collection(BackupRef.collectionRef).doc(supplierBackupId!);
     
     String newStatusfield=status==OrderRef.canceled?BackupRef.canceledCountRef:status==OrderRef.delivered?BackupRef.deliveredCountRef:status==OrderRef.waiting?BackupRef.waitingCountRef:BackupRef.partialCountRef;
     String oldStatusfield=oldStatus==OrderRef.canceled?BackupRef.canceledCountRef:oldStatus==OrderRef.delivered?BackupRef.deliveredCountRef:oldStatus==OrderRef.waiting?BackupRef.waitingCountRef:BackupRef.partialCountRef;

    batch.update(proBackupDoc, {
      BackupRef.payedRef: FieldValue.increment(proValue),
      newStatusfield:FieldValue.increment(1),
      oldStatusfield:FieldValue.increment(-1)
    });

    batch.update(supBackupDoc, {
      BackupRef.payedRef: FieldValue.increment(supValue),
      newStatusfield:FieldValue.increment(1),
      oldStatusfield:FieldValue.increment(-1)
    });

    await batch.commit().then((value)async{
 String? content =
          "تم تغيير حالة الطلب $custName العنوان : $custAddress $status الي";
      await sendNotify(
          toId: notifyUserId,
          content: content,
          backupId: providerBackupId,
          );

      Fluttertoast.showToast(msg: content);

    } );
  }

  Future<void> addMiniSuppliersOrder(
      {List<String>? ordersIds,
      String? supplierBackupId,
      String? notifyUserId}) async {
    final batch = firestore.batch();
    double totalPrice = 0;
    for (String orderId in ordersIds!) {
      var orderDoc =
          firestore.collection(OrderRef.ordersCollectionRef).doc(orderId);
      DocumentSnapshot<Map<String, dynamic>> doc = await orderDoc.get();

      totalPrice += doc.get(OrderRef.price) + doc.get(OrderRef.chargeValue);

      batch.update(orderDoc, {OrderRef.supplierBackupId: supplierBackupId});
    }

    var backupDoc =
        firestore.collection(BackupRef.collectionRef).doc(supplierBackupId);
    batch.update(
        backupDoc, {
          BackupRef.ordersCountRef: FieldValue.increment(ordersIds.length),
          BackupRef.waitingCountRef: FieldValue.increment(ordersIds.length),
          BackupRef.priceRef: FieldValue.increment(totalPrice)});

    await batch.commit().then((value) async {
      String? content = "تم ارسال طلبات جديدة لك";
      await sendNotify(
          toId: notifyUserId,
          content: content,
          backupId: supplierBackupId,
          );

      Fluttertoast.showToast(msg: "تم إضافة الطلبات بنجاح");
    });
  }

  Future<void> updateOrderServices(
      {Map<String, dynamic>? data,
      String? notifyUserId,
      double? oldPrice,
      String? updateOrRemove}) async {
    final batch = firestore.batch();

    var updateDoc = firestore
        .collection(OrderRef.ordersCollectionRef)
        .doc(data![OrderRef.orderId]);

    batch.update(updateDoc, {OrderRef.supplierBackupId: ""});

    var updateBackUpDoc = firestore.collection(BackupRef.collectionRef).doc(
        data[updateOrRemove == "update"
            ? OrderRef.providerBackupId
            : OrderRef.supplierBackupId]);

    double newPrice = updateOrRemove == "update"
        ? (-oldPrice! + data[OrderRef.price])
        : (-oldPrice!);
var backupData=updateOrRemove == "update" ?
{      BackupRef.priceRef: FieldValue.increment(newPrice)}
:
{
      BackupRef.priceRef: FieldValue.increment(newPrice),
      BackupRef.ordersCountRef: FieldValue.increment(-1),
      BackupRef.waitingCountRef: FieldValue.increment(-1),
    };

    batch.update(updateBackUpDoc,backupData);

    await batch.commit().then((value) async {
      String contentFirstPart =
          updateOrRemove == "update" ? "تم تعديل الطلب " : "تم حذف الطلب";
      String content =
          "$contentFirstPart ${data[OrderRef.customerName]}   العنوان : ${data[OrderRef.address]}";
      await sendNotify(
          toId: notifyUserId,
          content: content,
          backupId: data[updateOrRemove == "update"
              ? OrderRef.providerBackupId
              : OrderRef.supplierBackupId],
          );

      Fluttertoast.showToast(msg: contentFirstPart);
    });
  }

  Future<void> sendNotify(
      {String? content,
      String? backupId,
      String? toId,
      }) async {
    await firestore
        .collection(UserRef.userCollectionRef)
        .doc(toId)
        .get()
        .then((notifyUser) async {
      String token = notifyUser.get(UserRef.token);
      Map<String, dynamic> notifyData = {
        NotifyRef.notifyId: DateTime.now().microsecondsSinceEpoch.toString(),
        NotifyRef.fromName: userModel!.userName,
        NotifyRef.fromId: userModel!.userId,
        NotifyRef.fromImage: userModel!.image,
        NotifyRef.content: content,
        NotifyRef.contentId: backupId,
        NotifyRef.status: NotifyRef.notOpenedRef,
        NotifyRef.type: NotifyRef.orderRef,
        NotifyRef.toId: toId,
      };

      await notifyServices.addNotify(notifyData, token);
    });
  }

  Future<void> deleteOrderServices(
      {String? orderId,
      String? backupId,
      String? notifyUserId,
      double? price,
      String? customerName,
      String? address}) async {
    final batch = firestore.batch();
    var addDoc =
        firestore.collection(OrderRef.ordersCollectionRef).doc(orderId);

    batch.delete(addDoc);

    var updateBackUpDoc =
        firestore.collection(BackupRef.collectionRef).doc(backupId);
    batch.update(updateBackUpDoc, {
      BackupRef.ordersCountRef: FieldValue.increment(-1),
      BackupRef.waitingCountRef: FieldValue.increment(-1),
      BackupRef.priceRef: FieldValue.increment(-price!)
    });

    await batch.commit().then((value) async {
      String? content = "تم حذف الطلب ${customerName!} العنوان : ${address!}";
      await sendNotify(
          toId: notifyUserId,
          content: content,
          backupId: backupId,
          );
      Fluttertoast.showToast(msg: "تم حذف الطلب بنجاح");
    });
  }
}
