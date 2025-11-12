import 'dart:convert';
import 'dart:math';
import 'package:assist/Controllers/global_controller.dart';
import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/apis/apis_constant.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/apis/response/job_data_response.dart';
import 'package:assist/apis/response/jobs_list_response.dart';
import 'package:assist/apis/response/profile_response.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/utils/Widgets/widgets_file.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../utils/common_functions.dart';
import 'package:http/http.dart' as http;

class JobsDataListController extends GetxController {
  var tag = "job data list controller";
  /* this controller used in 2 screen so we diffrenciate the use of this controller by the screens  so we make this variable */
  String? screenType;

  /* Common variables */
  final loading = false.obs;

/* Job Booking List screen variables */
  late Future getJobsListFuture;
  List<OmJobsView> jobListModel = [];
  JobDataResponse? jobDataResponse;
  late Future getJobDataFuture;
  late Future<ProfileResponse> getProfileResponse;
  List<OmJobsView> responseList = [];
  List<OmJobsView> searchList = [];

  final searchController = TextEditingController();
  final global = Get.find<GlobalController>();
  final themeController = Get.find<ThemeController>();

  /* Customer Service details screen variables */
  String? requestFor;

  final isTowing = false.obs;
  final isTyreChanges = false.obs;
  final isOutOfFuelRescue = false.obs;
  final isSpareTyreAvailable = false.obs;
  final isName = true.obs;
  final isMobile = true.obs;
  final isAddress = true.obs;
  final isCurrentAddSuggestion = false.obs;
  final isLandmark = false.obs;
  final isFuelotherOptionTextField = false.obs;
  final isDropLandmark = false.obs;
  final isMechanicDropLandmark = false.obs;
  final isSuggestion = false.obs;
  final isOfficeOpen = true.obs;

  final currentAddress = "".obs;

  final onTime = "".obs;
  final offTime = "".obs;

  final ownership = 1.obs;
  final location = 1.obs;
  final focusFLag = 1.obs;

  final distanceKm = 0.0.obs;

  List<dynamic> placeList = [];
  List<dynamic> dropPlaceList = [];

  String? addressFromLatLong, city, state, postalCode;
  ScrollController controller = ScrollController();

  String cdLat = "";
  String cdLang = "";
  String tdAdress = "";
  String tdLat = "";
  String tdLang = "";
  String dropLandmarkHint = "Landmark";

  IconData iconDropLocationDropDown = Icons.location_on_outlined;

  var uuid = const Uuid();
  String? _sessionToken;

  FocusNode nameFocusNode = FocusNode();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode dropAddNode = FocusNode();
  FocusNode otherAddNode = FocusNode();
  FocusNode otherDropAddNode = FocusNode();
  FocusNode otherFuelType = FocusNode();

  final customerNameController = TextEditingController();
  final mobileController = TextEditingController();
  final currentAddressController = TextEditingController();
  final landmarkController = TextEditingController();
  final dropLandmarkController = TextEditingController();
  final fuelTypeController = TextEditingController();
  final dropAddressController = TextEditingController();

/* Here we initialize controller for Two screens those hanve same fucntions but have diff. work */
  @override
  void onInit() async {
    screenType = Get.arguments["screenType"];
    if (screenType == "CustomrServiceDetails") {
      requestFor = Get.arguments["requestFor"];

      vehicleLocation = 'Vehicle Parked';
      vehicleFuelType = 'Fuel Type';
      vehicleDropLocation = 'Drop Location';

      getSystemSetting().then((value) {
        _getCurrentLocation();
      });

      loading.value = true;
      if (requestFor == "TOWING") {
        isTowing.value = true;
      }
      if (requestFor == "FLAT TYRE") {
        isTyreChanges.value = true;
      }
      if (requestFor == "OUT OF FUEL RESCUE") {
        isOutOfFuelRescue.value = true;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          showDialogForOutOfFuel();
        });
        //
      }

      dropAddressController.addListener(() {
        Future.delayed(const Duration(microseconds: 300), () {
          _onChangedDropAddress();
        });
      });

      currentAddressController.addListener(() {
        Future.delayed(const Duration(microseconds: 300), () {
          _onChangedCurrentAddress();
        });
      });
    } else {
      loading.value = true;
      await getJobList();
    }
    super.onInit();
  }

  @override
  void onClose() {
    if (screenType == "CustomrServiceDetails") {
      addressFocusNode.dispose();
      dropAddNode.dispose();
      otherDropAddNode.dispose();
      otherAddNode.dispose();
      otherFuelType.dispose();
    } else {
      searchController.dispose();
    }
    super.onClose();
  }

  GetJobsByJobIdResponse getJobsByJobIdResponse = GetJobsByJobIdResponse();

