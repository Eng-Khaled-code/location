import 'package:location/PL/global/firebase_var_ref/backup_ref.dart';

class BackupModel {
  String? backupId;
  String? supplierId;
  String? providerId;
  String? providerImage;
  String? providerName;
  String? providerBrand;
  int? waitingCount;
  double? price;
  double? payed;
  int? ordersCount;
  int? deliveredCount;
  int? partialCount;
  int? canceledCount;
  String? date;
  String? userImage;
  String? userName;
  String? brand;
  String? backupType;

  BackupModel(
      {this.backupId,
      this.waitingCount,
      this.price,
      this.payed,
      this.supplierId,
      this.providerId,
      this.backupType,
      this.date,
      this.ordersCount,
      this.deliveredCount,
      this.partialCount,
      this.canceledCount,
      this.userImage,
      this.userName,
      this.brand,
      this.providerBrand,
      this.providerImage,
      this.providerName
      });

  factory BackupModel.fromSnapshot(Map<String, dynamic> data) {
    return BackupModel(
        providerId: data[BackupRef.providerId] ?? "",
        providerBrand: data[BackupRef.providerBrand] ?? "",
        providerImage: data[BackupRef.providerImage] ?? "",
        providerName: data[BackupRef.providerName] ?? "",
        supplierId: data[BackupRef.supplierIdRef] ?? "",
        backupId: data[BackupRef.backupIdRef] ?? "",
        waitingCount: data[BackupRef.waitingCountRef] ?? 0,
        price: data[BackupRef.priceRef].toDouble(),
        payed: data[BackupRef.payedRef].toDouble(),
        ordersCount: data[BackupRef.ordersCountRef] ?? 0,
        deliveredCount: data[BackupRef.deliveredCountRef] ?? 0,
        partialCount: data[BackupRef.partialCountRef] ?? 0,
        canceledCount: data[BackupRef.canceledCountRef] ?? 0,
        date: data[BackupRef.dateRef] ?? "",
        userImage: data[BackupRef.userImage] ?? "",
        userName: data[BackupRef.username] ?? "",
        backupType: data[BackupRef.backupType],
        brand: data[BackupRef.brand] ?? "");
  }
}
