import 'dart:convert';
import 'package:assist/Controllers/auth_controller.dart';
import 'package:assist/Controllers/global_controller.dart';

import 'package:assist/Controllers/jobs_datalist_controller.dart';
import 'package:assist/Controllers/profile_data_controller.dart';
import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/app_constants/app_images_path.dart';
import 'package:assist/firebase/notification.dart';
import 'package:assist/ui/map_home_screen.dart';
import 'package:assist/utils/common_functions.dart';
import 'package:assist/utils/pusher/pusher_new_services.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreenController extends GetxController {
  final String tag = "home screen controller";

  // Global controllers
  final global = Get.find<GlobalController>();
  final profileDataController = Get.put(ProfileDataController());
  final themeController = Get.find<ThemeController>();
  final authController = Get.find<AuthController>();

  // Observable variables of MapHome screen
  final lat = 0.0.obs;
  final lng = 0.0.obs;
  final currentIndex = 0.obs;
  final permissionsEnabled = false.obs;
  final isOfficeOpen = false.obs;
  final remainingCallouts = 0.obs;
  final isLoading = true.obs;
  final isDeactivated = false.obs;
  final contractExists = false.obs;
  final isCustomerAccess = false.obs;
  final onTime = "".obs;
  final offTime = "".obs;
  final userPhoneNumber = "".obs;

  /*Variables of Drawer Screen that is More.dart */
  final switchValue = false.obs;
  final appTheme = 0.obs;
  final isExpanded = false.obs;

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  void changeAppTheme(int? value) {
    appTheme.value = value ?? 0;
  }

  // Non-observable variables
  Position? _currentPosition;
  List<Marker> markers = [];
  GoogleMapController? googleMapController;
  final PusherNewServices pusherService = PusherNewServices();

  final GlobalKey<ConvexAppBarState> appBarKey = GlobalKey<ConvexAppBarState>();

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    userPhoneNumber.value = global.customerPhoneNumber;
    switchValue.value = global.isUserWantBiometric;
    appTheme.value = global.themeType;

    global.setIsFirstTime(true);
    await pusherService.firePusher('my-channel', 'customer-access-event');
    await checkCustomerContract();
    await JobsDataListController().getFeedBackURL();
    await initPermissions();
    await allAPIsCall();
    handleAppLifecycleState();
  }

  Future<void> initPermissions() async {
    await global.requestLocationPermission();
    permissionsEnabled.value = await global.checkGPSAndLocationPermission();
    global.setPermission(permissionsEnabled.value);
    printMessage(tag, "Permissions: $permissionsEnabled");
  }

  void handleAppLifecycleState() {
    SystemChannels.lifecycle.setMessageHandler((stateMessage) async {
      if (stateMessage == "AppLifecycleState.resumed") {
        final gpsAndPermission = await global.checkGPSAndLocationPermission();
        global.setPermission(gpsAndPermission);
        permissionsEnabled.value = gpsAndPermission;
        if (permissionsEnabled.value) {
          await getCurrentLocation();
        }
        await themeController.changeTheme(
          global.themeType,
        );
        update();
      }
      return null;
    });
  }

  Future<void> allAPIsCall() async {
    await Permission.notification.request();
    await getCurrentLocation();
    permissionsEnabled.value = global.permissionEnabled;
    await officeOpenStatus();
    await profileApi();
    update();
  }

  Future<void> checkCustomerContract() async {
    buildWaitingForLocation();
    try {
      final contractData = await checkCustomersContracts();
      if (contractData != null) {
        isCustomerAccess.value =
            contractData['CustomerAccess'].toString().toLowerCase() == 'yes';
        isDeactivated.value =
            contractData['isDeactivated'].toString().toLowerCase() == 'yes';
        contractExists.value = contractData['StatusCode'] != 0;
      }
      isLoading.value = false;
      Get.back();
    } catch (e, stacktrace) {
      printMessage(tag, e.toString());
      printMessage(tag, stacktrace.toString());
      isLoading.value = false;
    }
  }

  Future<dynamic> checkCustomersContracts() async {
    debugPrint('Phone: ${userPhoneNumber.value}');
    try {
      final response = await BaseClient.get(
          "Phone=${userPhoneNumber.value}", "APICheckCustomersContract");
      if (response != null) {
        final decodedResponse = json.decode(response);
        refresh();
        return decodedResponse;
      }
      return null;
    } catch (e, stacktrace) {
      printMessage(tag, e.toString());
      printMessage(tag, stacktrace.toString());
      return null;
    }
  }

  Future<void> getCurrentLocation() async {
    buildWaitingForLocation();
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat.value = _currentPosition!.latitude;
      lng.value = _currentPosition!.longitude;
      printMessage(tag, "Current position: $_currentPosition");
      moveCamera(_currentPosition!.latitude, _currentPosition!.longitude);
      Get.back();
      update();
    } catch (e) {
      printMessage(tag, "Error fetching location: $e");
    }
  }

  void moveCamera(double lat, double lng) {
    googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 14.0),
    ));
    update();
  }

  Future<void> profileApi() async {
    printMessage(tag, "Profile calling api");
    final profile = await profileDataController.getProfileList();
    if (profile != null) {
      printMessage(tag, "Profile Response: $profile");
      remainingCallouts.value = profile.remainingCallouts ?? 0;
      FirebaseNotification().getFCMToken();
      update();
    } else {
      printMessage(tag, "Profile data is null");
    }
  }

  bool checkOpenTimeStatus(String openTime, String closedTime) {
    TimeOfDay timeNow = TimeOfDay.now();

    TimeOfDay timeOpen = _parseTime(openTime);
    TimeOfDay timeClose = _parseTime(closedTime);

    int nowInMinutes = _timeOfDayToMinutes(timeNow);
    int openTimeInMinutes = _timeOfDayToMinutes(timeOpen);
    int closeTimeInMinutes = _timeOfDayToMinutes(timeClose);

    if (closeTimeInMinutes < openTimeInMinutes) {
      closeTimeInMinutes += 1440;
      if (nowInMinutes < openTimeInMinutes) {
        nowInMinutes += 1440;
      }
    }

    return openTimeInMinutes < nowInMinutes &&
        nowInMinutes < closeTimeInMinutes;
  }

  Future<void> officeOpenStatus() async {
    try {
      final response = await BaseClient.get("", "GetOfficeOpenOrClosed");
      if (response != null) {
        final systemData = jsonDecode(response);
        if (systemData.containsKey("BHEndTime")) {
          onTime.value = _formatTime(systemData['BHStartTime']);
          offTime.value = _formatTime(systemData['BHEndTime']);

          isOfficeOpen.value = systemData['StatusCode'] == 1;
          global.setOfficeOnOff(isOfficeOpen.value);
        }
      }
    } catch (e) {
      printMessage(tag, "Error fetching office status: $e");
    }
  }

  void tabMethod(int index) {
    if (index == 2 && global.phoneNoRetailer.isNotEmpty) {
      makePhoneCall(global.phoneNoRetailer).then(
        (value) => appBarKey.currentState?.animateTo(currentIndex.value),
      );
    } else {
      currentIndex.value = index;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  GoogleMap buildMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition:
          CameraPosition(target: LatLng(lat.value, lng.value), zoom: 14.0),
      markers: Set.from(markers),
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      onTap: handleTap,
    );
  }

  handleTap(LatLng tappedPoint) async {
    final icon = await getBitmapDescriptorFromAssetBytes(markerIcon, 80);
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
        icon: icon,
      ),
    );
    moveCamera(tappedPoint.latitude, tappedPoint.longitude);
    printMessage(
        tag, "Lat: ${tappedPoint.latitude}, Lng: ${tappedPoint.longitude}");
    update();
  }

  TimeOfDay _parseTime(String time) {
    String hourStr = time.substring(0, 2);
    String minuteStr = time.substring(3, 5);
    String amPm = time.substring(5);

    int hour = int.parse(hourStr);
    int minute = int.parse(minuteStr);

    if (amPm == "AM" && hour == 12) {
      hour = 0;
    } else if (amPm == "PM" && hour != 12) {
      hour += 12;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  int _timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  String _formatTime(String time) {
    final inputFormat = DateFormat('HH:mm');
    final date = inputFormat.parse(time);
    final outputFormat = DateFormat('hh:mm a');
    return outputFormat.format(date);
  }
}
