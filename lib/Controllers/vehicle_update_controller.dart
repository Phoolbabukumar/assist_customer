import 'dart:convert';
import 'package:assist/Controllers/buy_assistance_controller.dart';
import 'package:assist/Controllers/my_member_ships_controller.dart';
import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/apis/apis_constant.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/apis/response/membership_model_plan_details.dart';
import 'package:assist/apis/response/vehicle_list_response.dart';
import 'package:assist/apis/response/vehicle_makelist_response.dart';
import 'package:assist/apis/response/vehicle_model_list_response.dart';
import 'package:assist/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VehicleUpdateController extends GetxController {
  /* these are the arguments we take from vehicleAdd and PlanDetails screen */
  String? planID;
  String? planName;
  String? vehicleType;
  String? otherVehicleAdd;
  String? amount;
  String? userId;
  int? loginWay;
  /* These arguments from plan details screen */
  String? screenType;
  String? customerId;

/* controllers those are used in this controller */
  MyMemberShipsController? myMemberShipsController;
  final buyAssistanceController = Get.find<BuyAssistanceController>();
  final themecontroller = Get.find<ThemeController>();

/* variables used in both screens */
  var tag = "VehicleUpdateController";
  late Future makeListResponse;
  late Future modelListResponse;
  List<MakeListModel> makeList = [];
  List<VehicleModelListModel> modelList = [];
  String? chosenMakeValue;
  String? chosenModelValue;

  // for normal vehicle variabless........
  String? height;
  String? width;
  String? length;
  String? weight;
  int? makeId;
  String? modelId;
  String? vehicleId;
  final bodyType = "".obs;
  final chooseYearValue = 'Select Year'.obs;
  final chooseMake = 'Select Make'.obs;
  final chooseModel = 'Select Model'.obs;
  final heightEnable = true.obs;
  final widthEnable = true.obs;
  final weightEnable = true.obs;
  final lengthEnable = true.obs;
  final heightVisible = false.obs;
  final widthVisible = false.obs;
  final weightVisible = false.obs;
  final lengthVisible = false.obs;
  final isCarAdd = false.obs;
  final isCaravanAdd = false.obs;

  // for car + caravan vehicle variables........
  int? carMakeId;
  String? carModelId;
  String? carVehicleId;
  final carBodyType = ''.obs;
  final carChooseYearValue = 'Select Year'.obs;
  final carChooseMake = 'Select Make'.obs;
  final carChooseModel = 'Select Model'.obs;

  /* Lists those used in Both screens */
  List<String> makeItems = [];
  List<String> modelItems = [];
  List<String> yearsList = [];
  List<String> carMakeItems = [];
  List<String> carModelItems = [];
  List<String> carYearsList = [];
  RxList<VehicleModelListModel> carModelList = <VehicleModelListModel>[].obs;

  /* Controllers */
  final regoController = TextEditingController();
  final colorController = TextEditingController();
  final weightController = TextEditingController();
  final lengthController = TextEditingController();
  final heightController = TextEditingController();
  final widthController = TextEditingController();
  final carRegoController = TextEditingController();
  final carColorController = TextEditingController();

  final isCaravanExpanded = false.obs;
  final isCarExpanded = false.obs;
  String url = "";

/* variables used in Plan detail screen */
  final loading = false.obs;
  PlanDetailsMembershipListModel? response;
  String? carVehicleMake;
  String? carVehicleModel;
  final updateVehicleType = "".obs;

/* Vehicle edit screen variable */
  Vehicles? vehicleListResponse;
  String? membershipNo;

