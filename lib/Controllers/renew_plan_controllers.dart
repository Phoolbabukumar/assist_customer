import 'dart:convert';
import 'dart:developer';
import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/apis/apis_constant.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/apis/response/buy_plan_payment_response.dart';
import 'package:assist/utils/Widgets/coupon_widgets.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../apis/response/coupon_code_renew_response.dart';
import '../apis/response/plan_list_response.dart';
import '../utils/common_functions.dart';

class RenewPlanController extends GetxController {
  var tag = "MyMemberShipsController";

  final themecontroller = Get.find<ThemeController>();

  String? term,
      startDate,
      endDate,
      lastPlanName,
      retailerId,
      membershipNo,
      oldTerm,
      oldPlanName,
      membershipStatus,
      newEndDate,
      newStartDate,
      vehicleType,
      otherplantype;
  // now match dropdown list plans with planId, so we need to get previous planid this variable stores those id
  int? planid;

  late Future planListResponse;
  List<PlanListModel> plansList = [];
  List<String> planNameList = [];
  String? chosenValue;
  final applyCouponOnRenew = false.obs;
  final renewalDiscountPrice = "0".obs;
  final totalRenewalPrice = "0".obs;
  final renewApplied = false.obs;
  final renewCoupontextController = TextEditingController();

  final url = "".obs;
  // List<String> spinnerItems = [];

  String price = "", oldPlanPrice = "";
  int planId = 0;
  // ignore: prefer_typing_uninitialized_variables
  var newStartDateDay, newStartDateMonth, newStartDateYear;

  final viewAllPlan = false.obs;
  final termAndCondition = false.obs;

  double discountedPrice = 0.0;
  double forMinus = 0.0;
  double finalDiscount = 0.0;

  @override
  void onInit() {
    super.onInit();
    term = Get.arguments["term"];
    startDate = Get.arguments["startDate"];
    endDate = Get.arguments["endDate"];
    lastPlanName = Get.arguments["lastPlanName"];
    retailerId = Get.arguments["retailerId"];
    membershipNo = Get.arguments["membershipNo"];
    vehicleType = Get.arguments["vehicleType"];
    membershipStatus = Get.arguments["membershipStatus"];
    otherplantype = Get.arguments[
        "otherplantype"]; // if the plan is caravan this variable can pass into getplanlist api it can give me filtered list of plans
    planid = Get.arguments["planid"];

    oldTerm = term;
    oldPlanName = lastPlanName;

    dayIncrement();
    getPlanData();
  }

  void toggleRenewCode() {
    applyCouponOnRenew.value = !applyCouponOnRenew.value;
  }

