import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/controller/homeWebController.dart';
import 'package:shipper_app/providerClass/providerData.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';

class ProductTypeSelection extends StatefulWidget {
  @override
  State<ProductTypeSelection> createState() => _ProductTypeSelectionState();
}

class _ProductTypeSelectionState extends State<ProductTypeSelection> {
  TextEditingController txtProductTypeController = TextEditingController();

  HomeWebController homeWebController = Get.put(HomeWebController());

  List<String> productType = [
    'Agriculture and Food',
    'Alcoholic Beverage',
    'Auto Parts / Machine',
    'Chemical / Powder',
    'Construction Material',
    'Cylinders',
    'Chukkey',
    'DOC',
    'Electronic Goods / Battery',
    'Packaged / Consumer',
    'Paints / Petroleum',
    'Putty',
    'Scrap',
    'Taar',
    'Oil',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadDetailsHeader(
              reset: () {
                providerData.updateProductType("Choose Product Type");
              },
              title: 'Select Product Type',
              subTitle: 'We need some details from you.',
              previousScreen: (kIsWeb)
                  ? const PostLoadScreenTwo()
                  : const PostLoadScreenTwo()),
          Container(
            height: 10,
            color: lineDividerColor,
          ),
          Container(
            color: white,
            padding: const EdgeInsets.all(10),
            child: Text(
              'Recent',
              style: TextStyle(
                  color: kLiveasyColor,
                  fontFamily: 'Montserrat',
                  fontSize: size_9),
            ),
          ),
          Container(
            color: white,
            padding: const EdgeInsets.all(10),
            height: 100,
            child: Center(
              child: Text(
                'No Recent Item Found',
                style: TextStyle(
                    color: textLightColor,
                    fontFamily: 'Montserrat',
                    fontSize: size_12),
              ),
            ),
          ),
          Container(
            color: white,
            padding: const EdgeInsets.all(10),
            child: Text(
              'Recommended',
              style: TextStyle(
                  color: kLiveasyColor,
                  fontFamily: 'Montserrat',
                  fontSize: size_9),
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (Responsive.isMobile(context)) ? 1 : 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 0,
                  mainAxisExtent: 50),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (productType[index] != 'Others') {
                          setState(() {
                            Get.back();
                            providerData.updateProductType(productType[index]);
                            // providerData.updateResetActive(true);
                          });
                        } else if (productType[index] == 'Others') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  contentPadding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 40, bottom: 40),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Enter Product Type',
                                        style: TextStyle(
                                            color: kLiveasyColor,
                                            fontSize: size_10,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        controller: txtProductTypeController,
                                        style: TextStyle(
                                            color: kLiveasyColor,
                                            fontFamily: 'Montserrat',
                                            fontSize: size_8),
                                        textAlign: TextAlign.center,
                                        cursorColor: kLiveasyColor,
                                        cursorWidth: 1,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.zero,
                                                borderSide: BorderSide(
                                                    color: borderLightColor,
                                                    width: 1.5)),
                                            hintText: 'Enter Product Type',
                                            hintStyle: TextStyle(
                                                color: borderLightColor,
                                                fontFamily: 'Montserrat',
                                                fontSize: size_8),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.zero,
                                                borderSide: BorderSide(
                                                    color: truckGreen,
                                                    width: 1.5))),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              String otherProductType =
                                                  txtProductTypeController.text;

                                              if (otherProductType.isNotEmpty &&
                                                  otherProductType != null) {
                                                setState(() {
                                                  providerData
                                                      .updateProductType(
                                                          otherProductType);
                                                  Navigator.of(context).pop();
                                                  Get.back();
                                                });
                                              }
                                            },
                                            style: ButtonStyle(
                                                mouseCursor:
                                                    const MaterialStatePropertyAll(
                                                        SystemMouseCursors
                                                            .click),
                                                shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color: truckGreen,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                                Radius.circular(
                                                                    5)))),
                                                padding:
                                                    const MaterialStatePropertyAll(
                                                        EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 5,
                                                            bottom: 8)),
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        truckGreen)),
                                            child: const Text(
                                              'Ok',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          OutlinedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        red),
                                                mouseCursor:
                                                    MaterialStatePropertyAll(
                                                        SystemMouseCursors
                                                            .click),
                                                shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color: red,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)))),
                                                padding:
                                                    MaterialStatePropertyAll(
                                                        EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 5,
                                                            bottom: 8)),
                                              ),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.white),
                                              )),
                                        ],
                                      )
                                    ],
                                  ));
                            },
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: (providerData.productType != null &&
                                  providerData.productType ==
                                      productType[index])
                              ? const LinearGradient(
                                  colors: [gradientGreyColor, white])
                              : const LinearGradient(colors: [Colors.white, white]),
                        ),
                        padding: EdgeInsets.only(
                            left: (Responsive.isTablet(context)) ? 20 : 40,
                            right: (Responsive.isTablet(context)) ? 20 : 40,
                            top: 10,
                            bottom: 10),
                        child: Row(
                          mainAxisAlignment: (Responsive.isMobile(context))
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    right: (Responsive.isMobile(context)
                                        ? 40
                                        : 0)),
                                height:
                                    (Responsive.isTablet(context)) ? 20 : 30,
                                width: (Responsive.isTablet(context)) ? 20 : 30,
                                child: Image.asset(
                                  'assets/images/load_grey_icon.png',
                                  fit: BoxFit.fill,
                                )),
                            Text(
                              productType[index],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: kLiveasyColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: (Responsive.isTablet(context))
                                      ? size_7
                                      : size_9),
                              textAlign: TextAlign.left,
                            )
                          ],
                        ),
                      ),
                    ),
                    ((productType.length % 2) == 0)
                        ? ((productType.length - 2) > index)
                            ? const Divider(
                                thickness: 1,
                                height: 0,
                              )
                            : const SizedBox()
                        : ((productType.length - 1) != index)
                            ? const Divider(
                                thickness: 1,
                                height: 0,
                              )
                            : const SizedBox()
                  ],
                );
              },
              itemCount: productType.length,
            ),
          )
        ],
      ),
    );
  }
}
