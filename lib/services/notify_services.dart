import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/PL/global/firebase_var_ref/notify_ref.dart';

class NotifyServices
{
  FirebaseFirestore firestore=FirebaseFirestore.instance;

  seen({String? notifyId})async
  {
    firestore.collection(NotifyRef.notifyCollectionRef).doc(notifyId).update({
      NotifyRef.status:NotifyRef.openedRef
    });
  }

}