  void toggleRenewApplied() {
    renewApplied.value = !renewApplied.value;
  }

/* After done all process this api post the data for done the payment process and redirect user to the payment view */
  Future<BuyPlanPaymentResponse>? sendDataForPayment(String api) {
    try {
      return BaseClient.postNew(api, "RenewPlanAPI").then((value) {
        BuyPlanPaymentResponse response =
            BuyPlanPaymentResponse.fromJson(json.decode(value));
        return response;
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* This Api returns list of plans that related to the selected plan for Dropdown */
  Future<List<PlanListModel>?> planListData(
      String retailerId, String vehicleType, String otherType) async {
      final types =  vehicleType == "Mobility Scooter" ? "Mobility_Scooter" : vehicleType;
    try {
      final apiEndPoint = otherType.isNotEmpty
          ? "RetailerID=$retailerId&npVehicleType=$types&otherVehicleType=$otherType"
          : "RetailerID=$retailerId&npVehicleType=$types";
      return BaseClient.get(apiEndPoint, "GetPlanList").then((value) {
        if (value != null) {
          var response = PlanListResponse.fromJson(json.decode(value));

          plansList = response.response; //directly save vehicle details

          /* for (var item in plansList) {
            if (item.npVehicleType == vehicleType) {
              planNameList.add(item.planName!);
              printMessage(tag, 'item.planName..${item.planName}');
            }
          }*/
          log("filtered plan list: $plansList");
          return plansList;
        } else {}
        return null;
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* called when user apply the coupon code */
  Future<RenewCouponCodeApiResponse?> renewPlanCouponCodeApi(
    context,
    int contractid,
    int customerid,
    int planid,
  ) async {
    try {
      debugPrint(
          ">>> Cupon Code  Api <<<<"); // print coupon code here for check
      // Make API call
      final response = await BaseClient.get(
          "ContractID=$contractid"
              "&DiscountCode=${renewCoupontextController.value.text.trim().toUpperCase()}"
              "&CustomerID=$customerid"
              "&PlanID=$planid",
          "APIDiscountCodeRenewal");

      // Parse response
      final responseData = json.decode(response);

      if (responseData['StatusCode'] == 1) {
        RenewCouponCodeApiResponse couponResponse =
            RenewCouponCodeApiResponse.fromJson(responseData);

        // Update state

        String amount = "${couponResponse.discountedPrice ?? 0}";

        renewalDiscountPrice.value = amount;
        totalRenewalPrice.value = couponResponse.totalDiscount ?? "0";
        couponSuccessMsg(context);
        toggleRenewApplied();
        return couponResponse;
      } else if (responseData['StatusCode'] == 0) {
        // Show error message
        const CustomWidgets().snackBar(context, responseData['StatusMessage']);
      } else {
        const CustomWidgets().snackBar(context, "Something went wrong");
      }
    } catch (e, stacktrace) {
      debugPrint("$e");
      debugPrint("$stacktrace");

      // Show error message
      const CustomWidgets()
          .snackBar(context, "An error occurred. Please try again.");
    }
    return null;
  }

/* Remove Coupon code api */
  Future<void> removeRenewPlanCouponCodeApi(
    context,
    int contractid,
  ) async {
    try {
      debugPrint(
          ">>> Cupon Code  Api <<<<"); // print coupon code here for check
      // Make API call
      final response =
          await BaseClient.get("ContractID=$contractid", "APIRemoveDiscount");

      // Parse response
      final responseData = json.decode(response);

      if (responseData['StatusCode'] == 200) {
        // Update state
        const CustomWidgets()
            .snackBar(context, "Discount code removed successfully");
      } else {
        const CustomWidgets().snackBar(context, "Oops! Something went wrong");
      }
    } catch (e, stacktrace) {
      debugPrint("$e");
      debugPrint("$stacktrace");

      // Show error message
      const CustomWidgets()
          .snackBar(context, "An error occurred. Please try again.");
    }
  }

/* get teh future date of plan expiry according to the selected plan */
  void dayIncrement() {
    int eDay, eMonth, eYear;
    eDay = int.parse(endDate!.substring(0, 2));
    eMonth = int.parse(endDate!.substring(3, 5));
    eYear = int.parse(endDate!.substring(6, 10));

    var now = DateTime.now();
    var berlinWallFellDate = DateTime.utc(eYear, eMonth, eDay);

    if (berlinWallFellDate.compareTo(now) > 0) {
      var date = DateTime(eYear, eMonth, eDay + 1);

      newStartDateDay = date.day;
      newStartDateMonth = date.month;
      newStartDateYear = date.year;

      DateFormat d = DateFormat("dd/MM/yyyy");

      String nDate = d.format(
          DateTime(newStartDateYear, newStartDateMonth, newStartDateDay));

      newStartDate = nDate;

      yearIncrement(term!);
    } else {
      var date = DateTime.now();
      var tomorrowDate = date.add(const Duration(days: 1));

      newStartDateDay = tomorrowDate.day;
      newStartDateMonth = tomorrowDate.month;
      newStartDateYear = tomorrowDate.year;

      DateFormat d = DateFormat("dd/MM/yyyy");

      String nDate = d.format(
          DateTime(newStartDateYear, newStartDateMonth, newStartDateDay));

      newStartDate = nDate;
      yearIncrement(term!);
    }
  }

/* Method for getting plan data from perticular plan choosen by user */
  getPlanData() {
    planListData(retailerId!, vehicleType!, otherplantype!).then((value) {
      for (var item in plansList) {
        if (planid == item.planId) {
          chosenValue = lastPlanName;
          term = item.term;
          lastPlanName = item.planName;
          price = item.amount.toString();
          oldPlanPrice = item.amount.toString();
          planId = item.planId!;
          discountedPrice = item.discountedPrice ?? 0.0;
          forMinus = double.parse(price);
          finalDiscount = forMinus - discountedPrice;
          debugPrint("final discount:  $finalDiscount");

          debugPrint(
              "tag renewal discounted price==$discountedPrice   ${item.discountedPrice}");
          yearIncrement(term!);
          getTermsandConditions(item.npVehicleType);
          return;
        }
      }

      if ((chosenValue ?? "").isEmpty) {
        viewAllPlan.value = true;
      }
      // spinnerItems = value ?? [];
      // printMessage(tag, 'spinnerItems${spinnerItems.length}');
    });
  }

/* This method used to increase the timeline according to the selected plan expiry time from Today */
  void yearIncrement(String term) {
    int termYear;
    termYear = int.parse(term.substring(0, 2).trim());

    var date = DateTime(
        newStartDateYear + termYear, newStartDateMonth, newStartDateDay + 1);
    DateFormat d = DateFormat("dd/MM/yyyy");
    String nDate = d.format(DateTime(date.year, date.month, date.day));
    newEndDate = nDate;
    update();
  }

/* This method get the url of T&C according to the vehicle type */
  getTermsandConditions(String? npVehicleType) {
    switch (npVehicleType) {
      case "Car/Trailer":
        {
          url.value = APIsConstant().carTermConditionURl;
          update();
        }
        break;
      case "Motorhome":
        {
          url.value = APIsConstant().motorhomeTermConditionURl;
          update();
        }
        break;
      case "Caravan":
        {
          url.value = APIsConstant().caravanTermConditionURl;
          update();
        }
        break;
      case "Mobility Scooter":
        {
          url.value = APIsConstant().mobilityScooterTermConditionURl;
          update();
        }
        break;
      case "Mobility_Scooter":
        {
          url.value = APIsConstant().mobilityScooterTermConditionURl;
          update();
        }
        break;
      case "Bike":
        {
          url.value = APIsConstant().bikeTermConditionURl;
          update();
        }
        break;
    }
  }
}
