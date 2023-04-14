import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/models/notify_model.dart';
import 'package:location/provider/notify_provider.dart';
import 'package:provider/provider.dart';
import '../../global/widgets/no_data_card.dart';
import 'notify_card.dart';

class NotifyList extends StatelessWidget {
  const NotifyList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    NotifyProvider notifyProvider = Provider.of<NotifyProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        notifyProvider.refresh();
      },
      child: StreamBuilder(
          stream: notifyProvider.getNotificationStream(),
          builder: (context, snapshot) {
            return !snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting
                ? _loadingWidget()
                : snapshot.data!.size == 0
                    ? const NoDataCard(
                        message: "لا توجد إشعارات",
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.size,
                        reverse: true,
                        itemBuilder: (context, position) {
                          NotifyModel notifyModel = NotifyModel.fromSnapshot(
                              snapshot.data!.docs[position].data());
                          return NotifyCard(model: notifyModel);
                        });
          }),
    );
  }

  Align _loadingWidget() {
    return const Align(
        alignment: Alignment.topCenter, child: CupertinoActivityIndicator());
  }
}
