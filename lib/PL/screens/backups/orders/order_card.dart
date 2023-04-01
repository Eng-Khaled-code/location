import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/PL/global/firebase_var_ref/order_ref.dart';
import 'package:location/PL/global/themes/app_colors/dark_colors.dart';
import 'package:location/PL/global/themes/app_colors/light_colors.dart';
import 'package:location/PL/global/widgets/custom_alert_dialog.dart';
import 'package:location/PL/global/widgets/methoods.dart';
import 'package:location/models/backup_model.dart';
import 'package:location/models/order_model.dart';
import 'package:location/provider/backup_provider.dart';
import 'package:location/provider/orders_provider.dart';
import 'package:provider/provider.dart';
import '../../../global/widgets/colored_container.dart';
import 'add_order.dart';
class OrderCard extends StatelessWidget {
  final OrderModel? model;

   OrderCard({Key? key,@required this.model}) : super(key: key);
  Color? textColor;

  @override
  Widget build(BuildContext context) {
   textColor =Theme.of(context).brightness==Brightness.light?LightColors.cardText:
    DarkColors.cardText;
    return InkWell(
      onTap: () {
       if( model!.supplierId==""||model!.supplierId==null )
       {
         goTo(context: context,
             to: AddOrder.update(
               type: "تعديل طلب",
               customerName: model!.customerName,
               chargeValue: model!.chargeValue,
               phone2: model!.phone2,
               phone: model!.phone,
               price: model!.price,
               address: model!.address,
               orderId: model!.orderId,
               backupId: model!.backupId,backupDate: model!.date,
             ));
       }
       else
       {
        Fluttertoast.showToast(msg:"لا يمكن تعديل هذا الطلب");
       }

      } ,child: Card(
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
        _phone1Widget(),
        _typeWidget(),
        if(model!.supplierId==""||model!.supplierId==null)_deleteWidget(context),
    ],);
  }

  InkWell _deleteWidget(BuildContext context){
    return InkWell(onTap:()=>showDialog(
        context: context,
        builder:(context)=>CustomAlertDialog(
            title:"حذف الطلب",
            text: "هل تريد الحذف بالفعل؟",
            onPress:(){
              Navigator.pop(context);
              Provider.of<OrdersProvider>(context,listen: false)
                  .deleteOrder(backupId: model!.backupId,orderId: model!.orderId,
                  price: model!.price,customerName: model!.customerName,address: model!.address,backupDate: model!.date);
            }
        )),child:const ColoredContainer(content: "حذف",));
  }

   _centerWidget(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
              text:model!.customerName.toString(),style: Theme.of(context).textTheme.titleLarge
          ),
           TextSpan(
            text: "\nالعنوان : ${model!.address!}    |   ${model!.phone2!??""}",
          ),

        ]
      ),
     );
  }

  Row _bottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _priceWidget(),
        _payedWidget(),
        _chargeValueWidget()
      ],);
  }

  _phone1Widget() {
    return Text( " ${model!.phone.toString()}",style: textStyle());
  }

  _typeWidget() {
    return ColoredContainer(content:model!.providerStatus!);
  }

  _priceWidget() {
    return Text("سعر : ${model!.price.toString()}",style: textStyle());
  }

  _payedWidget() {
    return Text( "مدفوع : ${model!.payed.toString()}",style: textStyle());
  }
  _chargeValueWidget() {
    return Text( "م الشحن : ${model!.chargeValue.toString()}",style: textStyle());
  }
  Text _dateWidget(){
    return  Text(model!.date!,style: textStyle(),);
  }

  TextStyle textStyle(){
    return TextStyle(color:textColor,fontWeight: FontWeight.bold);}
}
