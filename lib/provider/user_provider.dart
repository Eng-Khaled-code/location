
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/PL/global/firebase_var_ref/user_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/global_variables/screen_controller_ref.dart';
import 'package:location/services/user_services.dart';

class UserProvider with ChangeNotifier
{
  String page=ScreenControllerRef.splashScreenPage;
  bool isLoading=false;
  bool isUsernameLoading=false;
  bool isAddressLoading=false;
  bool isPasswordLoading=false;
  bool isBrandLoading=false;

  final GetStorage storage=GetStorage();
  final UserServices userServices=UserServices();
  UserProvider(){
    checkLogIn();
  }

  checkLogIn()async {

    try {

             userStatusReason = "";
            if (storage.read(ScreenControllerRef.isLoggedIn) == ScreenControllerRef.homePage)
            {
              loadingUserData();
            }
            else
            {
              page=ScreenControllerRef.logInPage;
            }

      }
      catch (ex)
      {
            page=ScreenControllerRef.splashScreenPage;
            userStatusReason =ex.toString();
    }
    notifyListeners();

  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      bool result=await userServices.signIn(email: email,password: password);

      if(result){
        loadingUserData();
      }
      else
      {
        Fluttertoast.showToast(msg:"الايميل او كلمة المرور غير صحيحة");
        isLoading = false;
        notifyListeners();
      }


    }
    catch(ex)
    {
      Fluttertoast.showToast(msg: ex.toString());
      isLoading = false;
      notifyListeners();
    }
  }

  loadingUserData()async{

    String userId = storage.read(UserRef.userId);
    userModel = await userServices.loadUserData(userId: userId);

    if (userModel!.status == "مغلق") {
      userStatusReason = userModel!.reason!;
      page=ScreenControllerRef.splashScreenPage;
      isLoading=false;
    }else
    {
      isLoading=false;
      page=ScreenControllerRef.homePage;
    }
    notifyListeners();
  }

  Future<void> phoneOperations({String? type="",String? phoneId="",String? number=""})async
  {
    try {
      await userServices.phoneOperationsService(phoneId: phoneId,number: number,type: type);
      notifyListeners();
    }
    catch(ex)
    {
     Fluttertoast.showToast(msg:ex.toString());
    }
  }

  Future<void> updateUserFields({String? key,String? value})async{

    try {
      fieldLoading(true,key);
      await userServices.updateUserFieldsServices(key: key,value: value);
      loadingUserData();
      fieldLoading(false,key);
    }
    catch(ex)
    {
      Fluttertoast.showToast(msg:ex.toString());
      fieldLoading(false,key);

    }

  }
  fieldLoading(bool loading,key)
  {

    if(key==UserRef.username) {
      isUsernameLoading = loading;
    }
    else if(key==UserRef.brand){
      isBrandLoading=loading;
    }else{
      isAddressLoading = loading;
    }
    notifyListeners();
  }

  logOut()
  {
    page=ScreenControllerRef.logInPage;
    storage.write(ScreenControllerRef.isLoggedIn, ScreenControllerRef.logInPage);
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