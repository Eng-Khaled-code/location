import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/PL/global/firebase_var_ref/notify_ref.dart';

import 'notification_services/send_push_notofication.dart';

class NotifyServices {
  CollectionReference notifyFirestore =
      FirebaseFirestore.instance.collection(NotifyRef.notifyCollectionRef);

  seen({String? notifyId}) async {
    notifyFirestore
        .doc(notifyId)
        .update({NotifyRef.status: NotifyRef.openedRef});
  }

  addNotify(Map<String, dynamic> data, String? token) async {
    await notifyFirestore.doc(data[NotifyRef.notifyId]).set(data);
    await SendPushNotificationServices().sendPushNotification(token!, data);
  }

}
