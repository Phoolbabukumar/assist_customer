import 'dart:convert';
import 'package:assist/Controllers/buy_assistance_controller.dart';
import 'package:assist/Controllers/global_controller.dart';

import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/apis/response/membership_list_response.dart';
import 'package:assist/apis/response/service_details_response.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../apis/response/membership_model_plan_details.dart';
import '../apis/response/vehicle_list_response.dart';
import '../utils/common_functions.dart';

class MyMemberShipsController extends GetxController {
  final global = Get.find<GlobalController>();
  final themecontroller = Get.find<ThemeController>();
  final buyAssistanceController = Get.put(BuyAssistanceController());

  var tag = "MyMemberShipsController";
  late Future getMembershipListFuture;
  late Future myMembershipResponse;
  late Future myVehicleListResponse;
  late Future membershipDetailFuture;
  late Future vehicleDetailFuture;
  List<MembershipListModel> membershipList = [];
  List<Vehicles> vehicleList = [];
  List<ServiceDetailModel> serviceDetailList = [];
  PlanDetailsMembershipListModel membershipDetail =
      PlanDetailsMembershipListModel();
  Vehicles vehicleListModel = Vehicles();
  String? vehicleComing;

  final loading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    loading.value = true;
    await memberShipList(global.customerPhoneNumber.toString());
  }

/* This api get the customer membersips with details */
  Future<List<MembershipListModel>?> memberShipList(String mobileNo) async {
    try {
      loading.value = true;
      return BaseClient.get("Phone=$mobileNo", "GetMembershipsByPhone")
          .then((value) {
        var response = MembershipListResponse.fromJson(json.decode(value));
        membershipList = response.response ?? [];
        membershipList.sort((a, b) {
          var input1 = a.status ?? "".toString();
          var input2 = b.status ?? "".toString();
          return input1.compareTo(input2);
        });
        loading.value = false;
        return membershipList.obs;
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* This function return the list of vehicles according to the membership */
  Future<List<Vehicles>?> getVehicleList(String memberShipNo) async {
    vehicleList = [];
    vehicleComing = "";
    try {
      return BaseClient.get(
              "ContractID=$memberShipNo", "GetVehiclesForCustomer")
          .then((value) {
        if (value != null) {
          var response1 = VehicleListResponse.fromJson(json.decode(value));
          vehicleList = response1.vehicles ?? [];

          if (vehicleList.isNotEmpty && response1.statusCode != 404) {
            vehicleComing = vehicleList[0].vehicleType ?? '';
          }

          debugPrint("type of vehicle in plan ====$vehicleComing");
          return vehicleList.obs;
        } else {
          return [];
        }
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* plan plan details user delete the vehicle this api was called */
  Future<dynamic> vehicleDelete(String vehicleId) async {
    try {
      return BaseClient.get("VehicleID=$vehicleId", "APIDeleteVehicle")
          .then((value) {
        var response1 = json.decode(value);

        return response1;
        // return null;
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* ? */
  Future<List<ServiceDetailModel>?> getServiceData(String planID) async {
    try {
      return BaseClient.get("PlanID=$planID", "GetServiceAvailable")
          .then((value) {
        if (value != null) {
          var response1 =
              ServiceDetailsResponse.fromJson(json.decode(value ?? ''));
          serviceDetailList = response1.response;
          return serviceDetailList;
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

  Future<PlanDetailsMembershipListModel?> getMembershipDetail(
      String customerId) async {
    try {
      return BaseClient.get("ContractID=$customerId", "GetMembershipByID")
          .then((value) {
        membershipDetail =
            PlanDetailsMembershipListModel.fromJson(json.decode(value));

        return membershipDetail;
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

  Future<Vehicles?> getVehicleDetail(String vehicleID) async {
    try {
      return BaseClient.get("VehicleID=$vehicleID", "FindVehicleByID")
          .then((value) {
        vehicleListModel = Vehicles.fromJson(json.decode(value));
        return vehicleListModel;
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }
}
