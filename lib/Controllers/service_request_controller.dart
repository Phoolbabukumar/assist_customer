import 'dart:convert';
import 'package:assist/Controllers/my_member_ships_controller.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/apis/response/job_titles_respose.dart';
import 'package:assist/ui/vehicle_edit.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../apis/response/vehicle_list_byphone_response.dart';
import '../utils/common_functions.dart';

class ServiceRequestController extends GetxController {
  var tag = "ServiceRequestController";

  final myMemberShipsController = Get.put(MyMemberShipsController());

  List<VehicleListModel> vehicleList = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectTerms;
  String? customerIdForVehicle;
  String? isMembershipActive;
  String? planName;
  String? memberShipNo;
  String? contractId;
  int? remainingCallouts;
  String? callouts;

  final isJumpActive = false.obs;
  final isTyreActive = false.obs;
  final isBatteryActive = false.obs;
  final isLockOutActive = false.obs;
  final isTowingActive = false.obs;
  final isFuelActive = false.obs;
  final isAmbulanceActive = false.obs;
  final isAccoActive = false.obs;
  final isCarActive = false.obs;
  final isJobActive = true.obs;
  final loading = true.obs;

  /* variables to show or hide the tiles */
  final isJumpActiveOnApp = false.obs;
  final isBatteryActiveOnApp = false.obs;
  final isLockOutActiveOnApp = false.obs;
  final isTowingActiveOnApp = false.obs;
  final isFuelActiveOnApp = false.obs;
  final isTyreActiveOnApp = false.obs;
  final isAmbulanceActiveOnApp = false.obs;
  final isAccoActiveOnApp = false.obs;
  final isCarActiveOnApp = false.obs;

  String retailerNumber = "";
  double latitude = 0.0;
  double longitude = 0.0;
  int rsAtermsId = 0;
  String msg = "";

  List<String> activeJobsList = []; // Option 2
  List<Map<String, String>> activeJobsonApp = []; // Option 2
  List<VehicleListModel> tERMSList = [];
  List<String> termsList = [];

  @override
  void onInit() async {
    super.onInit();
    global.customerPhoneNumber != ""
        ? await getVehicleListForRoadsideService2(global.customerPhoneNumber)
        : null;
    await getActiveRequestsForRoadSide2(contractId!);
    update();
  }

