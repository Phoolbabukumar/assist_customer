import 'dart:convert';
import 'dart:developer';

import 'package:assist/apis/apis_constant.dart';
import 'package:assist/app_constants/app_pref_keys.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/ui/account/login_screen.dart';
import 'package:assist/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class GlobalController extends GetxController {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  final box = GetStorage();

  bool get permissionEnabled => box.read(permissionPrefs) ?? false;

  String get userId => box.read(userIdPrefs) ?? ''; // customer ID

  String get phoneNoRetailer => box.read(phoneNoRetailerPrefs) ?? "";

  bool get isLogin => box.read(isLoginPref) ?? false;

  bool get isOfficeOpenOrClosed => box.read(officeOpenClosedPrefs) ?? false;

  bool get isUserWantBiometric => box.read(userWantBiometricOrNot) ?? false;

  bool get isFirstTime => box.read(userComeFirstTime) ?? false;

  String get customerPhoneNumber => box.read(phoneCustomerNoPrefs) ?? "";

  String get profileUserFirstName => box.read(namePrefs) ?? "";

  String get profileUserImageUrl => box.read(imagePrefs) ?? "";

  String get rid => box.read(ridPrefs);

  int get themeType => box.read(themeMode) ?? 1;

  String get currentToken => box.read(token) ?? "";

  String get refreshedToken => box.read(refreshToken) ?? "";

  String get accesstime => box.read(accessTime) ?? "";

  var isCustomerAccessGlobal = true.obs;

  clearStorage() {
    box.erase();
  }

  logoutStorage() {
    box.remove(userIdPrefs);
    box.remove(phoneCustomerNoPrefs);
    box.remove(permissionPrefs);
    box.write(isLoginPref, false);
    box.remove(currentToken);
    box.remove(refreshedToken);
    box.erase();
  }

  setUserId(String userId) {
    box.write(userIdPrefs, userId.toString());
  }

  setProfileImageAndName(String imageurl, String name) {
    box.write(imagePrefs, imageurl.toString());
    box.write(namePrefs, name.toString());
  }

  setLoginData(userId, login, phoneNo) {
    box.write(userIdPrefs, userId.toString());
    box.write(isLoginPref, login);
    box.write(phoneCustomerNoPrefs, phoneNo);

    debugPrint("user id $userId  login $login phoneNo $phoneNo");
  }

  setRetailerPhoneNumber(phoneNo) {
    box.write(phoneNoRetailerPrefs, phoneNo);
  }

  setIsFirstTime(isFirstTime) {
    box.write(userComeFirstTime, isFirstTime);
  }

  setUserWantAddBiometric(status) {
    box.write(userWantBiometricOrNot, status);
  }

  setOfficeOnOff(bool isOpen) {
    box.write(officeOpenClosedPrefs, isOpen);
  }

  setPermission(permission) {
    box.write(permissionPrefs, permission);
  }

  setCustomerPhoneNumber(phoneNo) {
    debugPrint('casephone$phoneNo');
    box.write(phoneCustomerNoPrefs, phoneNo);
  }

  setrId(rId) {
    box.write(ridPrefs, rId);
  }

  setThemeMode(int value) {
    box.write(themeMode, value);
  }

  setToken(String data) async {
    await box.write(token, data);
  }

  setRefereshToken(String data) async {
    await box.write(refreshToken, data);
  }

  Future<bool> checkGPSAndLocationPermission() async {
    bool checkLocationPermissionEnabled1 =
        await checkLocationPermissionEnabled();
    bool checkGPSEnabled1 = await checkGPSEnabled();

    if (checkLocationPermissionEnabled1 && checkGPSEnabled1) {
      return true;
    }

    return false;
  }

  Future<bool> checkLocationPermissionEnabled() async {
    LocationPermission permission;

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    //todo: add condition for open settings for denied forever
    return true;
  }

  Future<bool> checkGPSEnabled() async {
    var location = Location();
    bool enabled = await location.serviceEnabled();
    if (enabled) {
      return true;
    } else {
      Future.error(errorLocationServicesDisable);
      return false;
    }
  }

  requestLocationPermission() async {
    await _geolocatorPlatform.requestPermission();
  }

  void openLocationSettings() async {
    await _geolocatorPlatform.openLocationSettings();
  }

  void openAppSettingsOn() async {
    await _geolocatorPlatform.openAppSettings();
  }

  Future<void> getToken() async {
    // box.write(token, 'dc4a5cb756c064612451bfa9e5ef0fc');
    //box.write(refreshToken, '717a2ae2ea68d3188ab06ad6dcfa70f6');
    //  https://247rsa.softservtest.com/OAuthToken/GetOuathToken?clientID=ASSIST00556181&secreteID=08119167294972074
    try {
      final url =
          "${APIsConstant.mainUrl}oAuth/GetOAuthToken?client_id=${APIsConstant.clientId}&client_secret=${APIsConstant.clientSecret}";
      printMessage("Token Api Url", url);
      final response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        printMessage("token Api", responseData);
        setToken(responseData["tokenKey"]);
        setRefereshToken(responseData["refreshToken"]);
        log("Token: $currentToken");
        log("RefreshToken: $refreshedToken");
        // box.write(token, responseData["tokenKey"]);
        // box.write(refreshToken, responseData["refreshToken"]);
        box.write(accessTime, DateTime.now().toString());
        debugPrint("Get Token time:  $accesstime");
        box.write(isLoginPref, false);
      } else {
        // refresh token also expired so the user logout
        Get.snackbar('Session Timed Out', 'Please Login again to continue');
        logoutStorage();
        Get.offAll(const LoginScreen());
      }
    } catch (e) {
      printMessage("token Api", "$e");
    }
  }

  Future<String?> getRefreshToken() async {
    printMessage(tag, 'RefreshToken$refreshedToken');

    try {
      final url = "${APIsConstant.mainUrl}CXF/services/oauth/token";
      printMessage("refresh Token Api Url", url);
      final body = {
        "grant_type": APIsConstant.grantType,
        "refresh_token": refreshedToken,
        "client_id": APIsConstant.clientId,
        "client_secret": APIsConstant.clientSecret,
      };

      log("$body");

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        printMessage("refresh token Api", responseData);
        setToken(responseData["tokenKey"]);
        setRefereshToken(responseData["refreshToken"]);
        log("from refresh api Token: $currentToken");
        log("from refresh api RefreshToken: $refreshedToken");
        await box.write(accessTime, DateTime.now().toString());
        debugPrint("refresh time:  $accesstime");
        return "${responseData["tokenKey"]}";
      } else {
        log(response.body);
        Get.snackbar('Session Timed Out', 'Please Login again to continue');
        logoutStorage();
        await getToken();
        Get.offAll(() => const LoginScreen());
        // call refresh token Api here..
        return "";
      }

      /*if (response.statusCode == 400 ||
          responseData["error"] == "invalid_grant") {
        Get.snackbar('Session Timed Out', 'Please Login again to continue');
        logoutStorage();
        await getToken();
        Get.offAll(() => const Login());
        // call refresh token Api here..
        return "";
      } else {
        setToken(responseData["tokenKey"]);
        setRefereshToken(responseData["refreshToken"]);
        log("from refresh api Token: $currentToken");
        log("from refresh api RefreshToken: $refreshedToken");
        await box.write(accessTime, DateTime.now().toString());
        debugPrint("refresh time:  $accesstime");
        return "${responseData["tokenKey"]}";
      }*/
    } catch (e) {
      printMessage("refresh token error", "$e");
    }
    return "";
  }
}