import 'package:get/get.dart';

class AddLocationDrawerToggleController extends GetxController {
  RxBool drawerState = false.obs;
  RxBool addTransporter = false.obs;

  toggleDrawer(bool selectedState) {
    drawerState.value = selectedState;
  }

  toggleAddTransporter(bool selectedState) {
    addTransporter.value = selectedState;
  }
}