/* init that maintain by the screen types because This controller class is initialized in two screen */
  @override
  void onInit() {
    super.onInit();
    screenType = Get.arguments['screenType'] ?? "";
    if (screenType == "VehicleAdd") {
      myMemberShipsController = Get.put(MyMemberShipsController());
      planID = Get.arguments['planID'] ?? "0";
      planName = Get.arguments['planName'] ?? "";
      vehicleType = Get.arguments['vehicleType'] ?? "";
      otherVehicleAdd = Get.arguments['otherVehicleAdd'] ?? "";
      amount = Get.arguments['amount'] ?? "";
      userId = Get.arguments['userId'] ?? "";
      loginWay = Get.arguments['loginWay'] ?? 0;
      generateListOfYears();
      makeItems.clear();
      carMakeItems.clear();

      serviceData().then((_) {
        vehicleMakeList().then((_) {
          makeItems.addAll(makeList.map((item) => item.make ?? '').toList());
          carMakeItems.addAll(makeList.map((item) => item.make ?? '').toList());
          SchedulerBinding.instance.addPostFrameCallback((_) => Get.back());
        });
      });
    } else if (screenType == "VehicleEdit") {
      vehicleListResponse = Get.arguments["vehicleListResponse"];
      membershipNo = Get.arguments["membershipNo"];
      planID = Get.arguments["planId"];
      myMemberShipsController = Get.find<MyMemberShipsController>();
      weightController.text = "0.0";
      lengthController.text = "0.0";
      widthController.text = "0.0";
      heightController.text = "0.0";

      generateListOfYears();

      vehicleId = vehicleListResponse?.vehicleID.toString() ?? "";
      makeId = vehicleListResponse?.vehicleInfo?.makeID;
      modelId = vehicleListResponse?.modelInfo?.modelID.toString() ?? "";
      bodyType.value = vehicleListResponse?.modelInfo?.type ?? "";
      chooseYearValue.value = vehicleListResponse?.year ?? "";
      regoController.text = vehicleListResponse?.rego ?? "";
      colorController.text = vehicleListResponse?.colour ?? "";
      chosenMakeValue = vehicleListResponse?.make ?? "";

      if (bodyType.value == "Caravan") {
        weightController.text = "${vehicleListResponse?.vehicleWeight ?? 0.0}";
        lengthController.text = "${vehicleListResponse?.vehicleLength ?? 0.0}";
        widthController.text = "${vehicleListResponse?.vehicleWidth ?? 0.0}";
        heightController.text = "${vehicleListResponse?.vehicleHeight ?? 0.0}";

        debugPrint("$width $length $weight $height");

        if (weightController.text.isNotEmpty) {
          weightVisible.value = true;
          weightEnable.value = false;
        }
        if (heightController.text.isNotEmpty) {
          heightVisible.value = true;
          heightEnable.value = false;
        }
        if (widthController.text.isNotEmpty) {
          widthVisible.value = true;
          widthEnable.value = false;
        }
        if (lengthController.text.isNotEmpty) {
          lengthVisible.value = true;
          lengthEnable.value = false;
        }
      }

      chosenModelValue = vehicleListResponse?.model;

      serviceData().then((value) {
        vehicleMakeList().then((value) {
          vehicleModelList(makeId.toString()).then((value) {
            printMessage(tag, "it's in side");
            for (var item in modelList) {
              if (item.type == vehicleListResponse?.vehicleType) {
                modelItems.add(item.modelName ?? "");
              }
            }
            for (var item in makeList) {
              makeItems.add(item.make ?? '');
            }
          });
        });
      });
    } else {
      myMemberShipsController = Get.find<MyMemberShipsController>();

      customerId = Get.arguments["customerId"];
      generateListOfYears();
      makeItems.clear();
      carMakeItems.clear();
      loading.value = true;

      getMembershipDetail().then((value) {
        getVehicleDetails();
        vehicleMakeList().then((value) {
          for (var item in makeList) {
            makeItems.add(item.make ?? '');
            carMakeItems.add(item.make ?? '');
          }
        });
      });
    }
  }

/* This method generate the list of years that is show in vehicle add page dropdown */
  void generateListOfYears() {
    DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy');
    int year = int.parse(formatter.format(now).toString());
    printMessage(tag, "Current Year : $year");
    for (int i = 2000; i <= year; i++) {
      //var x = i;
      yearsList.add(i.toString());
      carYearsList.add(i.toString());
    }
  }

/* This function call GetServiceAvailable api that give the services for a perticular plan */
  Future<void> serviceData() async {
    await buyAssistanceController
        .getServiceData(planID.toString())
        .then((value) {
      debugPrint("service list data is===========$value");
      if (value != null) {
        /// now we save things directly not use any model because of caravan separation api give direct values
        width = value["VehicleWidth"].toString();
        length = value["VehicleLength"].toString();
        height = value["VehicleHeight"].toString();
        weight = value["VehicleWeight"].toString();
        /*for (int i = 0; i < value.length; i++) {
          if (value[i].service.toString().toLowerCase() ==
              "Width (in meters)".toLowerCase()) {
            width = value[i].unit.toString();

            debugPrint("width is ==$width");
          } else if (value[i].service.toString().toLowerCase() ==
              "Length (in meters)".toLowerCase()) {
            length = value[i].unit.toString();

            debugPrint("width is ==$length");
          } else if (value[i].service.toString().toLowerCase() ==
              "Height (in meters)".toLowerCase()) {
            height = value[i].unit.toString();

            debugPrint("width is ==$height");
          } else if (value[i].service.toString().toLowerCase() ==
              "Weight (GVM in Ton)".toLowerCase()) {
            weight = value[i].unit.toString();

            debugPrint("width is ==$weight");
          }
        }*/
      }
    });
  }

/* This api called after make is selected */
  Future<void> modelApiCall(makeId) async {
    modelItems.clear();
    await vehicleModelList(makeId.toString()).then((value) {
      printMessage(tag, "it's in side");
      for (var item in value ?? []) {
        if (item.type == vehicleType?.replaceAll('_', ' ')) {
          modelItems.add(item.modelName);
        }
      }
      update();
    });
  }

