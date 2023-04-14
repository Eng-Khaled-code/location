import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/PL/global/firebase_var_ref/financial_ref.dart';
import 'package:location/PL/global/firebase_var_ref/user_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';

class FinancialServices
{
  FirebaseFirestore firestore=FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> financeStream({String? userType,String? selectedOne,
    String? selectedDate,String? type}){

    if(selectedOne=="الكل")
    {

      if(userType==UserRef.adminRef)
      {

        return firestore
            .collection(FinancialRef.collectionRef)
            .where(FinancialRef.type, isEqualTo: type)
            .get()
            .asStream();
      }
      else
      {

        return firestore
            .collection(FinancialRef.collectionRef)
            .where(FinancialRef.type, isEqualTo: type)
            .where(FinancialRef.toId,isEqualTo: userModel!.userId,)
            .get()
            .asStream();
      }

    }
    else if(selectedOne=="بحث") {

      if(userType==UserRef.adminRef)
      {

        return firestore
          .collection(FinancialRef.collectionRef)
          .where(FinancialRef.type, isEqualTo: type)
          .where(FinancialRef.date, isEqualTo: selectedDate)
          .get()
          .asStream();

      }
      else
      {
        return firestore
            .collection(FinancialRef.collectionRef)
            .where(FinancialRef.toId,isEqualTo: userModel!.userId,)
            .where(FinancialRef.type, isEqualTo: type)
            .where(FinancialRef.date, isEqualTo: selectedDate)
            .get()
            .asStream();
      }
    }
    else if(int.tryParse(selectedOne!)! < 13) {
      //is month
      if(userType==UserRef.adminRef)
      {

        return firestore
          .collection(FinancialRef.collectionRef)
          .where(FinancialRef.type, isEqualTo: type)
          .where(FinancialRef.monthRef,isEqualTo: DateTime.now().month)
          .where(FinancialRef.yearRef,isEqualTo:DateTime.now().year )
          .get()
          .asStream();


      }
      else
      {

        return firestore
            .collection(FinancialRef.collectionRef)
            .where(FinancialRef.type, isEqualTo: type)
            .where(FinancialRef.toId,isEqualTo: userModel!.userId,)
            .where(FinancialRef.monthRef,isEqualTo: DateTime.now().month)
            .where(FinancialRef.yearRef,isEqualTo:DateTime.now().year )
            .get()
            .asStream();
      }
    }
    else
    {
      //is year
      if(userType==UserRef.adminRef)
      {
      return firestore
          .collection(FinancialRef.collectionRef)
          .where(FinancialRef.type, isEqualTo: type)
          .where(FinancialRef.yearRef,isEqualTo:DateTime.now().year )
          .get()
          .asStream();
      }
      else
      {
        return firestore
            .collection(FinancialRef.collectionRef)
            .where(FinancialRef.toId,isEqualTo: userModel!.userId,)
            .where(FinancialRef.type, isEqualTo: type)
            .where(FinancialRef.yearRef,isEqualTo:DateTime.now().year )
            .get()
            .asStream();
      }
    }

  }


  }



  add(Map<String,dynamic> data) async{





}