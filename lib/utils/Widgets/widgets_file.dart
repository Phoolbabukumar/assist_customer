import 'package:assist/Controllers/buy_assistance_controller.dart';
import 'package:assist/Controllers/home_screen_controller.dart';
import 'package:assist/Controllers/jobdetail_with_map_controller.dart';
import 'package:assist/Controllers/jobs_datalist_controller.dart';
import 'package:assist/Controllers/my_transactions_controller.dart';
import 'package:assist/Controllers/profile_data_controller.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/ui/account/delete_account.dart';
import 'package:assist/ui/account/editphone_screen.dart';
import 'package:assist/ui/account/login_screen.dart';
import 'package:assist/ui/job_detail_withmap.dart';
import 'package:assist/ui/more_info_screen.dart';
import 'package:assist/ui/vehicle_add.dart';
import 'package:assist/utils/common_functions.dart';
import 'package:assist/utils/custom_shape.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:assist/utils/size_config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_images_path.dart';

/* When Location is not fetched in mapHomeScreen then this screen is called */
Widget buildNoLocation({required HomeScreenController homeScreenController}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
            image: AssetImage(
          markerIcon,
        )),
        const SizedBox(
          height: 15.0,
        ),
        customText(
          text: useYourLocation,
          size: 25,
          textAlign: TextAlign.center,
          color: secondaryColor,
        ),
        const SizedBox(
          height: 40.0,
        ),
        customText(
            text: automaticallyTrackedLocationText,
            textAlign: TextAlign.center,
            color: secondaryColor,
            size: 15),
        const SizedBox(
          height: 15.0,
        ),
        customText(
          text: useLocationInBackground,
          size: 15,
          textAlign: TextAlign.center,
          color: secondaryColor,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Image(
            image: AssetImage(mapImage),
            height: Get.height * 0.3,
            width: Get.height * 0.3),
        const SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: secondaryColor),
          // textColor: Colors.white,
          onPressed: () async {
            global.checkGPSAndLocationPermission().then((permitted) {
              global.setPermission(permitted);

              homeScreenController.permissionsEnabled.value = permitted;

              if (permitted) {
                homeScreenController.getCurrentLocation();
              } else {
                global
                    .checkLocationPermissionEnabled()
                    .then((locationPermissionEnabled) {
                  if (locationPermissionEnabled) {
                    global.checkGPSEnabled().then((gpsEnabled) {
                      if (gpsEnabled) {
                        global
                            .checkGPSAndLocationPermission()
                            .then((permitted) {
                          global.setPermission(permitted);

                          homeScreenController.permissionsEnabled.value =
                              permitted;
                          homeScreenController.getCurrentLocation();
                        });
                      } else {
                        homeScreenController.permissionsEnabled.value = false;
                        global.openLocationSettings();
                      }
                    });
                  } else {
                    global.openAppSettingsOn();
                  }
                });
              }
            });
          },
          child: customText(
              text: turnOnGpsLocationText, size: 16, color: whiteColor),
        )
      ],
    ),
  );
}

/*When office status is Off then this screen is called */
Widget buildOfficeOff() {
  return SizedBox(
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
              textAlign: TextAlign.center,
              color: secondaryColor),
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
            child: customText(text: labelCallNow, size: 16, color: whiteColor),
          ),
        ),
      ],
    ),
  );
}

/*When user press back button and try to out from the app this confirm dialog will be shown */
showDialogToAlertOnbackPressed() {
  return showDialog(
    context: Get.context!,
    useSafeArea: false,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (context) => PopScope(
      onPopInvokedWithResult: (didPop, result) async => false,
      child: CupertinoAlertDialog(
        title: customText(text: dontHaveAccessOfAppPleaseContactText),
        actions: [
          TextButton(
            onPressed: () {
              makePhoneCall(global.phoneNoRetailer);
            },
            child: customText(text: labelCall, color: secondaryColor),
          ),
          TextButton(
            onPressed: () {
              global.logoutStorage();
              Get.offAll(() => const LoginScreen());
            },
            child: customText(text: labelOk, color: secondaryColor),
          ),
        ],
      ),
    ),
  );
}

