import 'dart:convert';
import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/apis/response/login_response.dart';
import 'package:assist/apis/response/send_otp_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/common_functions.dart';

class LoginController extends GetxController {
  TextEditingController userIDController = TextEditingController();
  FocusNode? userNameFocusNode;

  List<LoginResponse> loginList = [];
  int? otpLength;

  /*change password screen variables */
  final passwordOldController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  final passwordOldVisible = true.obs;
  final passwordNewVisible = true.obs;
  final passwordReVisible = true.obs;

  final themecontroller = Get.find<ThemeController>();

  RegExp passwrdPattern =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,18}$');

  void togglePasswordOldVisible() {
    passwordOldVisible.value = !passwordOldVisible.value;
  }

  void togglepasswordNewVisible() {
    passwordNewVisible.value = !passwordNewVisible.value;
  }

  void togglepasswordReVisible() {
    passwordReVisible.value = !passwordReVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    userNameFocusNode = FocusNode();
  }

/* Login Api call in this Function */
  Future<LoginResponse?> getLogin(String userName, String password) async {
    try {
      debugPrint("ssss==$userName");

      userName = userName.toString().contains("+")
          ? userName.toString().replaceAll("+", '%2B')
          : userName;

      return BaseClient.get(
              "UserName=$userName"
                  "&Pass=${Uri.encodeQueryComponent(password)}",
              "CustomerLogin")
          .then((value) {
        if (value != null) {
          LoginResponse response = LoginResponse.fromJson(json.decode(value));
          debugPrint('sagar');
          return response;
        } else {
          return null;
        }
      });
    } catch (e) {
      printMessage("LoginController", e.toString());
      return null;
    }
  }

/* If user Sign In with OtP then this Api is called */
  Future<SendOTPResponse?> sendOTPToLogin(var phone) async {
    try {
      debugPrint("ssss==$phone");
      phone = phone.toString().contains("+")
          ? phone.toString().replaceAll("+", '%2B')
          : phone;
      return BaseClient.get("Phone=$phone", "APISignInByOTP").then((value) {
        if (value != null) {
          SendOTPResponse sendOTPResponse =
              SendOTPResponse.fromJson(json.decode(value));
          otpLength = int.parse(sendOTPResponse.oTP ?? '');
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

/* If user Login with OtP then this Api is called */
  Future<SendOTPResponse?> oTPToLogin(var phone) async {
    try {
      debugPrint("ssss==$phone");
      phone = phone.toString().contains("+")
          ? phone.toString().replaceAll("+", '%2B')
          : phone;
      return BaseClient.get("Phone=$phone", "APILoginByOTP").then((value) {
        if (value != null) {
          SendOTPResponse sendOTPResponse =
              SendOTPResponse.fromJson(json.decode(value));
          otpLength = int.parse(sendOTPResponse.oTP ?? '');
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

/* This api Called in Login or signUP both for verify the phone number */
  Future<dynamic> verifyMobileNumber(var phone) async {
    try {
      debugPrint("ssss==$phone");
      phone = phone.toString().contains("+")
          ? phone.toString().replaceAll("+", '%2B')
          : phone;
      final response =
          await BaseClient.get("Phone=$phone", 'APIVerifyCustomer');
      if (response != null) {
        return jsonDecode(response);
      } else {
        return null;
      }
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* This api Called in SignUP for verify the phone number */
  Future<dynamic> verifyMobileNumber2(var phone) async {
    try {
      debugPrint("ssss==$phone");
      phone = phone.toString().contains("+")
          ? phone.toString().replaceAll("+", '%2B')
          : phone;
      return BaseClient.get(
              "APIVerifyCustomerSignUp?"
                  "&Phone=$phone",
              "APIVerifyCustomerSignUp")
          .then((value) {
        if (value != null) {
          return json.decode(value);
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

/* This api only used for validate the Otp */
  Future<dynamic> verifyOTP(String phone, String otp) async {
    try {
      debugPrint("ssss==$phone");
      phone = phone.toString().contains("+")
          ? phone.toString().replaceAll("+", '%2B')
          : phone;
      return BaseClient.get(
              "OTPToVerify=$otp"
                  "&Phone=$phone",
              "APIVerifySignInOTP")
          .then((value) {
        if (value != null) {
          return json.decode(value);
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

/* By Using this api User can Reset the password, in forget password screen */
  Future<dynamic> resetPassword(String phone, String pass) async {
    try {
      phone = phone.toString().contains("+")
          ? phone.toString().replaceAll("+", '%2B')
          : phone;
      return BaseClient.get(
              "Phone=$phone"
                  "&Pass=${Uri.encodeQueryComponent(pass)}",
              "ResetPassword")
          .then((value) {
        if (value != null) {
          return json.decode(value);
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

/* By using this api we can change the password from inside the app drawer, where we can use change password */
  Future<dynamic> changePassword(
      String phone, String oldPassword, String pass) async {
    try {
      phone = phone.toString().contains("+")
          ? phone.toString().replaceAll("+", '%2B')
          : phone;
      return BaseClient.get(
              "&Phone=$phone"
                  "&OldPassword=${Uri.encodeQueryComponent(oldPassword)}"
                  "&Pass=${Uri.encodeQueryComponent(pass)}",
              'ChangePassword')
          .then((value) {
        if (value != null) {
          return json.decode(value);
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
