import 'dart:convert';
import 'dart:io';
import 'package:assist/apis/apis_constant.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/ui/appupdatedialog/app_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../utils/common_functions.dart';

class AppUpdateController extends GetxController {
  var tag = 'App update controller';
  String mandatoryUpdate = "";
  String newBuildNumber = "";
  String currentBuildNumber = "";
  String newIOSBuildNumber = "";
  bool? updateAvailable;

/* This Function Find the downloded version from user device */
  Future<void> getCurrentAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentBuildNumber = packageInfo.buildNumber;
    APIsConstant.version = packageInfo.version;
    printMessage(tag, 'currentVersion $currentBuildNumber');
    printMessage(tag, 'current Package number:  ${APIsConstant.version}');
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentAppVersion();
  }

/* This api fetch the live app version from Store and shwo update dialog accordingly */
  Future<void> appUpdateStatusApi(key) async {
    {
      try {
        return BaseClient.get("", "AppUpdateDetail").then((value) async {
          if (value != null) {
            var response = json.decode(value);

            mandatoryUpdate = response['MandatoryUpdate'];
            newBuildNumber = response['APP_VERSION'];
            newIOSBuildNumber = response['APP_VERSION_iOS'];
            printMessage(tag, 'newbuildNumber$newBuildNumber');
            printMessage(tag, 'newbuildNumber$mandatoryUpdate');
            printMessage(tag, 'newIOSBuildNumber$newIOSBuildNumber');
            if (Platform.isAndroid) {
              if (int.parse(currentBuildNumber) < int.parse(newBuildNumber)) {
                showDialogBox(Get.context);
              } else {
                // move to the next screen code here...
                updateAvailable = false;
              }
            } else if (Platform.isIOS) {
              printMessage(tag, 'called one');
              if (int.parse(currentBuildNumber) <
                  int.parse(newIOSBuildNumber)) {
                printMessage(tag, 'called');
                showDialogBox(Get.context);
              } else {
                updateAvailable = false;
              }
            }
          }
        });
      } catch (e) {
        printMessage("AppUpdateController", e.toString());
      }
    }
  }

  void showDialogBox(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => appUpdateDialog(
              context,
              currentBuildNumber,
              mandatoryUpdate,
            ));
  }

  void showSnack(String text, key) {
    if (key.currentContext != null) {
      ScaffoldMessenger.of(key.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }
}