  /* To refresh teh entire screen of roadsideservice screen */
  Future<void> refreshData() async {
    global.customerPhoneNumber != ""
        ? getVehicleListForRoadsideService2(global.customerPhoneNumber)
        : null;
    update();
  }

/* This is same like below getVehicleList fuc. but the diff. is, it make an extra filtration and give us a filtered list */
  Future<void> getVehicleListForRoadsideService2(String name) async {
    termsList.clear();
    printMessage(tag, "calling Vehicle Response $name");

    await getVehicleList(name).then((value) async {
      printMessage(tag, "GET Vehicle Response : $value");
      if (value != null) {
        if (value.response != null) {
          tERMSList = value.response ?? [];

          for (VehicleListModel list in tERMSList) {
            // termsCheck = true;
            termsList.add("${list.vehicleWithMembership}");
          }

          if (termsList.isEmpty) {
            msg = "No Service available";
          }
          await myMemberShipsController
              .getMembershipDetail(tERMSList[0].contractID.toString())
              .then((membershipData) {
            debugPrint('fer${membershipData!.planName}');
            debugPrint('fer${membershipData.membershipNo}');
            printMessage('callouts45', callouts);

            planName = membershipData.planName;
            memberShipNo = membershipData.membershipNo;
            callouts = membershipData.remCalloutsText;

            printMessage('callouts45', callouts);

            selectTerms = termsList.elementAt(0);
            rsAtermsId = tERMSList[0].vehicleID ?? 0;
            customerIdForVehicle = tERMSList[0].customerID.toString();
            contractId = tERMSList[0].contractID.toString();
            getActiveRequests(contractId!);
            update();
            if (termsList.elementAt(0).toLowerCase().contains("tba")) {
              const CustomWidgets().showDialogRegoRequest(Get.context, () {
                Get.back();
                myMemberShipsController
                    .getVehicleDetail(tERMSList[0].vehicleID.toString())
                    .then((vehicleData) {
                  Get.to(
                      () => VehicleEdit(
                            planName: membershipData.planName ?? "",
                          ),
                      popGesture: true,
                      arguments: {
                        "screenType": "VehicleEdit",
                        "vehicleListResponse": vehicleData,
                        "membershipNo": membershipData.membershipNo ?? '',
                        "planId": membershipData.planID.toString(),
                      })?.then((value) {
                    global.customerPhoneNumber != ""
                        ? getVehicleListForRoadsideService2(
                            global.customerPhoneNumber)
                        : null;
                  });
                });
              });
            }
          });
          update();
        }
      } else {
        update();
      }
      update();
    });
    update();
  }

/* This can find the active services and show the user */
  getActiveRequestsForRoadSide2(String name) async {
    printMessage(tag, "Calling getActiveRequests");

    isJumpActive.value = false;
    isTyreActive.value = false;
    isBatteryActive.value = false;
    isLockOutActive.value = false;
    isTowingActive.value = false;
    isFuelActive.value = false;
    isAmbulanceActive.value = false;
    isAccoActive.value = false;
    isCarActive.value = false;

    /* Available tiles variable */
    isJumpActiveOnApp.value = false;
    isBatteryActiveOnApp.value = false;
    isLockOutActiveOnApp.value = false;
    isTowingActiveOnApp.value = false;
    isFuelActiveOnApp.value = false;
    isTyreActiveOnApp.value = false;
    isAmbulanceActiveOnApp.value = false;
    isAccoActiveOnApp.value = false;
    isCarActiveOnApp.value = false;

    activeJobsList.clear();
    activeJobsonApp.clear();
    await getJobActiveOrNot(contractId.toString()).then((value) async {
      isJobActive.value = value['StatusCode'] == 1 ? true : false;

      printMessage(tag, "is active or not=====$isJobActive");

      await getMemberShipStatus(name).then((value) async {
        isMembershipActive = value['ContractStatus'];
        await getActiveRequests(name).then((value) async {
          printMessage(tag, "GET Active Request Response : $value");
          if (value != null) {
            for (JobTitlesModel list in value.response) {
              activeJobsList.add(list.service.toString());
              activeJobsonApp.add({
                'service': list.service.toString(),
                'status': list.availableOnApp.toString(),
              });
            }

            for (int i = 0; i < activeJobsList.length; i++) {
              switch (activeJobsList[i]) {
                case "JUMPSTARTS":
                  isJumpActive.value = true;
                  break;
                case "BATTERY REPLACEMENT":
                  isBatteryActive.value = true;
                  break;
                case "FLAT TYRE":
                  isTyreActive.value = true;
                  break;
                case "LOCKOUTS AND KEY RETRIEVALS":
                  isLockOutActive.value = true;
                  break;
                case "TOWING":
                  isTowingActive.value = true;
                  break;
                case "OUT OF FUEL RESCUE":
                  isFuelActive.value = true;
                  break;
                case "AMBULANCE":
                  isAmbulanceActive.value = true;
                  break;
                case "ACCOMODATION":
                  isAccoActive.value = true;
                  break;
                case "CAR HIRE":
                  isCarActive.value = true;
                  break;
              }
            }

            for (int i = 0; i < activeJobsonApp.length; i++) {
              String? service = activeJobsonApp[i]["service"];
              String? status = activeJobsonApp[i]["status"];
              bool isActive = status != "No";
              switch (service) {
                case "JUMPSTARTS":
                  isJumpActiveOnApp.value = isActive;
                  break;
                case "BATTERY REPLACEMENT":
                  isBatteryActiveOnApp.value = isActive;
                  break;
                case "FLAT TYRE":
                  isTyreActiveOnApp.value = isActive;
                  break;
                case "LOCKOUTS AND KEY RETRIEVALS":
                  isLockOutActiveOnApp.value = isActive;
                  break;
                case "TOWING":
                  isTowingActiveOnApp.value = isActive;
                  break;
                case "OUT OF FUEL RESCUE":
                  isFuelActiveOnApp.value = isActive;
                  break;
                case "AMBULANCE":
                  isAmbulanceActiveOnApp.value = isActive;
                  break;
                case "ACCOMODATION":
                  isAccoActiveOnApp.value = isActive;
                  break;
                case "CAR HIRE":
                  isCarActiveOnApp.value = isActive;
                  break;
              }
            }
          }

          await getMembershipDetails(name).then((value) {
            planName = value['PlanName'];
            memberShipNo = value['MembershipNo'];
            var remCalouts = value['RemainingCallouts'];
            if (remCalouts == null || remCalouts.toString().isEmpty) {
              var remCaloutsText = value['RemCalloutsText'];
//RemCalloutsText
              if (remCaloutsText.toString().toLowerCase() == "unlimited") {
                remainingCallouts = 1;
              } else {
                remainingCallouts = 0;
              }
            } else {
              remainingCallouts = value['RemainingCallouts'];
            }
            printMessage(tag, value);
            printMessage('Callouts', remainingCallouts);
            update();
          });
        });
      });
    });
  }

/* Get those vehicles that are show in dropdown */
  Future<VehicleListByPhoneResponse?> getVehicleList(String phoneNo) async {
    vehicleList = [];
    try {
      return BaseClient.get("Phone=$phoneNo", "FindVehicleByPhone")
          .then((value) {
        if (value != null) {
          VehicleListByPhoneResponse vehicleResponse =
              VehicleListByPhoneResponse.fromJson(json.decode(value));
          vehicleList = vehicleResponse.response ?? [];
          return vehicleResponse;
        } else {
          return null;
        }
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* This api return the service title and other details */
  Future<JobTitlesModelListResponse?> getActiveRequests(String name) async {
    try {
      return BaseClient.get("ContractID=$name", "APIGetJobTitles")
          .then((value) {
        if (value != null) {
          try {
            JobTitlesModelListResponse productResponse =
                JobTitlesModelListResponse.fromJson(json.decode(value ?? ''));
            update();
            return productResponse;
          } catch (e) {
            debugPrint("APIGetJobTitle ==$e");

            return null;
          }
        } else {
          return null;
        }
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

  Future<dynamic> getMembershipDetails(String name) async {
    try {
      return BaseClient.get("ContractID=$name", "GetMembershipByID")
          .then((value) {
        if (value != null) {
          var productResponse = json.decode(value);
          update();
          return productResponse;
        } else {
          return null;
        }
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

  Future<dynamic> getMemberShipStatus(String name) async {
    try {
      return BaseClient.get("ContractID=$name", "GetContractStatus")
          .then((value) {
        if (value != null) {
          var productResponse = json.decode(value);
          update();
          return productResponse;
        } else {
          return null;
        }
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* This can return teh status of the service, that is avilable for the perticular membership or not*/
  Future<dynamic> getJobActiveOrNot(String name) async {
    try {
      return BaseClient.get("ContractID=$name", "APIGetJobStatus")
          .then((value) {
        if (value != null) {
          var productResponse = json.decode(value);
          update();
          return productResponse;
        } else {
          return null;
        }
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }
}
