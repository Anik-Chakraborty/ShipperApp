import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/controller/homeWebController.dart';
import 'package:shipper_app/screens/Invoice_screen.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/radius.dart';
import '/constants/spaces.dart';
import '/controller/navigationIndexController.dart';
import '/screens/navigationScreen.dart';

class VerifyNowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeWebController homeWebController = Get.put(HomeWebController());

    NavigationIndexController navigationIndexController =
        Get.put(NavigationIndexController());
    return GestureDetector(
      onTap: () {
        if (kIsWeb) {
          homeWebController.changeVisibleWidgetWithSideBarSelectedIndex(const InvoiceScreen(), 3);
        } else {
          Get.offAll(NavigationScreen(initScreen: 2));
          navigationIndexController.updateIndex(2);
        }
      },
      child: Container(
        height: space_8,
        padding: EdgeInsets.symmetric(horizontal: space_3),
        decoration: BoxDecoration(
            color: darkBlueColor,
            borderRadius: BorderRadius.circular(radius_6)),
        child: Center(
          child: Text(
            'verifyButton'.tr,
            // "Verify Now",
            style: TextStyle(
                color: white, fontWeight: mediumBoldWeight, fontSize: size_8),
          ),
        ),
      ),
    );
  }
}
