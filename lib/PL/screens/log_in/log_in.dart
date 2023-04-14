import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/PL/global/widgets/custom_text_field.dart';
import 'package:location/PL/global/widgets/loading_widget.dart';
import 'package:location/PL/global/widgets/image_widget.dart';
import 'package:location/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home/contact_us.dart';
class LogIn extends StatefulWidget {

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  String? _txtUsername;
  String? _txtPassword;


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Center(
        child: Form(
                key: _formKey,
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const ImageWidget(),
                          const SizedBox(height: 20.0),
                          user.isLoading?const LoadingWidget(loadingText:"جاري تسجيل الدخول..." ,):   dataColumn(user)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ));
  }

  Widget dataColumn(UserProvider user){
    return Column(children: [

       CustomTextField(
          icon: Icons.person,
          onSave: (value){
            setState(()=>_txtUsername=value);
          },
          label: "الايميل",
      initialValue: _txtUsername,
      textInputType: TextInputType.emailAddress,
         onTap: (){},
    ),
     const SizedBox(height: 15.0),
     CustomTextField(
        label: "كلمة المرور",
        icon: Icons.lock,
        onSave: (value){
          setState(()=>_txtPassword=value);
        },
    initialValue: _txtPassword,
    textInputType: TextInputType.emailAddress,
onTap: (){},
      ),
     const SizedBox(height: 30.0),
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
           onPressed:()=>
          onPressLogIn(user),child: const Text("تسجيل الدخول")
        ),
      ),
      const SizedBox(height: 30.0),
      _buildConnectUsWidget()
    ],);
  }


  Widget _buildConnectUsWidget() {
    return TextButton(
        child: Text(
          "للتواصل إضغط هنا",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        onPressed:()=>const ContactUs(),

    );
  }
  onPressLogIn(UserProvider user){
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      user.signIn(_txtUsername!, _txtPassword!);

    }
  }

}
