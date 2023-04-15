import 'package:flutter/material.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/global_variables/screen_controller_ref.dart';
import 'package:location/PL/screens/home/home_page.dart';
import 'package:location/PL/screens/log_in/log_in.dart';
import 'package:location/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../screens/adminstration/adminstration.dart';
import 'splash_screen.dart';

class ScreenController extends StatelessWidget {
  const ScreenController({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    switch (user.page) {
      case ScreenControllerRef.homePage:
        if (userModel!.type == "مسئول") {
          return  Administration();
        } else {
          return  HomePage();
        }
      case ScreenControllerRef.logInPage:
        return const LogIn();
      default:
        return const SplashScreen();
    }
  }
}
