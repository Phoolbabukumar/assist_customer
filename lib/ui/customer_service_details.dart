import 'dart:convert';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/ui/map_home_screen.dart';
import 'package:assist/utils/size_config.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Controllers/jobs_datalist_controller.dart';
import '../apis/base_client.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_images_path.dart';
import '../app_constants/app_strings.dart';
import '../utils/common_functions.dart';
import '../utils/custom_widgets.dart';
import '../utils/pusher/pusher_new_services.dart';
import 'job_detail_withmap.dart';

class CustomerServiceDetails extends StatelessWidget {
  final String custId;
  final double lat;
  final double long;
  final int rsaTermID;

  CustomerServiceDetails(
      {super.key,
      required this.custId,
      required this.lat,
      required this.long,
      required this.rsaTermID});

  final jobsDataListController = Get.put(JobsDataListController());

  @override
  Widget build(BuildContext context) {
    var tag = "Service Details";
    bool keyboardOpen =
        MediaQuery.of(context).viewInsets.bottom != 0 ? true : false;
    keyboardOpen ? jobsDataListController.scrollDown() : null;
    printMessage(tag, 'keyboardOpen$keyboardOpen');
    return networkWidget(GetBuilder<JobsDataListController>(builder: (builder) {
      return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: const CustomWidgets().appBar(
                context,
                4.0,
                global.themeType == 1
                    ? MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.black
                        : secondaryColor
                    : builder.themeController.isDarkMode.value
                        ? Colors.black
                        : secondaryColor,
                IconThemeData(
                    color: builder.themeController.isDarkMode.value
                        ? secondaryColor
                        : Colors.white),
                customText(
                    text: builder.requestFor ?? "",
                    color: global.themeType == 1
                        ? MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? secondaryColor
                            : Colors.white
                        : builder.themeController.isDarkMode.value
                            ? secondaryColor
                            : Colors.white),
                true),
            body: Obx(
              () => builder.isOfficeOpen.value
                  ? (builder.loading.value)
                      ? const CustomWidgets().buildShimmerBlock()
                      : ListView(
                          controller: builder.controller,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          children: [
                            _buildPersonalBlock(jdc: builder),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _buildAddressBlock(
                                keyboardOpen: keyboardOpen, jdc: builder),
                            _buildBottomButtons(
                                keyboardOpen: keyboardOpen, jdc: builder),
                          ],
                        )
                  : SizedBox(
                      height: Get.height,
                      width: Get.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            officeClosedImage,
                            height: Get.height * 0.3,
                            width: Get.width * 0.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: customText(
                                text: labelOfficeCloseText,
                                size: 20,
                                color: secondaryColor,
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(
                            width: Get.width * 0.3,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: secondaryColor),
                              onPressed: () {
                                makePhoneCall(global.phoneNoRetailer);
                              },
                              child: customText(
                                  text: labelCallNow,
                                  size: 16,
                                  color: whiteColor),
                            ),
                          ),
                        ],
                      ),
                    ),
            )),
      );
    }), context);
  }

  _buildPersonalBlock({required JobsDataListController jdc}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      elevation: 8.0,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: jdc.ownership.value,
                          onChanged: (value) {
                            jdc.ownership.value = value!;
                            jdc.isName.value = true;
                            jdc.isMobile.value = true;
                          },
                          activeColor: secondaryColor,
                        ),
                        customText(
                          text: labelOwn,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: jdc.ownership.value,
                          onChanged: (value) {
                            jdc.ownership.value = value!;
                            jdc.isName.value = false;
                            jdc.isMobile.value = false;
                            printMessage(tag, value);
                            if (value == 2) {
                              FocusScope.of(Get.context!)
                                  .requestFocus(jdc.nameFocusNode);
                            }
                          },
                          activeColor: secondaryColor,
                        ),
                        customText(
                          text: labelOtherMember,
                        ),
                      ],
                    ),
                  )
                ],
              )),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Obx(
                () => TextField(
                    readOnly: jdc.isName.value,
                    focusNode: jdc.nameFocusNode,
                    keyboardType: TextInputType.text,
                    controller: jdc.customerNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-z ]"))
                    ],
                    decoration: const CustomWidgets().inputDecorationBox(
                        Get.context!, labelName, Icons.person)),
              )),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Obx(
                () => TextField(
                  readOnly: jdc.isMobile.value,
                  focusNode: jdc.mobileFocusNode,
                  keyboardType: TextInputType.phone,
                  controller: jdc.mobileController,
                  maxLength: 9,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                  ],
                  decoration: InputDecoration(
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          austrailiaFlagImage,
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 4),
                        customText(
                          text: labelAu,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          width: 1,
                          height: 20,
                          color: Colors.grey,
                        )
                      ],
                    ),
                    labelText: labelMobile,
                    counterText: "",
                    contentPadding: const EdgeInsets.only(left: 10),
                    labelStyle: TextStyle(color: gray800),
                    floatingLabelStyle: TextStyle(color: secondaryColor),
                    errorStyle: TextStyle(color: secondaryColor),
                    helperStyle: TextStyle(color: secondaryColor),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor),
                    ),
                  ),
                ),
              )),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  _buildAddressBlock(
      {required keyboardOpen, required JobsDataListController jdc}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      elevation: 8.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Obx(() => Radio(
                          value: 1,
                          groupValue: jdc.location.value,
                          onChanged: (value) {
                            jdc.location.value = value!;
                            jdc.isAddress.value = !jdc.isAddress.value;
                            jdc.currentAddressController.text =
                                jdc.currentAddress.value;
                          },
                          activeColor: secondaryColor,
                        )),
                    customText(
                      text: labelCurrentLocation,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Obx(() => Radio(
                          value: 2,
                          groupValue: jdc.location.value,
                          onChanged: (value) {
                            jdc.location.value = value!;
                            jdc.isAddress.value = !jdc.isAddress.value;
                            jdc.currentAddressController.text = "";
                            if (jdc.isAddress.value == false) {
                              FocusScope.of(Get.context!)
                                  .requestFocus(jdc.addressFocusNode);
                            }
                          },
                          activeColor: secondaryColor,
                        )),
                    customText(
                      text: labelOtherLocation,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => TextField(
                  readOnly: jdc.isAddress.value,
                  focusNode: jdc.addressFocusNode,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    jdc.isCurrentAddSuggestion.value = true;
                  },
                  controller: jdc.currentAddressController,
                  decoration: const CustomWidgets().inputDecorationBox(
                      Get.context!,
                      labelCurrentAddress,
                      Icons.where_to_vote_outlined),
                )),
          ),
          Obx(() => Visibility(
                visible: jdc.isCurrentAddSuggestion.value,
                child: ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: jdc.placeList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: customText(
                        text: jdc.placeList[index]["description"] ?? na,
                      ),
                      onTap: () async {
                        debugPrint('dff');
                        if (jdc.tdLat.isEmpty || jdc.tdLang.isEmpty) {
                          await jdc.getLatLangFromAddress(
                              jdc.placeList[index]["description"]);
                        }

                        jdc.currentAddressController.text =
                            jdc.placeList[index]["description"];
                        jdc.isCurrentAddSuggestion.value = false;
                        jdc
                            .getLatLangFromCurrentAddress(
                                jdc.currentAddressController.text.trim())
                            .then((value) {
                          jdc.distanceInKmBetweenEarthCoordinates(
                              double.parse(jdc.cdLat),
                              double.parse(jdc.cdLang),
                              double.parse(jdc.tdLat),
                              double.parse(jdc.tdLang));
                        });

                        jdc.addressFocusNode.unfocus();
                      },
                    );
                  },
                ),
              )),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: DropdownSearch<String>(
              popupProps: const PopupProps.menu(
                searchDelay: Duration(milliseconds: 0),
                showSearchBox: false,
                showSelectedItems: true,
                fit: FlexFit.loose,
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: const CustomWidgets()
                      .inputDecorationBox(
                          Get.context!, labelVehicleParked, Icons.car_repair)),
              items: vehicleLocationList,
              onChanged: (newValue) {
                jdc.isLandmark.value = false;
                vehicleLocation = newValue!;
                jdc.landmarkController.text = newValue;
                if (newValue == hintOther) {
                  jdc.isLandmark.value = !jdc.isLandmark.value;
                }
              },
            ),
          ),
          Obx(() => Visibility(
                visible: jdc.isLandmark.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    focusNode: jdc.otherAddNode,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: jdc.landmarkController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-z0-9]"))
                    ],
                    decoration: const CustomWidgets().inputDecorationBox(
                        Get.context!, labelLandmark, Icons.location_on),
                  ),
                ),
              )),
          Obx(() => Visibility(
                visible: jdc.isTowing.value,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          focusNode: jdc.dropAddNode,
                          keyboardType: TextInputType.multiline,
                          controller: jdc.dropAddressController,
                          onChanged: (value) {
                            jdc.isSuggestion.value = true;
                          },
                          decoration: const CustomWidgets().inputDecorationBox(
                              Get.context!,
                              labelDropAddress,
                              Icons.where_to_vote_outlined)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownSearch<String>(
                        selectedItem: vehicleDropLocation,
                        popupProps: const PopupProps.menu(
                          searchDelay: Duration(milliseconds: 0),
                          showSearchBox: false,
                          showSelectedItems: true,
                          fit: FlexFit.loose,
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            baseStyle: TextStyle(
                                color: vehicleDropLocation == 'Drop Location'
                                    ? Colors.grey
                                    : null),
                            dropdownSearchDecoration: const CustomWidgets()
                                .inputDecorationBox(
                                    Get.context!,
                                    labelDropLocation,
                                    jdc.iconDropLocationDropDown)),
                        items: vehicleDropTypePintList,
                        onChanged: (newValue) {
                          jdc.isDropLandmark.value = false;
                          vehicleDropLocation = newValue!;

                          if (newValue == "Home address") {
                            jdc.iconDropLocationDropDown = Icons.home;
                          }
                          if (newValue == "Other") {
                            jdc.iconDropLocationDropDown =
                                Icons.location_on_outlined;
                          }
                          if (newValue == "Mechanic") {
                            jdc.iconDropLocationDropDown =
                                Icons.manage_accounts_sharp;
                          }

                          if (newValue == hintOther || newValue == "Mechanic") {
                            if (newValue == hintOther) {
                              jdc.isDropLandmark.value = true;
                              jdc.dropLandmarkHint = "Landmark";
                              jdc.dropLandmarkController.text = newValue;
                            } else {
                              if (newValue == "Mechanic") {
                                jdc.isDropLandmark.value = true;
                                jdc.dropLandmarkHint = "Mechanic Name";
                                jdc.dropLandmarkController.text = "";
                              } else {
                                jdc.isDropLandmark.value = false;
                                jdc.dropLandmarkHint = "LandMark";
                              }
                            }
                          } else {
                            jdc.dropLandmarkController.text = newValue;
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: jdc.isDropLandmark.value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          focusNode: jdc.otherDropAddNode,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          controller: jdc.dropLandmarkController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-z0-9 ]"))
                          ],
                          decoration: const CustomWidgets().inputDecorationBox(
                              Get.context!,
                              jdc.dropLandmarkHint,
                              jdc.dropLandmarkHint == "Mechanic Name"
                                  ? Icons.manage_accounts_sharp
                                  : Icons.location_on),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Obx(() => Visibility(
                visible: jdc.isSuggestion.value,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: jdc.dropPlaceList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: customText(
                        text: jdc.dropPlaceList[index]["description"] ?? na,
                      ),
                      onTap: () async {
                        jdc.dropAddressController.text =
                            jdc.dropPlaceList[index]["description"];
                        jdc.isSuggestion.value = false;
                        await jdc
                            .getLatLangFromAddress(
                                jdc.dropAddressController.text)
                            .then((value) {
                          // distanceCalculator();
                          jdc.distanceInKmBetweenEarthCoordinates(
                              double.parse(jdc.cdLat),
                              double.parse(jdc.cdLang),
                              double.parse(jdc.tdLat),
                              double.parse(jdc.tdLang));

                          jdc.dropAddNode.unfocus();
                        });
                      },
                    );
                  },
                ),
              )),
          Obx(() => Visibility(
                visible: jdc.isTyreChanges.value,
                child: Row(
                  children: [
                    Checkbox(
                      value: jdc.isSpareTyreAvailable.value,
                      activeColor: secondaryColor,
                      onChanged: (value) {
                        jdc.isSpareTyreAvailable.value = value!;
                      },
                    ),
                    customText(
                        text: labelHaveSpareTyre,
                        size: 18,
                        color: secondaryColor,
                        fontWeight: FontWeight.w500),
                  ],
                ),
              )),
          Obx(() => Visibility(
                visible: jdc.isOutOfFuelRescue.value,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownSearch<String>(
                        selectedItem: vehicleFuelType,
                        popupProps: const PopupProps.menu(
                          searchDelay: Duration(milliseconds: 0),
                          showSearchBox: false,
                          showSelectedItems: true,
                          fit: FlexFit.loose,
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            baseStyle: TextStyle(
                                color: vehicleFuelType == "Fuel Type"
                                    ? Colors.grey
                                    : null),
                            dropdownSearchDecoration: const CustomWidgets()
                                .inputDecorationBox(Get.context!, labelFuelType,
                                    Icons.oil_barrel)),
                        items: vehicleFuelTypeList,
                        onChanged: (newValue) {
                          jdc.isFuelotherOptionTextField.value = false;
                          vehicleFuelType = newValue!;
                          jdc.fuelTypeController.text = newValue;
                          if (newValue == hintOther) {
                            jdc.isFuelotherOptionTextField.value =
                                !jdc.isFuelotherOptionTextField.value;
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: jdc.isFuelotherOptionTextField.value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          focusNode: jdc.otherFuelType,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          controller: jdc.fuelTypeController,
                          decoration: const CustomWidgets().inputDecorationBox(
                              Get.context!, labelFuelType, Icons.oil_barrel),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Obx(() => jdc.distanceKm.value > 0.0
              ? Visibility(
                  visible: jdc.isTowing.value,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 15, 0, 15),
                    child: customText(
                      text:
                          "$labelTowingDistanceIs ${jdc.distanceKm.value} $labelKm",
                    ),
                  ),
                )
              : Container())
        ],
      ),
    );
  }

  _buildBottomButtons(
      {required keyboardOpen, required JobsDataListController jdc}) {
    return Container(
      height: keyboardOpen ? 80 : 250,
      margin: const EdgeInsets.only(top: 40),
      alignment: Alignment.bottomCenter,
      child: Card(
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: secondaryColor),
                  onPressed: () {
                    if (jdc.isValid()) {
                      closeKeyBoard(Get.context!);
                      showDialogForVerifyPhoneNumber(jdc.mobileController.text);
                      if (jdc.focusFLag.value == 2) {
                        FocusScope.of(Get.context!)
                            .requestFocus(jdc.mobileFocusNode);
                      }
                    }
                  },
                  child: customText(
                      text: labelSubmit, size: 16, color: whiteColor),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: blackColor),
                  onPressed: () {
                    Get.back();
                  },
                  child: customText(
                      text: labelCancel, size: 16, color: whiteColor),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> getAddTicket(
      String customerName,
      phone,
      city,
      state,
      postalCode,
      String name,
      String date,
      String title,
      String des,
      String status,
      String landmark,
      String currAddress,
      bool spareTyre,
      String dropVehicleLandmark,
      String fuelType,
      bool isMechanicName) async {
    try {
      return BaseClient.postNew(
              "CustomerName=$customerName"
                  "&Phone=$phone"
                  "&City=$city"
                  "&State=$state"
                  "&PostalCode=$postalCode"
                  "&ContractID=$name"
                  "&Title=$title"
                  "&Description=$des"
                  "&Latitude=${jobsDataListController.cdLat.toString() != "" ? jobsDataListController.cdLat.toString() : lat.toString()}"
                  "&Longitude=${jobsDataListController.cdLang.toString() != "" ? jobsDataListController.cdLang.toString() : long.toString()}"
                  "&Address=$currAddress"
                  "&VehicleID=$rsaTermID"
                  "&TDAddress=${jobsDataListController.tdAdress}"
                  "&TDLatitude=${jobsDataListController.tdLat}"
                  "&TDLongitude=${jobsDataListController.tdLang}"
                  "&LandMark=$landmark"
                  '&MechanicName=${isMechanicName ? dropVehicleLandmark : ""}'
                  "&DestinationLandMark=${isMechanicName ? "" : dropVehicleLandmark}"
                  "&FuelType=$fuelType"
                  "&Distance=${jobsDataListController.distanceKm.value}"
                  "&isSpareTyre=${spareTyre ? 'Yes' : 'No'}",
              "CreateJob")
          .then((value) {
        if (value != null) {
          printMessage('Token', global.currentToken);
          printMessage('Request Body', jsonDecode(value));
          var responseBody = json.decode(value);
          global.setrId(responseBody["Rid"]);
          callPusher(responseBody["Rid"]);
          return "true";
        }
      });
    } catch (e) {
      printMessage(tag, e);
      return null;
    }
  }

  void callPusher(int id) async {
    printMessage(tag, "Pusher Called");
    PusherNewServices pusherService = PusherNewServices();
    pusherService.firePusher('my-channel', 'new-job-event');
  }

  showDialogForVerifyPhoneNumber(String phone) {
    return showDialog(
      context: Get.context!,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: "$dialogVerifyText $phone $dialogVerifyNumber",
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
              createJobAPICall();
            },
            child: customText(text: labelConfirm, color: secondaryColor),
          ),
          TextButton(
            onPressed: () {
              jobsDataListController.ownership.value = 2;
              jobsDataListController.focusFLag.value = 2;
              jobsDataListController.isName.value = false;
              jobsDataListController.isMobile.value = false;
              printMessage(tag, 2);

              Get.back();
            },
            child: customText(text: labelChange, color: cancelColor),
          ),
        ],
      ),
    );
  }

  createJobAPICall() {
    if (jobsDataListController.isTowing.value) {
      printMessage(tag, "City : ${jobsDataListController.city}");
      printMessage(tag, "State : ${jobsDataListController.state}");
      printMessage(tag, "Postal Code : ${jobsDataListController.postalCode}");

      getAddTicket(
              jobsDataListController.customerNameController.text,
              jobsDataListController.mobileController.text,
              jobsDataListController.city,
              jobsDataListController.state,
              jobsDataListController.postalCode,
              custId,
              DateFormat("dd/MM/yyyy").format(DateTime.now()),
              jobsDataListController.requestFor!,
              "",
              "Open",
              jobsDataListController.landmarkController.text,
              (jobsDataListController.currentAddressController.text.isEmpty)
                  ? jobsDataListController.addressFromLatLong.toString()
                  : jobsDataListController.currentAddressController.text
                      .toString(),
              jobsDataListController.isSpareTyreAvailable.value,
              jobsDataListController.dropLandmarkController.text,
              jobsDataListController.fuelTypeController.text,
              jobsDataListController.dropLandmarkHint == "Mechanic Name"
                  ? true
                  : false)
          .then((onValue) {
        {
          printMessage(tag, "Response : $onValue");

          if (onValue == "true") {
            jobsDataListController.landmarkController.text = "";
            jobsDataListController.getJobList().then((value) {
              if (value != null) {
                showDialog(
                  context: Get.context!,
                  useRootNavigator: false,
                  barrierDismissible: false,
                  builder: (context) => CupertinoAlertDialog(
                    title: customText(
                        text: labelRequestSentSuccessfully,
                        color: Get.isDarkMode ? whiteColor : blackColor),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.back();

                          Get.to(() => JobDetailWithMap(),
                              popGesture: true,
                              arguments: {
                                "jobId": value.omJobsView![0].jobNo.toString()
                              })?.then((_) {
                            Get.offAll(
                                () => MapHomeScreen(currentIndexValue: 1));
                          });
                        },
                        child: customText(text: labelOk, color: secondaryColor),
                      ),
                    ],
                  ),
                );
              } else {
                Get.back();
                const CustomWidgets()
                    .snackBar(Get.context!, errorSomethingWentWorngTryLater);
              }
            });
          } else {
            Get.back();
            const CustomWidgets()
                .snackBar(Get.context!, errorSomethingWentWorngTryLater);
          }
        }
      });
    } else {
      getAddTicket(
              jobsDataListController.customerNameController.text,
              jobsDataListController.mobileController.text,
              jobsDataListController.city,
              jobsDataListController.state,
              jobsDataListController.postalCode,
              custId,
              DateFormat("dd/MM/yyyy").format(DateTime.now()),
              jobsDataListController.requestFor!,
              "",
              "Open",
              jobsDataListController.landmarkController.text,
              (jobsDataListController.currentAddressController.text.isEmpty)
                  ? jobsDataListController.addressFromLatLong.toString()
                  : jobsDataListController.currentAddressController.text,
              jobsDataListController.isSpareTyreAvailable.value,
              jobsDataListController.dropLandmarkController.text,
              jobsDataListController.fuelTypeController.text,
              false)
          .then((onValue) {
        {
          if (onValue == "true") {
            jobsDataListController.getJobList().then((value) {
              printMessage(tag, "inside true request");
              jobsDataListController.landmarkController.text = "";
              showDialog(
                context: Get.context!,
                useRootNavigator: false,
                builder: (context) => CupertinoAlertDialog(
                  title: customText(
                      text: labelRequestSentSuccessfully,
                      color: Get.isDarkMode ? whiteColor : blackColor),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                        Get.back();

                        var result = Get.to(() => JobDetailWithMap(),
                            popGesture: true,
                            arguments: {
                              "jobId": (value != null)
                                  ? value.omJobsView![0].jobNo.toString()
                                  : value!.omJobsView![0].toString()
                            })?.then((value) {
                          Get.offAll(() => MapHomeScreen(currentIndexValue: 1));
                        });

                        debugPrint("$result");
                      },
                      child: customText(text: labelOk, color: secondaryColor),
                    ),
                  ],
                ),
              );
            });
          } else {
            const CustomWidgets().snackBar(Get.context!, backendError);

            printMessage(tag, onValue);
          }
        }
      });
    }
  }
}
