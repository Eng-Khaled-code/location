import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/PL/global/firebase_var_ref/order_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/widgets/circle_icon_button.dart';
import 'package:location/PL/global/widgets/custom_text_field.dart';
import 'package:location/provider/orders_provider.dart';
import 'package:provider/provider.dart';

import '../../../global/firebase_var_ref/user_ref.dart';

// ignore: must_be_immutable
class AddOrder extends StatelessWidget {
  final String? backupId;
  final String? notifyUserId;
  final String? backupDate;

  String? orderId;
  String? customerName;
  String? address;
  String? phone;
  String? phone2;
  double? price;
  double? chargeValue;
  double? oldPrice;
  final String? type;

  AddOrder(
      {Key? key, this.backupId, this.type, this.backupDate, this.notifyUserId})
      : super(key: key);
  AddOrder.update(
      {Key? key,
      this.backupId,
      this.orderId,
      this.type,
      this.customerName,
      this.phone,
      this.phone2,
      this.notifyUserId,
      this.chargeValue,
      this.price,
      this.address,
      this.backupDate})
      : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: _appBar(context),
          body: _body(context),
        ));
  }

  Align _loadWidget() => const Align(
      alignment: Alignment.topCenter, child: CupertinoActivityIndicator());

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(type!),
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
  }

  _body(BuildContext context) {
    OrdersProvider ordersProvider = Provider.of<OrdersProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: ordersProvider.isLoading
            ? _loadWidget()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      initialValue: customerName,
                      label: "اسم العميل",
                      onSave: (value) {
                        customerName = value;
                      },
                      icon: Icons.person,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      initialValue: phone,
                      label: "رقم التليفون",
                      onSave: (value) {
                        phone = value;
                      },
                      icon: Icons.phone,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      initialValue: phone2 ?? "",
                      label: "تليفون اخر (إن امكن)",
                      onSave: (value) {
                        phone2 = value;
                      },
                      icon: Icons.phone,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      initialValue: (price ?? "").toString(),
                      label: "السعر",
                      onSave: (value) {
                        oldPrice = price;
                        price = double.tryParse(value);
                      },
                      icon: Icons.monetization_on_outlined,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      initialValue: (chargeValue ?? "").toString(),
                      label: "مصاريف الشحن",
                      onSave: (value) {
                        chargeValue = double.tryParse(value);
                      },
                      icon: Icons.monetization_on_outlined,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      initialValue: address,
                      label: "العنوان",
                      onSave: (value) {
                        address = value;
                      },
                      icon: Icons.location_history,
                      onTap: () {},
                    ),
                    const SizedBox(height: 25.0),
                    _addButton(ordersProvider, context),
                  ],
                ),
              ),
      ),
    );
  }

  Map<String, dynamic> setData() {
    DateTime dateTime = DateTime.now();
    String docId = dateTime.microsecondsSinceEpoch.toString();
    String date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    Map<String, dynamic> data = {
      OrderRef.price: price,
      OrderRef.providerBackupId: backupId,
      OrderRef.supplierBackupId: "",
      OrderRef.orderId: type == "إضافة طلب" ? docId : orderId,
      OrderRef.address: address,
      OrderRef.phone: phone,
      OrderRef.phone2: phone2,
      OrderRef.chargeValue: chargeValue,
      OrderRef.status: OrderRef.waiting,
      OrderRef.customerName: customerName,
      OrderRef.supplierPayed: 0.0,
      OrderRef.providerPayed: 0.0,
      OrderRef.date: date,
      OrderRef.supplierId:notifyUserId,
      OrderRef.providerId:userModel!.userId,
      UserRef.brand:userModel!.brand,
      UserRef.image:userModel!.image,
      UserRef.username:userModel!.userName
    };

    return data;
  }

  ElevatedButton _addButton(
      OrdersProvider ordersProvider, BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            if (type == "إضافة طلب") {
              ordersProvider.addOrder(
                  data: setData(),
                  backupDate: backupDate,
                  context: context,
                  notifyUserId: notifyUserId);
            } else {
              ordersProvider.updateOrder(
                  data: setData(),
                  oldPrice: oldPrice,
                  context: context,
                  notifyUserId: notifyUserId);
            }
          }
        },
        child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Center(child: Text(type!))));
  }
}
