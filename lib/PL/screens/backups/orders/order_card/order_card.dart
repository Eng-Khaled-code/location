import 'package:flutter/material.dart';
import 'package:location/PL/global/themes/app_colors/dark_colors.dart';
import 'package:location/PL/global/themes/app_colors/light_colors.dart';
import 'package:location/PL/global/widgets/custom_alert_dialog.dart';
import 'package:location/PL/global/widgets/methoods.dart';
import 'package:location/models/order_model.dart';
import 'package:location/provider/orders_provider.dart';
import '../../../../global/firebase_var_ref/backup_ref.dart';
import '../../../../global/firebase_var_ref/order_ref.dart';
import '../../../../global/firebase_var_ref/user_ref.dart';
import '../../../../global/global_variables/global_variables.dart';
import '../../../../global/widgets/colored_container.dart';
import '../../../../global/widgets/user_identification.dart';
import '../add_order.dart';
import 'order_status_dialog.dart';

class OrderCard extends StatelessWidget {
  final OrderModel? model;
  final String? notifyUserId;
  final bool? selectable;
  final List<String>? selectedOrders;
  final Function? onSelect;
  final String? backupType;
  final OrdersProvider? ordersProvider;
  OrderCard(
      {Key? key,
      @required this.model,
      @required this.ordersProvider,
      this.notifyUserId,
      this.selectable = false,
      this.selectedOrders = const [],
      this.onSelect,
      this.backupType})
      : super(key: key);
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    textColor = Theme.of(context).brightness == Brightness.light
        ? LightColors.cardText
        : DarkColors.cardText;

    return !selectable! &&
            ((backupType==BackupRef.supplierBackup && userModel!.type == UserRef.providerRef) ||
                (backupType==BackupRef.miniSupplierBackup && userModel!.type == UserRef.supplierRef))
        ? Dismissible(
            direction: DismissDirection.startToEnd,
            key: Key(model!.providerBackupId!),
            onDismissed: (direction) {
              if (model!.supplierBackupId == "") {
                // provider delete from supplier
                onProviderDelete(context);
              } else if (model!.status == OrderRef.waiting) {
                //supplier delete from mini supplier
                onSupplierDelete(context);
              }
            },
            background: dismissibleBackground(),
            child: card(context))
        : card(context);
  }

  Container dismissibleBackground() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red[100], borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: const [
          Spacer(),
          Icon(
            Icons.delete,
            size: 30,
          )
        ],
      ),
    );
  }

  InkWell card(BuildContext context) {
    return InkWell(
      onTap: () {
        if (selectable!) {
          onSelect!();
        } else {
          if (model!.supplierBackupId == "" &&
              userModel!.type == UserRef.providerRef) {
            goTo(
                context: context,
                to: AddOrder.update(
                  type: "تعديل طلب",
                  customerName: model!.customerName,
                  chargeValue: model!.chargeValue,
                  phone2: model!.phone2,
                  phone: model!.phone,
                  price: model!.price,
                  address: model!.address,
                  orderId: model!.orderId,
                  backupId: model!.providerBackupId,
                  backupDate: model!.date,
                  notifyUserId: notifyUserId,
                ));
          }
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 5.0),
        shape: selectable! && selectedOrders!.contains(model!.orderId)
            ? RoundedRectangleBorder(
                side: BorderSide(color: Colors.blue.shade500, width: 2),
                borderRadius: BorderRadius.circular(25))
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              
              _topWidget(context),
              const Divider(),
              _centerWidget(context),
              const Divider(),
              _bottomWidget()
            ],
          ),
        ),
      ),
    );
  }

  Row _topWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        selectable!
            ? UserIdentification(
                image: model!.proImage,
                name: "${model!.proName} - ${model!.proBrand!}",
                date: model!.date,
                formatedDate: true)
            : _dateWidget(),
        selectable! ? Container() : _phone1Widget(),
        _typeWidget(context),
      ],
    );
  }

  void onProviderDelete(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
            title: "حذف الطلب",
            text: "هل تريد الحذف بالفعل؟",
            onPress: () {
              Navigator.pop(context);
              ordersProvider!.deleteOrder(
                  backupId: model!.providerBackupId,
                  orderId: model!.orderId,
                  price: model!.price,
                  customerName: model!.customerName,
                  address: model!.address,
                  notifyUserId: notifyUserId);
            }));
  }

  RichText _centerWidget(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
            text: model!.customerName.toString(),
            style: Theme.of(context).textTheme.titleLarge),
        TextSpan(
          text:
              "\nالعنوان : ${model!.address!}  |  ${selectable! ? model!.phone : ""}  |   ${model!.phone2! ?? ""}",
        style: textStyle()),
      ]),
    );
  }

  Row _bottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _priceWidget(),
        _chargeValueWidget(),
        backupType==BackupRef.supplierBackup?Container(): _totalWidget(),
        _payedWidget()
      ],
    );
  }

  Text _phone1Widget() {
    return Text(" ${model!.phone.toString()}", style: textStyle());
  }

  InkWell _typeWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        bool val = !selectable! && userModel!.type == UserRef.supplierRef
        &&model!.supplierBackupId != ""&&backupType==BackupRef.miniSupplierBackup;
        if (val) {
          showDialog(
              context: context,
               builder: (context) => OrderStatusDialog(
                orderModel: model,
                ordersProvider: ordersProvider,
               ));
        }
      },
      child: ColoredContainer(content: model!.status),
    );
  }

  Text _priceWidget() {
    return Text("${model!.price.toString()}\$", style: textStyle());
  }

  Text _totalWidget() {
    double value = model!.price! + model!.chargeValue!;
    return Text("اجمالي : $value\$", style: textStyle());
  }

  Text _payedWidget() {
    double? val = backupType==BackupRef.supplierBackup? model!.providerPayed
        : model!.supplierPayed;
    return Text("مدفوع : $val\$", style: textStyle());
  }

  Text _chargeValueWidget() {
    return Text("م ش : ${model!.chargeValue.toString()}\$", style: textStyle());
  }

  Text _dateWidget() {
    return Text(
      model!.date!,
      style: textStyle(),
    );
  }

  TextStyle textStyle() {
    return TextStyle(color: textColor, fontWeight: FontWeight.bold);
  }

  void onSupplierDelete(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
            title: "حذف الطلب",
            text: "هل تريد الحذف بالفعل؟",
            onPress: () {
              ordersProvider!.updateOrder(
                  data: {
                    OrderRef.supplierBackupId: model!.supplierBackupId,
                    OrderRef.customerName: model!.customerName,
                    OrderRef.address: model!.address,
                    OrderRef.orderId: model!.orderId,
                  },
                  oldPrice: model!.price! + model!.chargeValue!,
                  context: context,
                  updateOrRemove: "remove",
                  notifyUserId: notifyUserId);
            }));
  }
}
