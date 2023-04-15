import 'package:flutter/material.dart';
import 'package:location/PL/global/widgets/image_widget.dart';

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
            ],
          ),
        ),
      ),
    );
  }

}
