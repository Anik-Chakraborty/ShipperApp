import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/constants/colors.dart';
import '/constants/fontSize.dart';
import '/constants/fontWeights.dart';
import '/constants/spaces.dart';
import '/controller/shipperIdController.dart';
import '/providerClass/providerData.dart';
//import '/screens/TransporterOrders/callBtn.dart';
import '/screens/TransporterOrders/docInputEWBill.dart';
import '/screens/TransporterOrders/docInputPod.dart';
import '/screens/TransporterOrders/docInputWgtReceipt.dart';
import '/screens/TransporterOrders/navigateToTrackScreen.dart';
//import '/screens/TransporterOrders/postDocumentApiCall.dart';
//import '/screens/TransporterOrders/putDocumentApiCall.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../HelpScreen.dart';
import 'docInputLr.dart';
//import 'getDocName.dart';
//import 'getDocumentApiCall.dart';
import '/functions/documentApi/getDocName.dart';
import '/functions/documentApi/getDocumentApiCall.dart';
import '/functions/documentApi/postDocumentApiCall.dart';
import '/functions/documentApi/putDocumentApiCall.dart';
import '/widgets/buttons/callBtn.dart';

class documentUploadScreen extends StatefulWidget {
  String? bookingId;
  String? bookingDate;
  String? truckNo;
  String? transporterName;
  String? transporterPhoneNum;
  String? driverName;
  String? driverPhoneNum;
  String? loadingPoint;
  String? unloadingPoint;
  var gpsDataList;
  String? totalDistance;
  var device;
  String? productType;
  String? truckType;
  String? unitValue;

  documentUploadScreen({
    Key? key,
    this.bookingId,
    this.bookingDate,
    this.truckNo,
    this.transporterName,
    this.transporterPhoneNum,
    this.driverName,
    this.driverPhoneNum,
    this.unloadingPoint,
    this.loadingPoint,
    this.gpsDataList,
    this.totalDistance,
    this.device,
    this.productType,
    this.truckType,
    this.unitValue,
  }) : super(key: key);

  @override
  _documentUploadScreenState createState() => _documentUploadScreenState();
}

class _documentUploadScreenState extends State<documentUploadScreen> {
  bool progressBar = false;
  // bool? pod1 = false;
  // bool podother = false;

  @override
  void initState() {
    super.initState();
    // pod1 = false;

    Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ShipperIdController());
    var providerData = Provider.of<ProviderData>(context);

    //Pod :-

    late Map
        datanew; // this map will contain the data to be posted using the post document api.
    datanew = {
      "entityId": widget.bookingId.toString(),
      "documents": [
        {}
        // {"documentType": "documentType", "data": }
      ],
    };
    late Map dataput;
    // bool verified = false;

    // function to call the post or put api functions according to the need to upload the documents.
    uploadDocumentApiCall() async {
      var response = await postDocumentApiCall(datanew);
      if (response == "put") {
        dataput = {"documents": datanew["documents"]};
        print("dataput");
        print(dataput);
        response =
            await putDocumentApiCall(dataput, widget.bookingId.toString());
      }
      if (response == "successful") {
        // after uploading the document successfully we null the provider data of the documents to stop displaying the document upload screen.
        setState(() {
          providerData.PodPhotoFile = null;
          providerData.PodPhoto64 = null;
          providerData.LrPhotoFile = null;
          providerData.LrPhoto64 = null;
          providerData.EwayBillPhotoFile = null;
          providerData.EwayBillPhoto64 = null;
          providerData.WeightReceiptPhotoFile = null;
          providerData.WeightReceiptPhoto64 = null;
          progressBar = false;
        });
      }
      // return response;
    }

    var jsonresponse;
    var docLinks = [];
    var availDocs = [];

    // verifiedCheckPod() async {
    //   jsonresponse =
    //       await getDocApiCallVerify(widget.bookingId.toString(), "P");
    //   print(jsonresponse);
    //   // if (jsonresponse == true) {
    //   //   setState(() {
    //   //     verified = true;
    //   //   });
    //   // } else {
    //   //   verified = false;
    //   // }
    // }

    mapAvaildataPod(int i, String docname) async {
      if (i == 0 || i == 1 || i == 2 || i == 3) {
        var doc1 = {"documentType": docname, "data": providerData.PodPhoto64};

        datanew["documents"][0] = doc1;
      }
      await uploadDocumentApiCall();
    }

    assignDocNamePod(int i) async {
      // for assigning the document name according the available document name.
      if (i == 0) {
        await mapAvaildataPod(i, "PodPhoto1");
      } else if (i == 1) {
        await mapAvaildataPod(i, "PodPhoto2");
      } else if (i == 2) {
        await mapAvaildataPod(i, "PodPhoto3");
      } else if (i == 3) {
        await mapAvaildataPod(i, "PodPhoto4");
      }
    }

    uploadFirstPod() async {
      datanew = {
        "entityId": widget.bookingId.toString(),
        "documents": [
          {"documentType": "PodPhoto1", "data": providerData.PodPhoto64}
        ],
      };
      await uploadDocumentApiCall();
    }

