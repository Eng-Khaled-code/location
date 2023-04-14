import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/PL/global/themes/app_colors/dark_colors.dart';
import 'package:location/PL/global/themes/app_colors/light_colors.dart';
import 'package:location/PL/global/widgets/custom_alert_dialog.dart';
import 'package:location/PL/global/widgets/methoods.dart';
import 'package:location/PL/screens/backups/orders/orders_page.dart';
import 'package:location/models/backup_model.dart';
import 'package:location/provider/backup_provider.dart';
import 'package:provider/provider.dart';
import '../../../global/firebase_var_ref/backup_ref.dart';
import '../../../global/firebase_var_ref/user_ref.dart';
import '../../../global/global_variables/global_variables.dart';
import '../../../global/widgets/user_identification.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class BackupCard extends StatelessWidget {
  final BackupModel? model;
  BackupCard({Key? key, @required this.model}) : super(key: key);
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    textColor = Theme.of(context).brightness == Brightness.light
        ? LightColors.cardText
        : DarkColors.cardText;
    return Dismissible(
      direction: DismissDirection.startToEnd,
      key: Key(model!.backupId!),
      onDismissed: (direction) {
        if (model!.ordersCount == 0) {
          showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                  title: "حذف BackUp",
                  text: "هل تريد الحذف بالفعل؟",
                  onPress: () {
                    Navigator.pop(context);
                    Provider.of<BackupProvider>(context, listen: false)
                        .deleteBackup(backupId: model!.backupId);
                  }));
        } else {
          Fluttertoast.showToast(msg: "لا يمكنك الحذف لانه يحتوي علي طلبات");
        }
      },
      background: dismissibleBackground(),
      child: InkWell(
          onTap: () => goTo(
              context: context,
              to: OrdersPage(
                backupId: model!.backupId,
              )),
          child: Card(
              margin: const EdgeInsets.only(bottom: 5.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _topWidget(context),
                    const Divider(),
                    barCodeWidget(context),
                    const SizedBox(height: 10),
                    _centerWidget(context),
                    const Divider(),
                    _bottomWidget()
                  ],
                ),
              ))),
    );
  }

  barCodeWidget(BuildContext context) {
    return GestureDetector(
        onTapDown: (details) => showPopUpMenue(details, context),
        child: BarcodeWidget(
          data: model!.backupId!,
          barcode: Barcode.qrCode(),
          color: Colors.blue,
          height: 150,
          width: 150,
        ));
  }

  showPopUpMenue(TapDownDetails details, BuildContext context) {
    final List<String> types = ["عرض", "طباعة"];
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy,
        ),
        elevation: 3.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        items: types.map((String choice) {
          return PopupMenuItem(
            value: choice,
            onTap: () => printBarode(choice),
            child: Text(
              choice,
              style: const TextStyle(fontSize: 12),
            ),
          );
        }).toList());
  }

  Future<void> printBarode(String choice) async {
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
              child: pw.BarcodeWidget(
            data: model!.backupId!,
            barcode: Barcode.qrCode(),
            height: 400,
            width: 400,
          ));
        }));

    if (choice == "عرض") {
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => doc.save());
    } else {
      final output = await getExternalStorageDirectory();
      String savePath = "${output!.path}/${model!.brand! + model!.date!}.pdf";
      final file = File(savePath);
      await file.writeAsBytes(await doc.save());
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        Fluttertoast.showToast(msg: "تم الحفظ في ${file.path}");
      }
    }
  }

  Container dismissibleBackground() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red[100], borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: const [
          Spacer(),
          Icon(
            Icons.delete,
            size: 30,
          )
        ],
      ),
    );
  }

  Row _topWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        userModel!.type != UserRef.minSupplierRef
            ? UserIdentification(
                image: userModel!.type == UserRef.supplierRef
                    ? model!.providerImage
                    : model!.userImage,
                name: userModel!.type == UserRef.supplierRef
                    ? "${model!.providerName} - ${model!.providerBrand}"
                    : "${model!.userName} - ${model!.brand}",
                date: model!.date,
                formatedDate: true)
            : _dateWidget(),
        _ordersCountWidget(),
      ],
    );
  }

  RichText _centerWidget(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(text: "الإجمالي : ", style: TextStyle(color: textColor)),
        TextSpan(
            text: model!.price.toString(),
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: textColor)),
        TextSpan(text: "  |  المدفوع : ", style: TextStyle(color: textColor)),
        TextSpan(
            text: model!.payed.toString(),
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: textColor))
      ]),
    );
  }

  Row _bottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _waitingCountWidget(),
        _deliveredCountWidget(),
        _partialCountWidget(),
        _canceledCountWidget()
      ],
    );
  }

  Text _ordersCountWidget() {
    return Text("الطلبات : ${model!.ordersCount.toString()}",
        style: textStyle());
  }

  Text _waitingCountWidget() {
    return Text("المنتظر : ${model!.waitingCount.toString()}",
        style: textStyle());
  }

  Text _deliveredCountWidget() {
    return Text("الموصل : ${model!.deliveredCount.toString()}",
        style: textStyle());
  }

  Text _canceledCountWidget() {
    return Text("لاغي : ${model!.canceledCount.toString()}",
        style: textStyle());
  }

  Text _partialCountWidget() {
    return Text("جزئي : ${model!.partialCount.toString()}", style: textStyle());
  }

  Text _dateWidget() {
    return Text(
      model!.date!,
      style: textStyle(),
    );
  }

  TextStyle textStyle() {
    return TextStyle(color: textColor, fontWeight: FontWeight.bold);
  }
}
