import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/PL/global/firebase_var_ref/backup_ref.dart';
import 'package:location/PL/global/firebase_var_ref/order_ref.dart';
import 'package:location/PL/global/widgets/circle_icon_button.dart';
import 'package:location/PL/global/widgets/colored_container.dart';
import 'package:location/PL/global/widgets/methoods.dart';
import 'package:location/PL/global/widgets/no_data_card.dart';
import 'package:location/PL/screens/backups/orders/select_order/select_order.dart';
import 'package:location/models/order_model.dart';
import 'package:location/provider/orders_provider.dart';
import 'package:provider/provider.dart';
import '../../../global/firebase_var_ref/user_ref.dart';
import '../../../global/global_variables/global_variables.dart';
import 'add_order.dart';
import 'order_card/order_card.dart';

// ignore: must_be_immutable
class OrdersPage extends StatelessWidget {
  final String? backupId;
  const OrdersPage(
      {Key? key,
      this.backupId,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrdersProvider ordersProvider = Provider.of<OrdersProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        child: StreamBuilder(
                stream: ordersProvider.getBackupByIdStream(backupId!),
                builder: (context, snapshot1) 
                =>!snapshot1.hasData 
                        ? _loadWidget()
                        :Scaffold(
              appBar: _appBar(context, snapshot1.data[BackupRef.dateRef]!),
              bottomNavigationBar: _bottomNavBar(context:context,totalPrice: snapshot1.data[BackupRef.priceRef],totalPayed: snapshot1.data[BackupRef.payedRef],),
              floatingActionButton: userModel!.type != UserRef.minSupplierRef
                  ? _addOrder(context,snapshot1.data[BackupRef.backupType],snapshot1.data[BackupRef.supplierIdRef])
                  : null,
              body: StreamBuilder(
                        stream: ordersProvider.getOrdersStream(backupId!,snapshot1.data[BackupRef.backupType]!),
                        builder: (context, snapshot) => RefreshIndicator(
                    onRefresh: () async {
                      ordersProvider.refresh();
                    },
                    child: !snapshot.hasData ||
                            snapshot.connectionState == ConnectionState.waiting
                        ? _loadWidget()
                        : snapshot.data!.size == 0
                            ? ListView(
                              children: const[ NoDataCard(
                                  message: "لا يوجد طلبات",
                                )]
                            )
                            : SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(children: [
                                  statisticsWidget(ordersProvider,snapshot1.data),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _ordersList(snapshot.data, ordersProvider
                                  ,snapshot1.data[BackupRef.backupType],snapshot1.data[BackupRef.supplierIdRef]),
                                ]),
                              ))),
              ),
        ),
      ),
    );
  }

  Align _loadWidget() => const Align(
      alignment: Alignment.topCenter, child: CupertinoActivityIndicator());

  AppBar _appBar(BuildContext context, String date) {
    return AppBar(
      title: const Text("الطلبات"),
      leading: CircleIconButton(
        onTap: () => Navigator.pop(context),
        icon: Icons.arrow_back,
      ),
      actions: [
        Center(
            child: Text(
          date,
          style: Theme.of(context).textTheme.titleLarge,
        ))
      ],
      bottom: const PreferredSize(
          preferredSize: Size.fromHeight(15.0), // here the desired height
          child: Divider(
            color: Colors.blue,
          )),
    );
  }

  Wrap statisticsWidget(OrdersProvider ordersProvider,var data) {
    return Wrap(
      runAlignment: WrapAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: [
        ColoredContainer(content: "الكل: ${data[BackupRef.ordersCountRef]}"),
        ColoredContainer(content: "موصل: ${data[BackupRef.deliveredCountRef]}"),
        ColoredContainer(content: "جزئي: ${data[BackupRef.partialCountRef]}"),
        ColoredContainer(content: "منتظر: ${data[BackupRef.waitingCountRef]}"),
        ColoredContainer(content: "ملغي: ${data[BackupRef.canceledCountRef]}"),
      ],
    );
  }

  ListView _ordersList(data, OrdersProvider ordersProvider,String backupType,String? notifyUserId) {
   // ordersProvider.resettingStatistics();
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.size,
        itemBuilder: (context, position) {
          OrderModel orderModel =
              OrderModel.fromSnapshot(data.docs[position].data());
          //ordersProvider.setStatisticsValues(orderModel,currentIndex);
          return OrderCard(
            ordersProvider: ordersProvider,
            model: orderModel,
            notifyUserId: notifyUserId,
            backupType: backupType,
            onSelect: () {},
          );
        });
  }

  SizedBox _bottomNavBar({BuildContext? context,double? totalPrice,double? totalPayed}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Column(
        children: [
          const Divider(
            color: Colors.blue,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: "الإجمالي : ",
                  style: Theme.of(context!).textTheme.titleLarge),
              TextSpan(
                  text:totalPrice.toString(),
                  style: Theme.of(context).textTheme.titleLarge),
              TextSpan(
                  text: "  |  المدفوع : ",
                  style: Theme.of(context).textTheme.titleLarge),
              TextSpan(
                  text: totalPayed.toString(),
                  style: Theme.of(context).textTheme.titleLarge)
            ]),
          )
        ],
      ),
    );
  }

  Widget _addOrder(BuildContext context,String backupType,String?notifyUserId ) {
    return 
    (backupType==BackupRef.supplierBackup&&userModel!.type==UserRef.providerRef)
    ||
    (backupType==BackupRef.miniSupplierBackup&&userModel!.type==UserRef.supplierRef)
    ?
        FloatingActionButton.extended(
            onPressed: () => goTo(
                context: context,
                to: userModel!.type == UserRef.supplierRef
                    ? SelectOrder(
                        backupId: backupId, notifyUserId: notifyUserId)
                    : AddOrder(
                        backupId: backupId,
                        type: "إضافة طلب",
                        notifyUserId: notifyUserId,
                      )),
            label: const Text("إضافة طلب"),
          ):Container();
  }
}
