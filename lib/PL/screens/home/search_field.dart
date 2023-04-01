import 'package:flutter/material.dart';
class SearchField extends StatelessWidget {
  final Function()? onTap;
  final String? date;
  final TextEditingController? controller;
  const SearchField({Key? key,this.onTap,this.date,this.controller}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        elevation: 2,
        shape: const StadiumBorder(),child: TextFormField(
          readOnly: true,
          controller: controller,
          onTap: ()=>onTap!(),
          style:const TextStyle(color: Colors.grey, fontSize: 14),
          decoration:const InputDecoration(
              enabledBorder: InputBorder.none,

              focusedBorder: InputBorder.none,
              hintText: "بحث بتاريخ معين ...",
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              )),
        ),
      ),
    );
  }

}
