import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/PL/global/global_variables/theme_ref.dart';
import 'package:location/PL/global/themes/app_thems/dark_them_data.dart';
import 'package:location/PL/global/themes/app_thems/light_them_data.dart';
import 'package:location/provider/notify_provider.dart';
import 'package:location/provider/orders_provider.dart';
import 'package:location/provider/themeProvider.dart';
import 'package:location/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'screen_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/provider/backup_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

await GetStorage.init();
    await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BackupProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => NotifyProvider()),
      ],
      child:const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

  return Consumer<ThemeProvider>(
      builder: (context, theme, _) =>MaterialApp(
      title: 'LOCATION',
      debugShowCheckedModeBanner: false,
      themeMode:theme.themeMode==ThemeRef.light? ThemeMode.light:ThemeMode.dark,
      theme:lightThemeData(),
       darkTheme:darkThemeData(),
    home:const Directionality(textDirection: TextDirection.rtl,child: ScreenController()) ,
  ));
  }
}