    uploadedCheckPod() async {
      // to check already uploaded pod documents .
      docLinks = [];
      docLinks = await getDocumentApiCall(widget.bookingId.toString(), "P");
      setState(() {
        docLinks = docLinks;
      });
      print("docLinks :-");
      print(docLinks);
      if (docLinks.isNotEmpty) {
        if (docLinks.length == 4) {
        } else {
          availDocs = await getDocName(widget.bookingId.toString(), "P");

          setState(() {
            availDocs = availDocs;
          });
          print(availDocs);
          await assignDocNamePod(availDocs[0]);
          providerData.PodPhotoFile = null;
          providerData.PodPhoto64 = null;
        }
        // verifiedCheckPod();
      } else {
        print("Pod");
        await uploadFirstPod();
      }
    }

    // Lr :-
    // verifiedCheckLr() async {
    //   jsonresponse =
    //       await getDocApiCallVerify(widget.bookingId.toString(), "L");
    //   print(jsonresponse);
    //   // if (jsonresponse == true) {
    //   //   setState(() {
    //   //     verified = true;
    //   //   });
    //   // } else {
    //   //   verified = false;
    //   // }
    // }

    mapAvaildataLr(int i, String docname) async {
      if (i == 0 || i == 1 || i == 2 || i == 3) {
        var doc1 = {"documentType": docname, "data": providerData.LrPhoto64};

        datanew["documents"][0] = doc1;
      }
      await uploadDocumentApiCall();
    }

    assignDocNameLr(int i) async {
      if (i == 0) {
        await mapAvaildataLr(i, "LrPhoto1");
      } else if (i == 1) {
        await mapAvaildataLr(i, "LrPhoto2");
      } else if (i == 2) {
        await mapAvaildataLr(i, "LrPhoto3");
      } else if (i == 3) {
        await mapAvaildataLr(i, "LrPhoto4");
      }
    }

    uploadFirstLr() async {
      datanew = {
        "entityId": widget.bookingId.toString(),
        "documents": [
          {"documentType": "LrPhoto1", "data": providerData.LrPhoto64}
        ],
      };
      // providerData.Lr = false;
      await uploadDocumentApiCall();
    }

    uploadedCheckLr() async {
      docLinks = [];
      docLinks = await getDocumentApiCall(widget.bookingId.toString(), "L");
      setState(() {
        docLinks = docLinks;
      });
      print("docLinks :-");
      print(docLinks);
      if (docLinks.isNotEmpty) {
        if (docLinks.length == 4) {
          // setState(() {
          //   showAddMoreDoc = false;
          // });
        } else {
          availDocs = await getDocName(widget.bookingId.toString(), "L");

          setState(() {
            availDocs = availDocs;
          });
          print(availDocs);
          await assignDocNameLr(availDocs[0]);
          // await uploadDocumentApiCall();
          providerData.LrPhotoFile = null;
          providerData.LrPhoto64 = null;
        }
        // verifiedCheckLr();
      } else {
        print("Lr");
        await uploadFirstLr();
      }
    }

    // EwayBill :-
    // verifiedCheckEwayBill() async {
    //   jsonresponse =
    //       await getDocApiCallVerify(widget.bookingId.toString(), "E");
    //   print(jsonresponse);
    //   // if (jsonresponse == true) {
    //   //   setState(() {
    //   //     verified = true;
    //   //   });
    //   // } else {
    //   //   verified = false;
    //   // }
    // }

    mapAvaildataEwayBill(int i, String docname) async {
      if (i == 0 || i == 1 || i == 2 || i == 3) {
        var doc1 = {
          "documentType": docname,
          "data": providerData.EwayBillPhoto64
        };

        datanew["documents"][0] = doc1;
      }
      await uploadDocumentApiCall();
    }

    assignDocNameEwayBill(int i) async {
      if (i == 0) {
        await mapAvaildataEwayBill(i, "EwayBillPhoto1");
      } else if (i == 1) {
        await mapAvaildataEwayBill(i, "EwayBillPhoto2");
      } else if (i == 2) {
        await mapAvaildataEwayBill(i, "EwayBillPhoto3");
      } else if (i == 3) {
        await mapAvaildataEwayBill(i, "EwayBillPhoto4");
      }
    }

    uploadFirstEwayBill() async {
      datanew = {
        "entityId": widget.bookingId.toString(),
        "documents": [
          {
            "documentType": "EwayBillPhoto1",
            "data": providerData.EwayBillPhoto64
          }
        ],
      };
      await uploadDocumentApiCall();
    }

    uploadedCheckEwayBill() async {
      docLinks = [];
      docLinks = await getDocumentApiCall(widget.bookingId.toString(), "E");
      setState(() {
        docLinks = docLinks;
      });
      print("docLinks :-");
      print(docLinks);
      if (docLinks.isNotEmpty) {
        if (docLinks.length == 4) {
        } else {
          availDocs = await getDocName(widget.bookingId.toString(), "E");

          setState(() {
            availDocs = availDocs;
          });
          print(availDocs);
          await assignDocNameEwayBill(availDocs[0]);
          providerData.EwayBillPhotoFile = null;
          providerData.EwayBillPhoto64 = null;
        }
        // verifiedCheckEwayBill();
      } else {
        print("EwayBill");
        await uploadFirstEwayBill();
      }
    }

