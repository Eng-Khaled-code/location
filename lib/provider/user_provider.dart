import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/PL/global/firebase_var_ref/user_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/global_variables/screen_controller_ref.dart';
import 'package:location/services/user_services.dart';

class UserProvider with ChangeNotifier {
  String page = ScreenControllerRef.splashScreenPage;
  bool isLoading = false;
  bool isImageLoading = false;
  bool isUsernameLoading = false;
  bool isAddressLoading = false;
  bool isPasswordLoading = false;
  bool isBrandLoading = false;
  bool isPhoneLoading = false;
  String userStatusReason = "";
  final GetStorage storage = GetStorage();
  final UserServices userServices = UserServices();
  UserProvider() {
    checkLogIn();
  }

  checkLogIn() async {
    try {
      if (storage.read(ScreenControllerRef.isLoggedIn) ==
          ScreenControllerRef.homePage) {
        await loadingUserData();
      } else {
        page = ScreenControllerRef.logInPage;
      }
    } catch (ex) {
      page = ScreenControllerRef.splashScreenPage;
      userStatusReason = ex.toString();
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      bool result = await userServices.signIn(email: email, password: password);

      if (result) {
        loadingUserData();
      } else {
        Fluttertoast.showToast(msg: "الايميل او كلمة المرور غير صحيحة");
        isLoading = false;
        notifyListeners();
      }
    } on FirebaseException catch (ex) {
      Fluttertoast.showToast(msg: ex.message!);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfilePicture({File? imageFile}) async {
    try {
      isImageLoading = true;
      notifyListeners();

      await userServices.uploadingImageToStorage(image: imageFile);

      loadingUserData();

      isImageLoading = false;
      notifyListeners();
    } on FirebaseException catch (e) {
      isImageLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  loadingUserData() async {
    String userId = storage.read(UserRef.userId);
    userModel = await userServices.loadUserData(userId: userId);

    if (userModel!.status == "مغلق") {
      page = ScreenControllerRef.splashScreenPage;
      userStatusReason = userModel!.reason!;

      isLoading = false;
    } else {
      isLoading = false;
      page = ScreenControllerRef.homePage;
    }

    notifyListeners();
  }

  Future<void> phoneOperations(
      {String? type = "", String? phoneId = "", String? number = ""}) async {
    try {
      isPhoneLoading = true;
      notifyListeners();
      await userServices.phoneOperationsService(
          phoneId: phoneId, number: number, type: type);
      isPhoneLoading = false;
      notifyListeners();
    } on FirebaseException catch (ex) {
      Fluttertoast.showToast(msg: ex.message!);
    }
  }

  Future<void> addOrUpdateUser(
      {String? addOrUpdate,
      Map<String, dynamic>? data,
      BuildContext? context}) async {
    try {
      isLoading = true;
      notifyListeners();
      await userServices.addOrUpdateUser(data: data, type: addOrUpdate);
      Navigator.pop(context!);
      isLoading = false;
      notifyListeners();
    } on FirebaseException catch (ex) {
      Fluttertoast.showToast(msg: ex.message!);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserStatus({String? status, String? userId}) async {
    try {
      await userServices.updateUserStatus(userId: userId, status: status);
    } on FirebaseException catch (ex) {
      Fluttertoast.showToast(msg: ex.message!);
    }
  }

  Future<void> updateUserFields({String? key, String? value}) async {
    try {
      fieldLoading(true, key);
      await userServices.updateUserFieldsServices(key: key, value: value);
      loadingUserData();
      fieldLoading(false, key);
    } on FirebaseException catch (ex) {
      Fluttertoast.showToast(msg: ex.message!);
      fieldLoading(false, key);
    }
  }

  fieldLoading(bool loading, key) {
    if (key == UserRef.username) {
      isUsernameLoading = loading;
    } else if (key == UserRef.brand) {
      isBrandLoading = loading;
    } else if (key == UserRef.address) {
      isAddressLoading = loading;
    } else {
      isLoading = loading;
    }
    notifyListeners();
  }

  logOut() {
    page = ScreenControllerRef.logInPage;
    storage.write(
        ScreenControllerRef.isLoggedIn, ScreenControllerRef.logInPage);
    notifyListeners();
  }

  /*
   *
   *Future<String> getToken()async{

    try {
      String ? token = await FirebaseMessaging.instance.getToken();
      return token!;
    }on FirebaseException catch(ex){
      print(ex.message);
      error=ex.message;
      return '';
    }
  }
  */
}
