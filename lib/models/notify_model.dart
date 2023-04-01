import 'package:location/PL/global/firebase_var_ref/notify_ref.dart';

class NotifyModel{

  String? notifyId;
  String? date ;
  String? type ;
  String? content ;
  String? contentId ;
  String? backupDate ;
  String? fromId ;
  String? fromName;
  String? fromImage ;
  String? toId ;
  String? status;

  NotifyModel({this.backupDate,this.contentId,this.notifyId, this.date, this.type, this.content, this.fromId,
      this.fromName, this.fromImage, this.toId, this.status});

  factory NotifyModel.fromSnapshot(Map<String,dynamic> data){
    return NotifyModel
      (
      notifyId: data[NotifyRef.notifyId]??"",
      date: data[NotifyRef.date]??"",
      type: data[NotifyRef.type]??"",
      content: data[NotifyRef.content]??"",
      fromId: data[NotifyRef.fromId]??"",
      fromName: data[NotifyRef.fromName]??"",
      toId: data[NotifyRef.toId]??"",
      fromImage: data[NotifyRef.fromImage]??"",
      status: data[NotifyRef.status]??"",
      contentId: data[NotifyRef.contentId]??"",
      backupDate: data[NotifyRef.backupDate]??""
    );
  }

}