import 'package:flutter/cupertino.dart';
import 'package:location/PL/screens/backups/backups_page/backup_card.dart';
import 'package:location/models/backup_model.dart';
import 'package:location/provider/backup_provider.dart';
import '../../../global/widgets/no_data_card.dart';

class BackupList extends StatelessWidget {
  final BackupProvider? backupProvider;
  final int? currentIndex;
  const BackupList({Key? key, this.backupProvider,this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: backupProvider!.backupsStream(currentIndex!),
        builder: (context, snapshot) {
          return !snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting
              ? _loadingWidget()
              : snapshot.data!.size == 0
                  ? const NoDataCard(
                      message: "لا يوجد backups",
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.size,
                      reverse: true,
                      itemBuilder: (context, position) {
                        BackupModel backupModel = BackupModel.fromSnapshot(
                            snapshot.data!.docs[position].data());
                          return BackupCard(model: backupModel);
                      });
        });
  }

  Align _loadingWidget() {
    return const Align(
        alignment: Alignment.topCenter, child: CupertinoActivityIndicator());
  }
}
