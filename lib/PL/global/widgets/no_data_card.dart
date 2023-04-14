import 'package:flutter/material.dart';

import '../global_variables/app_sizes.dart';
class NoDataCard extends StatelessWidget {

  final String? message;
  const NoDataCard({Key? key,this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child:SizedBox(
          width: double.infinity,
          height: AppSizes.noDataCardHeight,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      const Icon(Icons.assignment,size: 50),
      const SizedBox(height: 15.0),
      Text( message!)],),
        ),
        );
  }
}
