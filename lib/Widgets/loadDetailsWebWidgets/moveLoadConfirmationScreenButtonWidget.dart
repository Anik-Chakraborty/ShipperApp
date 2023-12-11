import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/providerClass/providerData.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import 'package:shipper_app/screens/PostLoadScreens/loadConfirmation.dart';

class moveLoadConfirmationScreenButtonWidget extends StatefulWidget {
  @override
  State<moveLoadConfirmationScreenButtonWidget> createState() =>
      _moveLoadConfirmationScreenButtonWidgetState();
}

class _moveLoadConfirmationScreenButtonWidgetState
    extends State<moveLoadConfirmationScreenButtonWidget> {
  @override
  Widget build(BuildContext context) {
    bool enable = true;
    ProviderData providerData = Provider.of<ProviderData>(context);

    if(providerData.productType == "Choose Product Type"){
      providerData.productType = '';
    }
    if (providerData.publishMethod == 'Contract') {
        providerData.biddingEndTime = null;
        providerData.biddingEndDate = null;
        providerData.loadTransporterList = [];
    }
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStatePropertyAll(
            EdgeInsets.only(left: 60, right: 60, top: 20, bottom: 20)),
        mouseCursor: MaterialStatePropertyAll(
            (enable) ? SystemMouseCursors.click : SystemMouseCursors.basic),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: (Responsive.isMobile(context))
              ? BorderRadius.circular(50)
              : BorderRadius.all(Radius.zero),
        )),
        backgroundColor: MaterialStateProperty.all<Color>(
            (enable) ? truckGreen : disableButtonColor),
      ),
      onPressed: () {
        if (enable) {
          Get.to(() => HomeScreenWeb(
                index: 1000,
                selectedIndex: screens.indexOf(postLoadScreen),
                visibleWidget: LoadConfirmation(
                  previousScreen: (kIsWeb)
                      ? HomeScreenWeb(
                          index: screens.indexOf(postLoadScreenTwo),
                          selectedIndex: screens.indexOf(postLoadScreen),
                        )
                      : PostLoadScreenTwo(),
                ),
              ));
        }
      },
      child: Text(
        'Next', // AppLocalizations.of(context)!.postLoad,
        style: TextStyle(
            fontWeight: mediumBoldWeight,
            color: white,
            fontSize: size_8,
            fontFamily: 'Montserrat'),
      ),
    );
  }
}
