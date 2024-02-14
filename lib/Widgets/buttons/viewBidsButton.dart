import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/controller/homeWebController.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/screens/myLoadPages/biddingScreen.dart';

// ignore: must_be_immutable
class ViewBidsButton extends StatelessWidget {
  final String? loadId;
  final String? loadingPointCity;
  final String? unloadingPointCity;
  final bool screenSmall;

  ViewBidsButton(
      {required this.loadId,
      required this.loadingPointCity,
      required this.unloadingPointCity,
      required this.screenSmall});

  HomeWebController homeWebController = Get.put(HomeWebController());

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && Responsive.isDesktop(context)) {
      return Expanded(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            margin: const EdgeInsets.only(top: 5, bottom: 0, left: 0, right: 0),
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            decoration: const BoxDecoration(
              color: darkBlueColor,
            ),
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                )),
                backgroundColor:
                    MaterialStateProperty.all<Color>(darkBlueColor),
              ),
              child: Center(
                child: Text(
                  'viewBids'.tr,
                  // 'View Bids',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: 0.7,
                    fontWeight: mediumBoldWeight,
                    color: white,
                    fontSize: size_6,
                  ),
                ),
              ),
              onPressed: () {
                ((kIsWeb)
                    ? homeWebController.changeVisibleWidgetWithSideBarSelectedIndex(BiddingScreens(
                        loadId: loadId,
                        loadingPointCity: loadingPointCity,
                        unloadingPointCity: unloadingPointCity,
                      ), screens.indexOf(postLoadScreen))
                    : Get.to(() => BiddingScreens(
                          loadId: loadId,
                          loadingPointCity: loadingPointCity,
                          unloadingPointCity: unloadingPointCity,
                        )));
              },
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 5, bottom: 0, left: 0, right: 0),
        padding: EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: darkBlueColor,
        ),
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero),
            )),
            backgroundColor: MaterialStateProperty.all<Color>(darkBlueColor),
          ),
          child: Center(
            child: Text(
              'viewBids'.tr,
              // 'View Bids',
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 0.7,
                fontWeight: mediumBoldWeight,
                color: white,
                fontSize: size_6,
              ),
            ),
          ),
          onPressed: () {
            // print(loadId);
            Get.to(() => BiddingScreens(
                  loadId: loadId,
                  loadingPointCity: loadingPointCity,
                  unloadingPointCity: unloadingPointCity,
                ));
          },
        ),
      );
    }
  }
}
