import 'package:flutter/material.dart';
import '../../global/firebase_var_ref/user_ref.dart';
import '../../global/themes/text_thems/text_var.dart';
import '../../global/widgets/circle_icon_button.dart';
import '../../global/widgets/methoods.dart';
import '../adminstration/add_user.dart';
import '../adminstration/users_list.dart';

class Supplier extends StatelessWidget {
  const Supplier({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _appBar(context),
        body: UsersList(),
        floatingActionButton: _addMiniSupplier(context),
      ),
    );
  }

  AppBar _appBar(BuildContext context) => AppBar(
        title:  const Text("المناديب",
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: TextVar.englishFontFamily)),
        leading:
          CircleIconButton(
            onTap: ()=>Navigator.pop(context),
            icon: Icons.arrow_back,
          ),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(15.0), // here the desired height
            child: Divider(
              color: Colors.blue,
            )),
      );

  FloatingActionButton _addMiniSupplier(BuildContext context) =>
      FloatingActionButton.extended(
        onPressed: () => goTo(
            context: context,
            to: AddUser(
              userType: UserRef.minSupplierRef,
            )),
        label:const Text("اضافة مندوب"),
      );
}