/* this method used to get the terms and conditions url from type */
  getTermsandConditions(String? npVehicleType) {
    switch (npVehicleType) {
      case "Car/Trailer":
        {
          url = APIsConstant().carTermConditionURl;
        }
        break;
      case "Motorhome":
        {
          url = APIsConstant().motorhomeTermConditionURl;
        }
        break;
      case "Caravan":
        {
          url = APIsConstant().caravanTermConditionURl;
        }
        break;
      case "Mobility Scooter":
        {
          url = APIsConstant().mobilityScooterTermConditionURl;
        }
        break;
      case "Mobility_Scooter":
        {
          url = APIsConstant().mobilityScooterTermConditionURl;
        }
        break;
      case "Bike":
        {
          url = APIsConstant().bikeTermConditionURl;
        }
        break;
    }
  }

/* This api Update the vehicle details from DB */
  Future<dynamic> vehicleUpdate(
      String vehicleId,
      makeId,
      modelId,
      color,
      year,
      rego,
      bodytype,
      var weight,
      width,
      height,
      length,
      String membershipNo) async {
    try {
       final type =
          bodytype == "Mobility Scooter" ? "Mobility_Scooter" : bodytype;
      return BaseClient.get(
              "VehicleID=$vehicleId"
                  "&MembershipNo=$membershipNo"
                  "&MakeID=$makeId"
                  "&ModelID=$modelId"
                  "&Colour=$color"
                  "&Year=$year"
                  "&BodyType=$type"
                  "&Rego=$rego"
                  "&VehicleWeight=$weight"
                  "&VehicleWidth=$width"
                  "&VehicleHeight=$height"
                  "&VehicleLength=$length",
              "UpdateVehicle")
          .then((value) {
        return null;
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* If user have car+caravan Plan then this api helps to add two different type of vehicles */
  Future<dynamic> secondVehicleUpdate(
      String planId,
      makeId,
      modelId,
      color,
      year,
      rego,
      bodytype,
      var weight,
      width,
      height,
      length,
      String membershipNo,
      String regoSecondVehicle,
      yearSecondVehicle,
      bodyTypeSecondVehicle,
      modelNameSecondVehicle,
      makeNameSecondVehicle,
      colorSecondVehicle) async {
    try {
      return BaseClient.get(
              "&PlanID=$planId"
                  "&MembershipNo=$membershipNo"
                  "&VehicleMake=$makeId"
                  "&VehicleModel=$modelId"
                  "&Colour=$color"
                  "&Year=$year"
                  "&BodyType=$bodytype"
                  "&Rego=$rego"
                  "&VehicleWeight=$weight"
                  "&VehicleWidth=$width"
                  "&VehicleHeight=$height"
                  "&VehicleLength=$length"
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
              "APIAddSecondVehicle")
          .then((value) {
        return null;
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

  Future<dynamic> addVehicleDetailByPlanDetail(
    makeId,
    modelId,
    color,
    year,
    rego,
    bodytype,
    var weight,
    width,
    height,
    length,
    String membershipNo,
  ) async {
    try {
      return BaseClient.get(
              "APIAddVehicleFromApp?"
                  "&MembershipNo=$membershipNo"
                  "&VehicleMake=$makeId"
                  "&VehicleModel=$modelId"
                  "&Colour=$color"
                  "&Year=$year"
                  "&BodyType=$bodytype"
                  "&Rego=$rego"
                  "&VehicleWeight=$weight"
                  "&VehicleWidth=$width"
                  "&VehicleHeight=$height"
                  "&VehicleLength=$length",
              "APIAddVehicleFromApp")
          .then((value) {
        return null;
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* This api returns the Car Company list */
  Future<List<MakeListModel>?> vehicleMakeList() async {
    try {
      return BaseClient.get("", "GetVehicleMakeList").then((value) {
        var response1 = VehicleMakeListResponse.fromJson(json.decode(value));
        makeList = response1.response;

        refresh();
        return makeList;
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* This Api get the model list according to the selected company */
  Future<List<VehicleModelListModel>?> vehicleModelList(makeId) async {
    try {
      return BaseClient.get("Make=${makeId.toString()}", "GetModelByMakeID")
          .then((value) {
        try {
          if (value != null) {
            debugPrint("value is ==$value");
            var response1 =
                VehicleModelListResponse.fromJson(json.decode(value));
            modelList = response1.response;
            refresh();
            return modelList;
          } else {
            return null;
          }
        } catch (e) {
          return null;
        }
      });
    } catch (e, stacktrace) {
      Get.back();
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/*--------------------------------- Plan Details screen functions ------------------------------------------------------ */
  getVehicleDetails() {
    myMemberShipsController!.myVehicleListResponse = myMemberShipsController!
        .getVehicleList(customerId.toString())
        .whenComplete(() {
      printMessage(tag,
          "Vehicle Length : ${myMemberShipsController!.vehicleList.length}");
      loading.value = false;
    });
  }

/* This api return the list of purchased membersips by the user */
  Future<PlanDetailsMembershipListModel?> getMembershipDetail() async {
    myMemberShipsController!.membershipDetailFuture = myMemberShipsController!
        .getMembershipDetail(customerId.toString())
        .then((value) {
      printMessage(tag, "membership detail: ");
      serviceData();
      response = value;
      loading.value = false;
      return response;
    });
    return null;
  }
}
