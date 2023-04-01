import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/PL/global/widgets/circle_icon_button.dart';
import 'package:location/PL/global/widgets/colored_container.dart';
import 'package:location/PL/global/widgets/methoods.dart';
import 'package:location/PL/global/widgets/no_data_card.dart';
import 'package:location/models/order_model.dart';
import 'package:location/provider/orders_provider.dart';
import 'package:provider/provider.dart';
import 'add_order.dart';
import 'order_card.dart';
// ignore: must_be_immutable
class OrdersPage extends StatelessWidget {
  final String? backupId;
  final String? backUpDate;

  const OrdersPage({Key? key,this.backupId,this.backUpDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrdersProvider ordersProvider=Provider.of<OrdersProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder(
          stream:   ordersProvider.getOrdersStream(backupId!),
          builder:(context,snapshot)=>
        Scaffold(
          appBar: _appBar(context,backUpDate!),
          bottomNavigationBar: _bottomNavBar(context,ordersProvider),
          floatingActionButton: _addOrder(context),
          body:
          RefreshIndicator(
              onRefresh: ()async{

              ordersProvider.refresh();
              },
              child:
          !snapshot.hasData||snapshot.connectionState==ConnectionState.waiting
              ?
            _loadWidget()
              :
          snapshot.data!.size==0?const NoDataCard(message: "لا يوجد طلبات",):
           SingleChildScrollView(
             physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
                children:[
                      statisticsWidget(ordersProvider),
                      const SizedBox(height: 10,),
                     _ordersList(snapshot.data,ordersProvider),
            ]),
          ))),
      ),
    );
  }

  Align _loadWidget()=>const Align(alignment: Alignment.topCenter,child: CupertinoActivityIndicator());

  AppBar _appBar(BuildContext context,String date) {
    return AppBar(title:const Text("الطلبات" ),
      leading: CircleIconButton(onTap: ()=>Navigator.pop(context),icon: Icons.arrow_back,),
      actions: [Center(child: Text(date,style:Theme.of(context).textTheme.titleLarge ,))],
      bottom:const PreferredSize(
          preferredSize: Size.fromHeight(15.0), // here the desired height
          child:Divider(color: Colors.blue,)) ,
    );
  }

  Wrap statisticsWidget(OrdersProvider ordersProvider) {
    return Wrap(
      runAlignment: WrapAlignment.center,

      spacing: 5,
      runSpacing: 5,
      children: [
      ColoredContainer(content: "الكل: ${ordersProvider.ordersCount}"),
      ColoredContainer(content: "موصل: ${ordersProvider.deliveredCount}"),
      ColoredContainer(content: "جزئي: ${ordersProvider.partialCount}"),
      ColoredContainer(content: "منتظر: ${ordersProvider.waitingCount}"),
      ColoredContainer(content: "ملغي: ${ordersProvider.canceledCount}"),

    ],);
  }

 ListView _ordersList(data,OrdersProvider ordersProvider) {
    ordersProvider.resettingStatistics();
    return  ListView.builder(
               physics:const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.size,
              itemBuilder: (context,position){
                OrderModel orderModel=OrderModel.fromSnapshot(data.docs[position].data());
                ordersProvider.setStatisticsValues(orderModel);
                return OrderCard(model: orderModel);
        });
 }


  SizedBox _bottomNavBar(BuildContext context,OrdersProvider ordersProvider) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Column(children: [
       const Divider(color: Colors.blue,),

      RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            children: [ TextSpan(
              text: "الإجمالي : ",style: Theme.of(context).textTheme.titleLarge
            ),
              TextSpan(
                  text:ordersProvider.totalPrice.toString(),style: Theme.of(context).textTheme.titleLarge
              ),
               TextSpan(
                text: "  |  المدفوع : ",style: Theme.of(context).textTheme.titleLarge
              ),
              TextSpan(
                  text:ordersProvider.totalPayed.toString(),style: Theme.of(context).textTheme.titleLarge
              )
            ]
        ),
      )
      ],),
    );

  }

  FloatingActionButton _addOrder(BuildContext context) {
    return FloatingActionButton.extended(
          onPressed: ()=>goTo(context: context, to:  AddOrder(backupId: backupId,
            type: "إضافة طلب" ,backupDate: backUpDate,)),
          label:const Text("إضافة طلب"),
        );

  }

}
