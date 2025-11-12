import 'package:assist/Controllers/version_history_controller.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import '../Network/networkwidget.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_strings.dart';
import '../utils/custom_widgets.dart';

class VersionHistory extends StatelessWidget {
  const VersionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final versionHistory = Get.put(VersionHistoryController());
    return networkWidget(
        SafeArea(
          child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: global.themeType == 1
                    ? MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? blackColor
                        : secondaryColor
                    : versionHistory.themeController.isDarkMode.value
                        ? blackColor
                        : secondaryColor,
                title: customText(
                    text: versionHistoryText,
                    color: versionHistory.themeController.isDarkMode.value
                        ? secondaryColor
                        : whiteColor),
              ),
              body: InAppWebView(
                key: versionHistory.webViewKey,
                initialUrlRequest:
                    URLRequest(url: WebUri(versionHistory.getUrl())),
                onWebViewCreated: (controller) {
                  versionHistory.webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  debugPrint(url as String);
                },
                initialSettings: InAppWebViewSettings(),
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {},
                onLoadStop: (InAppWebViewController controller, url) async {
                  debugPrint("load stop call");
                  Get.back();
                },
              )),
        ),
        context);
  }
}
