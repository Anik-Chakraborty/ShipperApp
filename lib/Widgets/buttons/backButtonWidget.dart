import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/controller/homeWebController.dart';

class BackButtonWidget extends StatelessWidget {
  var previousPage;
  int? selectedIndex;

  BackButtonWidget({super.key, this.previousPage, this.selectedIndex});

  HomeWebController homeWebController = Get.put(HomeWebController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (previousPage != null) {
          if (kIsWeb) {
            homeWebController.changeVisibleWidgetWithSideBarSelectedIndex(previousPage, selectedIndex ?? 0);
          }else { 
            Navigator.pushReplacement(  
              context, 
              MaterialPageRoute(
                builder: (context) => previousPage,
              ));
          }
        } else {
          Get.back();
        }
      },
      child: const Icon(Icons.arrow_back_ios_rounded),
    );
  }
}
