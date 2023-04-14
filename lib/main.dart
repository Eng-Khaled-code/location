import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/PL/global/global_variables/theme_ref.dart';
import 'package:location/PL/global/themes/app_thems/dark_them_data.dart';
import 'package:location/PL/global/themes/app_thems/light_them_data.dart';
import 'package:location/provider/notify_provider.dart';
import 'package:location/provider/orders_provider.dart';
import 'package:location/provider/theme_provider.dart';
import 'package:location/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'PL/start_point/screen_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/provider/backup_provider.dart';

/*Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("object");
  await displayNotification(message);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
   FlutterLocalNotificationsPlugin();*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Firebase.initializeApp();
  
    
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BackupProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => NotifyProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
              title: 'LOCATION',
              debugShowCheckedModeBanner: false,
              themeMode: theme.themeMode == ThemeRef.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
              theme: lightThemeData(),
              darkTheme: darkThemeData(),
              home: const Directionality(
                  textDirection: TextDirection.rtl, child: ScreenController()),
            ));
  }
}

 /*initialize(BuildContext context) {
    AndroidInitializationSettings androidSettings =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettings =
        InitializationSettings(android: androidSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
    
        onDidReceiveBackgroundNotificationResponse:
            (NotificationResponse notificationResponse) {
      print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
      try {
        if (notificationResponse.id != null) {
          print("tttttttttttttttt");

          if (notificationResponse.payload == NotifyRef.orderRef) {
            print("oooooooooooooooooo");

            goTo(
                context: context, to: OrdersPage(backupId: "1680989798829597"));
          } else {
            // go to financial page
          }
        }
      } catch (ex) {
        print(ex);
      }
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await displayNotification(message);
    });
  }
   Future<void> displayNotification(RemoteMessage message) async {
    try {
      NotificationDetails notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
          'location_channel',
          'location_channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data[NotifyRef.type],
      );
    } on Exception catch (e) {
      print(e);
    }
  }*/