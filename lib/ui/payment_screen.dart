import 'package:assist/Controllers/payment_controller.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import '../Controllers/theme_controller.dart';
import '../app_constants/app_colors.dart';
import '../utils/common_functions.dart';
import '../utils/custom_widgets.dart';
import 'map_home_screen.dart';
import 'package:assist/ui/account/login_screen.dart';

class PaymentScreen extends StatelessWidget {
  final String title;
  final int loginWay;

  PaymentScreen({super.key, required this.title, required this.loginWay});

  final payController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return PopScope(child: SafeArea(
      child: GetBuilder<ThemeController>(builder: (builder) {
        return Scaffold(
          backgroundColor: Colors.blueGrey[100],
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: global.themeType == 1
                ? MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? blackColor
                    : secondaryColor
                : builder.isDarkMode.value
                    ? blackColor
                    : secondaryColor,
            automaticallyImplyLeading:
                false, //IconThemeData(color: builder.isDarkMode.value?secondaryColor:Colors.white),
            title: customText(
                text: title,
                color: builder.isDarkMode.value ? secondaryColor : whiteColor),
          ),
          body: Obx(() => Stack(children: <Widget>[
                InAppWebView(
                  key: payController.webViewKey,
                  initialUrlRequest:
                      URLRequest(url: WebUri(payController.webViewUrl ?? "")),
                  onWebViewCreated: (controller) {
                    payController.webViewController = controller;
                  },
                  initialSettings: InAppWebViewSettings(),
                  onConsoleMessage: (InAppWebViewController controller,
                      ConsoleMessage consoleMessage) {
                    debugPrint("Message===${consoleMessage.message}");

                    if (consoleMessage.message.toLowerCase() == "complete" ||
                        consoleMessage.message.toLowerCase() == "app") {
                      payController.message.value = consoleMessage.message;
                    }

                    ///complete

                    ///App text comes when membership is renewed
                    ///App/Id text comes when membership buys

                    if (consoleMessage.message.toString().toLowerCase() ==
                            'app' ||
                        consoleMessage.message
                            .toString()
                            .toLowerCase()
                            .contains('app/')) {
                      if (consoleMessage.message.toString().contains("/")) {
                        String userId =
                            consoleMessage.message.toString().split('/')[1];
                        String phoneNumber = global.customerPhoneNumber;
                        saveUserIdPhoneToPrefs(userId, phoneNumber);
                      }

                      debugPrint("LoginWay$loginWay");
                      //C8935595

                      if (loginWay == 1) {
                        Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
                      } else if (loginWay == 2) {
                        Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
                      } else if (loginWay == 4) {
                        Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
                      } else {
                        Get.offAll(() => const LoginScreen());
                      }
                    }
                  },
                  onPageCommitVisible: (controller, url) {
                    debugPrint("ddddd===${url.toString()}");
                    if (url.toString().contains(
                        "https://247roadservices.com.au/?AccessCode=")) {
                      if (loginWay == 1) {
                        Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
                      } else if (loginWay == 2) {
                        Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
                      } else if (loginWay == 4) {
                        Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
                      } else {
                        Get.offAll(() => const LoginScreen())?.then((value) {
                          const CustomWidgets()
                              .showDialogSignUpCompletion(Get.context);
                        });
                      }
                    }
                  },
                  onTitleChanged: (InAppWebViewController controller, title) {
                    debugPrint("title====$title");
                  },
                  onLoadResource:
                      (InAppWebViewController controller, LoadedResource data) {
                    debugPrint("Data====${data.toString()}");
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    payController.progress.value = progress / 100;
                  },
                ),
                payController.progress.value < 1.0
                    ? LinearProgressIndicator(
                        value: payController.progress.value,
                        color: secondaryColor,
                        minHeight: 12,
                        backgroundColor: primaryColor,
                      )
                    : Container(),
              ])),
        );
      }),
    ), onPopInvokedWithResult: (didPop, result) async {
      debugPrint("ddddddddddddddd");
      debugPrint(payController.message.value);

      if (loginWay == 1) {
        Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
      } else if (loginWay == 2) {
        Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
      } else if (loginWay == 4) {
        Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
      } else {
        Get.offAll(() => const LoginScreen());
      }
    });
  }
}
