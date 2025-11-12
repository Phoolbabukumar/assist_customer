import 'dart:convert';
import 'package:assist/Controllers/login_controller.dart';
import 'package:assist/apis/apis_constant.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../utils/common_functions.dart';
import 'package:http/http.dart' as http;

class SignUpController extends GetxController {
  String? screenType;

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final loginController = Get.find<LoginController>();

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode mobileNumberFocusNode = FocusNode();

  RegExp emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  /*VerifySignUp screen variables */

  String? currentAddress;
  String? addressFromLatLong;
  String? city;
  String? postalCode;
  String? state;

  String? mobile;
  String? emailArgu;

  final addressController = TextEditingController(text: " ");
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isCurrentAddSuggestion = false.obs;
  final passwordVisible = true.obs;
  final confirmPasswordVisible = true.obs;

  void togglePasswordVisible() {
    passwordVisible.value = !passwordVisible.value;
  }

  void toggleConfirmPasswordVisible() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }

  List<dynamic> placeList = [];
  ScrollController controller = ScrollController();
  FocusNode addressFocusNode = FocusNode();

  var uuid = const Uuid();
  String? _sessionToken;

  final isLoading = false.obs;
  final permissionsEnabled = true.obs;
  final sms = true.obs;
  final post = true.obs;
  final email = true.obs;
  final isAddressChange = false.obs;

  @override
  void onInit() {
    screenType = Get.arguments["screenType"];
    if (screenType == "VerifySignUp") {
      mobile = Get.arguments["mobile"];
      emailArgu = Get.arguments["email"];
      isLoading.value = true;
      isAddressChange.value = false;
      mobileNumberController.text = mobile!;
      emailController.text = emailArgu!;
      printMessage(tag, "Permissions : ${permissionsEnabled.value}");
      global.requestLocationPermission();
      global.checkGPSAndLocationPermission().then((value) {
        printMessage(tag, "Permissions value : $value");
        global.setPermission(value);
        permissionsEnabled.value = value;
      });
      handleAppLifecycleState();
      _getCurrentLocation().then((value) {
        isLoading.value = false;
      });

      addressController.addListener(() {
        Future.delayed(const Duration(microseconds: 300), () {
          _onChangedCurrentAddress();
        });
      });
    }
    super.onInit();
  }

  closeKeyBoard() {
    Get.focusScope!.requestFocus(FocusNode());
    // FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

/* If number is not exist then this function is called and send the otp */
  Future<dynamic> sendOTPToSignUp(
      String firstName, String lastName, String phone, String email) async {
    try {
      debugPrint("ssss==$phone");
      phone = phone.toString().contains("+")
          ? phone.toString().replaceAll("+", '%2B')
          : phone;
      return BaseClient.get(
              "Phone=$phone"
                  "&FirstName=$firstName"
                  "&LastName=$lastName"
                  "&Email=$email",
              "APISignUPCustomerFromApp")
          .then((value) {
        if (value != null) {
          var response = json.decode(value);
          refresh();
          return response;
        } else {
          return null;
        }
      });
    } catch (e, stacktrace) {
      printMessage("SignUpController", e);
      printMessage("SignUpController", stacktrace);
      return null;
    }
  }

/* This api call from verify signup screen */ // I will update this comment again
  Future<dynamic> addRemainingDataToSignUp(String customerId, String address,
      city, state, postalCode, String password, String checked) async {
    try {
      return BaseClient.postNew(
              "Address=$address"
                  "&CustomerID=$customerId"
                  "&Pass=${Uri.encodeQueryComponent(password)}"
                  "&City=$city"
                  "&State=$state"
                  "&PostalCode=$postalCode"
                  "&ContactYou=$checked",
              "APICompleteCustomerFromAPP")
          .then((value) {
        if (value != null) {
          var response = json.decode(value);
          refresh();
          return response;
        } else {
          return null;
        }
      });
    } catch (e, stacktrace) {
      printMessage("SignUpController", e);
      printMessage("SignUpController", stacktrace);
      return null;
    }
  }

/* --------------------------------------- Verify SignUp screen Functions ---------------------------------------------- */

  /* This means it handle the gogle map lifeCycle because it change it location at runtime */
  handleAppLifecycleState() {
    SystemChannels.lifecycle.setMessageHandler((stateMessage) async {
      switch (stateMessage) {
        case "AppLifecycleState.resumed":
          global.checkGPSAndLocationPermission().then((value) {
            global.setPermission(value);
            permissionsEnabled.value = value;
          });
          break;
        default:
      }
      return null;
    });
  }

/* when user changeit location at runtime this fucntion get it's location again */
  Future _getCurrentLocation() async {
    double latitude;
    double longitude;

    debugPrint("in current location");

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      latitude = position.latitude;
      longitude = position.longitude;
      printMessage(tag, 'latitude.. cs $latitude');
      printMessage(tag, 'longitude.. cs $longitude');

      setup(position.latitude, position.longitude);
    }).catchError((e) {
      printMessage(tag, "Error : $e");
    });
  }

/* After get the location get the lat lng from this method */
  getLatLangFromCurrentAddress(String query) async {
    addressFocusNode.unfocus();

    var address = await GeocodingPlatform.instance!.locationFromAddress(query);
    var firsts = address.first;
    var cdAdress = query;
    var cdLang = firsts.longitude.toString();
    var cdLat = firsts.latitude.toString();
    addressFromLatLong = query;
    debugPrint("offf===$cdAdress");
    getAddressFromLatLong(double.parse(cdLat), double.parse(cdLang));
  }

/* After get the location set lat olng of this */
  setup(var lat, long) async {
    await getAddressFromLatLng(lat, long).then((value) {
      printMessage(tag, "address in customer page ===$value");
      getLatLangFromCurrentAddress(value ?? "");
      currentAddress = value.toString();
      addressController.text = currentAddress ?? "";
    });
  }

  Future<String?> getAddressFromLatLong(double lat, double long) async {
    var address = await placemarkFromCoordinates(lat, long);
    var firsts = address.first;

    debugPrint("this is address =====$firsts");
    //addressFromLatLong = "${firsts.subLocality} ${firsts.locality} ${firsts.postalCode}";

    debugPrint("this is address ==addressFromLatLong===$addressFromLatLong");

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

/* In Address textfield when user change the address it suggest the locations accordingly */
  _onChangedCurrentAddress() {
    _sessionToken ??= uuid.v4();
    getSuggestion(addressController.value.text, types: 'geocode');
  }

  void getSuggestion(String input, {String types = 'geocode'}) async {
    String googleApiKey = APIsConstant().googleApiKey;

    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$googleApiKey&components=country:aus&sessiontoken=$_sessionToken&types=$types';
    debugPrint(request);

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      placeList = json.decode(response.body)['predictions'];
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}