commonLoginDesign(BuildContext context, Widget widget) {
  return Container(
    height: Get.height,
    color: Colors.white,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: Get.height * 0.18,
                width: Get.width * 0.4,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(120))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        appLogo,
                        height: Get.height * 0.15,
                        width: Get.width * 0.35,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          widget
        ],
      ),
    ),
  );
}

/*This is a custom widget for transaction history list */
Widget buildListBlock(
    {required MyTransactionsController myTransactionsController}) {
  return ListView.builder(
      itemCount: myTransactionsController.transactionsList.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final transaction = myTransactionsController.transactionsList[index];

        // Parse and format the transaction date
        final DateTime transactionDate =
            DateTime.parse(transaction["TransactionDateTime"]);
        final String formattedDate = DateFormat('dd/MM/yyyy')
            .format(transactionDate); // Change the format as needed
        return Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const CustomWidgets().infoTilesOffWhite3(
                          labelMembershipNo,
                          myTransactionsController.transactionsList[index]
                                      ["MembershipNo"]
                                  ?.toString() ??
                              "",
                          0,
                          false),
                      const CustomWidgets().infoTilesOffWhite3(
                          labelInvNumber,
                          myTransactionsController.transactionsList[index]
                                      ["InvoiceNumber"]
                                  ?.toString() ??
                              "",
                          1,
                          false),
                      const CustomWidgets().infoTilesOffWhite3(
                          labelTxnId,
                          myTransactionsController.transactionsList[index]
                                      ["TransactionID"]
                                  ?.toString() ??
                              "",
                          0,
                          false),
                      const CustomWidgets().infoTilesOffWhite3(
                          labelDate, formattedDate, 1, false),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey,
                  width: 0.2,
                  height: 70.0,
                  margin: const EdgeInsets.only(left: 4, right: 0),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        customText(
                            text: "\$",
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                            size: 20),
                        customText(
                            text: myTransactionsController
                                    .transactionsList[index]["TotalAmount"]
                                    ?.toString() ??
                                "0.0",
                            size: 20,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    Container(
                      color: Colors.red,
                      width: 40.0,
                      height: 1.0,
                      margin: const EdgeInsets.only(top: 2, bottom: 2),
                    ),
                    getStatusFotTransaction(myTransactionsController
                            .transactionsList[index]["TransactionStatus"] ??
                        ""),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        );
      });
}

/* this method is used for find the status of transaction */
getStatusFotTransaction(String transactionStatus) {
  switch (transactionStatus) {
    case "Success":
      {
        return const CustomWidgets()
            .transactionStatus(greenColor, customText(text: labelSuccess));
      }
    case "Fail":
      {
        return const CustomWidgets()
            .transactionStatus(redColor, customText(text: labelFail));
      }
    default:
      {
        return customText(text: "");
      }
  }
}

