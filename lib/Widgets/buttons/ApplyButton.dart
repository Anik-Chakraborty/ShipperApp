import 'package:flutter/material.dart';
import 'package:shipper_app/Web/screens/home_web.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import '/constants/colors.dart';
import '/constants/spaces.dart';
import '/controller/shipperIdController.dart';
import '/providerClass/providerData.dart';
import 'package:get/get.dart';
import '/screens/PostLoadScreens/loadConfirmation.dart';
import 'package:provider/provider.dart';

class ApplyButton extends StatelessWidget {
  const ApplyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ShipperIdController());

    ShipperIdController shipperIdController = Get.put(ShipperIdController());
    ProviderData providerData = Provider.of<ProviderData>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: space_20,
          height: space_8,
          margin: EdgeInsets.fromLTRB(space_8, space_4, space_8, space_0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(space_10),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: providerData.postLoadScreenTwoButton()
                      ? activeButtonColor
                      : deactiveButtonColor,
                ),
                child: Text(
                  'apply'.tr,
                  // AppLocalizations.of(context)!.apply,
                  style: const TextStyle(
                    color: white,
                  ),
                ),
                onPressed: () {
                  if (providerData.postLoadScreenTwoButton()) {
                    Get.to(() => LoadConfirmation(
                          previousScreen: const PostLoadScreenTwo(),
                        ));
                  } else {
                    return null;
                  }
                }),
          ),
        ),
      ],
    );
  }
}
