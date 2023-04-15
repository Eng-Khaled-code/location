// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/PL/screens/adminstration/users_list.dart';
import '../../global/firebase_var_ref/user_ref.dart';
import '../../global/widgets/circle_icon_button.dart';
import '../../global/widgets/custom_alert_dialog.dart';
import '../../global/widgets/methoods.dart';
import '../home/drawer.dart';
import 'add_user.dart';

class Administration extends StatefulWidget {
   Administration({super.key});

  @override
  State<Administration> createState() => _AdministrationState();
}

class _AdministrationState extends State<Administration> {
  final _key = GlobalKey<ScaffoldState>();
  String title = "الموردين";
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                    title: "خروج",
                    onPress: () {
                      SystemNavigator.pop();
                    },
                    text: "هل تريد الخروج من التطبيق بالفعل",
                  ));

          return true;
        },
        child: Scaffold(
          key: _key,
          drawer: const CustomDrawer(),
          appBar: _homeAppBar(),
          body: UsersList(userType: currentIndex == 0 ? UserRef.providerRef :currentIndex == 1 ?  UserRef.supplierRef:UserRef.minSupplierRef),
          floatingActionButton:currentIndex==2?null: _addUser(context),
          bottomNavigationBar: bottomNavBar(),
        ));
  }

  AppBar _homeAppBar() => AppBar(
      title: Text(title,
          style: const TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22)),
      leading: CircleIconButton(
        onTap: () => _key.currentState!.openDrawer(),
      ),
      actions: [
        CircleIconButton(
          onTap: () {},
          icon: Icons.notifications,
        )
      ],
      bottom: const PreferredSize(
          preferredSize: Size.fromHeight(15.0), // here the desired height
          child: Divider(
            color: Colors.blue,
          )));

  FloatingActionButton _addUser(BuildContext context) =>
      FloatingActionButton.extended(
        onPressed: () => goTo(
            context: context,
            to: AddUser(
              userType: currentIndex == 0 ? UserRef.providerRef : UserRef.supplierRef,
            )),
        label: Text( currentIndex == 0 ?"إضافة مورد" :"إضافة موزع"),
      );

  BottomNavigationBar bottomNavBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "الموردين"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "الموزعين"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "المناديب")

      ],
      selectedItemColor: Colors.blue,
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
          title = index == 0 ? "الموردين" :index == 1 ? "الموزعين":"المناديب";
        });
      },
    );
  }
}
