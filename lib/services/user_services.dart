// ignore_for_file: invalid_return_type_for_catch_error, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/PL/global/firebase_var_ref/phone_ref.dart';
import 'package:location/PL/global/firebase_var_ref/user_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/global_variables/screen_controller_ref.dart';
import 'package:location/models/user_model.dart';
import '../PL/global/firebase_var_ref/backup_ref.dart';
import '../PL/global/firebase_var_ref/notify_ref.dart';
import '../PL/global/firebase_var_ref/order_ref.dart';

class UserServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GetStorage storage = GetStorage();

  Future<UserModel> loadUserData({String? userId}) async {
    String? token = await FirebaseMessaging.instance.getToken();

    await firestore
        .collection(UserRef.userCollectionRef)
        .doc(userId!)
        .update({UserRef.token: token});

    DocumentSnapshot<Map<String, dynamic>> value =
        await firestore.collection(UserRef.userCollectionRef).doc(userId).get();

    return UserModel.fromSnapshot(value.data()!);
  }

  Future<void> phoneOperationsService(
      {String? type = "", String? phoneId = "", String? number = ""}) async {
    String docId = DateTime.now().microsecondsSinceEpoch.toString();
    DocumentReference docRef = firestore
        .collection(PhoneRef.phoneCollectionRef)
        .doc(type == "add" ? docId : phoneId);

    if (type == "add") {
      await docRef
          .set({
            PhoneRef.phoneId: docId,
            PhoneRef.number: number,
            PhoneRef.userId: userModel!.userId
          })
          .then((value) =>
              Fluttertoast.showToast(msg: "تم إضافة رقم التليفون بنجاح"))
          .catchError((error) => Fluttertoast.showToast(msg: error.toString()));
    } else if (type == "update") {
      await docRef
          .update({PhoneRef.number: number})
          .then((value) =>
              Fluttertoast.showToast(msg: "تم تعديل رقم التليفون بنجاح"))
          .catchError((error) => Fluttertoast.showToast(msg: error.toString()));
    } else {
      await docRef
          .delete()
          .then((value) =>
              Fluttertoast.showToast(msg: "تم حذف رقم التليفون بنجاح"))
          .catchError((error) => Fluttertoast.showToast(msg: error.toString()));
    }
  }

  Future<void> updateUserFieldsServices({String? key, String? value}) async {
    await firestore
        .collection(UserRef.userCollectionRef)
        .doc(userModel!.userId!)
        .update({key!: value}).then((value22) async {
      if (key == UserRef.username ||
          key == UserRef.image ||
          key == UserRef.brand) {
        await updateBackupUserNameAndImage(userModel!.userId!, key, value);
      }

      Fluttertoast.showToast(
          msg: key == UserRef.password
              ? "تم تغيير كلمةالمرور بنجاح"
              : "تم التعديل بنجاح");
    }).catchError((error) => Fluttertoast.showToast(msg: error.toString()));
  }

  Future<bool> signIn({String? email, String? password}) async {
    QuerySnapshot result = await firestore
        .collection(UserRef.userCollectionRef)
        .where(UserRef.email, isEqualTo: email)
        .where(UserRef.password, isEqualTo: password)
        .get();

    bool returnValue = result.size > 0;
    if (returnValue) {
      storage.write(
          ScreenControllerRef.isLoggedIn, ScreenControllerRef.homePage);
      storage.write(UserRef.userId, result.docs.first.id);
    }

    return returnValue;
  }

  Future<void> addOrUpdateUser(
      {Map<String, dynamic>? data, String? type}) async {
    DocumentReference documentReference = firestore
        .collection(UserRef.userCollectionRef)
        .doc(data![UserRef.userId]);

    if (type == "اضافة") {
      await documentReference.set(data);
    } else {
      await documentReference.update(data);
      await updateBackupUserNameAndImage(
          data[UserRef.userId], BackupRef.username, data[UserRef.username]);
    }
  }

  Future<void> updateUserStatus({String? userId, String? status}) async {
    await firestore
        .collection(UserRef.userCollectionRef)
        .doc(userId)
        .update({UserRef.status: status});
  }

  Future<void> updateBackupUserNameAndImage(
      String? userId, String? key, String? value) async {
    await firestore
        .collection(BackupRef.collectionRef)
        .where(BackupRef.supplierIdRef, isEqualTo: userId)
        .get()
        .then((value1) => value1.docs.forEach((element) async {
              await firestore
                  .collection(BackupRef.collectionRef)
                  .doc(element.id)
                  .update({key!: value});
            }));

    await firestore
        .collection(NotifyRef.notifyCollectionRef)
        .where(NotifyRef.fromId, isEqualTo: userId)
        .get()
        .then((value1) => value1.docs.forEach((element) async {
              String notifyKey =
                  (key == UserRef.username ? NotifyRef.fromName : key)!;
              await firestore
                  .collection(NotifyRef.notifyCollectionRef)
                  .doc(element.id)
                  .update({notifyKey: value});
            }));

    await firestore
        .collection(OrderRef.ordersCollectionRef)
        .where(OrderRef.providerId, isEqualTo: userId)
        .get()
        .then((value1) => value1.docs.forEach((element) async {
              await firestore
                  .collection(OrderRef.ordersCollectionRef)
                  .doc(element.id)
                  .update({key!: value});
            }));

    Map<String, dynamic> upData;
    if (userModel!.type == UserRef.supplierRef) {
      upData = {key!: value};
    } else {
      String keyField = (key == UserRef.image
          ? BackupRef.providerImage
          : key == UserRef.brand
              ? BackupRef.providerBrand
              : BackupRef.providerName);
      upData = {keyField: value};
    }
    await firestore
        .collection(BackupRef.collectionRef)
        .where(OrderRef.providerId, isEqualTo: userId)
        .get()
        .then((value1) => value1.docs.forEach((element) async {
              await firestore
                  .collection(BackupRef.collectionRef)
                  .doc(element.id)
                  .update(upData);
            }));
  }

  Future<void> uploadingImageToStorage({File? image}) async {
    try {
      Uint8List fileBytes = await image!.readAsBytes();

      await deleteImageFromStorage();

      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child("profile images")
          .child(userModel!.userId!);

      UploadTask storageUploadTask;
      if (kIsWeb) {
        storageUploadTask = storageReference.putData(fileBytes);
      } else {
        storageUploadTask = storageReference.putFile(image);
      }
      await storageUploadTask.whenComplete(() {});

      await storageReference.getDownloadURL().then((profileURL) async {
        await updateUserFieldsServices(key: UserRef.image, value: profileURL);
      });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: "خطا اثناء رفع الصورة ${e.message!}");
    }
  }

  Future<void> deleteImageFromStorage() async {
    try {
      await FirebaseStorage.instance
          .ref()
          .child("profile images")
          .child(userModel!.userId!)
          .delete();
    // ignore: empty_catches
    } catch (ex) {}
  }
}
