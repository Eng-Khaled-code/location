import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/PL/global/global_variables/images_ref.dart';
import 'package:location/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../global_variables/app_sizes.dart';
import 'package:flutter/cupertino.dart';
class ImageWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String? type;
  final String? url;
  final bool? isProfile;
  const ImageWidget(
      {Key? key,
      this.height = AppSizes.logoHeight,
      this.width = AppSizes.logoWidth,
      this.type = "assets",
      this.url,
      this.isProfile = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider= Provider.of<UserProvider>(context);
    return Center(
      child: userProvider.isImageLoading?SizedBox(width: width,height: height,child: const CupertinoActivityIndicator()): InkWell(
          onTap: ()=>onPressPhotoButton(context, userProvider),
          child: type == "network" ? networkImageWidget() : assetImageWidget()),
    );
  }

  onPressPhotoButton(BuildContext context, UserProvider userProvider) {
    return showDialog(
        context: context,
        builder: (con) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SimpleDialog(
              title: const Text(
                "صورة العلامة التجارية",
              ),
              children: [
                SimpleDialogOption(
                  child: const Text("التقاط بالكاميرا"),
                  onPressed: () => picImage(ImageSource.camera, context,userProvider),
                ),
                SimpleDialogOption(
                  child: const Text("اختيار من المعرض"),
                  onPressed: () => picImage(ImageSource.gallery, context,userProvider),
                ),
                SimpleDialogOption(
                  child: const Text("الغاء"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }

  picImage(ImageSource imageSource, BuildContext context,
      UserProvider userProvider) async {
    Navigator.pop(context);
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    File image = File(pickedImage!.path);
    // ignore: use_build_context_synchronously
    userProvider.updateProfilePicture(imageFile: image);
  }

  networkImageWidget() {
    return ClipOval(
      
        child: Image.network(
      url!,
      fit: BoxFit.cover,
       width: width,
      height: height,
      errorBuilder: (a, x, d) => Image.asset(
        ImagesRef.assetErrorString,
        fit: BoxFit.cover,
        width: width,
        height: height,
      ),
    ));
  }

  Container assetImageWidget() {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: AssetImage(ImagesRef.assetLogoString), fit: BoxFit.cover),
      ),
    );
  }
}
