import 'package:assist/Controllers/my_member_ships_controller.dart';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/utils/size_config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_images_path.dart';
import '../utils/common_functions.dart';
import '../utils/custom_widgets.dart';
import 'plan_details.dart';
import 'renew_plan.dart';

class MyMemberShips extends StatelessWidget {
  MyMemberShips({super.key});

  final myMemberShipsController = Get.put(MyMemberShipsController());

  @override
  Widget build(BuildContext context) {
    return networkWidget(
        SafeArea(
            child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () => myMemberShipsController
                .memberShipList(global.customerPhoneNumber.toString()),
            child: SingleChildScrollView(
              child: SizedBox(
                height: Get.height * 0.9,
                child: Center(
                    child: Obx(
                  () => (myMemberShipsController.loading.value)
                      ? SizedBox(
                          width: Get.width,
                          height: Get.height * 0.6,
                          child: Center(
                            child: SizedBox(
                                width: Get.width * 0.8,
                                height: Get.height * 0.5,
                                child: Center(
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey,
                                      direction: ShimmerDirection.ltr,
                                      child: Container(
                                        // height: 30,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 5.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Container(
                                          // width: 50,height: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8))),
                                        ),
                                      )),
                                )),
                          ),
                        )
                      : _buildListDataBlock(),
                )),
              ),
            ),
          ),
        )),
        context);
  }

