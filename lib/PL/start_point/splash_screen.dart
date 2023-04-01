import 'package:flutter/material.dart';
import 'package:location/PL/global/global_variables/global_variables.dart';
import 'package:location/PL/global/widgets/image_widget.dart';
class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    bool landscapeOrientation=MediaQuery.of(context).orientation==Orientation.landscape;
    print(userStatusReason);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
          children: [
            landscapeOrientation
                ?
            const SizedBox(height: 50,)
                :
            const SizedBox(height: 150,),
            const ImageWidget(),
            const SizedBox(height: 20,),

            _error(context),

          ],
            ),
        ),
      ),
    );
  }


  Text _error(BuildContext context)=>Text(userStatusReason,textAlign: TextAlign.center,style: Theme.of(context).textTheme.labelMedium,);

}
