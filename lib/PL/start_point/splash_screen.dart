import 'package:flutter/material.dart';
import 'package:location/PL/global/widgets/image_widget.dart';
import 'package:location/provider/user_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool landscapeOrientation =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              landscapeOrientation
                  ? const SizedBox(
                      height: 50,
                    )
                  : const SizedBox(
                      height: 150,
                    ),
              const ImageWidget(),
              const SizedBox(
                height: 20,
              ),
              _error(context),
            ],
          ),
        ),
      ),
    );
  }

  Text _error(BuildContext context) => Text(
        Provider.of<UserProvider>(context, listen: false).userStatusReason,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelMedium,
      );
}
