import 'dart:convert';
import 'dart:io';
import 'package:assist/Controllers/global_controller.dart';
import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/apis/apis_constant.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/apis/response/profile_response.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/utils/Widgets/widgets_file.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/common_functions.dart';
import 'package:http/http.dart' as http;

class ProfileDataController extends GetxController {
  var tag = "ProfileDataController";
  late Future getProfileResponse;
  final mobileNO = "".obs;
  final profileUrl = "".obs;
  int? otpLength;
  String checkData = "";
  final sms = false.obs;
  final post = false.obs;
  final email = false.obs;

  final globals = Get.find<GlobalController>();
  final themecontroller = Get.find<ThemeController>();

  final mobileController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final addressController = TextEditingController().obs;
  final firstNameController = TextEditingController().obs;
  final lastNameController = TextEditingController().obs;
  final planNameController = TextEditingController().obs;
  final cityController = TextEditingController().obs;
  final stateController = TextEditingController().obs;
  final pincodeController = TextEditingController().obs;

/*Profile screen variables */
  final userId = global.userId.toString();
  final isLoading = false.obs;
  final isFirstName = true.obs;
  final isLastName = true.obs;
  final isEmail = true.obs;
  final isAddress = true.obs;
  final isAddressChange = false.obs;
  final isCurrentAddSuggestion = false.obs;
  final isCoordinates = false.obs;
  final ImagePicker _picker = ImagePicker();
  var imagePicked = Rxn<File>();
  final sessionToken = "".obs;
  final chooseAddress = "".obs;
  final chooseAddressLat = "".obs;
  final chooseAddressLong = "".obs;
  final chooseAddressState = "".obs;
  final chooseAddressCity = "".obs;
  final chooseAddressPinCode = "".obs;
  List<dynamic> placeList = [];

/* Helps to change the screen state when user tap on edit  and update button */
  void toggleProfileEditButton() {
    isFirstName.value = !isFirstName.value;
    isLastName.value = !isLastName.value;
    isAddress.value = !isAddress.value;
    isEmail.value = !isEmail.value;
  }

/* This function fetch the user data from api */
  Future<ProfileResponse?> getProfileList() async {
    try {
      isLoading.value = true;
      profileUrl.value = "";
      return BaseClient.get(
              "CustomerID=${globals.userId.toString()}", "GetCustomerDetails")
          .then((value) {
        printMessage(tag, "Profile res :$value");
        if (value != null) {
          var profileResponse = ProfileResponse.fromJson(json.decode(value));
          mobileNO.value = profileResponse.phone ?? "";
          profileUrl.value = profileResponse.customerPicURL ?? "";
          checkData = profileResponse.contactYou ?? '';

          globals.setProfileImageAndName(profileResponse.customerPicURL ?? "",
              profileResponse.firstName ?? '');
          globals.setCustomerPhoneNumber(profileResponse.phone);

          firstNameController.value.text = profileResponse.firstName.toString();
          mobileController.value.text = profileResponse.phone.toString();
          emailController.value.text = profileResponse.email.toString();
          lastNameController.value.text = profileResponse.lastName.toString();
          addressController.value.text =
              profileResponse.address.toString().replaceAll('%20', ' ');
          planNameController.value.text = profileResponse.planName.toString();

          cityController.value.text = profileResponse.city.toString();
          stateController.value.text = profileResponse.state.toString();
          pincodeController.value.text = profileResponse.postalCode.toString();
          if (checkData.isNotEmpty) {
            if (checkData.toLowerCase().contains("sms")) {
              sms.value = true;
            }
            if (checkData.toLowerCase().contains("post")) {
              post.value = true;
            }
            if (checkData.toLowerCase().contains("email")) {
              email.value = true;
            }
          }
          isLoading.value = false;
          update();
          return profileResponse;
        } else {
          isLoading.value = false;
          update();
          return null;
        }
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* This is a custome function used to handle camera and gallery permissios acccording to the diff. scenerios and devices */
  Future<void> handlePermissionAndPickImage(ImageSource source) async {
    PermissionStatus status;
    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      // For gallery, we'll try photos permission first, then fall back to storage
      status = await Permission.photos.request();
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
    }
    switch (status) {
      case PermissionStatus.granted:
        source == ImageSource.camera ? getCaptureImage() : getImage();
        break;
      case PermissionStatus.permanentlyDenied:
        showPermissionDeniedDialog(
            permission: source == ImageSource.camera ? "Camera" : "Gallery");
        break;
      case PermissionStatus.limited:
        if (source == ImageSource.gallery) {
          getImage();
        }
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        break;
      default:
        // Handle any other status
        debugPrint("Unexpected permission status: $status");
    }
  }

  /* This function is used to pic image from gallery */
  Future getImage() async {
    imageCache.clear();
    printMessage(tag, "picked up from galleryddddd");

    try {
      var image = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 20);
      if (image != null) {
        imagePicked.value = File(image.path.toString());

        printMessage(tag, image.path);
        imagePicked.value = File(image.path.toString());
      }
      printMessage(tag, "picked up from gallery");
      submitImage(imagePicked.value!);
    } catch (e) {
      // show Dialog for open settings here..
      debugPrint("Galery error: $e");
    }
  }

/* This Function capture image from camera */
  Future getCaptureImage() async {
    try {
      XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 20); //.pickImage(source: ImageSource.camera));
      imagePicked.value = File(image!.path);

      submitImage(imagePicked.value!);
    } catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  /* for submit the selected image on the server */
  submitImage(File image) async {
    printMessage(tag, "Sending Image to Server");
    // ignore: unused_local_variable
    final response = await http
        .post(
      Uri.parse(APIsConstant().picURL),
      headers: {"content-type": "application/json"},
      body: jsonEncode({
        //"CustomerID": global.name.toString(),
        "CustomerID": globals.userId.toString(),
        //   "APIKey": APIsConstant().getAPIKey(),
        "Type": "jpg",
        'ProfilePicData':
            // ignore: unnecessary_null_comparison
            image != null ? base64Encode(image.readAsBytesSync()) : '',
        'token': globals.currentToken
      }),
    )
        .then((value) async {
      isLoading.value = true;

      printMessage(tag, "image is== ");
      printMessage(tag, value);
      await getProfileList();
    });
  }

/* This function is used to validate the teh textfields and perform accordingly */
  bool isValid() {
    final emailPattern = RegExp(
        r'^(([^<>()[\]\\...,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    bool checkCurrentAddress = false;

    for (int i = 0; i < placeList.length; i++) {
      var item = placeList[i]["description"];

      if (addressController.value.text == item) {
        checkCurrentAddress = true;
        break;
      }
    }

    if (isFirstName.value) {
      const CustomWidgets().snackBar(Get.context!, errorNoEditAvaiable);
      return false;
    } else if (firstNameController.value.value.text.trim().isEmpty) {
      const CustomWidgets().snackBar(Get.context!, errorEnterFirstName);
      return false;
    } else if (lastNameController.value.value.text.trim().isEmpty) {
      const CustomWidgets().snackBar(Get.context!, errorEnterLastName);
      return false;
    } else if (emailController.value.value.text.trim().isEmpty ||
        !emailPattern.hasMatch(emailController.value.value.text)) {
      const CustomWidgets().snackBar(Get.context!, errorEnterVaildEmail);
      return false;
    } else if (addressController.value.value.text.trim().isEmpty) {
      const CustomWidgets().snackBar(Get.context!, labelEnterYourAddress);
      return false;
    }
    if (isAddressChange.value) {
      if (!checkCurrentAddress) {
        const CustomWidgets().snackBar(Get.context!, errorSelectYourAddress);
        return false;
      }
    }

    debugPrint("${sms.value}");
    debugPrint("${email.value}");
    debugPrint("${post.value}");

    if (sms.value && email.value && post.value) {
      checkData = "SMS@Email@Post";
    } else if (sms.value && email.value) {
      checkData = "SMS@Email";
    } else if (sms.value && post.value) {
      checkData = "SMS@Post";
    } else if (email.value && post.value) {
      checkData = "Email@Post";
    } else if (email.value && sms.value) {
      checkData = "SMS@Email";
    } else if (post.value && sms.value) {
      checkData = "SMS@Post";
    } else if (post.value && email.value) {
      checkData = "Email@Post";
    } else if (post.value) {
      checkData = "Post";
    } else if (email.value) {
      checkData = "Email";
    } else if (sms.value) {
      checkData = "SMS";
    } else {
      checkData = "";
    }

    return true;
  }

/* These below 2 functions is used to give suggestions when user is change the address */
  void onChanged() {
    getSuggestion(addressController.value.text);
  }

  void getSuggestion(String input) async {
    String request =
        '${APIsConstant().mapBaseURL}?input=$input&key=${APIsConstant().googleApiKey}&components=country:aus&sessiontoken=${sessionToken.value}';

    printMessage(tag, " Request $request");

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      placeList = json.decode(response.body)['predictions'];
    } else {
      throw Exception('Failed to load predictions');
    }
  }

/* This is used to load teh image from the server and set into the variable */
  ImageProvider getImageForProfile() {
    printMessage(tag, "storage image ===${imagePicked.value}");
    printMessage(tag, "network image ===${profileUrl.value}");
    if (imagePicked.value == null) {
      return NetworkImage(profileUrl.value);
    } else {
      return MemoryImage(imagePicked.value!.readAsBytesSync());
    }
  }

/* by fetching the current lat,lng this func. find the current address */
  Future getLatLangFromCurrentAddress(String query) async {
    printMessage(tag, "Query :$query");
    var address = await GeocodingPlatform.instance!.locationFromAddress(query);
    var firsts = address.first;

    isCoordinates.value = true;
    printMessage(tag, "${firsts.timestamp} : $firsts");

    chooseAddress.value = query;
    chooseAddressLong.value = firsts.longitude.toString();
    chooseAddressLat.value = firsts.latitude.toString();

    var laddress = await GeocodingPlatform.instance!.placemarkFromCoordinates(
        double.parse(chooseAddressLat.value),
        double.parse(chooseAddressLong.value));
    var first = laddress.first;

    switch (first.administrativeArea) {
      case 'New South Wales':
        chooseAddressState.value = "NSW";
        break;
      case 'Victoria':
        chooseAddressState.value = "VIC";
        break;
      case 'South Australia':
        chooseAddressState.value = "SA";
        break;
      case 'Western Australia':
        chooseAddressState.value = "WA";
        break;
      case 'Northern Territory':
        chooseAddressState.value = "NT";
        break;
      case 'Queensland':
        chooseAddressState.value = "QLD";
        break;
      case 'Tasmania':
        chooseAddressState.value = "TAS";
        break;
      case 'Australian Capital Territory':
        chooseAddressState.value = "ACT";
        break;
      default:
        chooseAddressState.value = "";
        break;
    }
    chooseAddressCity.value = first.locality!;
    chooseAddressPinCode.value = first.postalCode!;

    printMessage(tag, "Address : $laddress");
    printMessage(tag, "First :$first");
    printMessage(tag, "lat long data is end==");
  }

/* function used in profile screen to get the image from server */
  getImageFromServer(String profilePic) {
    printMessage(tag, profilePic);
    String serverImage = Uri.encodeFull(profilePic);
    printMessage(tag, serverImage);
    return base64Decode(serverImage);
  }

  Future<dynamic> sendOTP(var newPhone, String oldPhone) async {
    try {
      return BaseClient.get(
              "OldPhone=$oldPhone"
                  "&Phone=$newPhone",
              "APISendOTP")
          .then((value) {
        if (value != null) {
          var sendOTPResponse = json.decode(value);

          otpLength = int.parse(sendOTPResponse['OTP'] ?? '1');
          refresh();
          return sendOTPResponse;
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

  Future<dynamic> getUpdateProfile(
      String name, var address, state, city, postalCode, checked) async {
    printMessage(tag, "Update profile API called");

    try {
      return BaseClient.postNew(
              "CustomerID=$name"
                  "&Phone=${mobileController.value.text}"
                  "&Email=${emailController.value.text}&"
                  "FirstName=${firstNameController.value.text}&"
                  "LastName=${lastNameController.value.text}&"
                  "Address=$address&"
                  "State=$state&"
                  "City=$city&"
                  "ContactYou=$checked&"
                  "PostalCode=$postalCode",
              "UpdateCustomerProfileAPP")
          .then((value) {
        printMessage(tag, value);
        var response = json.decode(value);

        return response;
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* If user request to delete their account then it give any valid reason and then hit this api and teh account was deleted or status is deactivated is set */
  Future<dynamic> deleteProfile(String phone, String reason) async {
    if (reason == "") {
      reason = "Unspecified";
    } else {
      reason = reason;
    }

    try {
      return BaseClient.get(
              "Phone=$phone"
                  "&Reason=$reason",
              "APIDeactivateCustomer")
          .then((value) {
        printMessage(tag, "Profile res :$value");
        if (value != null) {
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

/* ------------------------------ Edit PHone screen ----------------------------------------------------- */
  /* if user try to change the phone no. this method is verify the no. and return status */
  bool isValidEditPhone({required String text}) {
    if (text.isEmpty) {
      const CustomWidgets().snackBar(Get.context!, errorEnterOldMobileNumber);
      return false;
    } else if (text.isEmpty) {
      const CustomWidgets().snackBar(Get.context!, errorEnterNewMobileNumber);
      return false;
    } else if (text.length < 9) {
      const CustomWidgets().snackBar(Get.context!, errorNewMobileFormat);
      return false;
    } else if (text.substring(1, 10) == text) {
      const CustomWidgets()
          .snackBar(Get.context!, errorOldNumberNotMatchNewNumber);
      return false;
    }

    return true;
  }
}
