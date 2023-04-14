import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/provider/orders_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../models/order_model.dart';
import '../../../../global/widgets/circle_icon_button.dart';
import '../../../../global/widgets/custom_alert_dialog.dart';
import '../../../../global/widgets/no_data_card.dart';
import '../order_card/order_card.dart';

class SelectOrder extends StatefulWidget {
  const SelectOrder({super.key, this.backupId, this.notifyUserId});
  final String? backupId;
  final String? notifyUserId;

  @override
  State<SelectOrder> createState() => _SelectOrderState();
}

class _SelectOrderState extends State<SelectOrder> {
  List<String> selectedOrdersList = [];

  @override
  Widget build(BuildContext context) {
    OrdersProvider ordersProvider = Provider.of<OrdersProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: _addOrders(context),
        appBar: _appBar(context),
        body: RefreshIndicator(
          onRefresh: () async {
            ordersProvider.refresh();
          },
          child: StreamBuilder(
              stream: ordersProvider.getSupOrdersStream(),
              builder: (context, snapshot) => !snapshot.hasData
                  ? const Align(
                      alignment: Alignment.topCenter,
                      child: CupertinoActivityIndicator())
                  : snapshot.data!.size == 0
                      ? const NoDataCard(
                          message: "لا يوجد طلبات",
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.size,
                          itemBuilder: (context, position) {
                            OrderModel orderModel = OrderModel.fromSnapshot(
                                snapshot.data.docs[position].data());
                            return OrderCard(
                              model: orderModel,
                              notifyUserId: widget.notifyUserId!,
                              selectable: true,
                              selectedOrders: selectedOrdersList,
                              onSelect: () {
                                if (selectedOrdersList
                                    .contains(orderModel.orderId)) {
                                  selectedOrdersList.remove(orderModel.orderId);
                                } else {
                                  selectedOrdersList.add(orderModel.orderId!);
                                }
                                setState(() {});
                              },
                            );
                          })),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) => AppBar(
        title: const Text("اختر الطلبات",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            )),
        leading: CircleIconButton(
          onTap: () => Navigator.pop(context),
          icon: Icons.arrow_back,
        ),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(15.0), // here the desired height
            child: Divider(
              color: Colors.blue,
            )),
      );

  Widget _addOrders(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
              title: "اضافة طلب",
              text: "هل تريد اضافةهذه الطلبات بالفعل؟",
              onPress: () {
                Navigator.pop(context);
                Provider.of<OrdersProvider>(context, listen: false)
                    .addMiniSuppliersOrder(
                        supplierBackupId: widget.backupId,
                        ordersIds: selectedOrdersList,
                        notifyUserId: widget.notifyUserId,
                        context: context);
              })),
      label: const Text("إضافة طلب"),
    );
  }
}