/* When page is refresh this function run and update data */
  Future<void> refreshData() async {
    await getJobList();
    return getJobsListFuture;
  }

/* This method handle the search texts */
  onSearchTextChanged(String text) async {
    searchList.clear();
    if (text.isEmpty) {
      update();
      return;
    } else {
      debugPrint("text is $text");
      for (OmJobsView data in jobListModel) {
        if ((data.jobNo ?? "0").contains(text)) {
          searchList.add(data);
        } else if ((data.status ?? 'NA')
            .toLowerCase()
            .contains(text.toLowerCase())) {
          searchList.add(data);
        } else if ((data.title ?? 'NA')
            .toLowerCase()
            .contains(text.toLowerCase())) {
          searchList.add(data);
        }
      }
    }
  }

/* This fucntion is Used to fetch teh customer profile */
  Future<ProfileResponse?> getProfileData(var name) async {
    try {
      return BaseClient.get("CustomerID=$name", "GetCustomerDetails")
          .then((value) {
        if (value != null) {
          ProfileResponse profile =
              ProfileResponse.fromJson(json.decode(value));
          refresh();
          return profile;
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

/* This Api provides us the feedback url */
  Future<String?> getFeedBackURL() async {
    try {
      return BaseClient.get("", 'APIGetSystemSettings').then((value) {
        if (value != null) {
          var jsonDecode = json.decode(value);
          String feedBackUrl = jsonDecode['FeedbackURL'].toString();

          global.setRetailerPhoneNumber(jsonDecode['Def_Number']);
//https://g.page/r/CckdoTfQECflEAg/review
          printMessage(tag, feedBackUrl);

          refresh();
          return feedBackUrl;
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

/* This Api used to fetch the Jobs */
  Future<JobListResponse?> getJobList() async {
    try {
      return BaseClient.get("Phone=${global.customerPhoneNumber.toString()}",
              "GetCustomerJobs")
          .then((value) {
        if (value != null) {
          var jobListResponse = JobListResponse.fromJson(json.decode(value));

          if (jobListResponse.omJobsView != null) {
            jobListModel = jobListResponse.omJobsView!;
            responseList = jobListModel;
            printMessage(tag, "Response length : ${responseList.length}");
          }
          update();
          loading.value = false;
          return jobListResponse;
        } else {
          loading.value = false;
          return null;
        }
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* This api get teh details of that perticular job */
  Future<JobDataResponse?> getJobData(var name) async {
    try {
      return BaseClient.get("JobID=$name", "GetJobsByJobID").then((value) {
        if (value != null) {
          jobDataResponse = JobDataResponse.fromJson(json.decode(value));
          printMessage(tag, 'Title${jobDataResponse?.title}');
          // jobDataResponseList =jobDataResponse;
          refresh();
          return jobDataResponse;
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

/* this fucntion return us the jobs according to the selected model and then it give us the jobs that is available in this membership */
  Future<GetJobsByJobIdResponse?> getJobData2(var name) async {
    try {
      return BaseClient.get(
              //  "GetJobsByJobID?"
              "JobID=$name",
              "GetJobsByJobID")
          .then((value) {
        if (value != null) {
          getJobsByJobIdResponse =
              GetJobsByJobIdResponse.fromJson(json.decode(value));
          printMessage(
              tag, 'Title${getJobsByJobIdResponse.omJobsView?[0].title}');
          refresh();
          return getJobsByJobIdResponse;
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

/*----------------------------------- Customer Services Details Screen Functions and Methods ---------------------------------------------- */

/* This Api fetch the Office time and show status, when user go to book a job */
  Future<dynamic> getSystemSetting() async {
    try {
      BaseClient.get("", "GetOfficeOpenOrClosed").then((value) {
        if (value != null) {
          var systemData = jsonDecode(value);

          if (systemData.containsKey("BHEndTime")) {
            onTime.value = systemData['BHStartTime'];
            offTime.value = systemData['BHEndTime'];
            var statusCode = systemData['StatusCode'];

            if (onTime.value.isNotEmpty && offTime.value.isNotEmpty) {
              var inputFormat = DateFormat('HH:mm');
              var inputDateOnTime =
                  inputFormat.parse(systemData['BHStartTime'].toString());
              var inputDateOutTime = inputFormat.parse(systemData['BHEndTime']);

              var outputFormat = DateFormat('hh:mm a');
              onTime.value = outputFormat.format(inputDateOnTime);
              offTime.value = outputFormat.format(inputDateOutTime);

              if (statusCode == 1) {
                isOfficeOpen.value = true;
              } else {
                isOfficeOpen.value = false;
              }

              global.setOfficeOnOff(isOfficeOpen.value);
            }
            return jsonDecode(value);
          }
          return null;
        } else {
          return false;
        }
      });
    } catch (e) {
      printMessage(tag, "Error ---> $e");
      return null;
    }
  }

  _getCurrentLocation() async {
    double latitude;
    double longitude;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      latitude = position.latitude;
      longitude = position.longitude;
      printMessage(tag, 'latitude.. cs $latitude');
      printMessage(tag, 'longitude.. cs $longitude');

      setupProfile(position.latitude, position.longitude);
      update();
    }).catchError((e) {
      printMessage(tag, "Error : $e");
    });
  }

  _onChangedDropAddress() {
    _sessionToken ??= uuid.v4();
    getSuggestionForDrop(dropAddressController.text);
  }

  _onChangedCurrentAddress() {
    _sessionToken ??= uuid.v4();
    getSuggestion(currentAddressController.text);
  }

  void scrollDown() {
    // ignore: invalid_use_of_protected_member
    if (currentAddressController.hasListeners) {
      controller.jumpTo(20);
    }
    // ignore: invalid_use_of_protected_member
    if (dropAddressController.hasListeners) {
      dropPlaceList.isNotEmpty
          ? controller.jumpTo(controller.position.maxScrollExtent)
          : controller.jumpTo(controller.position.maxScrollExtent);
    }
    // ignore: invalid_use_of_protected_member
    if (landmarkController.hasListeners) {
      controller.jumpTo(controller.position.maxScrollExtent);
    }
  }

  void getSuggestionForDrop(String input) async {
    String apiKey = APIsConstant().googleApiKey;

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String request =
        '$baseURL?input=$input&key=$apiKey&components=country:aus&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      debugPrint("google address api response");

      dropPlaceList = json.decode(response.body)['predictions'];
      update();
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  void getSuggestion(String input) async {
    String apiKey = APIsConstant().googleApiKey;

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String request =
        '$baseURL?input=$input&key=$apiKey&components=country:aus&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      debugPrint("google address api response");

      placeList = json.decode(response.body)['predictions'];
      update();
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Future<void> getLatLangFromAddress(String query) async {
    debugPrint('dfafa');
    var address = await GeocodingPlatform.instance!.locationFromAddress(query);
    var firsts = address.first;

    // ignore: unused_local_variable
    var isCoordinates = true;
    printMessage(tag, "${firsts.timestamp} : $firsts");
    tdAdress = query;
    tdLang = firsts.longitude.toString();
    tdLat = firsts.latitude.toString();
    debugPrint('Lattitude$tdLat');

    //return firsts;
  }

  setupProfile(var lat, long) async {
    await getAddressFromLatLng(lat, long).then((value) {
      printMessage(tag, "address in customer page ===$value");
      getLatLangFromCurrentAddress(value ?? "");
      currentAddress.value = value.toString();
      getProfileData(global.userId.toString()).then((value) {
        if (value != null) {
          printMessage(tag, "Profile Response : $value");

          loading.value = false;
          customerNameController.text = "${value.firstName} ${value.lastName}";
          mobileController.text = value.phone!.replaceFirst("0", "");
        }
      });

      currentAddressController.text = currentAddress.value;
      update();
    });
  }

  Future getLatLangFromCurrentAddress(String query) async {
    addressFocusNode.unfocus();

    var address = await GeocodingPlatform.instance!.locationFromAddress(query);
    var firsts = address.first;

    // ignore: unused_local_variable
    var isCoordinates = true;
    // ignore: unused_local_variable
    var cdAdress = query;
    cdLang = firsts.longitude.toString();
    cdLat = firsts.latitude.toString();

    getAddressFromLatLong(double.parse(cdLat), double.parse(cdLang));
  }

  Future<String?> getAddressFromLatLong(double lat, double long) async {
    var address = await placemarkFromCoordinates(lat, long);
    var firsts = address.first;

    addressFromLatLong =
        "${firsts.street} ${firsts.subLocality} ${firsts.locality} ${firsts.postalCode}";

    city = firsts.locality;
    postalCode = firsts.postalCode;

    switch (firsts.administrativeArea) {
      case 'New South Wales':
        state = "NSW";
        break;
      case 'Victoria':
        state = "VIC";
        break;
      case 'South Australia':
        state = "SA";
        break;
      case 'Western Australia':
        state = "WA";
        break;
      case 'Northern Territory':
        state = "NT";
        break;
      case 'Queensland':
        state = "QLD";
        break;
      case 'Tasmania':
        state = "TAS";
        break;
      case 'Australian Capital Territory':
        state = "ACT";
        break;
      default:
        state = "";
        break;
    }
    return addressFromLatLong;
  }

  distanceInKmBetweenEarthCoordinates(
      double lat1, double lon1, double lat2, double lon2) {
    debugPrint("$lat1");
    debugPrint("$lon1");
    debugPrint("$lat2");
    debugPrint("$lon2");
    const earthRadiusKm = 6371;
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final radLat1 = _degreesToRadians(lat1);
    final radLat2 = _degreesToRadians(lat2);

    final a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) * cos(radLat1) * cos(radLat2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    distanceKm.value = double.parse((earthRadiusKm * c).toStringAsFixed(2));

    debugPrint("distance is ====${distanceKm.value}");
    debugPrint("lat1 is ====$lat1");
    debugPrint("long1 is ====$lon1");
    debugPrint("lat2 is ====$lat2");
    debugPrint("long2 is ====$lon2");
    update();
  }

  double _degreesToRadians(degrees) {
    return degrees * pi / 180;
  }

  calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

    debugPrint("data of distance ===${12742 * asin(sqrt(a))}");

    distanceKm.value = 12742 * asin(sqrt(a));
    update();
  }

  distanceCalculator() async {
    debugPrint("$cdLang $cdLang $tdLat $tdLang");
    final distance = Geolocator.distanceBetween(
      double.parse(cdLat),
      double.parse(cdLang),
      double.parse(tdLat),
      double.parse(tdLang),
    );

    distanceKm.value = double.parse((distance / 1000).toStringAsFixed(2));
    update();
    //  var distanceKM = distance/1000;

    debugPrint("Distance is ===${distanceKm.value}");
  }

/* This can check that the address is fill by the user is valid or not? */
  bool isValid() {
    bool checkCurrentAddress = false;
    bool checkDropAddress = false;
    for (int i = 0; i < placeList.length; i++) {
      var item = placeList[i]["description"];

      if (currentAddressController.text == item) {
        checkCurrentAddress = true;
        break;
      }
    }
    for (int i = 0; i < dropPlaceList.length; i++) {
      var item = dropPlaceList[i]["description"];

      if (dropAddressController.text == item) {
        checkDropAddress = true;
        break;
      }
    }

    if (customerNameController.text.toString().isEmpty) {
      const CustomWidgets().snackBar(Get.context!, errorEnterYourName);
      return false;
    } else if (mobileController.text.toString().isEmpty) {
      const CustomWidgets().snackBar(Get.context!, errorEnterCorrectMobile);
      return false;
    } else if (mobileController.text.length < 9) {
      const CustomWidgets().snackBar(Get.context!, errorEnterCorrectMobile);
      return false;
    } else if (currentAddressController.text.toString().trim().isEmpty) {
      const CustomWidgets().snackBar(Get.context!, errorEnterYourAddress);
      return false;
    } else if (checkCurrentAddress == false && location.value != 1) {
      const CustomWidgets().snackBar(Get.context!, errorSelectAddress);
      return false;
    } else if (landmarkController.text.toString().trim().isEmpty) {
      const CustomWidgets().snackBar(Get.context!, errorChooseLocation);
      return false;
    } else if (isTowing.value) {
      if (dropAddressController.text.trim().isEmpty) {
        const CustomWidgets().snackBar(Get.context!, errorDropLocation);
        return false;
      } else if (checkDropAddress == false) {
        const CustomWidgets().snackBar(Get.context!, errorSelectDropAddress);
        return false;
      }

      if (dropLandmarkController.text.trim().isEmpty) {
        const CustomWidgets().snackBar(Get.context!, errorDropLocationLandmak);
        return false;
      }
    } else if (isOutOfFuelRescue.value) {
      if (fuelTypeController.text.trim().isEmpty) {
        const CustomWidgets().snackBar(Get.context!, errorFuelType);
        return false;
      }
    }

    return true;
  }
}