    // WeightReceipt :-
    // verifiedCheckWeightReceipt() async {
    //   jsonresponse =
    //       await getDocApiCallVerify(widget.bookingId.toString(), "W");
    //   print(jsonresponse);
    //   // if (jsonresponse == true) {
    //   //   setState(() {
    //   //     verified = true;
    //   //   });
    //   // } else {
    //   //   verified = false;
    //   // }
    // }

    mapAvaildataWeightReceipt(int i, String docname) async {
      if (i == 0 || i == 1 || i == 2 || i == 3) {
        var doc1 = {
          "documentType": docname,
          "data": providerData.WeightReceiptPhoto64
        };

        datanew["documents"][0] = doc1;
      }
      await uploadDocumentApiCall();
    }

    assignDocNameWeightReceipt(int i) async {
      if (i == 0) {
        await mapAvaildataWeightReceipt(i, "WeightReceiptPhoto1");
      } else if (i == 1) {
        await mapAvaildataWeightReceipt(i, "WeightReceiptPhoto2");
      } else if (i == 2) {
        await mapAvaildataWeightReceipt(i, "WeightReceiptPhoto3");
      } else if (i == 3) {
        await mapAvaildataWeightReceipt(i, "WeightReceiptPhoto4");
      }
    }

    uploadFirstWeightReceipt() async {
      datanew = {
        "entityId": widget.bookingId.toString(),
        "documents": [
          {
            "documentType": "WeightReceiptPhoto1",
            "data": providerData.WeightReceiptPhoto64
          }
        ],
      };
      await uploadDocumentApiCall();
    }

    uploadedCheckWeightReceipt() async {
      docLinks = [];
      docLinks = await getDocumentApiCall(widget.bookingId.toString(), "W");
      setState(() {
        docLinks = docLinks;
      });
      print("docLinks :-");
      print(docLinks);
      if (docLinks.isNotEmpty) {
        if (docLinks.length == 4) {
        } else {
          availDocs = await getDocName(widget.bookingId.toString(), "W");

          setState(() {
            availDocs = availDocs;
          });
          print(availDocs);
          await assignDocNameWeightReceipt(availDocs[0]);
          // await uploadDocumentApiCall();
          providerData.WeightReceiptPhotoFile = null;
          providerData.WeightReceiptPhoto64 = null;
        }
        // verifiedCheckWeightReceipt();
      } else {
        print("WeightReceipt");
        await uploadFirstWeightReceipt();
      }
    }

    // Future<File?>
    // _cropImage({required File? imageFile}) async {
    //   CroppedFile? croppedFile =
    //       await ImageCropper().cropImage(sourcePath: imageFile!.path);

    //   if (croppedFile == null) {
    //     return null;
    //   }
    //   // providerData.updateLrPhoto(croppedFile.path as File);
    //   // final bytes = await Io.File(croppedFile.path).readAsBytes();
    //   // String img64 = base64Encode(bytes); // croppedFile.path;
    //   // providerData.updateLrPhotoStr(img64);
    // }

