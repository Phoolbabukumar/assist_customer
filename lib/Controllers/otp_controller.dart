import 'dart:async';
import 'dart:convert';
import 'package:assist/Controllers/profile_data_controller.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/apis/response/otp_response.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/utils/common_functions.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';

/* This class is used in 4 parts of app signUp, login,drawer and profile */
class OTPController extends GetxController {
  var tag = "OTPController";
  String? screenType;

  ProfileDataController? profileController;

  // Timer-related variables
  final timer = 30.obs;
  final timerActive = true.obs;
  final resendVisible = false.obs;
  Timer? _timer;
  late OTPInteractor _otpInteractor;
  late OTPTextEditController optTextController;

  @override
  void onInit() {
    screenType = Get.arguments["screenType"];
    if (screenType != "SignUpOtp") {
      profileController = Get.find<ProfileDataController>();
    }
    startTimer();

    _otpInteractor = OTPInteractor();
    _otpInteractor
        .getAppSignature()
        .then((value) => debugPrint('signature - $value'));
    optTextController = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
      );
    super.onInit();
  }

  // Starts the timer when OTP screen appears
  void startTimer() {
    timer.value = 30;
    timerActive.value = true;
    resendVisible.value = false;
    _startCountdown();
    update();
  }

  // Private method to handle the countdown logic
  void _startCountdown() {
    _timer?.cancel(); // Ensure any existing timer is canceled
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (this.timer.value > 0) {
          this.timer.value--;
          update();
        } else {
          timerActive.value = false;
          resendVisible.value = true;
          _timer?.cancel(); // Cancel the timer once the countdown ends
          update();
        }
      },
    );
  }

/* Ensure the timer is canceled when the controller is disposed */
  @override
  void onClose() {
    _timer?.cancel();
    optTextController.stopListen();
    super.onClose();
  }

  /* When otp screen occur the timer is started */

  Future<OtpResponse?> getOTPVerify(
      String customerId, otp, oldPhone, newPhone) async {
    try {
      return BaseClient.get(
              "CustomerID=$customerId"
                  "&OTPToVerify=$otp"
                  "&OldPhone=$oldPhone"
                  "&Phone=$newPhone",
              "APIVerifyOTP")
          .then((value) {
        var response = OtpResponse.fromJson(json.decode(value));
        update();
        return response;
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }

/* when user update our phone no. it verify the number  */
  Future<String?> validateOtp({
    required realOtp,
    required otpLength,
    required oldPhoneNumber,
    required newPhoneNumber,
  }) async {
    if (realOtp.length == int.parse(otpLength ?? "0")) {
      SchedulerBinding.instance.addPostFrameCallback((_) {});
      getOTPVerify(
        global.userId.toString(),
        realOtp.toString(),
        oldPhoneNumber,
        newPhoneNumber,
      ).then((value) {
        if (value!.statusCode == 1) {
          global.setCustomerPhoneNumber(newPhoneNumber);

          SchedulerBinding.instance.addPostFrameCallback((_) {
            const CustomWidgets().snackBar(Get.context!, mobileNumberChanged);
          });

          Future.delayed(const Duration(milliseconds: 2000), () {});
        } else {
          const CustomWidgets().snackBar(Get.context!, sbIncorrectOtp);
        }

        //
      });
      return null;
    } else {
      if (optTextController.text.isEmpty) {
        const CustomWidgets().snackBar(Get.context!, pleaseEnterOtp);
      } else {
        const CustomWidgets().snackBar(Get.context!, pleaseEnterOtp6Digit);
      }
    }
    return null;
  }
}
