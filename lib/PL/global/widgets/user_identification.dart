import 'package:flutter/material.dart';

class UserIdentification extends StatelessWidget {
  const UserIdentification({super.key, this.date = "", this.image, this.name,this.formatedDate=false});
  final String? name;
  final String? image;
  final String? date;
  final bool? formatedDate;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 5,
        ),
        image == ""
            ? ClipOval(
                child: Image.asset(
                "assets/images/app_icon.jpeg",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ))
            : CircleAvatar(
                backgroundImage: NetworkImage(image!),
                backgroundColor: Colors.grey,
              ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name!,
              maxLines: 1,
            ),
            date == ""
                ? Container()
                : Text(
                    formatedDate!?date!: date!.substring(0, date!.length - 10),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                  ),
          ],
        ),
      ],
    );
  }
}
