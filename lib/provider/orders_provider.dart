import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/PL/global/firebase_var_ref/backup_ref.dart';
import 'package:location/PL/global/firebase_var_ref/order_ref.dart';
import 'package:location/services/order_services.dart';
import '../PL/global/global_variables/global_variables.dart';

class OrdersProvider with ChangeNotifier {
  bool isLoading = false;
  OrdersServices ordersServices = OrdersServices();

  refresh() {
    notifyListeners();
  }

  Stream getOrdersStream(String backupId, String backupType) =>
      FirebaseFirestore.instance
          .collection(OrderRef.ordersCollectionRef)
          .where(
              backupType==BackupRef.supplierBackup
                  ? OrderRef.providerBackupId
                  : OrderRef.supplierBackupId,
              isEqualTo: backupId)
          .get()
          .asStream();

  Stream getBackupByIdStream(String backupId) => FirebaseFirestore.instance
      .collection(BackupRef.collectionRef).doc(backupId)
      .get()
      .asStream();
  Stream getSupOrdersStream() => FirebaseFirestore.instance
      .collection(OrderRef.ordersCollectionRef)
      .where(OrderRef.supplierBackupId, isEqualTo: "")
      .where(OrderRef.supplierId, isEqualTo: userModel!.userId)
      .get()
      .asStream();


  Future<void> changeOrderStatus(
       {String? orderId,
      String? status,
      double? proValue,
      double? supValue,
      String? providerBackupId,
      String?oldStatus,
      String? supplierBackupId,
      String?notifyUserId,
      String? custName,
      String? custAddress,
      }) async {

try {
      isLoading = true;
      notifyListeners();
      await ordersServices.changeOrderStatus(
          orderId: orderId,
          oldStatus: oldStatus,
          status: status,
          proValue: proValue,
          supValue: supValue,
          supplierBackupId: supplierBackupId,
          providerBackupId: providerBackupId,
          custAddress: custAddress,
          custName: custName,
            notifyUserId: notifyUserId
            );
      isLoading = false;
      notifyListeners();
    }on FirebaseException catch (ex) {
      isLoading = false;
      Fluttertoast.showToast(msg: ex.message!);
      notifyListeners();
    }
      }
  addOrder(
      {Map<String, dynamic>? data,
      String? notifyUserId,
      String? backupDate,
      BuildContext? context}) async {
    try {
      isLoading = true;
      notifyListeners();
      await ordersServices.addOrderServices(
          data: data, notifyUserId: notifyUserId);
      Navigator.pop(context!);
      isLoading = false;
      notifyListeners();
    }on FirebaseException catch (ex) {
      isLoading = false;
      Fluttertoast.showToast(msg: ex.message!);
      notifyListeners();
    }
  }

  Future<void> addMiniSuppliersOrder(
      {List<String>? ordersIds,
      String? supplierBackupId,
      String? notifyUserId,
      BuildContext? context}) async {
    try {
      isLoading = true;
      notifyListeners();
      await ordersServices.addMiniSuppliersOrder(
          notifyUserId: notifyUserId,
          ordersIds: ordersIds,
          supplierBackupId: supplierBackupId);
      isLoading = false;

      notifyListeners();
    } on FirebaseException catch (ex) {
      Fluttertoast.showToast(msg: ex.message!);
      isLoading = false;
      notifyListeners();
    }
  }

  updateOrder(
      {Map<String, dynamic>? data,
      String? notifyUserId,
      double? oldPrice,
      String? updateOrRemove = "update",
      BuildContext? context}) async {
    try {
      isLoading = true;
      notifyListeners();
      await ordersServices.updateOrderServices(
          notifyUserId: notifyUserId,
          data: data,
          oldPrice: oldPrice,
          updateOrRemove: updateOrRemove);
      isLoading = false;

      Navigator.pop(context!);
      notifyListeners();
    } on FirebaseException catch (ex) {
      Fluttertoast.showToast(msg: ex.message!);
      isLoading = false;
      notifyListeners();
    }
  }

  deleteOrder(
      {String? notifyUserId,
      String? orderId,
      String? backupId,
      double? price,
      String? customerName,
      String? address}) async {
    try {
      await ordersServices.deleteOrderServices(
          notifyUserId: notifyUserId,
          orderId: orderId,
          backupId: backupId,
          price: price,
          customerName: customerName,
          address: address,
          );
      notifyListeners();
    } on FirebaseException catch (ex) {
      Fluttertoast.showToast(msg: ex.message!);

      notifyListeners();
    }
  }
}
