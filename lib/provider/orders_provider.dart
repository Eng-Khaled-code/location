import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/PL/global/firebase_var_ref/order_ref.dart';
import 'package:location/models/order_model.dart';
import 'package:location/services/order_services.dart';

class OrdersProvider with ChangeNotifier{
  bool isLoading=false;
  OrdersServices ordersServices=OrdersServices();

  int ordersCount=0,deliveredCount=0,canceledCount=0,partialCount=0,waitingCount=0;
  double totalPrice=0.0,totalPayed=0.0;

  refresh(){
    notifyListeners();
  }


  Stream getOrdersStream(String backupId)=>FirebaseFirestore.instance.collection(OrderRef.ordersCollectionRef)
      .where(OrderRef.backupId,isEqualTo: backupId).get().asStream();

  void resettingStatistics(){
  ordersCount=0;
  deliveredCount=0;
  canceledCount=0;
  partialCount=0;
  waitingCount=0;
  totalPrice=0.0;
  totalPayed=0.0;
}

  void setStatisticsValues(OrderModel orderModel) {

    totalPrice+=orderModel.price!.toDouble();
    totalPayed+=orderModel.payed!.toDouble();

    ordersCount++;

    orderModel.providerStatus==OrderRef.partial
        ?
    partialCount++
        :
    orderModel.providerStatus==OrderRef.delivered
        ?
    deliveredCount++
        :
    orderModel.providerStatus==OrderRef.canceled
        ?
    canceledCount++
        :
    waitingCount++
    ;

  }

  addOrder({Map<String,dynamic>? data ,String? backupDate,BuildContext? context})async {
    try {
      isLoading=true;
      notifyListeners();
      await ordersServices.addOrderServices(data: data,backupDate: backupDate);
      Navigator.pop(context!);
      isLoading=false;
      notifyListeners();

    }
    catch(ex)
    {
      isLoading=false;
      Fluttertoast.showToast(msg:ex.toString());
      notifyListeners();
    }


  }

  updateOrder({Map<String,dynamic>? data ,double? oldPrice,String? backupDate,BuildContext? context})async{
    try {
      isLoading=true;
      notifyListeners();
      await ordersServices.updateOrderServices(data: data,oldPrice: oldPrice,backupDate: backupDate);
      isLoading=false;

      Navigator.pop(context!);
      notifyListeners();
    }

    catch(ex)
    {
      Fluttertoast.showToast(msg:ex.toString());
      isLoading=false;

      notifyListeners();
    }

  }

  deleteOrder({String? orderId,String? backupId,double? price,String? customerName,String? backupDate,String? address})async{
    try {

      await ordersServices.deleteOrderServices(orderId: orderId,backupId: backupId,price: price,backupDate: backupDate);
      notifyListeners();
    }
    catch(ex)
    {
      Fluttertoast.showToast(msg:ex.toString());
      notifyListeners();
    }

  }


}