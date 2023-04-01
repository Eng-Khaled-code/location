import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/themes/text_thems/text_var.dart';
import 'package:location/PL/global/widgets/circle_icon_button.dart';
import 'package:location/PL/global/widgets/custom_alert_dialog.dart';
import 'package:location/provider/backup_provider.dart';
import 'package:provider/provider.dart';
import 'package:location/PL/screens/home/search_field.dart';
import '../backups/backups_page/backup_list.dart';

class FinancialPage extends StatelessWidget {
   const FinancialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BackupProvider backupProvider=Provider.of<BackupProvider>(context);
    return Scaffold(
      appBar:_homeAppBar() ,
    body: _body(backupProvider,context),
    floatingActionButton: _addBackUp(context)
    );
  }

 AppBar _homeAppBar()=> AppBar(
    title:const Text("BackUps",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 22,fontFamily: TextVar.englishFontFamily)),
    leading: CircleIconButton(onTap: ()=>_key.currentState!.openDrawer(),),
    actions: [CircleIconButton(onTap: (){},icon: Icons.notifications,)],
    bottom:const PreferredSize(
        preferredSize: Size.fromHeight(15.0), // here the desired height
        child:Divider(color: Colors.blue,)) ,
  );

 FloatingActionButton _addBackUp(BuildContext context)=>
       FloatingActionButton.extended(
        onPressed: ()=>showDialog(
            context: context,
            builder:(context)=>CustomAlertDialog(
                title:"إضافة BackUp",
                text: "هل تريد إضافة BackUp جديد",
                onPress:(){
                Navigator.pop(context);
                Provider.of<BackupProvider>(context,listen: false).addBackup();
                }
                )),
        label:const Text("إضافة Backup"),
       );

   RefreshIndicator _body(BackupProvider backupProvider,BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async{
        backupProvider.refresh();
      },
      child: SingleChildScrollView(
          physics:const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          filterList(backupProvider),
          const SizedBox(height: 10,),
          backupProvider.selectedType=="بحث"?_searchWidget(backupProvider,context):Container(),
          const SizedBox(height: 10,),
           BackupList(backupProvider: backupProvider),
        ],
      )),
    );
  }

  SizedBox filterList(BackupProvider backupProvider) {
     return SizedBox(
       height: 41,
       child: ListView.builder(
         shrinkWrap: true,
           scrollDirection: Axis.horizontal,
           itemCount: GlobalVariables.filterList.length,
           itemBuilder: (context,position)
       {
         return itemCard(GlobalVariables.filterList[position],position,backupProvider);
       }),
     );
  }

  InkWell itemCard(String text,int position,BackupProvider backupProvider){
    bool con=backupProvider.selectedType==text?true:false;
    String newText=position==2?getMonthAsString(text):text;
         return InkWell(
             onTap:(){
               backupProvider.setType(text);
             },
             child: Container(padding:const EdgeInsets.all(10),  margin :const EdgeInsets.symmetric(horizontal: 5),
                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: con ?Colors.blue:Colors.transparent),
                 child: Text(newText ,textAlign: TextAlign.center,style:TextStyle (color:con?Colors.white:Colors.blue,)
             )));

  }

  SearchField _searchWidget(BackupProvider backupProvider,BuildContext context) {
     TextEditingController textEditingController =TextEditingController(text:backupProvider.selectedDate!);
     return SearchField(date:backupProvider.selectedDate ,controller: textEditingController,onTap:()async{

       DateTime? pickedDate = await showDatePicker(
           context: context,
           initialDate: DateTime.now(),
           firstDate: DateTime(2022),
           lastDate: DateTime(2100));
       if (pickedDate != null) {
         String date=pickedDate.toString().substring(0,10);
         backupProvider.setDate(date);
       }     });}

  String getMonthAsString(String text) {
   String month="";

   if(text=="1")
   {
     month="يناير";
   }
   else if(text=="2")
   {
     month="فبراير";
   }
   else if(text=="3")
   {
     month="مارس";
   }
   else if(text=="4")
   {
     month="ابريل";
   }
   else if(text=="5")
   {
     month="مايو";
   }
   else if(text=="6")
   {
     month="يونيه";
   }
   else if(text=="7")
   {
     month="يوليو";
   }
   else if(text=="8")
   {
     month="أغسطس";
   }
   else if(text=="9")
   {
     month="سبتمبر";
   }
   else if(text=="10")
   {
     month="أكتوبر";
   }
   else if(text=="11")
   {
     month="نوفمبر";
   }
   else
   {
     month="ديسمبر";
   }

   return month;
  }


}
