import 'package:assist/Controllers/buy_assistance_controller.dart';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/utils/Widgets/widgets_file.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_strings.dart';
import '../utils/custom_widgets.dart';

class ViewPlanDetails extends StatelessWidget {
  final String userId;
  final int loginWay;
  ViewPlanDetails({super.key, required this.userId, required this.loginWay});

  final buyAssistanceController = Get.put(BuyAssistanceController());

  @override
  Widget build(BuildContext context) {
    return networkWidget(
        SafeArea(
          child: Scaffold(
              appBar: const CustomWidgets().appBar(
                  context,
                  0.0,
                  global.themeType == 1
                      ? MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Colors.black26
                          : secondaryColor
                      : buyAssistanceController.themecontroller.isDarkMode.value
                          ? Colors.black26
                          : secondaryColor,
                  IconThemeData(
                      color: buyAssistanceController
                              .themecontroller.isDarkMode.value
                          ? secondaryColor
                          : whiteColor),
                  customText(
                      text: lalebRoadsideAssistance,
                      color: buyAssistanceController
                              .themecontroller.isDarkMode.value
                          ? secondaryColor
                          : whiteColor),
                  true),
              body: bodyOfPlanDetailsPage(
                  buyAssistanceController: buyAssistanceController,
                  userid: userId,
                  loginway: loginWay)),
        ),
        context);
  }
}
