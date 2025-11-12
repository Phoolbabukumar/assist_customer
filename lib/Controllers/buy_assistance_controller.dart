import 'dart:convert';
import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/apis/response/buy_plan_payment_response.dart';
import 'package:assist/apis/response/buy_plan_response.dart';
import 'package:assist/apis/response/service_details_response.dart';
import 'package:assist/apis/response/service_plansdetails_response.dart';
import 'package:assist/apis/response/tabledata_model.dart';
import 'package:assist/app_constants/app_images_path.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/common_functions.dart';

class BuyAssistanceController extends GetxController {
  var tag = "Buy Assistance controller";

  final themecontroller = Get.find<ThemeController>();

  List<PlanWithServices> servicePlans = [];
  List<TableDataModel> getServicesData11 = [];
  List<ServiceDetailModel> serviceDetailList = [];

  double hight1 = 0;
  final cardTap = 0.obs;
  final vehicleType = "Car/Trailer".obs;
  final isLoading = true.obs;
  final hasError = false.obs;

/* This variable contain the text icon and type of vehicle that is used in plan Details page */
  final List<Map<String, dynamic>> vehicleOptions = [
    {
      "label": labelCar,
      "type": "Car/Trailer",
      "icon": appBuyCarIcon,
    },
    {
      "label": labelCaravans,
      "type": "Caravan",
      "icon": appCaravanIcon,
    },
    {
      "label": labelMotorHomes,
      "type": "Motorhome",
      "icon": appMotorHomeIcon,
    },
    {
      "label": labelMotorbikes,
      "type": "Bike",
      "icon": appMotorBikeIcon,
    },
    {
      "label": labelMobilityScooter,
      "type": "Mobility_Scooter",
      "icon": appScooterIcon,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    getPlanData();
  }

/* This fucntion extract the plan details by diff. types used in plan detail screen, whenever the type is changed */
  Future<void> getPlanData() async {
    isLoading(true);
    hasError(false);
    try {
      final response = await servicesListData(vehicleType.value);
      if (response == null) {
        return;
      }

      getServicesData11.clear();

      List<String> servicesList = [];
      for (int i = 0; i < servicePlans.length; i++) {
        servicesList.clear();
        final plan = servicePlans[i];
        if (plan.planName != null && plan.term != null) {
          for (var service in plan.planService ?? []) {
            servicesList.add(service.servicesCovered ?? '');
          }

          if (hight1 < servicesList.length.toDouble()) {
            hight1 = servicesList.length.toDouble();
          }

          getServicesData11.add(
            TableDataModel(
              plan.amount.toString(),
              plan.rNPlanID.toString(),
              plan.planName.toString(),
              plan.term.toString(),
              plan.includeOtherVehicle.toString(),
              servicesList,
            ),
          );
          isLoading(false);
        }
      }
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

/* This funtion give the entire list of services available in the plans and then getPlan data extract this list nad save into the diff. lists and these lists are used in plan details page */
  Future<ServicePlansDetailsResponse?> servicesListData(
      String vehicleType) async {
    try {
      final responseJson = await BaseClient.get(
          "npVehicleType=$vehicleType", "GetServicesOfPlans");
      final response =
          ServicePlansDetailsResponse.fromJson(json.decode(responseJson));
      servicePlans = response.planWithServices ?? [];
      return response;
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      hasError.value = true;
      return null;
    }
  }

/* This Api called when user only select car or caravan or moterHome, from Inside the App */
  Future<BuyPlanResponse?> buyPlan(
      String customerID,
      String planID,
      String makeName,
      String modelName,
      String rego,
      String year,
      String color,
      String bodyType,
      String height,
      String width,
      String weight,
      String length,
      String source) async {
    try {
      debugPrint('Running');
      return BaseClient.postNew(
              "CustomerID=$customerID"
                  "&Rego=$rego"
                  "&BodyType=$bodyType"
                  "&Colour=$color"
                  "&VehicleMake=$makeName"
                  "&VehicleModel=$modelName"
                  "&Year=$year"
                  "&Source=$source"
                  "&VehicleWeight=$weight"
                  "&VehicleWidth=$width"
                  "&VehicleHeight=$height"
                  "&VehicleLength=$length"
                  "&PlanID=$planID",
              "BuyPlan")
          .then((value) {
        if (value != null) {
          BuyPlanResponse response =
              BuyPlanResponse.fromJson(json.decode(value));

          return response;
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

/* When user try to buy plan from SignUp this Api is calling */
  Future<BuyPlanResponse?> buyPlanSignUp(
      String customerID,
      String planID,
      String makeName,
      String modelName,
      String rego,
      String year,
      String color,
      String bodyType,
      String height,
      String width,
      String weight,
      String length,
      String source) async {
    try {
      debugPrint('Running1');

      return BaseClient.postNew(
              "&CustomerID=$customerID"
                  "&Rego=$rego"
                  "&BodyType=$bodyType"
                  "&Colour=$color"
                  "&VehicleMake=$makeName"
                  "&VehicleModel=$modelName"
                  "&Year=$year"
                  "&Source=$source"
                  "&VehicleWeight=$weight"
                  "&VehicleWidth=$width"
                  "&VehicleHeight=$height"
                  "&VehicleLength=$length"
                  "&PlanID=$planID",
              "APIBuyPlanSignUP")
          .then((value) {
        if (value != null) {
          BuyPlanResponse response =
              BuyPlanResponse.fromJson(json.decode(value));

          return response;
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

/* If user select car+caravan then this Api is called */
  Future<BuyPlanResponse?> buyPlanMultipleVehicle(
      String customerID,
      String planID,
      String makeName,
      String modelName,
      String rego,
      String year,
      String color,
      String bodyType,
      String height,
      String width,
      String weight,
      String length,
      String makeNameSecondVehicle,
      String modelNameSecondVehicle,
      String regoSecondVehicle,
      String yearSecondVehicle,
      String colorSecondVehicle,
      String bodyTypeSecondVehicle,
      String source) async {
    try {
      return BaseClient.postNew(
              "CustomerID=$customerID"
                  "&PlanID=$planID"
                  "&Rego=$rego"
                  "&BodyType=$bodyType"
                  "&Colour=$color"
                  "&VehicleMake=$makeName"
                  "&VehicleModel=$modelName"
                  "&Year=$year"
                  "&VehicleWeight=$weight"
                  "&VehicleWidth=$width"
                  "&VehicleHeight=$height"
                  "&VehicleLength=$length"
                  "&RegoMultiple=$regoSecondVehicle"
                  "&YearMultiple=$yearSecondVehicle"
                  "&Source=$source"
                  "&BodyTypeMultiple=$bodyTypeSecondVehicle"
                  "&VehicleModelSecond=$modelNameSecondVehicle"
                  "&VehicleMakeSecond=$makeNameSecondVehicle"
                  "&ColourForMultiple=$colorSecondVehicle"
                  "&VehicleWidthMultiple=0"
                  "&VehicleLengthMultiple=0"
                  "&VehicleHeightMultiple=0"
                  "&VehicleWeightMultiple=0",
              "BuyPlanMultipleVehicle")
          .then((value) {
        if (value != null) {
          BuyPlanResponse response =
              BuyPlanResponse.fromJson(json.decode(value));
          Get.back();
          return response;
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

/* If user select car+caravan then this Api is called from signUp flow*/
  Future<BuyPlanResponse?> buyPlanMultipleVehicleForSignUp(
      String customerID,
      String planID,
      String makeName,
      String modelName,
      String rego,
      String year,
      String color,
      String bodyType,
      String height,
      String width,
      String weight,
      String length,
      String makeNameSecondVehicle,
      String modelNameSecondVehicle,
      String regoSecondVehicle,
      String yearSecondVehicle,
      String colorSecondVehicle,
      String bodyTypeSecondVehicle,
      String source) async {
    try {
      return BaseClient.postNew(
              "CustomerID=$customerID"
                  "&PlanID=$planID"
                  "&Rego=$rego"
                  "&BodyType=$bodyType"
                  "&Colour=$color"
                  "&VehicleMake=$makeName"
                  "&VehicleModel=$modelName"
                  "&Year=$year"
                  "&VehicleWeight=$weight"
                  "&VehicleWidth=$width"
                  "&VehicleHeight=$height"
                  "&VehicleLength=$length"
                  "&Source=$source"
                  "&RegoMultiple=$regoSecondVehicle"
                  "&YearMultiple=$yearSecondVehicle"
                  "&BodyTypeMultiple=$bodyTypeSecondVehicle"
                  "&VehicleModelSecond=$modelNameSecondVehicle"
                  "&VehicleMakeSecond=$makeNameSecondVehicle"
                  "&ColourForMultiple=$colorSecondVehicle"
                  "&VehicleWidthMultiple=0"
                  "&VehicleLengthMultiple=0"
                  "&VehicleHeightMultiple=0"
                  "&VehicleWeightMultiple=0",
              "BuyPlanMultipleVehicleSignUP")
          .then((value) {
        if (value != null) {
          BuyPlanResponse response =
              BuyPlanResponse.fromJson(json.decode(value));
          Get.back();
          return response;
        } else {
          Get.back();
          return null;
        }
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* this api called when user buy plan from app signup flow */
  Future<BuyPlanPaymentResponse?> paymentOfNewMembership(
      String membershipNo, String amount) async {
    try {
      return BaseClient.get(
              "MembershipNo=$membershipNo"
                  "&PlanAmount=$amount",
              "BuyPlanFromApp")
          .then((value) {
        if (value != null) {
          BuyPlanPaymentResponse response =
              BuyPlanPaymentResponse.fromJson(json.decode(value));

          return response;
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

/* ? */
  Future<dynamic> paymentFromApp(
      String membershipNo,
      String accessCode,
      authorisationCode,
      responseCode,
      responseMessage,
      totalAmount,
      transactionID,
      transactionStatus,
      policyType) async {
    try {
      return BaseClient.get(
              "BuyPlanFromAppNew?"
                  "MembershipNo=$membershipNo"
                  "&AccessCode=$accessCode"
                  "&AuthorisationCode=$authorisationCode"
                  "&ResponseCode=$responseCode"
                  "&ResponseMessage=$responseMessage"
                  "&TransactionID=$transactionID"
                  "&TransactionStatus=$transactionStatus"
                  "&PolicyType=$policyType"
                  "&TotalAmount=$totalAmount",
              "BuyPlanFromAppNew")
          .then((value) {
        if (value != null) {
          var response = json.decode(value);

          return response;
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

/* If user try to Renew the plan this api is called */
  Future<dynamic> paymentFromAppForRenewal(
      String membershipNo,
      String accessCode,
      authorisationCode,
      responseCode,
      responseMessage,
      totalAmount,
      transactionID,
      transactionStatus,
      policyType) async {
    try {
      return BaseClient.get(
              "RenewPlanFromApp?"
                  "MembershipNo=$membershipNo"
                  "&AccessCode=$accessCode"
                  "&AuthorisationCode=$authorisationCode"
                  "&ResponseCode=$responseCode"
                  "&ResponseMessage=$responseMessage"
                  "&TransactionID=$transactionID"
                  "&TransactionStatus=$transactionStatus"
                  "&PolicyType=$policyType"
                  "&TotalAmount=$totalAmount",
              "RenewPlanFromApp")
          .then((value) {
        if (value != null) {
          var response = json.decode(value);

          return response;
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

/* This Api helps to find the services regarding that perticular plan */
  Future<dynamic> getServiceData(String planID) async {
    try {
      return BaseClient.get("PlanID=$planID", "GetServiceAvailable")
          .then((value) {
        if (value != null) {
          var response1 = json.decode(value);
         
          return response1;
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
