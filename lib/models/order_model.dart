import '../PL/global/firebase_var_ref/order_ref.dart';

class OrderModel
{
      String? orderId;
      String? backupId;
      String? customerName;
      String? phone;
      String? phone2;
      String? address;
      String? providerStatus;
      String? providerId;
      String? supplierStatus;
      String? supplierId;
      double? price;
      double? chargeValue;
      double? payed;
      String? date;

      OrderModel({
          this.orderId,
          this.customerName,
          this.phone,
          this.phone2,
          this.address,
          this.providerStatus,
          this.providerId,
          this.price,
          this.chargeValue,
          this.backupId,
          this.payed,
          this.date,
          this.supplierId,
          this.supplierStatus
      });

      factory OrderModel.fromSnapshot(Map<String,dynamic> data){
        return OrderModel
          (
            orderId: data[OrderRef.orderId]??"",
            backupId: data[OrderRef.backupId]??"",
            chargeValue: data[OrderRef.chargeValue]??0.0,
            price: data[OrderRef.price]??0.0,
            payed: data[OrderRef.payed]??0.0,
            customerName: data[OrderRef.customerName]??"",
            address: data[OrderRef.address]??"",
            phone: data[OrderRef.phone]??"",
            phone2: data[OrderRef.phone2]??"",
            date: data[OrderRef.date]??"",
            providerId: data[OrderRef.providerId]??"",
            providerStatus: data[OrderRef.providerStatus]??"",
            supplierStatus: data[OrderRef.supplierStatus]??"",
            supplierId: data[OrderRef.supplierId]??"",

        );


}

}