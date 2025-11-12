import 'package:assist/Controllers/service_request_controller.dart';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/ui/vehicle_edit.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../apis/response/vehicle_list_byphone_response.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_images_path.dart';
import '../utils/common_functions.dart';
import 'customer_service_details.dart';

class RoadsideServices2 extends StatelessWidget {
  RoadsideServices2({
    super.key,
  });

  final serviceRequestController = Get.put(ServiceRequestController());

  @override
  Widget build(BuildContext context) {
    return networkWidget(SafeArea(
      child: GetBuilder<ServiceRequestController>(builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          resizeToAvoidBottomInset: false,
          body: controller.termsList.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: serviceRequestController.refreshData,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 15.0,
                    ),
                    children: [
                      Card(
                        elevation: 5.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 15.0),
                              child: customText(
                                  text: labelVehicle,
                                  size: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(
                                  15.0, 0.0, 15.0, 5.0),
                              child: DropdownButton(
                                isExpanded: true,
                                //isDense: true,
                                value: controller.selectTerms,
                                // alignment: AlignmentDirectional.bottomCenter,
                                onChanged: (newValue) {
                                  if (newValue!.toLowerCase().contains("tba")) {
                                    controller.selectTerms = newValue;
                                    String cId = "";
                                    String vId = "";
                                    for (VehicleListModel list
                                        in controller.tERMSList) {
                                      if (newValue ==
                                          "${list.vehicleWithMembership}") {
                                        cId = list.contractID.toString();
                                        vId = list.vehicleID.toString();
                                      }
                                    }
                                    const CustomWidgets()
                                        .showDialogRegoRequest(context, () {
                                      Get.back();

                                      SchedulerBinding.instance
                                          .addPostFrameCallback((_) {
                                        const CustomWidgets()
                                            .widgetLoadingData();
                                      });
                                      controller.myMemberShipsController
                                          .getMembershipDetail(cId)
                                          .then((membershipData) {
                                        controller.myMemberShipsController
                                            .getVehicleDetail(vId)
                                            .then((vehicleData) {
                                          Get.back();
                                          Get.to(
                                              () => VehicleEdit(
                                                    planName: membershipData
                                                            ?.planName ??
                                                        "",
                                                  ),
                                              popGesture: true,
                                              arguments: {
                                                "screenType": "VehicleEdit",
                                                "vehicleListResponse":
                                                    vehicleData,
                                                "membershipNo": membershipData
                                                        ?.membershipNo ??
                                                    '',
                                                "planId": membershipData?.planID
                                                        .toString() ??
                                                    '',
                                              })?.then((value) {
                                            global.customerPhoneNumber != ""
                                                ? controller
                                                    .getVehicleListForRoadsideService2(
                                                        global
                                                            .customerPhoneNumber)
                                                : null;
                                          });
                                        });
                                      });
                                    });
                                  } else {
                                    controller.selectTerms = newValue;
                                    for (VehicleListModel list
                                        in controller.tERMSList) {
                                      if (newValue ==
                                          "${list.vehicleWithMembership}") {
                                        controller.rsAtermsId =
                                            list.vehicleID ?? 0;
                                        controller.customerIdForVehicle =
                                            list.customerID.toString();
                                        controller.isJumpActive.value = false;
                                        controller.isTyreActive.value = false;
                                        controller.isBatteryActive.value =
                                            false;
                                        controller.isLockOutActive.value =
                                            false;
                                        controller.isTowingActive.value = false;
                                        controller.isFuelActive.value = false;
                                        controller.isAmbulanceActive.value =
                                            false;
                                        controller.isAccoActive.value = false;
                                        controller.isCarActive.value = false;
                                        controller.contractId =
                                            list.contractID.toString();

                                        controller
                                            .getActiveRequestsForRoadSide2(
                                                controller.contractId!);
                                      }
                                    }
                                  }
                                },
                                items: controller.termsList.map((location) {
                                  return DropdownMenuItem(
                                    value: location,
                                    child: customText(
                                      text: location.contains(")")
                                          ? "${location.split(")")[0]})"
                                          : location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Card(
                        elevation: 5.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, top: 15.0, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customText(
                                    text: labelMembershipNo,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  customText(
                                    text: controller.memberShipNo ?? '',
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, top: 15.0, bottom: 15, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customText(
                                    text: labelPlanName,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  customText(
                                    text: controller.planName ?? '',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Obx(() {
                        return controller.isTowingActiveOnApp.value
                            ? InkWell(
                                splashColor: gray400,
                                onTap: () {
                                  if (controller.isTowingActive.value) {
                                    if (controller.isMembershipActive ==
                                        'Active') {
                                      if (controller.isJobActive.value ==
                                          false) {
                                        printMessage('Callouts1',
                                            controller.remainingCallouts);

                                        if (controller.remainingCallouts != 0) {
                                          Get.to(
                                              () => CustomerServiceDetails(
                                                  custId:
                                                      controller.contractId!,
                                                  lat: 0.0,
                                                  long: 0.0,
                                                  rsaTermID:
                                                      controller.rsAtermsId),
                                              popGesture: true,
                                              arguments: {
                                                "screenType":
                                                    "CustomrServiceDetails",
                                                "requestFor": "TOWING"
                                              });
                                        } else {
                                          showDialogForCallouts();
                                        }
                                      } else {
                                        const CustomWidgets()
                                            .jobActiveDialog(context);
                                      }
                                    } else {
                                      const CustomWidgets()
                                          .membershipStatusDialog(
                                              context,
                                              controller.isMembershipActive ??
                                                  '');
                                    }
                                  } else {
                                    const CustomWidgets()
                                        .showDialogForInActiveService(context);
                                  }
                                },
                                child: Card(
                                    elevation: 5.0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SvgPicture.asset(
                                            appTowing,
                                            height: Get.height * 0.15,
                                            colorFilter: ColorFilter.mode(
                                                controller.isTowingActive.value
                                                    ? secondaryColor
                                                    : Colors.grey,
                                                BlendMode.srcIn),
                                          ),
                                          customText(
                                            text: labelTowing,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                            : const SizedBox.shrink();
                      }),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        runSpacing: 15,
                        spacing: MediaQuery.of(context).size.width * 0.03,
                        children: [
                          Obx(() => controller.isJumpActiveOnApp.value
                              ? const CustomWidgets().serviceCard(
                                  serviceActiveStatus:
                                      controller.isJumpActive.value,
                                  serviceName: labelJumbstart,
                                  serviceImagePath: jumpstartIcon,
                                  onTap: () {
                                    if (controller.isJumpActive.value) {
                                      if (controller.isMembershipActive ==
                                          'Active') {
                                        if (controller.isJobActive.value ==
                                            false) {
                                          printMessage('Callouts2',
                                              controller.remainingCallouts);
                                          if (controller.remainingCallouts !=
                                              0) {
                                            Get.to(
                                                () => CustomerServiceDetails(
                                                    custId:
                                                        controller.contractId!,
                                                    lat: 0.0,
                                                    long: 0.0,
                                                    rsaTermID:
                                                        controller.rsAtermsId),
                                                popGesture: true,
                                                arguments: {
                                                  "screenType":
                                                      "CustomrServiceDetails",
                                                  "requestFor": "JUMPSTARTS"
                                                });
                                          } else {
                                            showDialogForCallouts();
                                          }
                                        } else {
                                          const CustomWidgets()
                                              .jobActiveDialog(context);
                                        }
                                      } else {
                                        const CustomWidgets()
                                            .membershipStatusDialog(
                                                context,
                                                controller.isMembershipActive ??
                                                    '');
                                      }
                                    } else {
                                      const CustomWidgets()
                                          .showDialogForInActiveService(
                                              context);
                                    }
                                  })
                              : const SizedBox.shrink()),
                          Obx(() => controller.isBatteryActiveOnApp.value
                              ? const CustomWidgets().serviceCard(
                                  serviceActiveStatus:
                                      controller.isBatteryActive.value,
                                  serviceName: labelBatteryReplacement,
                                  serviceImagePath: appBatteryReplace,
                                  onTap: () {
                                    if (controller.isBatteryActive.value) {
                                      if (controller.isMembershipActive ==
                                          'Active') {
                                        if (controller.isJobActive.value ==
                                            false) {
                                          if (controller.remainingCallouts !=
                                              0) {
                                            Get.to(
                                                () => CustomerServiceDetails(
                                                    custId:
                                                        controller.contractId!,
                                                    lat: 0.0,
                                                    long: 0.0,
                                                    rsaTermID:
                                                        controller.rsAtermsId),
                                                popGesture: true,
                                                arguments: {
                                                  "screenType":
                                                      "CustomrServiceDetails",
                                                  "requestFor":
                                                      "BATTERY REPLACEMENT"
                                                });
                                          } else {
                                            showDialogForCallouts();
                                          }
                                        } else {
                                          const CustomWidgets()
                                              .jobActiveDialog(context);
                                        }
                                      } else {
                                        const CustomWidgets()
                                            .membershipStatusDialog(
                                                context,
                                                controller.isMembershipActive ??
                                                    '');
                                      }
                                    } else {
                                      const CustomWidgets()
                                          .showDialogForInActiveService(
                                              context);
                                    }
                                  })
                              : const SizedBox.shrink()),
                          Obx(() => controller.isTyreActiveOnApp.value
                              ? const CustomWidgets().serviceCard(
                                  serviceActiveStatus:
                                      controller.isTyreActive.value,
                                  serviceName: labelTyreChangeService,
                                  serviceImagePath: appTyreChange,
                                  onTap: () {
                                    if (controller.isTyreActive.value) {
                                      if (controller.isMembershipActive ==
                                          'Active') {
                                        if (controller.isJobActive.value ==
                                            false) {
                                          if (controller.remainingCallouts !=
                                              0) {
                                            Get.to(
                                                () => CustomerServiceDetails(
                                                    custId:
                                                        controller.contractId!,
                                                    lat: 0.0,
                                                    long: 0.0,
                                                    rsaTermID:
                                                        controller.rsAtermsId),
                                                popGesture: true,
                                                arguments: {
                                                  "screenType":
                                                      "CustomrServiceDetails",
                                                  "requestFor": "FLAT TYRE"
                                                });
                                          } else {
                                            showDialogForCallouts();
                                          }
                                        } else {
                                          const CustomWidgets()
                                              .jobActiveDialog(context);
                                        }
                                      } else {
                                        const CustomWidgets()
                                            .membershipStatusDialog(
                                                context,
                                                controller.isMembershipActive ??
                                                    '');
                                      }
                                    } else {
                                      const CustomWidgets()
                                          .showDialogForInActiveService(
                                              context);
                                    }
                                  })
                              : const SizedBox.shrink()),
                          Obx(() => controller.isFuelActiveOnApp.value
                              ? const CustomWidgets().serviceCard(
                                  serviceActiveStatus:
                                      controller.isFuelActive.value,
                                  serviceName: labelOutFuel,
                                  serviceImagePath: appOutOfFuel,
                                  onTap: () {
                                    if (controller.isFuelActive.value) {
                                      if (controller.isMembershipActive ==
                                          'Active') {
                                        if (controller.isJobActive.value ==
                                            false) {
                                          if (controller.remainingCallouts !=
                                              0) {
                                            Get.to(
                                                () => CustomerServiceDetails(
                                                    custId:
                                                        controller.contractId!,
                                                    lat: 0.0,
                                                    long: 0.0,
                                                    rsaTermID:
                                                        controller.rsAtermsId),
                                                popGesture: true,
                                                arguments: {
                                                  "screenType":
                                                      "CustomrServiceDetails",
                                                  "requestFor":
                                                      "OUT OF FUEL RESCUE"
                                                });
                                          } else {
                                            showDialogForCallouts();
                                          }
                                        } else {
                                          const CustomWidgets()
                                              .jobActiveDialog(context);
                                        }
                                      } else {
                                        const CustomWidgets()
                                            .membershipStatusDialog(
                                                context,
                                                controller.isMembershipActive ??
                                                    '');
                                      }
                                    } else {
                                      const CustomWidgets()
                                          .showDialogForInActiveService(
                                              context);
                                    }
                                  })
                              : const SizedBox.shrink()),
                          Obx(() => controller.isLockOutActiveOnApp.value
                              ? const CustomWidgets().serviceCard(
                                  serviceActiveStatus:
                                      controller.isLockOutActive.value,
                                  serviceName: labelLockoutKeys,
                                  serviceImagePath: appKeys,
                                  onTap: () {
                                    if (controller.isLockOutActive.value) {
                                      if (controller.isMembershipActive ==
                                          'Active') {
                                        if (controller.isJobActive.value ==
                                            false) {
                                          if (controller.remainingCallouts !=
                                              0) {
                                            Get.to(
                                                () => CustomerServiceDetails(
                                                    custId:
                                                        controller.contractId!,
                                                    lat: 0.0,
                                                    long: 0.0,
                                                    rsaTermID:
                                                        controller.rsAtermsId),
                                                popGesture: true,
                                                arguments: {
                                                  "screenType":
                                                      "CustomrServiceDetails",
                                                  "requestFor":
                                                      "LOCKOUTS AND KEY RETRIEVALS"
                                                });
                                          } else {
                                            showDialogForCallouts();
                                          }
                                        } else {
                                          const CustomWidgets()
                                              .jobActiveDialog(context);
                                        }
                                      } else {
                                        const CustomWidgets()
                                            .membershipStatusDialog(
                                                context,
                                                controller.isMembershipActive ??
                                                    '');
                                      }
                                    } else {
                                      const CustomWidgets()
                                          .showDialogForInActiveService(
                                              context);
                                    }
                                  })
                              : const SizedBox.shrink()),
                          Obx(() => controller.isCarActiveOnApp.value
                              ? const CustomWidgets().serviceCard(
                                  serviceActiveStatus:
                                      controller.isCarActive.value,
                                  serviceName: labelCarHire,
                                  serviceImagePath: appCar,
                                  onTap: () {
                                    if (controller.isCarActive.value) {
                                      if (controller.isMembershipActive ==
                                          'Active') {
                                        if (controller.isJobActive.value ==
                                            false) {
                                          if (controller.remainingCallouts !=
                                              0) {
                                            Get.to(
                                                () => CustomerServiceDetails(
                                                    custId:
                                                        controller.contractId!,
                                                    lat: 0.0,
                                                    long: 0.0,
                                                    rsaTermID:
                                                        controller.rsAtermsId),
                                                popGesture: true,
                                                arguments: {
                                                  "screenType":
                                                      "CustomrServiceDetails",
                                                  "requestFor": "CAR HIRE"
                                                });
                                          } else {
                                            showDialogForCallouts();
                                          }
                                        } else {
                                          const CustomWidgets()
                                              .jobActiveDialog(context);
                                        }
                                      } else {
                                        const CustomWidgets()
                                            .membershipStatusDialog(
                                                context,
                                                controller.isMembershipActive ??
                                                    '');
                                      }
                                    } else {
                                      const CustomWidgets()
                                          .showDialogForInActiveService(
                                              context);
                                    }
                                  })
                              : const SizedBox.shrink()),
                          Obx(() => controller.isAmbulanceActiveOnApp.value
                              ? const CustomWidgets().serviceCard(
                                  serviceActiveStatus:
                                      controller.isAmbulanceActive.value,
                                  serviceName: labelAmubulanceCover,
                                  serviceImagePath: appHospital,
                                  onTap: () {
                                    if (controller.isAmbulanceActive.value) {
                                      if (controller.isMembershipActive ==
                                          'Active') {
                                        if (controller.isJobActive.value ==
                                            false) {
                                          if (controller.remainingCallouts !=
                                              0) {
                                            Get.to(
                                                () => CustomerServiceDetails(
                                                    custId:
                                                        controller.contractId!,
                                                    lat: 0.0,
                                                    long: 0.0,
                                                    rsaTermID:
                                                        controller.rsAtermsId),
                                                popGesture: true,
                                                arguments: {
                                                  "screenType":
                                                      "CustomrServiceDetails",
                                                  "requestFor": "AMBULANCE"
                                                });
                                          } else {
                                            showDialogForCallouts();
                                          }
                                        } else {
                                          const CustomWidgets()
                                              .jobActiveDialog(context);
                                        }
                                      } else {
                                        const CustomWidgets()
                                            .membershipStatusDialog(
                                                context,
                                                controller.isMembershipActive ??
                                                    '');
                                      }
                                    } else {
                                      const CustomWidgets()
                                          .showDialogForInActiveService(
                                              context);
                                    }
                                  })
                              : const SizedBox.shrink()),
                          Obx(() => controller.isAccoActiveOnApp.value
                              ? const CustomWidgets().serviceCard(
                                  serviceActiveStatus:
                                      controller.isAccoActive.value,
                                  serviceName: labelAccommodation,
                                  serviceImagePath: appAccommodations,
                                  onTap: () {
                                    if (controller.isAccoActive.value) {
                                      if (controller.isMembershipActive ==
                                          'Active') {
                                        if (controller.isJobActive.value ==
                                            false) {
                                          if (controller.remainingCallouts !=
                                              0) {
                                            Get.to(
                                                () => CustomerServiceDetails(
                                                    custId:
                                                        controller.contractId!,
                                                    lat: 0.0,
                                                    long: 0.0,
                                                    rsaTermID:
                                                        controller.rsAtermsId),
                                                popGesture: true,
                                                arguments: {
                                                  "screenType":
                                                      "CustomrServiceDetails",
                                                  "requestFor": "ACCOMODATION"
                                                });
                                          } else {
                                            showDialogForCallouts();
                                          }
                                        } else {
                                          const CustomWidgets()
                                              .jobActiveDialog(context);
                                        }
                                      } else {
                                        const CustomWidgets()
                                            .membershipStatusDialog(
                                                context,
                                                controller.isMembershipActive ??
                                                    '');
                                      }
                                    } else {
                                      const CustomWidgets()
                                          .showDialogForInActiveService(
                                              context);
                                    }
                                  })
                              : const SizedBox.shrink()),
                        ],
                      )
                    ],
                  ),
                )
              : Center(
                  child: customText(
                    text: controller.msg,
                  ),
                ),
        );
      }),
    ), context);
  }

  showDialogForCallouts() {
    return showDialog(
      context: Get.context!,
      useSafeArea: false,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (context) => PopScope(
        onPopInvokedWithResult: (didPop, result) async => false,
        child: CupertinoAlertDialog(
          title: customText(
            text: calloutMessage,
          ),
          actions: [
            TextButton(
              onPressed: () {
                makePhoneCall(global.phoneNoRetailer);
              },
              child: customText(text: labelCall, color: secondaryColor),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: customText(text: labelCancel, color: secondaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