/* In Job booking list this listView widgets will use to show the list containers that show the actual value*/
Widget buildListDataSearchBlock(
    {required JobsDataListController jobsDataListController}) {
  return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: jobsDataListController.searchList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Get.to(() => JobDetailWithMap(), popGesture: true, arguments: {
                "jobId":
                    jobsDataListController.searchList[index].jobNo.toString(),
              });
            },
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Container(
                width: Get.width * 0.9,
                height: Get.height * 0.15,
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        // height: Get.height*0.15,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getStatusForJobList(jobsDataListController
                                    .searchList[index].title ??
                                ''),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                width: Get.width,
                                alignment: Alignment.center,
                                child: customText(
                                    text: jobsDataListController
                                            .searchList[index].title ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: secondaryColor,
                                    size: 15))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: customText(
                                text:
                                    "${jobsDataListController.searchList[index].status}",
                                color: getStatusForText(jobsDataListController
                                        .searchList[index].status ??
                                    ''),
                                size: 20),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            width: Get.width,
                            child: customText(
                              text:
                                  "Job No. : ${jobsDataListController.searchList[index].jobNo ?? ''}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            width: Get.width,
                            child: customText(
                              text:
                                  "Date : ${jobsDataListController.searchList[index].serviceRequestDate ?? ''}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            width: Get.width,
                            child: customText(
                              text:
                                  "Retailer : ${jobsDataListController.searchList[index].retailerName}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 5,
                      height: Get.height,
                      decoration: BoxDecoration(
                        color: getStatusForText(
                            jobsDataListController.searchList[index].status ??
                                ''),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

/* this widget can help to show the job status in job Booking list */
Widget getStatusForJobList(String warrantyStatus) {
  switch (warrantyStatus) {
    case "JUMPSTARTS":
      {
        return getImageDataForTransaction(jumpstartIcon);
      }
    case "BATTERY REPLACEMENT":
      {
        return getImageDataForTransaction(appBatteryReplace);
      }
    case "TOWING":
      {
        return getImageDataForTransaction(appTowing);
      }
    case "FLAT TYRE":
      {
        return getImageDataForTransaction(appTyreChange);
      }
    case "OUT OF FUEL RESCUE":
      {
        return getImageDataForTransaction(appOutOfFuel);
      }
    case "LOCKOUTS AND KEY RETRIEVALS":
      {
        return getImageDataForTransaction(appKeys);
      }
    case "CAR HIRE":
      {
        return getImageDataForTransaction(appCar);
      }
    case "AMBULANCE":
      {
        return getImageDataForTransaction(appHospital);
      }
    case "ACCOMODATION":
      {
        return getImageDataForTransaction(appAccommodations);
      }
  }
  return Container();
}

Widget getImageDataForTransaction(String image) {
  return SizedBox(
      height: Get.height * 0.08,
      width: Get.width * 0.2,
      child: SvgPicture.asset(
        image,
        colorFilter: ColorFilter.mode(secondaryColor, BlendMode.srcIn),
        // color: secondaryColor,
      ));
}

/* This method helps to change the text color according to the status of job in job booking list screen */
Color? getStatusForText(String status) {
  switch (status) {
    case "Approved":
      return const Color(0xffF4A460);
    case "New":
      return const Color(0xffff0040);

    case "Pending Confirmation":
      return const Color(0xff4682B4);
    case "Awaiting Acceptance":
      return const Color(0xffD8BFD8);

    case "In Progress":
      return const Color(0xff9ACD32);

    case "Completed":
      return const Color(0xffDA70D6);

    case "Cancelled":
      return Colors.grey;

    default:
      return const Color(0xFF283e4a);
  }
}

/* This Widget is used to show the list of bookings that is not searched by the user */
Widget buildListDataBlock(
    {required JobsDataListController jobsDataListController}) {
  return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: jobsDataListController.responseList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Get.to(() => JobDetailWithMap(), popGesture: true, arguments: {
                "jobId":
                    jobsDataListController.responseList[index].jobNo.toString(),
              });
            },
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Container(
                width: Get.width * 0.9,
                height: Get.height * 0.15,
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        // height: Get.height*0.15,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getStatusForJobList(jobsDataListController
                                    .responseList[index].title ??
                                ''),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                width: Get.width,
                                alignment: Alignment.center,
                                child: customText(
                                    text: jobsDataListController
                                            .responseList[index].title ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    color: secondaryColor,
                                    size: 15))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: customText(
                                text:
                                    "${jobsDataListController.responseList[index].status}",
                                color: getStatusForText(jobsDataListController
                                        .responseList[index].status ??
                                    ''),
                                size: 20),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            width: Get.width,
                            child: customText(
                              text:
                                  "Job No. : ${jobsDataListController.responseList[index].jobNo ?? ''}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            width: Get.width,
                            child: customText(
                              text:
                                  "Date : ${jobsDataListController.responseList[index].serviceRequestDate ?? ''}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            width: Get.width,
                            child: customText(
                              text:
                                  "Retailer : ${jobsDataListController.responseList[index].retailerName}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 5,
                      height: Get.height,
                      decoration: BoxDecoration(
                        color: getStatusForText(
                            jobsDataListController.responseList[index].status ??
                                ''),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

/*This widget show the body of plan details page */
Widget bodyOfPlanDetailsPage(
    {required BuyAssistanceController buyAssistanceController,
    required String userid,
    required int loginway}) {
  return SizedBox(
    height: Get.height,
    child: Column(
      children: [
        Container(
          height: Get.height * 0.19,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: buyAssistanceController.vehicleOptions
                .length, // Assuming you have a list of vehicle types
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Obx(
                    () => InkWell(
                      onTap: () {
                        if (buyAssistanceController.cardTap.value != index) {
                          buyAssistanceController
                              .vehicleType.value = buyAssistanceController
                                  .vehicleOptions[index]
                              ["type"]; // Assign vehicle type based on index
                          buyAssistanceController.getPlanData();
                        }
                        buyAssistanceController.cardTap.value = index;
                      },
                      child: const CustomWidgets().choosePlanCardDesign(
                        Get.context!,
                        buyAssistanceController.vehicleOptions[index]
                            ["label"], // Label for the card
                        buyAssistanceController.vehicleOptions[index]
                            ["icon"], // Icon for the card
                        buyAssistanceController.cardTap.value == index
                            ? global.themeType == 1
                                ? MediaQuery.of(Get.context!)
                                            .platformBrightness ==
                                        Brightness.dark
                                    ? primaryColor
                                    : whiteColor
                                : buyAssistanceController
                                        .themecontroller.isDarkMode.value
                                    ? primaryColor
                                    : whiteColor
                            : buyAssistanceController
                                    .themecontroller.isDarkMode.value
                                ? blacklight
                                : gray400,
                      ),
                    ),
                  ),
                  if (index < buyAssistanceController.vehicleOptions.length - 1)
                    const SizedBox(width: 10),
                ],
              );
            },
          ),
        ),
        Obx(() {
          if (buyAssistanceController.isLoading.value) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey,
                child: Container(
                  width: Get.width * 0.7,
                  height: Get.height * 0.5,
                  margin: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[200],
                  ),
                ),
              ),
            );
          } else if (buyAssistanceController.hasError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customText(text: unknownErrorOccurred),
                  IconButton(
                    onPressed: () {
                      buyAssistanceController.getPlanData();
                    },
                    icon: const Icon(CupertinoIcons.refresh),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  CarouselSlider.builder(
                    itemCount: buyAssistanceController.getServicesData11.length,
                    itemBuilder: (BuildContext context, int itemIndex, int i) =>
                        Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: SizedBox(
                        height: Get.height * 0.7,
                        width: Get.width * 0.7,
                        child: Container(
                          height: Get.height * 0.5,
                          width: Get.width * 0.5,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  customText(
                                      text:
                                          "${buyAssistanceController.getServicesData11[itemIndex].planName}",
                                      fontWeight: FontWeight.w800),
                                  Container(
                                    margin: const EdgeInsets.only(top: 30),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipRect(
                                              child: Container(
                                                height: 10,
                                                width: 10,
                                                decoration: const BoxDecoration(
                                                    color: Colors.greenAccent,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                child: customText(
                                                  text:
                                                      "Price:  \$${buyAssistanceController.getServicesData11[itemIndex].amount}",
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipRect(
                                              child: Container(
                                                height: 10,
                                                width: 10,
                                                decoration: const BoxDecoration(
                                                    color: Colors.greenAccent,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                child: customText(
                                                  text:
                                                      "Validity ${buyAssistanceController.getServicesData11[itemIndex].term}",
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipRect(
                                              child: Container(
                                                height: 10,
                                                width: 10,
                                                decoration: const BoxDecoration(
                                                    color: Colors.greenAccent,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                child: customText(
                                                  text: activeIn48Hourse,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      margin: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: opacitySecondary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        child: customText(
                                            text: labelSelect,
                                            color: whiteColor,
                                            size: 16),
                                        onPressed: () async {
                                          Get.to(() => VehicleAdd(),
                                              popGesture: true,
                                              arguments: {
                                                "screenType": "VehicleAdd",
                                                "planID":
                                                    buyAssistanceController
                                                        .getServicesData11[
                                                            itemIndex]
                                                        .planId,
                                                "vehicleType":
                                                    buyAssistanceController
                                                        .vehicleType.value,
                                                "planName":
                                                    buyAssistanceController
                                                        .getServicesData11[
                                                            itemIndex]
                                                        .planName,
                                                "otherVehicleAdd":
                                                    buyAssistanceController
                                                        .getServicesData11[
                                                            itemIndex]
                                                        .includeOtherVehicle,
                                                "amount":
                                                    buyAssistanceController
                                                        .getServicesData11[
                                                            itemIndex]
                                                        .amount,
                                                "userId": userid,
                                                "loginWay": loginway,
                                              });
                                        },
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                          () => MoreInfoScreen(
                                                vehicleType:
                                                    buyAssistanceController
                                                        .vehicleType.value,
                                                moreItem:
                                                    buyAssistanceController
                                                            .getServicesData11[
                                                        itemIndex],
                                                bac: buyAssistanceController,
                                              ),
                                          popGesture: true);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        customText(
                                            text: moreInfo, color: Colors.grey),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.grey,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    options: CarouselOptions(
                      initialPage: 0,
                      viewportFraction: 0.7,
                      height: Get.height * 0.45,
                      autoPlay: false,
                      reverse: false,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      autoPlayCurve: Curves.linear,
                      autoPlayInterval: const Duration(seconds: 2),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      pauseAutoPlayOnTouch: false,
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                ],
              ),
            );
          }
        }),
      ],
    ),
  );
}

/* Job Booking Details Map screen widget */
showRatingBox(
    {responsebody,
    required bool isFeedbackBox,
    required String fBUrl,
    required JobDetailsWithMapController jobdetailMapController}) {
  return showDialog(
    context: Get.context!,
    builder: (_) {
      printMessage(tag, "sdfouhsfdhiodsifo====$fBUrl");
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                      child: Column(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              customText(
                                  text: dialogRateTechnician,
                                  color: secondaryColor,
                                  size: 18),
                              const SizedBox(
                                height: 10.0,
                              ),
                              customText(
                                  text: responsebody.title,
                                  color: secondaryColor,
                                  size: 15),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                          jobdetailMapController.rating = 1;
                                          jobdetailMapController.firstStar =
                                              true;
                                          jobdetailMapController.secondStar =
                                              false;
                                          jobdetailMapController.thirdStar =
                                              false;
                                          jobdetailMapController.fourthStar =
                                              false;
                                          jobdetailMapController.fifthStar =
                                              false;
                                        },
                                        child: const CustomWidgets().starIcon(
                                            context,
                                            jobdetailMapController.firstStar,
                                            30)),
                                    Container(
                                      width: 10.0,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          jobdetailMapController.rating = 2;

                                          jobdetailMapController.firstStar =
                                              true;
                                          jobdetailMapController.secondStar =
                                              true;
                                          jobdetailMapController.thirdStar =
                                              false;
                                          jobdetailMapController.fourthStar =
                                              false;
                                          jobdetailMapController.fifthStar =
                                              false;
                                        },
                                        child: const CustomWidgets().starIcon(
                                            context,
                                            jobdetailMapController.secondStar,
                                            30)),
                                    Container(
                                      width: 10.0,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          jobdetailMapController.rating = 3;

                                          jobdetailMapController.firstStar =
                                              true;
                                          jobdetailMapController.secondStar =
                                              true;
                                          jobdetailMapController.thirdStar =
                                              true;
                                          jobdetailMapController.fourthStar =
                                              false;
                                          jobdetailMapController.fifthStar =
                                              false;
                                        },
                                        child: const CustomWidgets().starIcon(
                                            context,
                                            jobdetailMapController.thirdStar,
                                            30)),
                                    Container(
                                      width: 10.0,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          jobdetailMapController.rating = 4;

                                          jobdetailMapController.firstStar =
                                              true;
                                          jobdetailMapController.secondStar =
                                              true;
                                          jobdetailMapController.thirdStar =
                                              true;
                                          jobdetailMapController.fourthStar =
                                              true;
                                          jobdetailMapController.fifthStar =
                                              false;
                                        },
                                        child: const CustomWidgets().starIcon(
                                            context,
                                            jobdetailMapController.fourthStar,
                                            30)),
                                    Container(
                                      width: 10.0,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          printMessage(tag, "5 Star");
                                          jobdetailMapController.rating = 5;
                                          jobdetailMapController.firstStar =
                                              true;
                                          jobdetailMapController.secondStar =
                                              true;
                                          jobdetailMapController.thirdStar =
                                              true;
                                          jobdetailMapController.fourthStar =
                                              true;
                                          jobdetailMapController.fifthStar =
                                              true;
                                        },
                                        child: const CustomWidgets().starIcon(
                                            context,
                                            jobdetailMapController.fifthStar,
                                            30)),
                                  ]),
                              Container(
                                height: 20.0,
                              ),
                              isFeedbackBox
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            //
                                          },
                                          child: customText(
                                              text: labelFeedback,
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w800,
                                              size: 18),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Text.rich(TextSpan(children: [
                                          TextSpan(
                                              text: labelJobCompleteDialogText,
                                              //"24/7 Roadside Job complete, for one month complimentary roadside assistance, \nplease click on this link: ",
                                              style: TextStyle(
                                                  color: secondaryColor,
                                                  fontSize: 15.0)),
                                          TextSpan(
                                              text: labelFeedbackText,
                                              //"FeedBack ,",
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () =>
                                                    _launchURLBrowser(fBUrl),
                                              style: TextStyle(
                                                  color: blueColor,
                                                  fontSize: 15.0)),
                                          TextSpan(
                                              text: labelFeedbackText2,
                                              //" and leave a positive review. Once done \nemail: admin@247roadservices.com.au and we will update your membership.\nIf your experience was not what you expected, please email us directly,\nwe appreciate your feedback.",
                                              style: TextStyle(
                                                  color: secondaryColor,
                                                  fontSize: 15.0)),
                                        ]))
                                      ],
                                    )
                                  : Container(),
                              Container(
                                height: 10.0,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: secondaryColor),
                                // color:  Constants.secondaryColor,
                                onPressed: () {
                                  if (jobdetailMapController.rating > 0) {
                                    debugPrint("this loader is open");

                                    jobdetailMapController.ratingController
                                        .sendRating(
                                            jobdetailMapController.rating,
                                            responsebody.jobNo)
                                        .then((value) {
                                      const CustomWidgets().snackBar(
                                          Get.context!,
                                          value['StatusMessage'].toString());

                                      jobdetailMapController
                                          .callApi(false)
                                          .then((value) {
                                        debugPrint("this loader is closed");
                                      });
                                    });
                                  } else {
                                    const CustomWidgets().snackBar(
                                        context, dialogRateServiceprovider);
                                  }
                                },
                                child: customText(
                                  text: labelOk,
                                  color: whiteColor,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: customText(
                                    text: labelNextTime,
                                    color: secondaryColor,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: -60,
                      child: Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(55)),
                            color: secondaryColor),
                        child: CircleAvatar(
                          backgroundColor: Get.isDarkMode ? null : Colors.white,
                          radius: 55,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset(
                              appLogo,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : secondaryColor,
                            ),
                          ),
                        ),
                      )),
                ],
              )));
    },
  );
}