/* card widget show in the UI screen */
  _buildListDataBlock() {
    return CarouselSlider.builder(
      itemCount: myMemberShipsController.membershipList.length,
      itemBuilder: (BuildContext context, int index, int i) => GestureDetector(
        onTap: () {
          Get.to(() => PlanDetails(), popGesture: true, arguments: {
            "screenType": "PlanDetails",
            "customerId": myMemberShipsController
                .membershipList[index].contractID
                .toString(),
          });
        },
        child: Card(
          elevation: 10,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: SizedBox(
            width: Get.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getCar(myMemberShipsController
                              .membershipList[index].vehicleType ??
                          ''),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.time_solid,
                                size: 18,
                                color: getStatus(myMemberShipsController
                                    .membershipList[index].status
                                    .toString()),
                              ),
                              const SizedBox(width: 2),
                              customText(
                                text: capitalize(myMemberShipsController
                                        .membershipList[index].status ??
                                    ""),
                                size: 18,
                                fontWeight: FontWeight.bold,
                                color: getStatus(myMemberShipsController
                                        .membershipList[index].status ??
                                    ''),
                              ),
                            ],
                          ),
                          Container(
                            width: Get.width * 0.4,
                            alignment: Alignment.center,
                            child: customText(
                              text: myMemberShipsController
                                      .membershipList[index].planName ??
                                  '',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ]),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                (myMemberShipsController.membershipList[index].vehicleDetails ??
                                [])
                            .isNotEmpty ||
                        myMemberShipsController
                                .membershipList[index].vehicleDetailSingle !=
                            null
                    ? (myMemberShipsController
                                    .membershipList[index].vehicleDetails ??
                                [])
                            .isNotEmpty
                        ? Center(
                            child: customText(
                                text: getVehicleDetails(myMemberShipsController
                                        .membershipList[index].vehicleDetails ??
                                    []),
                                size: 12,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w600),
                          )
                        : Center(
                            child: customText(
                                text: myMemberShipsController
                                        .membershipList[index]
                                        .vehicleDetailSingle ??
                                    '',
                                size: 12,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w600),
                          )
                    : const SizedBox.shrink(),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      customText(
                        text: "$membershipNo$labelColunm",
                        size: 12,
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                        flex: 1,
                        child: customText(
                          text:
                              " ${myMemberShipsController.membershipList[index].membershipNo ?? ''}",
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      customText(
                        text: "$expireOn$labelColunm",
                        size: 12,
                        textAlign: TextAlign.right,
                      ),
                      Expanded(
                        flex: 1,
                        child: customText(
                          text:
                              " ${myMemberShipsController.membershipList[index].expiryDate ?? ''}",
                          size: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      customText(
                        text: "$remCollout$labelColunm",
                        size: 12,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                      Expanded(
                        flex: 1,
                        child: customText(
                          text:
                              " ${myMemberShipsController.membershipList[index].remCalloutsText}",
                          size: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                (myMemberShipsController.membershipList[index].isRenewed !=
                            "No") &&
                        myMemberShipsController
                                .membershipList[index].newStartDate !=
                            null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            customText(
                              text: "$nextStartDate$labelColunm",
                              size: 12,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                            Expanded(
                              flex: 1,
                              child: customText(
                                text:
                                    " ${myMemberShipsController.membershipList[index].newStartDate}",
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: Get.height * 0.1),
                SizedBox(
                  width: Get.width / 2,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: myMemberShipsController
                                    .membershipList[index].isRenewed !=
                                "Yes"
                            ? secondaryColor
                            : cancelColor,
                      ),
                      child: customText(
                          text: myMemberShipsController
                                      .membershipList[index].isRenewed !=
                                  "Yes"
                              ? labelRenew
                              : labelRenewed,
                          size: 15,
                          color: whiteColor),
                      onPressed: () {
                        if (myMemberShipsController.membershipList[index].status
                                    ?.toLowerCase() ==
                                "Active".toLowerCase() ||
                            myMemberShipsController.membershipList[index].status
                                    ?.toLowerCase() ==
                                "Expired".toLowerCase()) {
                          if (myMemberShipsController
                                  .membershipList[index].isRenewed !=
                              "Yes") {
                            if (myMemberShipsController
                                    .membershipList[index].availableForRenewal
                                    ?.toLowerCase() ==
                                'yes') {
                              if (myMemberShipsController
                                      .membershipList[index].isRenewed ==
                                  "No") {
                                Get.to(
                                    () => RenewPlan(
                                          contractId: myMemberShipsController
                                                  .membershipList[index]
                                                  .contractID ??
                                              0,
                                          customerId: myMemberShipsController
                                                  .membershipList[index]
                                                  .customerID ??
                                              0,
                                        ),
                                    popGesture: true,
                                    arguments: {
                                      "term": myMemberShipsController
                                              .membershipList[index].term ??
                                          '',
                                      "startDate": myMemberShipsController
                                              .membershipList[index]
                                              .contractDate ??
                                          "",
                                      "endDate": myMemberShipsController
                                              .membershipList[index]
                                              .expiryDate ??
                                          '',
                                      "lastPlanName": myMemberShipsController
                                              .membershipList[index].planName ??
                                          '',
                                      "retailerId": myMemberShipsController
                                          .membershipList[index].retailerID
                                          .toString(),
                                      "membershipNo": myMemberShipsController
                                              .membershipList[index]
                                              .membershipNo ??
                                          '',
                                      "vehicleType": myMemberShipsController
                                          .membershipList[index].vehicleType
                                          .toString(),
                                      "membershipStatus":
                                          myMemberShipsController
                                              .membershipList[index].status
                                              .toString(),
                                      "otherplantype": myMemberShipsController
                                              .membershipList[index]
                                              .otherVehicleType ??
                                          '',
                                      "planid": myMemberShipsController
                                              .membershipList[index].planID ??
                                          0,
                                    });
                              } else {
                                const CustomWidgets()
                                    .snackBar(context, labelPlanAlreadyRenewed);
                              }
                            } else {
                              showDialogToOtherRetailer();
                            }
                          } else {
                            const CustomWidgets()
                                .snackBar(context, sbMembershipRenewed);
                          }
                        } else {
                          var masg = "";
                          if (myMemberShipsController
                                  .membershipList[index].status
                                  .toString()
                                  .toLowerCase() ==
                              "InActive".toLowerCase()) {
                            masg = labelPeriodMembershipIsNotStarted;
                          } else {
                            masg = labelMembershipNotActiveText;
                          }
                          debugPrint(
                              'PlanStatus${myMemberShipsController.membershipList[index].status ?? "".toLowerCase()}');

                          showDialogForInActiveMembership(masg);
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
      options: CarouselOptions(
        initialPage: 0,
        viewportFraction: 0.7,
        height: Get.height / 1.8,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        enableInfiniteScroll: false,
        autoPlayCurve: Curves.bounceIn,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  showDialogToOtherRetailer() {
    return showDialog(
      context: Get.context!,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: labelPleaseContactSupport,
        ),
        actions: [
          TextButton(
            onPressed: () {
              makePhoneCall(global.phoneNoRetailer).then((value) {
                Get.back();
              });
            },
            child: customText(text: labelCall, color: secondaryColor),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelClose, color: cancelColor),
          )
        ],
      ),
    );
  }

  showDialogForInActiveMembership(String type) {
    return showDialog(
      context: Get.context!,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: type,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelClose, color: cancelColor),
          )
        ],
      ),
    );
  }

  String getVehicleDetails(dynamic vehicleList) {
    String data = "";
    for (int i = 0; i < vehicleList.length; i++) {
      if (vehicleList[i] != null) {
        if (i != vehicleList.length - 1) {
          data = "${data + vehicleList[i]}, \n";
        } else {
          data = data + vehicleList[i];
        }
      }
    }
    return data;
  }

  Widget getCar(String carStatus) {
    switch (carStatus) {
      case "Car/Trailer":
        {
          return getImageData(appBuyCarIcon);
        }
      case "Caravan":
        {
          return getImageData(appCaravanIcon);
        }
      case "Motorhome":
        {
          return getImageData(appMotorHomeIcon);
        }
      case "Bike":
        {
          return getImageData(appMotorBikeIcon);
        }
      case "Mobility Scooter":
        {
          return getImageData(appScooterIcon);
        }
    }
    return Container();
  }

  Color? getStatus(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case "expired":
        color = expiredColor;
        break;
      case "inactive":
        color = Colors.yellow;
        break;
      case 'active':
        color = Colors.green;
        break;
      case 'cancelled':
        color = cancelColor;
        break;
      case 'onhold':
        color = onHoldColor;
        break;
      default:
        color = Colors.black;
        break;
    }
    return color;
  }

  Widget getImageData(String image) {
    return Center(
      child: SvgPicture.asset(
        image,
        height: Get.width * 0.2,
        width: Get.width * 0.2,
        colorFilter: ColorFilter.mode(secondaryColor, BlendMode.srcIn),
        alignment: Alignment.center,
      ),
    );
  }
}
