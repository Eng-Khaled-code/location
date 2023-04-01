import 'package:location/PL/global/firebase_var_ref/phone_ref.dart';

class PhoneModel
{

  String? userId;
  String? phoneId;
  String? number;

  PhoneModel({this.userId, this.phoneId, this.number});

  factory PhoneModel.fromSnapshot(Map<String,dynamic> data){
    return PhoneModel
      (
        userId: data[PhoneRef.userId]??"",
        phoneId: data[PhoneRef.phoneId]??"",
        number: data[PhoneRef.number]??"",
    );
  }

}