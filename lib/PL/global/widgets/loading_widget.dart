import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? loadingText;
  const LoadingWidget({Key? key,this.loadingText=""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CupertinoActivityIndicator(),
        Text(loadingText!,style: Theme.of(context).textTheme.titleMedium)
      ],
    );
  }
}
