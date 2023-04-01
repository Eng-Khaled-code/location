import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/PL/global/firebase_var_ref/notify_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/services/notify_services.dart';

class NotifyProvider with ChangeNotifier{

  NotifyServices notifyServices=NotifyServices();

  refresh(){
    notifyListeners();
  }


  Stream getNotificationStream()=>FirebaseFirestore.instance.collection(NotifyRef.notifyCollectionRef)
      .where(NotifyRef.toId,isEqualTo: userModel!.userId).get().asStream();

  seen(String notifyId)async{

    try {
      await notifyServices.seen(notifyId: notifyId);
      notifyListeners();
    }
    catch(ex)
    {
      notifyListeners();
    }
  }

}