/* This method is used for launching the feedBack Url on Browser */
void _launchURLBrowser(String feedbackURL) async {
  printMessage(tag, feedbackURL);
  var url = Uri.parse(feedbackURL.toString());
  printMessage(tag, url);
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

/* ------------------------------------------   PROFILE SCREEN WIDGETS  ----------------------------------------------------------------------- */

/* This is the build widget and called main widget of the ui screen */
Widget buildDataBlock(ProfileDataController builder, double defaultSize) {
  return Column(
    children: [
      SizedBox(
        height: defaultSize * 24,
        child: Stack(
          children: [
            ClipPath(
              clipper: CustomShape(),
              child: Container(
                height: defaultSize * 15, //150
                color: global.themeType == 1
                    ? MediaQuery.of(Get.context!).platformBrightness ==
                            Brightness.dark
                        ? Colors.black
                        : secondaryColor
                    : builder.themecontroller.isDarkMode.value
                        ? Colors.black
                        : secondaryColor,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                          margin: EdgeInsets.only(bottom: defaultSize),
                          height: defaultSize * 14,
                          width: defaultSize * 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: whiteColor,
                              width: defaultSize * 0.8, //8
                            ),
                          ),
                          child: Obx(
                            () => builder.profileUrl.toString().isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      builder.profileUrl.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.asset(
                                    'assets/images/default.jpg',
                                    fit: BoxFit.cover,
                                  )),
                          )),
                      Positioned(
                        right: 1.0,
                        bottom: 1.0,
                        child: GestureDetector(
                          onTap: () async {
                            getImageDialog(profileDataController: builder);
                          },
                          child: Container(
                            height: 35.0,
                            width: 35.0,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_enhance,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: defaultSize / 2), //5
                ],
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15.0,
                ),
                const CustomWidgets().textEditingField(
                  Get.context!,
                  builder.isFirstName.value,
                  TextInputType.text,
                  builder.firstNameController.value,
                  labelFirstName,
                  Icons.person,
                  [
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-z ]")),
                  ],
                ),
                const CustomWidgets().textEditingField(
                  Get.context!,
                  builder.isLastName.value,
                  TextInputType.text,
                  builder.lastNameController.value,
                  labelLastName,
                  Icons.person,
                  [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-z ]"))],
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLength: 10,
                      readOnly: true,
                      keyboardType: TextInputType.phone,
                      controller: builder.mobileController.value,
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                austrailiaFlagImage,
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 5),
                              customText(
                                text: labelAu,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                width: 1,
                                height: 20,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            if (builder
                                .mobileController.value.text.isNotEmpty) {
                              Get.to(
                                      () => EditPhoneScreen(
                                            oldPhone: builder
                                                .mobileController.value.text,
                                            profileDataController: builder,
                                          ),
                                      popGesture: true)
                                  ?.then(
                                (value) async => await builder.getProfileList(),
                              );
                            } else {
                              showDialogForMobileNumberNotAvailable(
                                  Get.context!);
                            }
                          },
                          child: Icon(
                            Icons.edit,
                            color: secondaryColor,
                          ),
                        ),
                        labelText: labelMobile,
                        counterText: "",
                        contentPadding: const EdgeInsets.only(left: 10),
                        //labelStyle: TextStyle(color: gray800),
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
                    )),
                const CustomWidgets().textEditingField(
                    Get.context!,
                    builder.isEmail.value,
                    TextInputType.emailAddress,
                    builder.emailController.value,
                    labelEmailAddress,
                    Icons.email),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                        readOnly: builder.isAddress.value,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          printMessage(tag, "Value : $value");
                          builder.onChanged();

                          builder.isCurrentAddSuggestion.value = true;
                          builder.isAddressChange.value = true;
                        },
                        controller: builder.addressController.value,
                        decoration: const CustomWidgets().inputDecorationBox(
                            Get.context!, labelAddress, Icons.home))),
                Visibility(
                  visible: builder.isCurrentAddSuggestion.value,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: builder.placeList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: customText(
                            text: builder.placeList[index]["description"]),
                        onTap: () {
                          builder.addressController.value.text =
                              builder.placeList[index]["description"];
                          FocusScope.of(context).unfocus();
                          builder.isCurrentAddSuggestion.value = false;
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(text: labelHowWouldLikeToContact, size: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: builder.sms.value,
                                  activeColor: secondaryColor,
                                  onChanged: (value) {
                                    if (builder.isFirstName.value == false) {
                                      builder.sms.value = value!;
                                    }
                                  },
                                ),
                              ),
                              customText(
                                  text: labelSms,
                                  size: 18,
                                  fontWeight: FontWeight.w500)
                            ],
                          ),
                          Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: builder.email.value,
                                  activeColor: secondaryColor,
                                  onChanged: (value) {
                                    if (builder.isFirstName.value == false) {
                                      builder.email.value = value!;
                                    }
                                  },
                                ),
                              ),
                              customText(
                                  text: labelEmail,
                                  size: 18,
                                  fontWeight: FontWeight.w500)
                            ],
                          ),
                          Row(
                            children: [
                              Obx(() => Checkbox(
                                    value: builder.post.value,
                                    activeColor: secondaryColor,
                                    onChanged: (value) {
                                      if (builder.isFirstName.value == false) {
                                        builder.post.value = value!;
                                      }
                                    },
                                  )),
                              customText(
                                  text: labelPost,
                                  size: 18,
                                  fontWeight: FontWeight.w500)
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Obx(() {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: customText(
                          text: (builder.isFirstName.value)
                              ? labelEdit
                              : labelUpdate,
                          color: whiteColor,
                          size: 18,
                        ),
                        onPressed: () {
                          if (builder.isFirstName.value) {
                            builder.toggleProfileEditButton();
                          } else {
                            if (builder.isValid()) {
                              builder
                                  .getLatLangFromCurrentAddress(
                                      builder.addressController.value.text)
                                  .whenComplete(() {
                                builder
                                    .getUpdateProfile(
                                        builder.userId,
                                        builder.chooseAddress.value,
                                        builder.chooseAddressState.value,
                                        builder.chooseAddressCity.value,
                                        builder.chooseAddressPinCode.value,
                                        builder.checkData)
                                    .then((value) {
                                  printMessage(tag, "Response value : $value");
                                  builder.toggleProfileEditButton();
                                  builder.getProfileList();

                                  const CustomWidgets().snackBar(
                                      Get.context!, labelProfileUpdated);
                                });
                              });
                            }
                          }
                        },
                      );
                    }),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Get.to(
                          () => DeleteAccount(
                                profileDataController: builder,
                              ),
                          popGesture: true);
                    },
                    child: Center(
                      child: customText(
                        text: labelDeleteAccount,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                )
              ],
            );
          }),
        ),
      )
    ],
  );
}

