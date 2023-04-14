import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/PL/global/firebase_var_ref/financial_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/services/financial_services.dart';

class FinancialProvider with ChangeNotifier
{

      bool isLoading=false;
      int selectedIndex=0;

      String selectedType="الكل";
      String? selectedDate="";

      FinancialServices financialServices=FinancialServices();

      refresh(){
        notifyListeners();
      }

      setType(String type){
        selectedType=type;
        notifyListeners();
      }

      setDate(String date){
        selectedDate=date;
        notifyListeners();
      }


      Stream<QuerySnapshot<Map<String, dynamic>>> financeStream(){
        Stream<QuerySnapshot<Map<String, dynamic>>>? stream;

          stream=financialServices.financeStream(userType: userModel!.type,selectedOne: selectedType,selectedDate: selectedDate,
              type: selectedIndex==0?FinancialRef.incomeRef:FinancialRef.outcomeRef);

        return stream;
      }



}