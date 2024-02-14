// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Web/screens/web_dashboard.dart';
import 'package:shipper_app/Widgets/accountPopup.dart';
import 'package:shipper_app/Widgets/addLocationDrawerWidget.dart';
import 'package:shipper_app/constants/shipper_nav_icons.dart';
import 'package:shipper_app/controller/addLocationDrawerToggleController.dart';
import 'package:shipper_app/controller/homeWebController.dart';
import 'package:shipper_app/responsive.dart';
import 'package:shipper_app/functions/shipperApis/isolatedShipperGetData.dart';
import 'package:shipper_app/constants/screens.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/screens/Eway_Bills_Screen.dart';
import 'package:shipper_app/screens/Invoice_screen.dart';
import 'package:shipper_app/screens/PostLoadScreens/postLoadScreen.dart';
import 'package:shipper_app/screens/employee_list_with_roles_screen.dart';
import 'package:shipper_app/screens/facilities.dart';
import 'package:shipper_app/screens/transporter/transporterScreen.dart';
import 'package:sizer/sizer.dart';
import 'package:shipper_app/Web/logo.dart';

class HomeScreenWeb extends StatefulWidget {

  const HomeScreenWeb({Key? key}) : super(key: key);

  @override
  State<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends State<HomeScreenWeb> {

  HomeWebController homeWebController = Get.put(HomeWebController());


  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  AddLocationDrawerToggleController addLocationDrawerToggleController =
      Get.put(AddLocationDrawerToggleController());

  @override
  void initState() {
    super.initState();
    isolatedShipperGetData();
  }

  //TODO: This is the list for Navigation Rail List Destinations,This contains icons and it's labels

  //TODO : This is the list for Bottom Navigation Bar
  List<BottomNavigationBarItem> bottom_destinations = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.space_dashboard), label: "Control Tower"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.inventory_2_rounded), label: "My Loads"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long), label: "Eway Bills"),
    const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.fileInvoice), label: "Invoice"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.supervised_user_circle_outlined), label: "Team"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.local_shipping), label: "Transporter"),
    const BottomNavigationBarItem(
        icon: Icon(Icons.location_on), label: "Facility"),
  ];

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context) &&
        addLocationDrawerToggleController.drawerState.value == true) {
      addLocationDrawerToggleController.toggleDrawer(false);
    }
    return Obx(() {
      if (addLocationDrawerToggleController.drawerState.value == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scaffoldKey.currentState?.openEndDrawer();
        });
      } else {
        scaffoldKey.currentState?.closeEndDrawer();
      }
      return Scaffold(
        //TODO : Bottom Navigation Bar is only displayed when the screen size is in between sizes of mobile devices
        bottomNavigationBar: Responsive.isMobile(context)
            ? BottomNavigationBar(
                selectedItemColor: kLiveasyColor,
                unselectedItemColor: Colors.blueGrey,
                showUnselectedLabels: true,
                items: bottom_destinations,
                currentIndex: homeWebController.sideBarSelectedIndex.value,
                onTap: (updatedIndex) {
                    homeWebController.changeSideBarSelectedIndex( updatedIndex);
                    homeWebController.changeVisibleWidget(screens[updatedIndex]);
                },
              )
            : null,
        key: scaffoldKey,
        endDrawer: AddLocationDrawerWidget(
          context: context,
        ),
        onEndDrawerChanged: (isOpened) {
          if (isOpened == false) {
            addLocationDrawerToggleController.toggleDrawer(false);
          }
        },
        appBar: AppBar(
          leading: null,
          backgroundColor: kLiveasyColor,
          title: Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreenWeb()));
                },
                child: SizedBox(
                  child: Row(
                    children: [
                      const LiveasyLogoImage(),
                      SizedBox(
                        width: 0.5.w,
                      ),
                      const Text(
                        'Liveasy',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Montserrat Bold",
                            color: white),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(child: SizedBox())
            ],
          ),
          actions: [
            SizedBox(
              width: 48,
              height: 40,
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: white,
                ),
                label: const Text(''),
              ),
            ),
            SizedBox(
              width: 48,
              height: 40,
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_outlined,
                  color: white,
                ),
                label: const Text(''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: SizedBox(
                width: 48,
                height: 40,
                child: AccountMenuButton(
                  screens: screens,
                ),
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            //TODO : Similar to bottom navigation bar, Navigation rail is only displayed when it is not mobile screen
            Responsive.isMobile(context)
                ? const SizedBox(
                    width: 0.01,
                  )
                : Stack(
                  children: [
                    Row(children: [
                      Card(
                        surfaceTintColor: transparent,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.zero)),
                        elevation: 5,
                        shadowColor: Colors.grey,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 50),
                          width: homeWebController.sideBarWidth.value,
                          color: white,
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.65,
                                child : SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SideExpandedItem(
                                          onClick: (){
                                            if(homeWebController.sideBarSelectedIndex.value == 0){
                                              homeWebController.refreshVisibleWidget();
                                              Future.delayed(const Duration(milliseconds: 500), () => homeWebController.changeVisibleWidget(const WebDashBoard()));
                                            }
                                            else{
                                              homeWebController.changeSideBarSelectedIndex(0);
                                              homeWebController.changeVisibleWidget(const WebDashBoard());
                                            }
                                          },
                                          title: "Control Tower",
                                          iconSize: 18,
                                          icon: ShipperNav.control_tower,
                                          position: 0),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      SideExpandedItem(
                                          onClick: (){
                                            if(homeWebController.sideBarSelectedIndex.value == 1){
                                              homeWebController.refreshVisibleWidget();
                                              Future.delayed(const Duration(milliseconds: 500), () => homeWebController.changeVisibleWidget(const PostLoadScreen()));
                                            }
                                            else{
                                              homeWebController.changeSideBarSelectedIndex(1);
                                              homeWebController.changeVisibleWidget(const PostLoadScreen());
                                            }
                                          },
                                          title: "My Loads",
                                          iconSize: 18,
                                          icon: ShipperNav.loads,
                                          position: 1),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      SideExpandedItem(
                                          onClick: (){
                                            if(homeWebController.sideBarSelectedIndex.value == 2){
                                              homeWebController.refreshVisibleWidget();
                                              Future.delayed(const Duration(milliseconds: 500), () => homeWebController.changeVisibleWidget(const EwayBills()));
                                            }
                                            else{
                                              homeWebController.changeSideBarSelectedIndex(2);
                                              homeWebController.changeVisibleWidget(const EwayBills());
                                            }
                                          },
                                          title: "Eway Bills",
                                          iconSize: 18,
                                          icon: ShipperNav.eway_bill,
                                          position: 2),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      SideExpandedItem(
                                          onClick: (){
                                            if(homeWebController.sideBarSelectedIndex.value == 3){
                                              homeWebController.refreshVisibleWidget();
                                              Future.delayed(const Duration(milliseconds: 500), () => homeWebController.changeVisibleWidget(const InvoiceScreen()));
                                            }
                                            else{
                                              homeWebController.changeSideBarSelectedIndex(3);
                                              homeWebController.changeVisibleWidget(const InvoiceScreen());
                                            }
                                          },
                                          title: "Invoice",
                                          iconSize: 18,
                                          icon: ShipperNav.invoice,
                                          position: 3),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      SideExpandedItem(
                                          onClick: (){
                                            if(homeWebController.sideBarSelectedIndex.value == 4){
                                              homeWebController.refreshVisibleWidget();
                                              Future.delayed(const Duration(milliseconds: 500), () => homeWebController.changeVisibleWidget(const EmployeeListRolesScreen()));
                                            }
                                            else{
                                              homeWebController.changeSideBarSelectedIndex(4);
                                              homeWebController.changeVisibleWidget(const EmployeeListRolesScreen());
                                            }
                                          },
                                          title: "Team",
                                          iconSize: 18,
                                          icon: ShipperNav.team,
                                          position: 4),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      SideExpandedItem(
                                          onClick: (){
                                            if(homeWebController.sideBarSelectedIndex.value == 5){
                                              homeWebController.refreshVisibleWidget();
                                              Future.delayed(const Duration(milliseconds: 500), () => homeWebController.changeVisibleWidget(const TransporterScreen()));
                                            }
                                            else{
                                              homeWebController.changeSideBarSelectedIndex(5);
                                              homeWebController.changeVisibleWidget(const TransporterScreen());
                                            }
                                          },
                                          title: "Transporter",
                                          iconSize: 18,
                                          icon: ShipperNav.transporter,
                                          position: 5),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      SideExpandedItem(
                                          onClick: (){
                                            if(homeWebController.sideBarSelectedIndex.value == 6){
                                              homeWebController.refreshVisibleWidget();
                                              Future.delayed(const Duration(milliseconds: 500), () => homeWebController.changeVisibleWidget(const Facilities()));
                                            }
                                            else{
                                              homeWebController.changeSideBarSelectedIndex(6);
                                              homeWebController.changeVisibleWidget(const Facilities());
                                            }
                                          },
                                          title: "Facility",
                                          iconSize: 18,
                                          icon: ShipperNav.facility,
                                          position: 6),
                                    ],
                                  ),
                                )
                              ),
                              Expanded(
                                  child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 30),
                                      child: SideExpandedItem(
                                          onClick: (){},
                                          title: "Liveasy",
                                          iconSize: 23,
                                          icon: ShipperNav.liveasy_logo,
                                          position: 7))))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: headerLightBlueColor,
                        width: 15,
                      )
                    ]),
                    Positioned(
                      left: homeWebController.sideBarWidth.value - 10,
                      top: (MediaQuery.of(context).size.height -
                              AppBar().preferredSize.height) *
                          0.45,
                      height: 30,
                      width: 30,
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(50),
                            color: white),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (homeWebController.sideBarIsExpanded.value) {
                                homeWebController.changeSideBarExpandMode(false);
                                homeWebController.changeSideBarWidth(homeWebController.sideBarIsExpanded.value);
                              } else {
                                homeWebController.changeSideBarExpandMode(true);
                                homeWebController.changeSideBarWidth(homeWebController.sideBarIsExpanded.value);
                              }
                            });
                          },
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                              (homeWebController.sideBarIsExpanded.value)
                                  ? Icons.arrow_back_ios_rounded
                                  : Icons.arrow_forward_ios_rounded,
                              color: darkBlueTextColor,
                              size: 20),
                          style: ButtonStyle(
                            backgroundColor:
                                const MaterialStatePropertyAll<Color>(
                                    white),
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                  width: 1, color: Colors.black),
                            ),
                          ),
                          hoverColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),

            Expanded(
              child: Center(
                child: homeWebController.visibleWidget.value
              ),
            ),
          ],
        ),
      );
    });
  }

  InkWell SideExpandedItem(
      {required String title,
      required IconData icon,
      required int position,
      required double iconSize,
      required Function onClick}) {

    return InkWell(
        onTap: () {
            onClick();
        },
        child: Container(
            height: 60,
            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: homeWebController.sideBarSelectedIndex.value == position ? kLiveasyColor : Colors.white),
            child: Row(
              children: [
                Icon(icon,
                    size: iconSize,
                    color: position == homeWebController.sideBarSelectedIndex.value ? white : darkBlueColor),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                    visible: homeWebController.sideBarIsExpanded.value,
                    child: (title == "Liveasy")
                        ? Text(
                            title,
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat Bold",
                                color: position == homeWebController.sideBarSelectedIndex.value
                                    ? white
                                    : darkBlueColor),
                          )
                        : Text(
                            title,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Montserrat",
                                color: (position == homeWebController.sideBarSelectedIndex.value)
                                    ? white
                                    : darkBlueColor),
                          ))
              ],
            )));
  }
}