/* This dialog shown when the user parmanently deny any of the permissions */
showPermissionDeniedDialog({required String permission}) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: customText(text: labelPermissionRequired),
      content: customText(text: '$permission $permissionAreRequiredText'),
      actions: <Widget>[
        TextButton(
          child: customText(text: openSettingsText),
          onPressed: () {
            Get.back();
            openAppSettings();
          },
        ),
        TextButton(
          child: customText(text: labelCancel),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ),
  );
}

/* when user want to change the image then this dialog is occured an have camera and Gallery things */
void getImageDialog({required ProfileDataController profileDataController}) {
  showDialog(
    context: Get.context!,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: customText(text: labelCamera),
            leading: const Icon(
              Icons.camera,
            ),
            onTap: () {
              // getCaptureImage();
              profileDataController
                  .handlePermissionAndPickImage(ImageSource.camera);
              Get.back();
            },
          ),
          ListTile(
            title: customText(text: labelGallery),
            leading: const Icon(
              Icons.photo,
            ),
            onTap: () {
              printMessage(tag, "pick up from gallery");

              // getImage();
              profileDataController
                  .handlePermissionAndPickImage(ImageSource.gallery);
              Get.back();
            },
          )
        ],
      ),
      title: customText(text: labelPickOption, color: secondaryColor),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: customText(text: labelCancel, color: secondaryColor),
        ),
      ],
    ),
  );
}

