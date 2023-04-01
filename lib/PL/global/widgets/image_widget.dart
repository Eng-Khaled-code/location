import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/PL/global/global_variables/images_ref.dart';
import '../global_variables/app_sizes.dart';
class ImageWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String? type;
  final String? url;
  final File? imageFile;
  const ImageWidget({Key? key,this.height=AppSizes.logoHeight,
    this.width=AppSizes.logoWidth,this.type="assets",this.url=ImagesRef.assetLogoString,this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  type=="network"?networkImageWidget():type=="assets"?assetImageWidget():fileImage();
  }

   networkImageWidget() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(60),
     child:Image.network(
      url! ,
      fit: BoxFit.cover,
      errorBuilder: (a, x, d) =>
          Image.asset(
            ImagesRef.assetErrorString,
            fit: BoxFit.cover,
            width: width,
            height:height,
          ),));
  }

  Container assetImageWidget() {
    return Container(
      width: width,
      height: height,
      decoration:BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image:AssetImage(url!),
            fit: BoxFit.cover
        ),
      ),
    );
  }

  fileImage(){
    return ClipRRect(
        borderRadius: BorderRadius.circular(60),
    child:Image.file(imageFile!,
    fit: BoxFit.cover,
      width: width,
      height:height,));
  }



}
