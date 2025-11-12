import 'dart:io';
import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/apis/apis_constant.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class VersionHistoryController extends GetxController {
  final themeController = Get.find<ThemeController>();
  late InAppWebViewController webViewController;
  final GlobalKey webViewKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      const CustomWidgets().widgetLoadingData();
    });
  }

  String getUrl() {
    String url = "";
    if (Platform.isAndroid) {
      url = APIsConstant().versionHistoryUrl;
    } else if (Platform.isIOS) {
      url = APIsConstant().versionHistoryUrlIOS;
    }
    return url;
  }
}
