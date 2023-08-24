import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Widgets/loadDetailsWebWidgets/loadDetailsHeader.dart';
import 'package:shipper_app/responsive.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/screens/PostLoadScreens/PostLoadScreenLoadDetails.dart';
import '/widgets/addPostLoadHeader.dart';
import '/providerClass/providerData.dart';
import 'package:provider/provider.dart';
import '/screens/PostLoadScreens/PostLoadScreenLoacationDetails.dart';
import '/screens/PostLoadScreens/PostLoadScreenMultiple.dart';

class PostLoadNav extends StatefulWidget {
  final Widget setChild;
  final int index;

  const PostLoadNav({Key? key, required this.setChild, required this.index})
      : super(key: key);

  @override
  State<PostLoadNav> createState() => _PostLoadNavState();
}

class _PostLoadNavState extends State<PostLoadNav> {
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);

    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Container(
          color: white,
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
                child: Row(
                  children: [
                    Text(
                      "Post Load",
                      style: TextStyle(
                        fontSize: (Responsive.isTablet(context))
                            ? size_13
                            : (Responsive.isDesktop(context))
                                ? size_15
                                : size_10,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: kLiveasyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 100,
                child: Center(
                    child: Image.asset(
                  (widget.index == 0)
                      ? 'assets/images/load_location_details_progress_status.png'
                      : (widget.index == 1)
                          ? 'assets/images/load_details_progress_status.png'
                          : 'assets/images/load_confirmation_progress_status.png',
                  width: (Responsive.isTablet(context))
                      ? MediaQuery.of(context).size.width * 0.45
                      : 600,
                  filterQuality: FilterQuality.high,
                )),
              ),
              widget.setChild
            ],
          ),
        ),
      ),
    );
  }
}
