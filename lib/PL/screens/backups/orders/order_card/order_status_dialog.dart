import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/models/order_model.dart';
import 'package:location/provider/orders_provider.dart';

import '../../../../global/firebase_var_ref/order_ref.dart';
import '../../../../global/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class OrderStatusDialog extends StatefulWidget {
  const OrderStatusDialog(
      {super.key, this.ordersProvider, this.orderModel});
  final OrdersProvider? ordersProvider;
  final OrderModel? orderModel;
  @override
  State<OrderStatusDialog> createState() => _OrderStatusDialogState();
}

class _OrderStatusDialogState extends State<OrderStatusDialog> {
  String selectedStatus = OrderRef.delivered;
  double payedValue = 0.0;
  List<String> statusList = const [
    OrderRef.delivered,
    OrderRef.partial,
    OrderRef.canceled
  ];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text("تغيير حالة الطلب"),
          content: SizedBox(
            width: 200,
            height: 150,
            child: SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        statusListWidget(),
                        const SizedBox(height: 10),
                        selectedStatus == OrderRef.canceled
                            ? Container()
                            : CustomTextField(
                                initialValue: (payedValue == 0 ? "" : payedValue)
                                    .toString(),
                                label: "القيمة",
                                onSave: (value) =>
                                    payedValue = double.tryParse(value)!,
                                icon: Icons.monetization_on_outlined,
                                onTap: () {},
                              ),
                      ],
                    ))),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate())   formKey.currentState!.save();

                  bool  condition = (payedValue <= (widget.orderModel!.price! + widget.orderModel!.chargeValue!));

                  if (selectedStatus == OrderRef.canceled ||
                      (payedValue > 0 && condition)) {
                    Navigator.pop(context);

                    widget.ordersProvider!.changeOrderStatus(
                        status: selectedStatus,
                        orderId: widget.orderModel!.orderId,
                        custAddress: widget.orderModel!.address,
                        custName: widget.orderModel!.customerName,
                        providerBackupId: widget.orderModel!.providerBackupId,
                        supplierBackupId: widget.orderModel!.supplierBackupId,
                        oldStatus: widget.orderModel!.status,
                        proValue: selectedStatus == OrderRef.canceled &&
                                widget.orderModel!.providerPayed == 0
                            ? 0
                            : selectedStatus == OrderRef.partial
                                ? payedValue -
                                    widget.orderModel!.supplierPayed! -
                                    widget.orderModel!.chargeValue!
                                : payedValue -
                                    widget.orderModel!.supplierPayed!,
                        supValue: selectedStatus == OrderRef.canceled &&
                                widget.orderModel!.supplierPayed == 0
                            ? 0
                            : payedValue - widget.orderModel!.supplierPayed!,
                        notifyUserId: widget.orderModel!.proId);
                  } else {
                   
                   
                    Fluttertoast.showToast(
                        msg:
                            " يجب ان تدخل قيمة اكبر من صفر واقل من او تساوي  ${widget.orderModel!.price!+widget.orderModel!.chargeValue!}",
                        toastLength: Toast.LENGTH_LONG);
                  }
                },
                child: const Text("تاكيد")),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("الغاء"))
          ],
        ));
  }

  SizedBox statusListWidget() {
    return SizedBox(
      height: 41,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: statusList.length,
          itemBuilder: (context, position) {
            return itemCard(statusList[position], position);
          }),
    );
  }

  InkWell itemCard(String text, int position) {
    bool con = selectedStatus == text ? true : false;
    return InkWell(
        onTap: () => setState(() => selectedStatus = text),
        child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: con ? Colors.blue : Colors.transparent),
            child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: con ? Colors.white : Colors.blue,
                ))));
  }
}
