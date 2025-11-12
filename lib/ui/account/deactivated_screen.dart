import 'package:assist/Controllers/home_screen_controller.dart';
import 'package:assist/app_constants/app_colors.dart';
import 'package:assist/app_constants/app_images_path.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Network/networkwidget.dart';
import '../../app_constants/app_strings.dart';
import '../../utils/common_functions.dart';
import '../../utils/custom_widgets.dart';
import 'package:assist/ui/account/login_screen.dart';

class DeactivatedScreen extends StatelessWidget {
  final HomeScreenController hsc;
  const DeactivatedScreen({super.key, required this.hsc});

  @override
  Widget build(BuildContext context) {
    return networkWidget(
        SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const CustomWidgets().appBar(
                context,
                4.0,
                global.themeType == 1
                    ? MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.black
                        : secondaryColor
                    : hsc.themeController.isDarkMode.value
                        ? Colors.black
                        : secondaryColor,
                const IconThemeData(color: Colors.white),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.2,
                    vertical: Get.height * 0.4,
                  ),
                  child: Image.asset(
                    newLogoBlack,
                    color: Colors.white,
                  ),
                ),true),
            body: Container(
              height: Get.height,
              width: Get.width,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    customText(text: inProcessOfDeletion, size: 30, color: null,textAlign: TextAlign.center),
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    customText(text: contactForRestoreMembership, size: 18,textAlign: TextAlign.center),
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    Icon(
                      Icons.auto_delete_outlined,
                      color: secondaryColor,
                      size: Get.height * 0.2,
                    ),
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    SizedBox(
                      width: Get.width * 0.8,
                      child: ElevatedButton(
                          onPressed: () {
                            global.logoutStorage();
                            Get.offAll(() => const LoginScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: customText(text: labelSignOut, size: 16)
                           ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        makePhoneCall(global.phoneNoRetailer);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone),
                          const SizedBox(
                            width: 3,
                          ),
                          customText(text: callCustomerSupport, size: 18,textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        context);
  }
}
