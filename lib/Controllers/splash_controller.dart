import 'dart:convert';
import 'package:assist/Controllers/app_update_controller.dart';
import 'package:assist/Controllers/auth_controller.dart';
import 'package:assist/Controllers/global_controller.dart';
import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/ui/account/login_screen.dart';
import 'package:assist/ui/map_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../apis/apis_constant.dart';
import '../utils/common_functions.dart';
import '../utils/custom_widgets.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  bool isLogin = false;

  late AnimationController animation;
  late Animation<double> fadeInFadeOut;
  bool isPermissionApproved = false;
  final tag = "Splash Screen";

  final global = Get.put(GlobalController());
  ThemeController themeController = Get.put(ThemeController());
  AuthController authController = Get.put(AuthController());
  AppUpdateController appUpdateController = Get.put(AppUpdateController());

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      int themeValue = global.themeType;
      printMessage(tag, "themeType $themeValue");
      themeController
          .changeTheme(themeValue)
          .then((value) => update());
    });

    getUpdate();
  }

/* In this function we check the updates are avilable or not */
  Future<void> getUpdate() async {
    // await getBaseUrlApi();
    // await global.getToken();
    await splashAnimation();
    await appUpdateController
        .appUpdateStatusApi(Get.context)
        .then((value) async {
      debugPrint(
          "Update available bool: ${appUpdateController.updateAvailable}");
      if (appUpdateController.updateAvailable == false) {
        await isPref();
      }
    });
  }

/* Take login status and call movetoNextscreen fun. to redirect from splash */
  Future<void> isPref() async {
    isLogin = global.isLogin;
    printMessage(tag, "isLogin $isLogin");
    authController.getBiometricsSupport();
    debugPrint("Biometric drawer called----");
    moveToNextScreen();
  }

/* In this function splash animation is starting */
  Future<void> splashAnimation() async {
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    fadeInFadeOut = Tween<double>(begin: -1, end: 1).animate(animation);

    Future.delayed(const Duration(milliseconds: 200), () {
      animation.forward();
    });
  }

/*If user already login then it move to mapHomeScreen otherWise on Login Screen */
  void moveToNextScreen() {
    Future.delayed(const Duration(seconds: 1), () {
      if (isLogin) {
        if (global.isUserWantBiometric) {
          authController.authenticateMe().then((value) {
            debugPrint("From splash = $value");
            if (value) {
              Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
            } else {
              const CustomWidgets().snackBar(
                  Get.context!, "Authentication failed, please try again!!");
            }
          });
        } else {
          Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
        }
      } else {
        Get.offAll(() => const LoginScreen());
      }
    });
  }

/*By using this function we can get the base url, it can help in api calling */
  Future<void> getBaseUrlApi() async {
    var url = await http.get(Uri.parse(
        "https://assist.247roadservices.com.au/GetBaseURLForOAuth.json")); /* Test link: https://247rsa.softservtest.com/GetBaseURLForOAuth.json */
    var finalUrl = jsonDecode(url.body);
    printMessage(tag, 'BASEuRL $finalUrl');
    if (finalUrl['baseURL'] != null &&
        finalUrl['baseURL'].toString().isNotEmpty) {
      APIsConstant.mainUrl = finalUrl['baseURL'];
      APIsConstant.clientId = finalUrl['client_id'];
      APIsConstant.clientSecret = finalUrl['client_secret'];

      if (global.currentToken == "") {
        debugPrint("Token API called from check base URL");
        await global.getToken();
      }
    } else {
      const CustomWidgets().snackBar1(
          Get.context!, "Something went wrong. Please try again later.");
    }
  }

  /*In this animation is stoped or disposed */
  @override
  void onClose() {
    animation.dispose();
    super.onClose();
  }
}
