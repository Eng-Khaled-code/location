import 'package:location/PL/global/firebase_var_ref/backup_ref.dart';
class BackupModel
{

   String? backupId;
   String? userId;
   int? waitingCount;
   double? price;
   double? payed;
   int? ordersCount;
   int? deliveredCount;
   int? partialCount;
   int? canceledCount;
   String? date;

   BackupModel({
      this.backupId,
      this.waitingCount,
      this.price,
      this.payed,
      this.userId,
       this.date,
      this.ordersCount,
      this.deliveredCount,
      this.partialCount,
      this.canceledCount,
      });

  factory BackupModel.fromSnapshot(Map<String,dynamic> data){
    return BackupModel
      (
        userId: data[BackupRef.userIdRef]??"",
        backupId: data[BackupRef.backupIdRef]??"",
      waitingCount: data[BackupRef.waitingCountRef]??0,
      price: data[BackupRef.priceRef]??0.0,
      payed: data[BackupRef.payedRef]??0.0,
      ordersCount: data[BackupRef.ordersCountRef]??0,
      deliveredCount: data[BackupRef.deliveredCountRef]??0,
      partialCount: data[BackupRef.partialCountRef]??0,
      canceledCount: data[BackupRef.canceledCountRef]??0,
      date: data[BackupRef.dateRef]??""
    );
  }

}