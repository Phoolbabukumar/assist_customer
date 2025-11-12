import 'package:assist/Network/networkwidget.dart';
import 'package:assist/apis/apis_constant.dart';
import 'package:assist/app_constants/app_colors.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/theme_controller.dart';
import '../app_constants/app_images_path.dart';
import '../utils/custom_widgets.dart';
import 'terms_accordingto_plan.dart';

class TermsCondition extends StatelessWidget {
  TermsCondition({super.key});

  final themeController = Get.find<ThemeController>();
  final webViewKey = GlobalKey();

  void getRoute(String url) {
    Get.to(
      () => TermsAccordingToPlan(url),
      popGesture: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return networkWidget(
        SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: global.themeType == 1
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black
                      : secondaryColor
                  : themeController.isDarkMode.value
                      ? Colors.black
                      : secondaryColor,
              title: customText(
                  text: labelTremsConditions,
                  color: themeController.isDarkMode.value
                      ? secondaryColor
                      : whiteColor),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                        child: const CustomWidgets().serviceCard(
                            serviceActiveStatus: true,
                            serviceName: labelCar,
                            serviceImagePath: appBuyCarIcon,
                            onTap: () {
                              getRoute(APIsConstant().carTermConditionURl);
                            })),
                    const SizedBox(width: 10.0),
                    Expanded(
                        child: const CustomWidgets().serviceCard(
                            serviceActiveStatus: true,
                            serviceName: labelCaravans,
                            serviceImagePath: appCaravanIcon,
                            onTap: () {
                              getRoute(APIsConstant().caravanTermConditionURl);
                            })),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: const CustomWidgets().serviceCard(
                            serviceActiveStatus: true,
                            serviceName: labelMotorHomes,
                            serviceImagePath: appMotorHomeIcon,
                            onTap: () {
                              getRoute(
                                  APIsConstant().motorhomeTermConditionURl);
                            })),
                    Container(width: 10.0),
                    Expanded(
                        child: const CustomWidgets().serviceCard(
                            serviceActiveStatus: true,
                            serviceName: labelMotorbikes,
                            serviceImagePath: appMotorBikeIcon,
                            onTap: () {
                              getRoute(APIsConstant().bikeTermConditionURl);
                            })),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: const CustomWidgets().serviceCard(
                            serviceActiveStatus: true,
                            serviceName: labelMobilityScooter,
                            serviceImagePath: appScooterIcon,
                            onTap: () {
                              getRoute(APIsConstant()
                                  .mobilityScooterTermConditionURl);
                            })),
                    Container(width: 10.0),
                    Expanded(child: Container()),
                  ],
                ),
              ],
            ),
          ),
        ),
        context);
  }
}
