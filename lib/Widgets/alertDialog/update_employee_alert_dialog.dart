import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipper_app/constants/colors.dart';
import 'package:shipper_app/controller/homeWebController.dart';
import 'package:shipper_app/responsive.dart';
import '../../screens/employee_list_with_roles_screen.dart';
import '../../Web/screens/home_web.dart';
import '../../constants/screens.dart';

//TODO: This is used to update the employee role
class UpdateEmployeeRole extends StatefulWidget {
  final String employeeUid;
  final String selectedRole;

  const UpdateEmployeeRole({
    Key? key,
    required this.employeeUid,
    required this.selectedRole,
  }) : super(key: key);

  @override
  State<UpdateEmployeeRole> createState() => _UpdateEmployeeRoleState();
}

class _UpdateEmployeeRoleState extends State<UpdateEmployeeRole> {

  HomeWebController homeWebController = Get.put(HomeWebController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      contentPadding: EdgeInsets.only(
          left: Responsive.isMobile(context)
              ? screenWidth * 0.18
              : screenWidth * 0.09,
          right: Responsive.isMobile(context)
              ? screenWidth * 0.18
              : screenWidth * 0.09,
          top: screenHeight * 0.1,
          bottom: screenHeight * 0.05), // Adjust the padding as needed
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text("Are you sure you want to\nchange the role?",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600, color: darkBlueTextColor)),
          ],
        ),
      ),
      actions: [
        Container(
          width: Responsive.isMobile(context)
              ? screenWidth * 0.2
              : screenWidth * 0.06,
          padding: EdgeInsets.only(bottom: screenHeight * 0.09),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: okButtonColor,
            ),
            onPressed: () {
              _updateUserRole();
              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              right: Responsive.isMobile(context)
                  ? screenWidth * 0.18
                  : screenWidth * 0.1,
              bottom: screenHeight * 0.09),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: diffDeleteButtonColor,
                  width: 2.0,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: diffDeleteButtonColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateUserRole() async {
    if (widget.selectedRole != null && widget.selectedRole.isNotEmpty) {
      try {
        final String shipperApiUrl = dotenv.get('shipperApiUrl');

        Map data = {
          "roles": widget.selectedRole,
        };

        String body = json.encode(data);
        final response =
            await http.put(Uri.parse('$shipperApiUrl/${widget.employeeUid}'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: body);

        if (response.statusCode == 200) {
          homeWebController.changeVisibleWidgetWithSideBarSelectedIndex(const EmployeeListRolesScreen(), screens.indexOf(accountVerificationStatusScreen));
        } else {
          debugPrint('Something wrong');
        }
      } catch (error) {
        debugPrint(error.toString());
      }
    }
  }
}
