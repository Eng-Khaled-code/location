import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final Function(String value)? onSave;
  final Function()? onTap;
  final String? initialValue;
  final TextInputType? textInputType;
  CustomTextField(
      {super.key,
      @required this.label,
      @required this.icon,
      @required this.onSave,
      this.onTap,
      this.initialValue = "",
      this.textInputType = TextInputType.text});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hidePass = true;

  IconData hidePassIcon = Icons.visibility_off;

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: TextFormField(
            onSaved: (value) {
              widget.onSave!(value!);
            },
            initialValue: widget.initialValue,
            maxLines: widget.label == "تفاصيل اكثر" || widget.label == "العنوان"
                ? 3
                : 1,
            keyboardType: widget.textInputType,
            obscureText: widget.label == "كلمة المرور" ||
                    widget.label == "كلمة المرور الجديدة" ||
                    widget.label == "كلمة المرور القديمة"
                ? hidePass
                : false,
            validator: (value) {
              bool isNumber;
              bool isGreaterThan0;
              //checking is number or not
              try {
                int.parse(value!);
                isNumber = true;
              } catch (ex) {
                isNumber = false;
              }

         bool isDouble(String s) {
        if (s == "") {
          return false;
        }
        return double.tryParse(s) != null;
      }

              //checking is greater than zero or not
              if (isNumber) {
                if (int.parse(value!) > 0) {
                  isGreaterThan0 = true;
                } else {
                  isGreaterThan0 = false;
                }
              } else {
                isGreaterThan0 = false;
              }

              if (value!.isEmpty && widget.label != "تليفون اخر (إن امكن)") {
                return "من فضلك إدخل ${widget.label!}";
              } else if (widget.label == "الايميل") {
                   Pattern pattern =
                    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$';

                RegExp regExp = RegExp(pattern.toString());
                if (!regExp.hasMatch(value)) return "تاكد من صحة الإيميل";
              } else if ((widget.label == "كلمة المرور" ||
                      widget.label == "كلمة المرور الجديدة" ||
                      widget.label == "كلمة المرور القديمة") &&
                  value.length < 8) {
                return "كلمة المرور يجب الا تقل عن ثمانية احرف";
              } else if ((widget.label == "رقم الطابق" ||
                      widget.label == "الكمية") &&
                  ( isNumber == false ||isGreaterThan0==false)) {
                return "من فضلك إدخل رقم";
              } else if ((widget.label == "السعر" ||
                      widget.label == "القيمة" ||
                      widget.label == "مصاريف الشحن") &&
                  (isDouble(value) == false ||isGreaterThan0==false)) {
                return "من فضلك إدخل قيمة";
              } else if ((widget.label == "رقم التليفون" ||widget.label == "تليفون (اخر إن امكن)") &&(isNumber==false||value.length != 11||!value.startsWith("01"))
                 ) {
                return "رقم التليفون غير صحيح";
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: widget.label,
              icon: Icon(
                widget.icon,
              ),
              suffixIcon: widget.label == "كلمة المرور" ||
                      widget.label == "كلمة المرور الجديدة" ||
                      widget.label == "كلمة المرور القديمة"
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                        icon: Icon(hidePassIcon),
                        onPressed: () {
                          setState(() {
                            if (hidePass) {
                              hidePass = false;
                              hidePassIcon = Icons.visibility;
                            } else {
                              hidePass = true;
                              hidePassIcon = Icons.visibility_off;
                            }
                          });
                        },
                      ),
                    )
                  : null,
            ),
            onTap: () {
              widget.onTap!();
            },
          ),
        ));
  }
}
