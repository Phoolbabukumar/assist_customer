import 'dart:async';
import 'package:assist/Controllers/auth_controller.dart';
import 'package:assist/Controllers/login_controller.dart';
import 'package:assist/ui/account/forget_password_inpust_screen.dart';
import 'package:assist/ui/authenticate_fingerprint.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import '../ui/map_home_screen.dart';

class LoginWithCredentialController extends GetxController {
  final loginType = 0.obs;
  final mobileNumber = "".obs;
  final customerid = "".obs;
  final userPasswordController = TextEditingController();
  FocusNode? passwordFocusNode;
  final passwordVisible = true.obs;
  final showTimer = true.obs;
  final enableResendOption = false.obs;
  final focusNode = FocusNode();
  final start = 30.obs;
  Timer? timer;

  late OTPTextEditController optTextController;
  late OTPInteractor _otpInteractor;
  final focusNode1 = FocusNode();

  final loginController = Get.find<LoginController>();
  final authController = Get.find<AuthController>();

/* Otp interacter package is initialized first and call some functions */
  @override
  void onInit() {
    super.onInit();
    passwordFocusNode = FocusNode();
    authController.getBiometricsSupport();
    authController.getAvailableSupport();

    _otpInteractor = OTPInteractor();
    _otpInteractor
        .getAppSignature()
        .then((value) => debugPrint('signature - $value'));
    optTextController = OTPTextEditController(
      codeLength: 6,
      onCodeReceive: (code) =>
          debugPrint('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
      );
  }

  @override
  void onClose() {
    super.onClose();
    optTextController.stopListen();
  }

/*unhide the password text */
  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  void startTimer() {
    start.value = 30;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
          enableResendOption.value = true;
        } else {
          start.value--;
        }
      },
    );
  }

/* If the loginType is 2 then it called and move to the mapHome screen by checking biometric */
  void sendOTPToHomePage(String code, String? mobile, String? customerid) {
    if (code.length == 6) {
      loginController.verifyOTP(mobile ?? '', code).then((value) {
        if (value['StatusCode'] == 1) {
          global.setLoginData(customerid, true, value['Phone']);

          if (!global.isFirstTime && authController.fingerPrintSupport) {
            Get.to(() => const AuthenticateFingerprint(), popGesture: true)
                ?.then((value) {
              if (value == false) {
                global.setUserWantAddBiometric(false);
                Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
              } else {
                authController.authenticateMe().then((data) {
                  debugPrint("ddddddd$data");

                  if (data) {
                    Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
                  }
                  global.setUserWantAddBiometric(data);
                });
              }
            });
          } else {
            Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
          }
        } else {
          const CustomWidgets().snackBar1(Get.context!, "Incorrect Code");
        }
      });
    } else {
      if (optTextController.text.isNotEmpty) {
        const CustomWidgets()
            .snackBar1(Get.context!, "Please enter 6 digit code");
      } else {
        const CustomWidgets().snackBar1(Get.context!, "Please enter the code");
      }
    }
  }

/*If user click on forgot password then loginType=3 and  user fill the otp then this api is called */
  void forgetPasswordOTP(
    String code,
    String? mobile,
  ) {
    if (code.length == 6) {
      loginController.verifyOTP(mobile ?? '', code).then((value) {
        if (value['StatusCode'] == 1) {
          Get.off(() => ForgetPasswordInputScreen(mobileNumber: mobile ?? ""));
        } else {
          const CustomWidgets().snackBar1(Get.context!, "Incorrect Code");
        }
      });
    } else {
      if (optTextController.text.isNotEmpty) {
        const CustomWidgets()
            .snackBar1(Get.context!, "Please enter 6 digit code");
      } else {
        const CustomWidgets().snackBar1(Get.context!, "Please enter the code");
      }
    }
  }
}