    return WillPopScope(
      onWillPop: () async {
        // to null the provider data of the documents variables after clicking the back button of the android device.

        print("After clicking the Android Back Button");
        // var providerData = Provider.of<ProviderData>(context);
        providerData.LrPhotoFile = null;
        providerData.LrPhoto64 = null;

        providerData.EwayBillPhotoFile = null;
        providerData.EwayBillPhoto64 = null;

        providerData.WeightReceiptPhotoFile = null;
        providerData.WeightReceiptPhoto64 = null;

        providerData.PodPhotoFile = null;
        providerData.PodPhoto64 = null;
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(245, 246, 250, 1),
        body: Container(
          child: (providerData.LrPhotoFile !=
                  null) // to display the document upload screen only if the lr photo is selected by the user.
              ? SafeArea(
                  child: Scaffold(
                    body: Column(
                      children: [
                        Container(
                          height: size_15 + 30,
                          color: whiteBackgroundColor,
                          child: Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Get.back();
                                          setState(() {
                                            providerData.LrPhotoFile = null;
                                            providerData.LrPhoto64 = null;

                                            providerData.EwayBillPhotoFile =
                                                null;
                                            providerData.EwayBillPhoto64 = null;

                                            providerData
                                                .WeightReceiptPhotoFile = null;
                                            providerData.WeightReceiptPhoto64 =
                                                null;

                                            providerData.PodPhotoFile = null;
                                            providerData.PodPhoto64 = null;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.arrow_back_ios,
                                          color: darkBlueColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: space_1,
                                    ),
                                    Text(
                                      "Upload Image".tr,
                                      style: TextStyle(
                                          fontSize: size_10 - 1,
                                          fontWeight: boldWeight,
                                          color: darkBlueColor,
                                          letterSpacing: -0.408),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: size_3,
                          color: darkGreyColor,
                        ),
                        providerData.LrPhotoFile != null
                            ? Expanded(
                                child: SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, left: 10, right: 10),
                                    child: kIsWeb
                                        ? Image.network(
                                            providerData.LrPhotoFile!.path)
                                        : Image.file(providerData.LrPhotoFile!),
                                  ),
                                ),
                              )
                            : Container(),
                        Row(children: [
                          // Flexible(
                          //     child: ElevatedButton(
                          //   child: Text("Edit"),
                          //   onPressed: () async {
                          //     await _cropImage(
                          //         imageFile: providerData.LrPhotoFile);
                          //   },
                          // )),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 7.5, bottom: 10, top: 10),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: const Color(0xFFE75347),
                                  child: SizedBox(
                                    height: space_10,
                                    child: Center(
                                      child: Text(
                                        "Discard".tr,
                                        style: TextStyle(
                                            color: white,
                                            fontSize: size_9,
                                            fontWeight: mediumBoldWeight),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      providerData.LrPhotoFile = null;
                                    });
                                    providerData.LrPhotoFile = null;
                                  }),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 7.5, right: 15, bottom: 10, top: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                      onTapUp: (value) {
                                        setState(() {
                                          progressBar = true;
                                        });
                                      },
                                      onTap: uploadedCheckLr,
                                      child: Container(
                                        color: const Color(0xFF09B778),
                                        height: space_10,
                                        child: Center(
                                          child: progressBar
                                              ? const CircularProgressIndicator(
                                                  color: white,
                                                )
                                              : Text(
                                                  "Save".tr,
                                                  style: TextStyle(
                                                      color: white,
                                                      fontSize: size_9,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                        ),
                                      )),
                                )),
                          ),
                        ]),
                      ],
                    ),
                  ),
                )
              : (providerData.EwayBillPhotoFile != null)
                  ? SafeArea(
                      child: Scaffold(
                        body: Column(
                          children: [
                            Container(
                              height: size_15 + 30,
                              color: whiteBackgroundColor,
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: GestureDetector(
                                            onTap: () {
                                              // Get.back();
                                              setState(() {
                                                providerData.LrPhotoFile = null;
                                                providerData.LrPhoto64 = null;

                                                providerData.EwayBillPhotoFile =
                                                    null;
                                                providerData.EwayBillPhoto64 =
                                                    null;

                                                providerData
                                                        .WeightReceiptPhotoFile =
                                                    null;
                                                providerData
                                                        .WeightReceiptPhoto64 =
                                                    null;

                                                providerData.PodPhotoFile =
                                                    null;
                                                providerData.PodPhoto64 = null;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.arrow_back_ios,
                                              color: darkBlueColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: space_1,
                                        ),
                                        Text(
                                          "Upload Image".tr,
                                          style: TextStyle(
                                              fontSize: size_10 - 1,
                                              fontWeight: boldWeight,
                                              color: darkBlueColor,
                                              letterSpacing: -0.408),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: size_3,
                              color: darkGreyColor,
                            ),
                            providerData.EwayBillPhotoFile != null
                                ? Expanded(
                                    child: SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, left: 10, right: 10),
                                        child: kIsWeb
                                            ? Image.network(providerData
                                                .EwayBillPhotoFile!.path)
                                            : Image.file(providerData
                                                .EwayBillPhotoFile!),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Row(children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 7.5,
                                      bottom: 10,
                                      top: 10),
                                  child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: const Color(0xFFE75347),
                                      child: SizedBox(
                                        height: space_10,
                                        child: Center(
                                          child: Text(
                                            "Discard".tr,
                                            style: TextStyle(
                                                color: white,
                                                fontSize: size_9,
                                                fontWeight: mediumBoldWeight),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          providerData.EwayBillPhotoFile = null;
                                        });
                                        providerData.EwayBillPhotoFile = null;
                                      }),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 7.5,
                                        right: 15,
                                        bottom: 10,
                                        top: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: InkWell(
                                          onTapUp: (value) {
                                            setState(() {
                                              progressBar = true;
                                            });
                                          },
                                          onTap: uploadedCheckEwayBill,
                                          child: Container(
                                            color: const Color(0xFF09B778),
                                            height: space_10,
                                            child: Center(
                                              child: progressBar
                                                  ? const CircularProgressIndicator(
                                                      color: white,
                                                    )
                                                  : Text(
                                                      "Save".tr,
                                                      style: TextStyle(
                                                          color: white,
                                                          fontSize: size_9,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                            ),
                                          )),
                                    )),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    )
                  : (providerData.WeightReceiptPhotoFile != null)
                      ? SafeArea(
                          child: Scaffold(
                            body: Column(
                              children: [
                                Container(
                                  height: size_15 + 30,
                                  color: whiteBackgroundColor,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Get.back();
                                                  setState(() {
                                                    providerData.LrPhotoFile =
                                                        null;
                                                    providerData.LrPhoto64 =
                                                        null;

                                                    providerData
                                                            .EwayBillPhotoFile =
                                                        null;
                                                    providerData
                                                        .EwayBillPhoto64 = null;

                                                    providerData
                                                            .WeightReceiptPhotoFile =
                                                        null;
                                                    providerData
                                                            .WeightReceiptPhoto64 =
                                                        null;

                                                    providerData.PodPhotoFile =
                                                        null;
                                                    providerData.PodPhoto64 =
                                                        null;
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.arrow_back_ios,
                                                  color: darkBlueColor,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: space_1,
                                            ),
                                            Text(
                                              "Upload Image".tr,
                                              style: TextStyle(
                                                  fontSize: size_10 - 1,
                                                  fontWeight: boldWeight,
                                                  color: darkBlueColor,
                                                  letterSpacing: -0.408),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: size_3,
                                  color: darkGreyColor,
                                ),
                                providerData.WeightReceiptPhotoFile != null
                                    ? Expanded(
                                        child: SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0, left: 10, right: 10),
                                            child: kIsWeb
                                                ? Image.network(providerData
                                                    .WeightReceiptPhotoFile!
                                                    .path)
                                                : Image.file(providerData
                                                    .WeightReceiptPhotoFile!),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Row(children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 7.5,
                                          bottom: 10,
                                          top: 10),
                                      child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          color: const Color(0xFFE75347),
                                          child: SizedBox(
                                            height: space_10,
                                            child: Center(
                                              child: Text(
                                                "Discard".tr,
                                                style: TextStyle(
                                                    color: white,
                                                    fontSize: size_9,
                                                    fontWeight:
                                                        mediumBoldWeight),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              providerData
                                                      .WeightReceiptPhotoFile =
                                                  null;
                                            });
                                            providerData
                                                .WeightReceiptPhotoFile = null;
                                          }),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7.5,
                                            right: 15,
                                            bottom: 10,
                                            top: 10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: InkWell(
                                              onTapUp: (value) {
                                                setState(() {
                                                  progressBar = true;
                                                });
                                              },
                                              onTap: uploadedCheckWeightReceipt,
                                              child: Container(
                                                color: const Color(0xFF09B778),
                                                height: space_10,
                                                child: Center(
                                                  child: progressBar
                                                      ? const CircularProgressIndicator(
                                                          color: white,
                                                        )
                                                      : Text(
                                                          "Save".tr,
                                                          style: TextStyle(
                                                              color: white,
                                                              fontSize: size_9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                ),
                                              )),
                                        )),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        )
                      : (providerData.PodPhotoFile != null)
                          ? SafeArea(
                              child: Scaffold(
                                body: Column(
                                  children: [
                                    Container(
                                      height: size_15 + 30,
                                      color: whiteBackgroundColor,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // Get.back();
                                                      setState(() {
                                                        providerData
                                                            .LrPhotoFile = null;
                                                        providerData.LrPhoto64 =
                                                            null;

                                                        providerData
                                                                .EwayBillPhotoFile =
                                                            null;
                                                        providerData
                                                                .EwayBillPhoto64 =
                                                            null;

                                                        providerData
                                                                .WeightReceiptPhotoFile =
                                                            null;
                                                        providerData
                                                                .WeightReceiptPhoto64 =
                                                            null;

                                                        providerData
                                                                .PodPhotoFile =
                                                            null;
                                                        providerData
                                                            .PodPhoto64 = null;
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.arrow_back_ios,
                                                      color: darkBlueColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: space_1,
                                                ),
                                                Text(
                                                  "Upload Image".tr,
                                                  style: TextStyle(
                                                      fontSize: size_10 - 1,
                                                      fontWeight: boldWeight,
                                                      color: darkBlueColor,
                                                      letterSpacing: -0.408),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: size_3,
                                      color: darkGreyColor,
                                    ),
                                    providerData.PodPhotoFile != null
                                        ? Expanded(
                                            child: SizedBox(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0,
                                                    left: 10,
                                                    right: 10),
                                                child: kIsWeb
                                                    ? Image.network(providerData
                                                        .PodPhotoFile!.path)
                                                    : Image.file(providerData
                                                        .PodPhotoFile!),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Row(children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15,
                                              right: 7.5,
                                              bottom: 10,
                                              top: 10),
                                          child: MaterialButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              color: const Color(0xFFE75347),
                                              child: SizedBox(
                                                height: space_10,
                                                child: Center(
                                                  child: Text(
                                                    "Discard".tr,
                                                    style: TextStyle(
                                                        color: white,
                                                        fontSize: size_9,
                                                        fontWeight:
                                                            mediumBoldWeight),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  providerData.PodPhotoFile =
                                                      null;
                                                });
                                                providerData.PodPhotoFile =
                                                    null;
                                              }),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 7.5,
                                                right: 15,
                                                bottom: 10,
                                                top: 10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: InkWell(
                                                  onTapUp: (value) {
                                                    setState(() {
                                                      progressBar = true;
                                                    });
                                                  },
                                                  onTap: uploadedCheckPod,
                                                  child: Container(
                                                    color:
                                                        const Color(0xFF09B778),
                                                    height: space_10,
                                                    // width: space_30,
                                                    child: Center(
                                                      child: progressBar
                                                          ? const CircularProgressIndicator(
                                                              color: white,
                                                            )
                                                          : Text(
                                                              "Save".tr,
                                                              style: TextStyle(
                                                                  color: white,
                                                                  fontSize:
                                                                      size_9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                      // ),
                                                    ),
                                                  )),
                                            )),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              // this will be displayed if any document is not selected for uploading.
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    child: Container(
                                      // alignment: Alignment.topLeft,
                                      child: const Padding(
                                        padding: EdgeInsets.all(32.0),
                                        child: Text(
                                          "Loads",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  21, 41, 104, 1),
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //header
                                  Material(
                                    elevation: 5,
                                    child: Container(
                                      height: size_15 + 50,
                                      color: white,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.back();
                                                      providerData.LrPhotoFile =
                                                          null;
                                                      providerData.LrPhoto64 =
                                                          null;

                                                      providerData
                                                              .EwayBillPhotoFile =
                                                          null;
                                                      providerData
                                                              .EwayBillPhoto64 =
                                                          null;

                                                      providerData
                                                              .WeightReceiptPhotoFile =
                                                          null;
                                                      providerData
                                                              .WeightReceiptPhoto64 =
                                                          null;

                                                      providerData
                                                          .PodPhotoFile = null;
                                                      providerData.PodPhoto64 =
                                                          null;
                                                    },
                                                    child: const Icon(
                                                      Icons.arrow_back_ios,
                                                      color: darkBlueColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: space_1,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Loads Details",
                                                      // widget.truckNo.toString(),
                                                      // "TN 09 JP 1234",
                                                      style: TextStyle(
                                                          fontSize: size_10 - 1,
                                                          fontWeight:
                                                              boldWeight,
                                                          color: darkBlueColor,
                                                          letterSpacing:
                                                              -0.408),
                                                    ),
                                                    Text(
                                                      "On Going load details",
                                                      style: TextStyle(
                                                          fontSize:
                                                              size_10 - 10,
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //For Track button
                                  // navigateToTrackScreen(
                                  //   truckApproved: true,
                                  //   bookingDate: widget.bookingDate,
                                  //   bookingId: widget.bookingId,
                                  //   loadingPoint: widget.loadingPoint,
                                  //   unloadingPoint: widget.unloadingPoint,
                                  //   gpsData: widget.gpsDataList[0],
                                  //   TruckNo: widget.truckNo,
                                  //   totalDistance: widget.totalDistance,
                                  //   // device: widget.device,
                                  // ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  //from to widget
                                  Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Material(
                                      elevation: 5,
                                      child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              10,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    90,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    90),
                                            child: Container(
                                              color: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "${widget.loadingPoint}",
                                                        style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              9, 183, 120, 1),
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      Container(
                                                        // rectangle429199w (1:2)
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2,
                                                        height: 7,
                                                        decoration:
                                                            const BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment(
                                                                -1, -1),
                                                            end: Alignment(
                                                                1, -1),
                                                            colors: <Color>[
                                                              Color(0xff09b778),
                                                              Color(0xffec4a4a)
                                                            ],
                                                            stops: <double>[
                                                              0,
                                                              1
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${widget.unloadingPoint}",
                                                        style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              237, 74, 74, 1),
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  //BOXXX
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Material(
                                      elevation: 5,
                                      child: Container(
                                          color: Colors.white,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3) /
                                                    5,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black,
                                                          width: 1)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) /
                                                          6,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(),
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Truck\nNumber",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) *
                                                          2 /
                                                          6,
                                                      child: Center(
                                                          child: Text(
                                                              "${widget.truckNo}")),
                                                    ),
                                                    Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) /
                                                          6,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "LR Number",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) *
                                                          2 /
                                                          6,
                                                      child: const Center(
                                                          child: Text(
                                                        "Hm98765432110112",
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3) /
                                                    5,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black,
                                                          width: 1)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) /
                                                          6,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(),
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Driver Name",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) *
                                                          2 /
                                                          6,
                                                      child: Center(
                                                          child: Text(
                                                              "${widget.driverName}")),
                                                    ),
                                                    Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) /
                                                          6,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Product Type",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) *
                                                          2 /
                                                          6,
                                                      child: Center(
                                                          child: Text(
                                                        "${widget.productType}",
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3) /
                                                    5,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black,
                                                          width: 1)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) /
                                                          6,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(),
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Driver\nMobile No.",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) *
                                                          2 /
                                                          6,
                                                      child: Center(
                                                          child: Text(
                                                              "${widget.driverPhoneNum}")),
                                                    ),
                                                    Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) /
                                                          6,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Truck Type",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) *
                                                          2 /
                                                          6,
                                                      child: Center(
                                                          child: Text(
                                                        "${widget.truckType}",
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3) /
                                                    5,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.black,
                                                          width: 1)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) /
                                                          6,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(),
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Booking\nDate",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) *
                                                          2 /
                                                          6,
                                                      child: Center(
                                                          child: Text(
                                                              "${widget.bookingDate}")),
                                                    ),
                                                    Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) /
                                                          6,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "weight",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) *
                                                          2 /
                                                          6,
                                                      child: Center(
                                                          child: Text(
                                                        "${widget.unitValue}",
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3) /
                                                    5,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) /
                                                          6,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(),
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Transpoter",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) *
                                                          2 /
                                                          6,
                                                      child: const Center(
                                                          child: Text(
                                                              "LivEasy Logistics")),
                                                    ),
                                                    Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) /
                                                          6,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            9, 183, 120, 1),
                                                      ),
                                                      child: const Center(
                                                          child: Text(
                                                        "Fright",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                    ),
                                                    SizedBox(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              60) *
                                                          2 /
                                                          6,
                                                      child: const Center(
                                                          child: Text(
                                                        "17,000",
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Divider(
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        space_4, space_4, space_4, 0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Upload Documents",
                                        style: TextStyle(
                                            color: const Color.fromRGBO(
                                                21, 41, 104, 1),
                                            fontWeight: boldWeight,
                                            fontSize: size_10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, right: 50),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "Lorry Recipt",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "EWAY Bill",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "Weight Recipt",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "POD (Pahoch)",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
//Might Be usefull
                                  // Padding(
                                  //   padding: EdgeInsets.fromLTRB(
                                  //       space_4, space_4, space_4, 0),
                                  //   child: Container(
                                  //     height: 70,
                                  //     color: darkBlueColor,
                                  //     width: MediaQuery.of(context).size.width,
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.start,
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.center,
                                  //       children: [
                                  //         const Padding(
                                  //           padding: EdgeInsets.only(left: 15),
                                  //           child: Image(
                                  //               image: AssetImage(
                                  //                   "assets/icons/MaleUser.png")),
                                  //         ),
                                  //         Padding(
                                  //           padding:
                                  //               const EdgeInsets.only(left: 16),
                                  //           child: Text(
                                  //             widget.transporterName.toString(),
                                  //             style: TextStyle(
                                  //                 color: white,
                                  //                 fontSize: size_8,
                                  //                 fontWeight: mediumBoldWeight),
                                  //           ),
                                  //         ),
                                  //         // Flexible(
                                  //         //   flex: 2,
                                  //         //   child: Align(
                                  //         //     alignment: Alignment.centerRight,
                                  //         //     child: Padding(
                                  //         //       padding: EdgeInsets.only(
                                  //         //           left: 55,
                                  //         //           right: 15,
                                  //         //           top: 10,
                                  //         //           bottom: 10),
                                  //         //       child:
                                  //         //       callBtn(
                                  //         //         directCall: true,
                                  //         //         name: widget.transporterName
                                  //         //             .toString(),
                                  //         //         phoneNum: widget
                                  //         //             .transporterPhoneNum
                                  //         //             .toString(),
                                  //         //       ),
                                  //         //     ),
                                  //         //   ),
                                  //         // ),
                                  //         // Expanded(
                                  //         //   child: Container(
                                  //         //       child: Column
                                  //         //     )
                                  //         // )
                                  //         Expanded(
                                  //             child: Container(
                                  //                 // color: Colors.deepOrange,
                                  //                 margin: const EdgeInsets.only(
                                  //                   top: 10,
                                  //                   bottom: 10,
                                  //                   right: 15,
                                  //                 ),
                                  //                 child: Column(
                                  //                     // mainAxisAlignment: MainAxisAlignment.end,
                                  //                     children: [
                                  //                       Container(
                                  //                         alignment: Alignment
                                  //                             .centerRight,
                                  //                         child: callBtn(
                                  //                           directCall: true,
                                  //                           name: widget
                                  //                               .transporterName
                                  //                               .toString(),
                                  //                           phoneNum: widget
                                  //                               .transporterPhoneNum
                                  //                               .toString(),
                                  //                         ),
                                  //                       )
                                  //                     ])))
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: size_2,
                                  // ),
                                  // Padding(
                                  //   padding: EdgeInsets.fromLTRB(
                                  //       space_4, space_4, space_4, 0),
                                  //   child: Align(
                                  //     alignment: Alignment.centerLeft,
                                  //     child: Text(
                                  //       "Truck & Driver".tr,
                                  //       style: TextStyle(
                                  //           color: grey,
                                  //           fontWeight: boldWeight,
                                  //           fontSize: size_10),
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: space_5,
                                  // ),
                                  // Padding(
                                  //   padding: EdgeInsets.fromLTRB(
                                  //       space_4, 0, space_4, 0),
                                  //   child: Container(
                                  //     height: 70,
                                  //     color: darkBlueColor,
                                  //     width: MediaQuery.of(context).size.width,
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.start,
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.center,
                                  //       children: [
                                  //         const Padding(
                                  //           padding: EdgeInsets.only(left: 15),
                                  //           child: Image(
                                  //               image: AssetImage(
                                  //                   "assets/icons/deliveryTruck.png")),
                                  //         ),
                                  //         Padding(
                                  //           padding:
                                  //               const EdgeInsets.only(left: 16),
                                  //           child: Text(
                                  //             widget.truckNo.toString(),
                                  //             // "TN 09 JP 1234",
                                  //             style: TextStyle(
                                  //                 color: white,
                                  //                 fontSize: size_8,
                                  //                 fontWeight: mediumBoldWeight),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: size_2,
                                  // ),
                                  // Padding(
                                  //   padding: EdgeInsets.fromLTRB(
                                  //       space_4, 0, space_4, 0),
                                  //   child: Container(
                                  //     color: darkBlueColor,
                                  //     width: MediaQuery.of(context).size.width,
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.start,
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         const Padding(
                                  //           padding: EdgeInsets.only(
                                  //               top: 11, left: 15),
                                  //           child: Image(
                                  //               image: AssetImage(
                                  //                   "assets/icons/MaleUser.png")),
                                  //         ),
                                  //         Padding(
                                  //           padding: const EdgeInsets.only(
                                  //               left: 11, top: 5, bottom: 5),
                                  //           child: Column(
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.start,
                                  //             children: [
                                  //               Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.all(5),
                                  //                 child: Text(
                                  //                   widget.driverName
                                  //                       .toString(),
                                  //                   // "Rajpal Sharma",
                                  //                   style: TextStyle(
                                  //                       color: white,
                                  //                       fontSize: size_8,
                                  //                       fontWeight:
                                  //                           mediumBoldWeight),
                                  //                 ),
                                  //               ),
                                  //               Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.all(5),
                                  //                 child: Text(
                                  //                   widget.driverPhoneNum
                                  //                       .toString(),
                                  //                   // "7894561230",
                                  //                   style: TextStyle(
                                  //                       color: white,
                                  //                       fontSize: size_8),
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //         // Flexible(
                                  //         //   flex: 2,
                                  //         //   child: Align(
                                  //         //     alignment: Alignment.centerRight,
                                  //         //     child: Padding(
                                  //         //       padding: EdgeInsets.only(
                                  //         //           left: 35,
                                  //         //           right: 15,
                                  //         //           top: 10,
                                  //         //           bottom: 10),
                                  //         //       child:
                                  //         //     ),
                                  //         //   ),
                                  //         // ),
                                  //         // Container(
                                  //         //   // alignment: Alignment.centerRight,
                                  //         //   // color: Colors.deepOrange,
                                  //         //   child:
                                  //         //   callBtn(
                                  //         //     directCall: true,
                                  //         //     name: widget.driverName
                                  //         //         .toString(),
                                  //         //     phoneNum: widget
                                  //         //         .driverPhoneNum
                                  //         //         .toString(),
                                  //         //   ),
                                  //         // )
                                  //         Expanded(
                                  //             child: Container(
                                  //                 // color: Colors.deepOrange,
                                  //                 margin: const EdgeInsets.only(
                                  //                   top: 10,
                                  //                   bottom: 10,
                                  //                   right: 15,
                                  //                 ),
                                  //                 child: Column(
                                  //                     // mainAxisAlignment: MainAxisAlignment.end,
                                  //                     children: [
                                  //                       Container(
                                  //                         alignment: Alignment
                                  //                             .centerRight,
                                  //                         child: callBtn(
                                  //                           directCall: true,
                                  //                           name: widget
                                  //                               .driverName
                                  //                               .toString(),
                                  //                           phoneNum: widget
                                  //                               .driverPhoneNum
                                  //                               .toString(),
                                  //                         ),
                                  //                       )
                                  //                     ])))
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  const SizedBox(height: 30),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        space_4, space_4, space_4, 0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Upload Documents".tr,
                                        style: TextStyle(
                                            color: grey,
                                            fontWeight: boldWeight,
                                            fontSize: size_10),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        space_4, space_2, space_4, 0),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Loading Documents".tr,
                                          style: TextStyle(
                                              color: grey,
                                              fontSize: size_9,
                                              decoration:
                                                  TextDecoration.underline),
                                        )),
                                  ),
                                  // Text("Uploading Documents"),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        space_4, space_1, space_4, 0),
                                    child: Text(
                                      "Upload Loadoing document photos for advanced payment"
                                          .tr,
                                      style: const TextStyle(color: grey),
                                    ),
                                  ),

                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          space_4, space_4, space_4, 0),
                                      child: docInputLr(
                                          providerData: providerData,
                                          bookingId: widget.bookingId)),

                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          space_4, space_4, space_4, 0),
                                      child: docInputEWBill(
                                          providerData: providerData,
                                          bookingId: widget.bookingId)),

                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          space_4, space_4, space_4, 0),
                                      child: docInputWgtReceipt(
                                        providerData: providerData,
                                        bookingId: widget.bookingId,
                                      )),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        space_4, space_4, space_4, 0),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Uploading Documents".tr,
                                          style: TextStyle(
                                              color: grey,
                                              fontSize: size_9,
                                              decoration:
                                                  TextDecoration.underline),
                                        )),
                                  ),
                                  // Text("Uploading Documents"),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        space_4, space_1, space_4, 0),
                                    child: Text(
                                      "Upload unloadoing document photos for final payment"
                                          .tr,
                                      style: const TextStyle(color: grey),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        space_4, space_4, space_4, space_4),
                                    child: docInputPod(
                                      providerData: providerData,
                                      bookingId: widget.bookingId,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 40,
                                  )
                                ],
                              ),
                            ),
        ),
      ),
    );
  }
}

//help button
// Flexible(
//                                           flex: 1,
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         const HelpScreen()),
//                                               );
//                                             },
//                                             child: Row(
//                                               children: [
//                                                 Container(
//                                                   height: space_5,
//                                                   width: space_5,
//                                                   decoration: const BoxDecoration(
//                                                       image: DecorationImage(
//                                                           image: AssetImage(
//                                                               "assets/icons/help_ic.png"))),
//                                                 ),
//                                                 SizedBox(
//                                                   width: space_1,
//                                                 ),
//                                                 Text(
//                                                   'help'.tr,
//                                                   // AppLocalizations.of(context)!.help,
//                                                   style: TextStyle(
//                                                       fontSize: size_10,
//                                                       color: darkBlueColor,
//                                                       fontWeight: boldWeight),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
