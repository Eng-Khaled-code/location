import 'package:flutter/material.dart';
import 'package:location/PL/global/themes/app_colors/dark_colors.dart';
import 'package:location/PL/global/themes/app_colors/light_colors.dart';
import 'package:location/PL/global/widgets/custom_alert_dialog.dart';
import 'package:location/PL/global/widgets/methoods.dart';
import 'package:location/PL/screens/backups/orders/orders_page.dart';
import 'package:location/models/backup_model.dart';
import 'package:location/provider/backup_provider.dart';
import 'package:provider/provider.dart';
import '../../../global/widgets/colored_container.dart';
class BackupCard extends StatelessWidget {
  final BackupModel? model;

   BackupCard({Key? key,@required this.model}) : super(key: key);
  Color? textColor;

  @override
  Widget build(BuildContext context) {
   textColor =Theme.of(context).brightness==Brightness.light?LightColors.cardText:
    DarkColors.cardText;
    return InkWell(
      onTap: ()=>goTo(context: context, to: OrdersPage(backUpDate: model!.date,backupId: model!.backupId,)),
      child: Card(
        margin:const EdgeInsets.only(bottom: 5.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:Column(children: [
           _topWidget(context),
           const Divider(),
           _centerWidget(context),
            const Divider(),
            _bottomWidget()
        ],),
        ),
      ),
    );
  }

  Row _topWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _dateWidget(),
        _ordersCountWidget(),
        if(model!.ordersCount==0)_deleteWidget(context),
    ],);
  }

  RichText _centerWidget(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          children: [const TextSpan(
            text: "الإجمالي : ",
          ),
            TextSpan(
                text:model!.price.toString(),style: Theme.of(context).textTheme.titleLarge
            ),
            const TextSpan(
              text: "  |  المدفوع : ",
            ),
            TextSpan(
                text:model!.payed.toString(),style: Theme.of(context).textTheme.titleLarge
            )
          ]
      ),
    );
  }

  Row _bottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _waitingCountWidget(),
        _deliveredCountWidget(),
        _partialCountWidget(),
        _canceledCountWidget()
      ],);
  }

  InkWell _deleteWidget(BuildContext context){
    return InkWell(onTap:()=>showDialog(
        context: context,
        builder:(context)=>CustomAlertDialog(
            title:"حذف BackUp",
            text: "هل تريد الحذف بالفعل؟",
            onPress:(){
              Navigator.pop(context);
              Provider.of<BackupProvider>(context,listen: false).deleteBackup(backupId: model!.backupId);
            }
        )),child:const ColoredContainer(content: "حذف",));
  }

  Text _ordersCountWidget() {
    return Text("الطلبات : ${model!.ordersCount.toString()}",style: textStyle());
  }

  Text _waitingCountWidget() {
    return Text("المنتظر : ${model!.waitingCount.toString()}",style: textStyle());
  }

  Text _deliveredCountWidget() {
    return Text("الموصل : ${model!.deliveredCount.toString()}",style: textStyle());
  }

  Text _canceledCountWidget() {
    return Text( "لاغي : ${model!.canceledCount.toString()}",style: textStyle());
  }

  Text _partialCountWidget() {
    return Text( "جزئي : ${model!.partialCount.toString()}",style: textStyle());
  }

  Text _dateWidget(){
    return  Text(model!.date!,style: textStyle(),);
  }

  TextStyle textStyle(){
    return TextStyle(color:textColor,fontWeight: FontWeight.bold);}
}
