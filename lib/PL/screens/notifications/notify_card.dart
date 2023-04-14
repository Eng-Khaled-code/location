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

import '../../global/widgets/user_identification.dart';
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
          goTo(context: context, to:
           OrdersPage(backupId: model!.contentId));
        }

        Provider.of<NotifyProvider>(context,listen: false).seen(model!.notifyId!);

      },
      child: Container(
          color:model!.status==NotifyRef.openedRef ? 
          Colors.transparent : notOpenedColor,
          
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: UserIdentification(
              name: model!.fromName!,
              image: model!.fromImage!,
              date: DateTime.fromMicrosecondsSinceEpoch(
                      int.tryParse(model!.date!)!)
                  .toString()),
           ),
       
        Padding(
          padding: const EdgeInsets.only(right: 75,bottom: 5),
          child: Text(model!.content!,
            maxLines: 3,
            textAlign: TextAlign.justify,
          ),
        ),
         const Divider(height: 0,thickness: 1,)
    ]

      ),
    ));
  }


}
