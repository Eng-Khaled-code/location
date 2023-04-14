import '../PL/global/firebase_var_ref/order_ref.dart';
import '../PL/global/firebase_var_ref/user_ref.dart';

class OrderModel
{
      String? orderId;
      String? supplierBackupId;
      String? customerName;
      String? phone;
      String? phone2;
      String? address;
      String? status;
      String? providerBackupId;
      double? price;
      double? chargeValue;
      double? providerPayed;
      double? supplierPayed;
      String? date;
      String? proId;
      String? proImage;
      String? proName;
      String? proBrand;
      OrderModel({
          this.orderId,
          this.customerName,
          this.phone,
          this.phone2,
          this.address,
          this.status,
          this.providerBackupId,
          this.price,
          this.chargeValue,
          this.supplierBackupId,
          this.supplierPayed,
          this.providerPayed,
          this.date,
       this.proBrand,
       this.proId,this.proImage,
       this.proName
      });

      factory OrderModel.fromSnapshot(Map<String,dynamic> data){
        return OrderModel
          (
            orderId: data[OrderRef.orderId]??"",
            providerBackupId: data[OrderRef.providerBackupId]??"",
            supplierBackupId: data[OrderRef.supplierBackupId]??"",
            chargeValue: data[OrderRef.chargeValue].toDouble(),
            price: data[OrderRef.price].toDouble(),
            providerPayed: data[OrderRef.providerPayed].toDouble(),
            supplierPayed: data[OrderRef.supplierPayed].toDouble(),
            customerName: data[OrderRef.customerName]??"",
            address: data[OrderRef.address]??"",
            phone: data[OrderRef.phone]??"",
            phone2: data[OrderRef.phone2]??"",
            date: data[OrderRef.date]??"",
            status: data[OrderRef.status]??"",
            proId: data[OrderRef.providerId]??"",
            proBrand: data[UserRef.brand]??"",
            proImage: data[UserRef.image]??"",
            proName: data[UserRef.username]??"",
        );


}

}