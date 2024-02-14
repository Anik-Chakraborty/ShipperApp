import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/constants/fontSize.dart';
import 'package:shipper_app/constants/fontWeights.dart';
import 'package:shipper_app/constants/spaces.dart';
import 'package:shipper_app/controller/homeWebController.dart';
import 'package:shipper_app/providerClass/providerData.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import 'package:shipper_app/screens/PostLoadScreens/TruckTypePostLoadDetailsScreen.dart';

class LoadTruckWeightSelectScreenWeb extends StatefulWidget {
  final minWeight, maxWeight;
  final String truckTypeName, truckTypeValue;

  const LoadTruckWeightSelectScreenWeb(
      {super.key,
      required this.minWeight,
      required this.maxWeight,
      required this.truckTypeName,
      required this.truckTypeValue});

  @override
  State<LoadTruckWeightSelectScreenWeb> createState() =>
      _LoadTruckWeightSelectScreenWebState();
}

class _LoadTruckWeightSelectScreenWebState
    extends State<LoadTruckWeightSelectScreenWeb> {
  List<String> selectedWeight = [];
  dynamic providerFunctionWeight = () {};
  List<List<double>> weightSlots = [
    [0, 0]
  ];

  HomeWebController homeWebController = Get.put(HomeWebController());

  var controller = PageController();
  bool check = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.maxWeight > widget.minWeight && widget.minWeight != 0.0) {
      createSlotFromWeightRange();
      if (weightSlots[0][0] == 0 && weightSlots[0][1] == 0) {
        weightSlots.removeAt(0);
      }
    }
  }

  //this createSlotFromWeightRange function will create slots between minWeight and maxWeight
  //example --> 7.5 - 25.5 -- > [[7.5 - 10], [11 - 15], [16 - 20], [21 - 25.5]]
  //example --> 7 - 27.5 -- > [[7 - 10], [11 - 15], [16 - 20], [21 - 25.5], [26 - 27.5]]
  //example --> 5 - 26.5 -- > [[5 - 5], [6 - 10], [11 - 15], [16 - 20], [21 - 25.5], [26 - 26.5]]
  //example --> 9.5 - 24.5 -- > [[9.5 - 10], [11 - 15], [16 - 20], [21 - 24.5]]

  void createSlotFromWeightRange() {
    bool slotFirstWeight = false;
    List<double> slot = [widget.minWeight];
    int slotIndex = 0;

    for (double j = (widget.minWeight).ceil();
        j <= (widget.maxWeight).ceil();
        j++) {
      if (j % 5 != 0 || j > widget.maxWeight) {
        if (j == widget.maxWeight) {
          slot.add(j);
          weightSlots.add(slot);
        } else {
          if (slotFirstWeight && j < widget.maxWeight) {
            slot.add(j);
            slotFirstWeight = false;
          } else {
            if (j > widget.maxWeight) {
              if (slot.isEmpty) {
                weightSlots[slotIndex - 1][1] = widget.maxWeight;
              } else {
                slot.add(widget.maxWeight);
                weightSlots.add(slot);
              }
            }
          }
        }
      } else {
        slot.add(j);
        if (slotIndex == 0) {
          weightSlots[0] = slot;
        } else {
          weightSlots.add(slot);
        }
        slot = [];
        ++slotIndex;
        slotFirstWeight = true;
      }
    }
  }

  getLoadWeight() {
    return weightSlots.map<Widget>((e) {
      return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key: GlobalObjectKey(e),
              (e.length == 1)
                  ? '${e[0]} - ${e[0]} tons'
                  : '${e[0]} - ${e[1]} tons',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: truckGreen,
                  fontSize: size_9),
            ),
            const SizedBox(
              height: 5,
            ),
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, iterator) {
                  return CheckboxListTile(
                    contentPadding:
                        const EdgeInsets.only(top: 5, bottom: 5, right: 10),
                    value: (((e.length > 1 &&
                            (((e[1] - e[0]) + 1).ceil().toInt()) - 1 ==
                                iterator &&
                            selectedWeight
                                .contains('${(e[0] + iterator).floor()}')))
                        ? true
                        : selectedWeight.contains('${e[0] + iterator}')
                            ? true
                            : false),
                    onChanged: (value) {
                      setState(() {
                        if ((value ?? false) && selectedWeight.length < 5) {
                          if (e.length > 1 &&
                              (((e[1] - e[0]) + 1).ceil().toInt()) - 1 ==
                                  iterator) {
                            selectedWeight.add('${(e[0] + iterator).floor()}');
                          } else {
                            selectedWeight.add('${e[0] + iterator}');
                          }
                        } else {
                          if (e.length > 1 &&
                              (((e[1] - e[0]) + 1).ceil().toInt()) - 1 ==
                                  iterator) {
                            selectedWeight
                                .remove('${(e[0] + iterator).floor()}');
                          } else {
                            selectedWeight.remove('${e[0] + iterator}');
                          }
                        }
                        // check = value ?? false;
                      });
                    },
                    mouseCursor: SystemMouseCursors.click,
                    title: Text(
                      (e.length > 1 &&
                              (((e[1] - e[0]) + 1).ceil().toInt()) - 1 ==
                                  iterator)
                          ? '${e[1]} tons'
                          : '${e[0] + iterator} tons',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: kLiveasyColor,
                          fontSize: size_9),
                    ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2))),
                    activeColor: truckGreen,
                    controlAffinity: ListTileControlAffinity.leading,
                    secondary: Image.asset(
                        'assets/images/load_weight_boxes.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1,
                    height: 0,
                  );
                },
                itemCount: (e.length == 1)
                    ? (((e[0] - e[0]) + 1).toInt())
                    : ((e[1] - e[0]) + 1).ceil().toInt())
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    selectedWeight = providerData.passingWeightMultipleValue;
    providerFunctionWeight = providerData.updatePassingWeightMultipleValue;
    return Scaffold(
      floatingActionButton: SizedBox(
        height: space_8,
        width: space_33,
        child: TextButton(
          style: ButtonStyle(
            mouseCursor: MaterialStatePropertyAll((selectedWeight.isNotEmpty)
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: (Responsive.isMobile(context))
                  ? BorderRadius.circular(50)
                  : const BorderRadius.all(Radius.zero),
            )),
            backgroundColor: MaterialStateProperty.all<Color>(
                (selectedWeight.isNotEmpty) ? truckGreen : disableButtonColor),
          ),
          onPressed: () {
            if (selectedWeight.isNotEmpty) {
              List<double> sortedNumbers =
                  selectedWeight.map(double.parse).toList()..sort();
              selectedWeight =
                  sortedNumbers.map((number) => number.toString()).toList();
              providerData.updateResetActive(true);
              providerData.updateTruckTypeValue(widget.truckTypeValue);
              providerData.resetOnNewType();
              providerFunctionWeight(selectedWeight);
              if (kIsWeb){
                homeWebController.changeVisibleWidgetWithSideBarSelectedIndex(const PostLoadScreenTwo(), screens.indexOf(postLoadScreen));
              }
              else{
                Get.to(() => const PostLoadScreenTwo());
              }
            }
          },
          child: Text(
            'Finish', // AppLocalizations.of(context)!.postLoad,
            style: TextStyle(
                fontWeight: mediumBoldWeight,
                color: white,
                fontSize: size_8,
                fontFamily: 'Montserrat'),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadDetailsHeader(
              reset: () {
                selectedWeight.clear();
                providerFunctionWeight(<String>[]);
              },
              title: 'Choose a Truck Type',
              subTitle: 'What type of truck you require?',
              previousScreen: (kIsWeb)
                  ? TruckTypePostLoadDetailsScreen()
                  : null),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: lineDividerColor,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            if (index < weightSlots.length) {
                              WidgetsBinding.instance.addPostFrameCallback(
                                  (_) => Scrollable.ensureVisible(
                                      GlobalObjectKey(weightSlots[index])
                                          .currentContext!,
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 250)));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 20, left: 10, right: 10),
                            child: Center(
                                child: Text(
                              (index < weightSlots.length)
                                  ? (weightSlots[index].length == 1)
                                      ? '${weightSlots[index][0]} - ${weightSlots[index][0]} tons'
                                      : '${weightSlots[index][0]} - ${weightSlots[index][1]} tons'
                                  : 'Other',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: truckGreen,
                                  fontSize: size_9),
                            )),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          thickness: 1,
                          height: 0,
                        );
                      },
                      itemCount: weightSlots.length + 1,
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: getLoadWeight(),
                            ),
                          )),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
