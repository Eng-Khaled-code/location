
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/PL/global/firebase_var_ref/phone_ref.dart';
import 'package:location/PL/global/firebase_var_ref/user_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/global_variables/screen_controller_ref.dart';
import 'package:location/models/user_model.dart';

class UserServices
{
  final FirebaseFirestore firestore=FirebaseFirestore.instance;
  final GetStorage storage=GetStorage();
  Future<UserModel> loadUserData({String? userId})async
  {
       DocumentSnapshot<Map<String,dynamic>> value=  await firestore
         .collection(UserRef.userCollectionRef)
         .doc(userId!)
         .get();


    return UserModel.fromSnapshot(value.data()!);

  }
  Future<void> phoneOperationsService({String? type="",String? phoneId="",String? number=""})async
  {
    String docId=DateTime.now().microsecondsSinceEpoch.toString();
    DocumentReference docRef= firestore.collection(PhoneRef.phoneCollectionRef).doc(type == "add"?docId:phoneId);

    if (type == "add"){
        await docRef.set({
        PhoneRef.phoneId:docId,
        PhoneRef.number:number,
        PhoneRef.userId:userModel!.userId
      })
            .then((value) =>Fluttertoast.showToast(msg: "تم إضافة رقم التليفون بنجاح"))
            .catchError((error)=>Fluttertoast.showToast(msg:error.toString()));

    }
    else if (type == "update"){
        await docRef.update({ PhoneRef.number:number})
            .then((value) =>Fluttertoast.showToast(msg: "تم تعديل رقم التليفون بنجاح"))
            .catchError((error)=>Fluttertoast.showToast(msg:error.toString()));

    }
    else{
        await docRef.delete()
            .then((value) =>Fluttertoast.showToast(msg: "تم حذف رقم التليفون بنجاح"))
            .catchError((error)=>Fluttertoast.showToast(msg:error.toString()));

    }

  }
  Future<void> updateUserFieldsServices({String? key,String? value})async
  {

   await firestore.collection(UserRef.userCollectionRef).doc(userModel!.userId!).update({key!:value})
       .then((value) =>Fluttertoast.showToast(msg:key=="password"?"تم تغيير كلمةالمرور بنجاح": "تم التعديل بنجاح"))
       .catchError((error)=>Fluttertoast.showToast(msg:error.toString()));

  }

  Future<bool> signIn({String? email,String? password})async
  {

    QuerySnapshot result=await firestore
        .collection(UserRef.userCollectionRef)
        .where(UserRef.email,isEqualTo: email)
        .where(UserRef.password,isEqualTo: password)
        .get();

    bool returnValue=result.size>0;
    if(returnValue)
    {
      storage.write(ScreenControllerRef.isLoggedIn,ScreenControllerRef.homePage);
      storage.write(UserRef.userId, result.docs.first.id);
    }
    return returnValue;
  }

}