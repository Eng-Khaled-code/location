import 'package:flutter/material.dart';
import 'package:location/PL/global/firebase_var_ref/notify_ref.dart';
import 'package:location/PL/global/global_variables/app_sizes.dart';
import 'package:location/PL/global/themes/app_colors/dark_colors.dart';
import 'package:location/PL/global/themes/app_colors/light_colors.dart';
import 'package:location/PL/global/widgets/image_widget.dart';
import 'package:location/PL/global/widgets/methoods.dart';
import 'package:location/PL/screens/backups/orders/orders_page.dart';
import 'package:location/models/notify_model.dart';
import 'package:location/provider/notify_provider.dart';
import 'package:provider/provider.dart';
class NotifyCard extends StatelessWidget {
  final NotifyModel? model;

   NotifyCard({Key? key,@required this.model}) : super(key: key);
  Color? textColor,notOpenedColor;

  @override
  Widget build(BuildContext context) {
    bool con=Theme.of(context).brightness==Brightness.light;
    textColor =con?LightColors.cardText: DarkColors.cardText;
    notOpenedColor=con?LightColors.notifyNotOpened: DarkColors.notifyNotOpened;
    return InkWell(
      onTap: (){
        if(model!.type==NotifyRef.moneyRef)
        {

        }else
        {
          goTo(context: context, to: OrdersPage(backupId: model!.contentId,backUpDate: model!.backupDate,));
        }

        Provider.of<NotifyProvider>(context,listen: false).seen(model!.notifyId!);

      },
      child: Container(
          padding:const EdgeInsets.all(10),
          color:model!.status==NotifyRef.openedRef ? Colors.transparent : notOpenedColor,
      child: Column(
        children: [
        contentWidget(),
         const Divider()
    ]

      ),
    ));
  }

  _userImage() {
    return   ImageWidget(url: model!.fromImage,
        type: "network",height: AppSizes.notifyImageHeight,width:AppSizes.notifyImageWidth);
  }

  contentWidget() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        _userImage(),
        const SizedBox(width: 10.0),
        Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model!.fromName!,
                  maxLines: 1,
                ),
                Text(model!.content!,
                  maxLines: 3,
                ),
                Text(DateTime.fromMillisecondsSinceEpoch(int.tryParse(model!.date!)!).toString().substring(0,10)
                )
              ],
            )),
      ],);
  }
}
