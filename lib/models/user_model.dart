import 'package:location/PL/global/firebase_var_ref/user_ref.dart';

class UserModel
{

  String? userId;
  String? userName;
  String? address;
  String? type;
  String? email;
  String? password;
  String? status;
  String? reason;
  String? token;
  String? brand;
  String? image;


  UserModel({this.brand,this.image,this.userId, this.userName, this.address, this.type,
      this.email, this.password, this.status, this.reason, this.token});

  factory UserModel.fromSnapshot(Map<String,dynamic> data){
    return UserModel
      (
        userId: data[UserRef.userId]??"",
        userName: data[UserRef.username]??"",
        email: data[UserRef.email]??"",
        password: data[UserRef.password]??"",
        address: data[UserRef.address]??"",
        status: data[UserRef.status]??"",
        reason: data[UserRef.reason]??"",
        type: data[UserRef.type]??"",
        token: data[UserRef.token]??"",
        brand: data[UserRef.brand]??"",
        image: data[UserRef.image]??"",
    );
  }

}