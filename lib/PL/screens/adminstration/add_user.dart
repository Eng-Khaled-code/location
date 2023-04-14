import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/PL/global/firebase_var_ref/user_ref.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:provider/provider.dart';
import '../../../provider/user_provider.dart';
import '../../global/widgets/circle_icon_button.dart';
import '../../global/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class AddUser extends StatelessWidget {
  AddUser(
      {Key? key,
      this.addOrUpdate = "اضافة",
      this.address = "",
      this.name = "",
      this.email = "",
      this.password = "",
      this.brand = "",
      this.userId,
      this.userType})
      : super(key: key);

  String? addOrUpdate;
  String? name;
  String? userId;
  String? email;
  String? password;
  String? address;
  String? brand;
  String? userType;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: _appBar(context),
          body: _body(userProvider, context),
        ));
  }

  Align _loadWidget() => const Align(
      alignment: Alignment.topCenter, child: CupertinoActivityIndicator());

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text("${addOrUpdate!} مستخدم"),
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

  _body(UserProvider userProvider, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: userProvider.isLoading
            ? _loadWidget()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      initialValue: name,
                      label: "اسم المستخدم",
                      onSave: (value) {
                        name = value;
                      },
                      icon: Icons.person,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10.0),
                    addOrUpdate != "اضافة"
                        ? Container()
                        : CustomTextField(
                            icon: Icons.email,
                            onSave: (value) => email = value,
                            label: "الايميل",
                            initialValue: email,
                            textInputType: TextInputType.emailAddress,
                            onTap: () {},
                          ),
                    addOrUpdate != "اضافة"
                        ? Container()
                        : const SizedBox(height: 10.0),
                    addOrUpdate != "اضافة"
                        ? Container()
                        : CustomTextField(
                            label: "كلمة المرور",
                            icon: Icons.lock,
                            onSave: (value) => password = value,
                            initialValue: password,
                            textInputType: TextInputType.emailAddress,
                            onTap: () {},
                          ),
                    addOrUpdate != "اضافة"
                        ? Container()
                        : const SizedBox(height: 10.0),
                    CustomTextField(
                      initialValue: brand,
                      label: "العلامة التجارية",
                      onSave: (value) => brand = value,
                      icon: Icons.branding_watermark_sharp,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      initialValue: address,
                      label: "العنوان",
                      onSave: (value) => address = value,
                      icon: Icons.location_history,
                    ),
                    const SizedBox(height: 25.0),
                    _addButton(userProvider, context),
                  ],
                ),
              ),
      ),
    );
  }

  Map<String, dynamic> setData() {
    DateTime dateTime = DateTime.now();
    String docId = dateTime.microsecondsSinceEpoch.toString();
    Map<String, dynamic> data;
    if (addOrUpdate == "اضافة") {
      data = {
        UserRef.userId: docId,
        UserRef.address: address,
        UserRef.brand: brand,
        UserRef.email: email,
        UserRef.password: password,
        UserRef.image: "",
        UserRef.type: userType,
        UserRef.status: "مفتوح",
        UserRef.reason: "",
        UserRef.token: "",
        UserRef.username: name,
          //if user type is mini supplier then the mini supplier is belongs to supplier
        UserRef.adminId:userModel!.userId
      };
    } else {
      data = {
        UserRef.userId: userId,
        UserRef.address: address,
        UserRef.brand: brand,
        UserRef.username: name,
      };
    }
    return data;
  }

  ElevatedButton _addButton(UserProvider userProvider, BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            await userProvider.addOrUpdateUser(
                data: setData(), addOrUpdate: addOrUpdate, context: context);
          }
        },
        child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Center(child: Text(addOrUpdate!))));
  }
}
