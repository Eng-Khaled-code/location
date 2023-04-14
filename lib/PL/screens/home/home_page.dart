import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/themes/text_thems/text_var.dart';
import 'package:location/PL/global/widgets/circle_icon_button.dart';
import 'package:location/PL/global/widgets/custom_alert_dialog.dart';
import 'package:location/provider/backup_provider.dart';
import 'package:provider/provider.dart';
import 'package:location/PL/screens/home/search_field.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../global/firebase_var_ref/backup_ref.dart';
import '../../global/firebase_var_ref/notify_ref.dart';
import '../../global/firebase_var_ref/user_ref.dart';
import '../../global/widgets/methoods.dart';
import '../backups/backups_page/backup_list.dart';
import '../backups/orders/orders_page.dart';
import '../notifications/notifications.dart';
import 'add_back_up/add_backup_dialog.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();
  int currentIndex = userModel!.type == UserRef.minSupplierRef ? 1 : 0;
  String title = "Backups الموردين";

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);


  }

  void _handleMessage(RemoteMessage message) {

    if (message.data[NotifyRef.type] == NotifyRef.orderRef) {

      goTo(
          context: context,
          to: OrdersPage(backupId: message.data[BackupRef.backupIdRef]));
    } else {
      // go to financial page
    }
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();

  }

  @override
  Widget build(BuildContext context) {
    BackupProvider backupProvider = Provider.of<BackupProvider>(context);
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
            body: _body(backupProvider, context),
            bottomNavigationBar:
                userModel!.type == UserRef.supplierRef ? bottomNavBar() : null,
            floatingActionButton: showFAB() ? _addBackUp(context) : null));
  }

  bool showFAB() {
    return (userModel!.type == UserRef.providerRef && currentIndex == 0) ||
        (userModel!.type == UserRef.supplierRef && currentIndex == 1);
  }

  AppBar _homeAppBar() => AppBar(
        title: Text(title,
            style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: TextVar.englishFontFamily)),
        leading: CircleIconButton(
          onTap: () => _key.currentState!.openDrawer(),
        ),
        actions: [
          CircleIconButton(
            onTap: () => goTo(context: context, to: const NotificationPage()),
            icon: Icons.notifications,
          ),
          CircleIconButton(
            onTap: () async => await scanQr(),
            icon: Icons.barcode_reader,
          )
        ],
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(15.0), // here the desired height
            child: Divider(
              color: Colors.blue,
            )),
      );

  FloatingActionButton _addBackUp(BuildContext context) =>
      FloatingActionButton.extended(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AddBackupDialog(
                  backupType: currentIndex == 0
                      ? BackupRef.supplierBackup
                      : BackupRef.miniSupplierBackup,
                )),
        label: const Text("إضافة Backup"),
      );

  RefreshIndicator _body(BackupProvider backupProvider, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        backupProvider.refresh();
      },
      child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              filterList(backupProvider),
              const SizedBox(
                height: 10,
              ),
              backupProvider.selectedType == "بحث"
                  ? _searchWidget(backupProvider, context)
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              BackupList(
                backupProvider: backupProvider,
                currentIndex: currentIndex,
              ),
            ],
          )),
    );
  }

  SizedBox filterList(BackupProvider backupProvider) {
    return SizedBox(
      height: 41,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: GlobalVariables.filterList.length,
          itemBuilder: (context, position) {
            return itemCard(
                GlobalVariables.filterList[position], position, backupProvider);
          }),
    );
  }

  InkWell itemCard(String text, int position, BackupProvider backupProvider) {
    bool con = backupProvider.selectedType == text ? true : false;
    String newText = position == 2 ? getMonthAsString(text: text) : text;
    return InkWell(
        onTap: () {
          backupProvider.setType(text);
        },
        child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: con ? Colors.blue : Colors.transparent),
            child: Text(newText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: con ? Colors.white : Colors.blue,
                ))));
  }

  SearchField _searchWidget(
      BackupProvider backupProvider, BuildContext context) {
    TextEditingController textEditingController =
        TextEditingController(text: backupProvider.selectedDate!);
    return SearchField(
        date: backupProvider.selectedDate,
        controller: textEditingController,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2022),
              lastDate: DateTime(2100));
          if (pickedDate != null) {
            String date = pickedDate.toString().substring(0, 10);
            backupProvider.setDate(date);
          }
        });
  }

  BottomNavigationBar bottomNavBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: "الموردين Backups"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: "المندوب Backups")
      ],
      selectedItemColor: Colors.blue,
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
          title = index == 0 ? "الموردين Backups" : "المندوب Backups";
        });
      },
    );
  }

  Future<void> scanQr() async {
    try {
      String value = await FlutterBarcodeScanner.scanBarcode(
          '#2A99CF', 'رجوع', true, ScanMode.QR);
      bool condition = value.length == 16 && int.tryParse(value) != null;
      final Uri? uri = Uri.tryParse(value);

      if (condition) {
        // ignore: use_build_context_synchronously
        goTo(context: context, to: OrdersPage(backupId: value));
      } else if (uri!.hasAbsolutePath) {
        await launchUrl(uri);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
    }
  }
}
