import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/global_variables/theme_ref.dart';

class ThemeProvider with ChangeNotifier {

  String? themeMode;
  final GetStorage storage=GetStorage();
  ThemeProvider(){
    themeMode=storage.read(ThemeRef.themMode)??ThemeRef.light;

  }
  void setThemeMode(String mode) async {
    themeMode=mode;
    storage.write(ThemeRef.themMode,mode );
    notifyListeners();
  }

}