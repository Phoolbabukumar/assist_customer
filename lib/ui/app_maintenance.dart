import 'dart:developer';
import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/apis/base_client.dart';
import 'package:assist/app_constants/app_colors.dart';
import 'package:assist/app_constants/app_images_path.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/ui/account/login_screen.dart';
import 'package:assist/ui/map_home_screen.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:assist/utils/size_config.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppMaintanenceScreen extends StatelessWidget {
  final String msg;
  const AppMaintanenceScreen({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    final themecontroller = Get.put(ThemeController());
    return Scaffold(
      appBar: const CustomWidgets().appBar(
          context,
          4.0,
          global.themeType == 1
              ? MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Colors.black26
                  : secondaryColor
              : themecontroller.isDarkMode.value
                  ? Colors.black26
                  : secondaryColor,
          IconThemeData(
              color: global.themeType == 1
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? secondaryColor
                      : Colors.white
                  : themecontroller.isDarkMode.value
                      ? secondaryColor
                      : Colors.white),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2,
              vertical: MediaQuery.of(context).size.height * 0.2,
            ),
            child: SizedBox(
              child: Image.asset(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.35,
                themecontroller.isDarkMode.value ? newLogo : newLogo,
                color: global.themeType == 1
                    ? MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? null
                        : Colors.white
                    : themecontroller.isDarkMode.value
                        ? null
                        : Colors.white,
              ),
            ),
          ),
          false),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixed,
        backgroundColor: global.themeType == 1
            ? MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.black
                : Colors.white
            : themecontroller.isDarkMode.value
                ? Colors.black
                : whiteColor,
        activeColor: secondaryColor,
        color: global.themeType == 1
            ? MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.white
                : transparentBlack
            : themecontroller.isDarkMode.value
                ? Colors.white
                : transparentBlack,
        height: 50.0,
        elevation: 10.0,
        curveSize: 100.0,
        initialActiveIndex: 0,
        items: [
          TabItem(icon: Icons.map_outlined, title: labelMap),
          TabItem(icon: Icons.directions_car, title: labelRoadside),
          TabItem(icon: Icons.phone, title: labelSupport),
          TabItem(icon: Icons.group, title: labelMembership),
          TabItem(icon: Icons.person, title: labelProfile),
        ],
        onTap: (int i) {},
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: EdgeInsets.only(
                right: 8,
                left: 8,
                bottom: MediaQuery.of(context).size.height * 0.12),
            decoration: BoxDecoration(
                border: Border.all(color: gray500),
                borderRadius: BorderRadius.circular(10)),
            child: customText(
                text: msg,
                size: 18,
                color: gray500,
                fontWeight: FontWeight.w500),
          ),
          Image.asset(
            "assets/images/under_maintanence_image.png",
            fit: BoxFit.fill,
            color: themecontroller.isDarkMode.value ? gray400 : gray800,
          ),
          customText(
              text: appUnderMaintenance,
              size: 18,
              color:
                  themecontroller.isDarkMode.value ? whiteColor : blackColor),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  BaseClient.appMaintanenceApi().then(
                    (value) {
                      if (value != null) {
                        log("maintanence screen tap response $value");
                        if (value["StatusCode"] != "503") {
                          if (global.profileUserFirstName.isEmpty) {
                            global.logoutStorage();
                            Get.offAll(() => const LoginScreen());
                          } else {
                            Get.offAll(() => MapHomeScreen(
                                  currentIndexValue: 0,
                                ));
                          }
                        }
                      }
                    },
                  );
                },
                child:
                    customText(text: labelRetry, size: 16, color: whiteColor),
              ))
        ],
      )),
    );
  }
}
