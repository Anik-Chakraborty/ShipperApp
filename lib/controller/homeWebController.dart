import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shipper_app/Web/screens/web_dashboard.dart';

class HomeWebController extends GetxController{

  Rx<Widget> visibleWidget = Container(child: const WebDashBoard(),).obs;
  RxInt sideBarSelectedIndex = 0.obs;
  RxBool sideBarIsExpanded = true.obs;
  RxDouble sideBarWidth = (220.0).obs;

  changeVisibleWidget(Widget widget){
    visibleWidget.value = Container(child: widget,);
  }

  changeSideBarSelectedIndex(int index){
    sideBarSelectedIndex.value = index;
  }

  refreshVisibleWidget(){
    visibleWidget.value = Container();
  }

  changeVisibleWidgetWithSideBarSelectedIndex(Widget widget, int index){
    visibleWidget.value = Container(child: widget);
    sideBarSelectedIndex.value = index;
  }

  changeSideBarExpandMode(bool state){
    sideBarIsExpanded.value = state;
  }

  changeSideBarWidth(bool sideBarIsExpanded){
    if(sideBarIsExpanded){
      sideBarWidth.value = 220;
    }
    else{
      sideBarWidth.value = 110;
    }
  }


}