/* In profile update section when user fill the existing number when it update then this error dialog is shown */
showDialogForMobileNumberNotAvailable(context) {
  return showDialog(
    context: context,
    useRootNavigator: false,
    builder: (context) => CupertinoAlertDialog(
      title: customText(
        text: labelPhoneNumberIsnotAvailable,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: customText(text: labelOk, color: secondaryColor),
        ),
      ],
    ),
  );
}

/* -----------------------------------------Widget for Customer Services Details ----------------------------------------------- */
showDialogForOutOfFuel() {
  return showDialog(
    context: Get.context!,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (context) => CupertinoAlertDialog(
      title: customText(
        text: labelBannerMemberExpense,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: customText(text: labelOk, color: secondaryColor),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: customText(text: labelCancel, color: cancelColor),
        ),
      ],
    ),
  );
}



/*This widget is in under development and it used as dropdown fields in make and model selection work */
/*Widget buildDropdown({required String label, required List<String> items, required String selectedItem, required Function(String?) onChanged, required controller }) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: DropdownSearch<String>(
      selectedItem: selectedItem,
      popupProps: PopupProps.modalBottomSheet(
        searchDelay: const Duration(milliseconds: 0),
        showSearchBox: true,
        showSelectedItems: true,
        modalBottomSheetProps: ModalBottomSheetProps(
            elevation: 30,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            backgroundColor: controller.themecontroller.isDarkMode.value
                ? gray800
                : Colors.white),
        searchFieldProps: TextFieldProps(
          decoration: const CustomWidgets().inputDecorationBox(
              Get.context!, labelSearchMakerInfo, CupertinoIcons.car_detailed),
        ),
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: TextStyle(
            color:
                controller.carChooseMake == "Select Make" ? Colors.grey : null),
        dropdownSearchDecoration: const CustomWidgets()
            .dropDownSearchDecorationBox(
                Get.context!, labelMakerInfo, CupertinoIcons.car_detailed),
      ),
      items: items,
      onChanged: onChanged
    ),
  );
}*/
