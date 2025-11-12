import 'dart:io' show Platform;
import 'package:assist/Controllers/app_update_controller.dart';
import 'package:assist/Controllers/auth_controller.dart';
import 'package:assist/apis/apis_constant.dart';
import 'package:assist/ui/map_home_screen.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_strings.dart';
import '../../utils/common_functions.dart';
import 'package:assist/ui/account/login_screen.dart';

final appUpdateController = Get.find<AppUpdateController>();
final authController = Get.find<AuthController>();
Widget appUpdateDialog(
  BuildContext context,
  String currentVersion,
  String mandatoryUpdate,
) {
  var tag = "appUpdateDialog";
  void launchURLBrowser(String appURL) async {
    printMessage(tag, appURL);
    var url = Uri.parse(appURL.toString());
    printMessage(tag, url);
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  return PopScope(
    onPopInvokedWithResult: (didPop, result) {
      if (Platform.isAndroid) {
        if (didPop) {
          SystemNavigator.pop();
        }
      }
      if (Platform.isIOS) {
        if (didPop) {
          Get.back();
          Get.back();
        }
      }
    },
    child: CupertinoAlertDialog(
        title: customText(
            text: dialogAppUpdate,
            size: 16,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center),
        content: customText(
            text: dialogLatestAppUpdate,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.left),
        actions: [
          Row(
            mainAxisAlignment: mandatoryUpdate == "No"
                ? MainAxisAlignment.end
                : MainAxisAlignment.center,
            children: [
              mandatoryUpdate == "No"
                  ? TextButton(
                      onPressed: () {
                        if (global.isLogin) {
                          if (global.isUserWantBiometric) {
                            authController.authenticateMe().then((value) {
                              debugPrint("from splash =$value");
                              if (value) {
                                Get.offAll(() => MapHomeScreen(
                                      currentIndexValue: 0,
                                    ));
                              } else {
                                const CustomWidgets().snackBar(
                                    Get.context!, authenticationFailed);
                              }
                            });
                          } else {
                            Get.offAll(
                                () => MapHomeScreen(currentIndexValue: 0));
                          }
                        } else {
                          Get.offAll(() => const LoginScreen());
                        }
                      },
                      child: customText(
                          text: labelLater,
                          size: 16,
                          color: secondaryColor,
                          fontWeight: FontWeight.w500),
                    )
                  : Container(),
              TextButton(
                onPressed: () {
                  //launchURLBrowser("https://play.google.com/store/apps/details?id=au.com.roadservices.assist");
                  if (Platform.isAndroid) {
                    launchURLBrowser(
                        "${APIsConstant().appStoreURl}?platform=android");
                  }
                  if (Platform.isIOS) {
                    launchURLBrowser(
                        "${APIsConstant().appStoreURl}?platform=ios");
                  }

                  Get.back();
                },
                child: customText(
                    text: labelUpdate,
                    size: 16,
                    color: secondaryColor,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )
        ]),
  );
}
