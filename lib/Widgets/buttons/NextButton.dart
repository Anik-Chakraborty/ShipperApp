import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/controller/homeWebController.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/colors.dart';
import '/constants/spaces.dart';
import '/providerClass/providerData.dart';
import 'package:get/get.dart';
import '/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import 'package:provider/provider.dart';

class nextButton extends StatefulWidget {
  nextButton({Key? key}) : super(key: key);

  @override
  State<nextButton> createState() => _nextButtonState();
}

class _nextButtonState extends State<nextButton> {

  HomeWebController homeWebController = Get.put(HomeWebController());

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        height: space_8,
        width: space_33,
        margin: EdgeInsets.fromLTRB(space_8, space_0, space_8, space_2),
        child: ClipRRect(
          child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: (Responsive.isMobile(context))
                        ? BorderRadius.circular(50)
                        : const BorderRadius.all(Radius.zero),
                  )),
                  backgroundColor: providerData.postLoadScreenOneButton()
                      ? MaterialStateProperty.all<Color>(truckGreen)
                      : deactiveButtonColor),
              child: Text(
                'next'.tr,
                // AppLocalizations.of(context)!.next,
                style: TextStyle(
                  fontWeight: mediumBoldWeight,
                  color: white,
                  fontSize: size_8,
                ),
              ),
              onPressed: () {
                providerData.postLoadScreenOneButton()
                    ? ((kIsWeb)
                        ? homeWebController.changeVisibleWidgetWithSideBarSelectedIndex(const PostLoadScreenTwo(), screens.indexOf(postLoadScreen))
                        : Get.to(() => const PostLoadScreenTwo()))
                    : null;
              }),
        ),
      ),
    ]);
  }
}
