import 'package:assist/app_constants/app_colors.dart';
import 'package:assist/app_constants/app_images_path.dart';
import 'package:assist/ui/view_plan_details.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../Controllers/home_screen_controller.dart';
import '../Network/networkwidget.dart';
import '../app_constants/app_strings.dart';
import '../utils/custom_widgets.dart';
import 'package:assist/ui/account/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return networkWidget(GetBuilder<HomeScreenController>(builder: (builder) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const CustomWidgets().appBar(
              context,
              4.0,
              global.themeType == 1
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black
                      : secondaryColor
                  : builder.themeController.isDarkMode.value
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
              ),
              true),
          body: Container(
            height: Get.height,
            width: Get.width,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customText(
                    text: chooseYourPlan,
                    size: 30,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  customText(
                    text: youDontHaveAnyMembership,
                    size: 18,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  _buildInfoBlock(),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  SizedBox(
                    width: Get.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(
                            () => ViewPlanDetails(
                                userId: global.userId,
                                loginWay: global.isLogin ? 1 : 2),
                            popGesture: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: customText(text: buyNow, size: 16),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  InkWell(
                    onTap: () {
                      global.logoutStorage();
                      Get.offAll(() => const LoginScreen());
                    },
                    child: customText(
                        text: loginWithDifferentAccount,
                        size: 15,
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }), context);
  }

  _buildInfoBlock() {
    return Card(
      elevation: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 0.0,
            ),
            ListTile(
              leading: Icon(
                Icons.not_interested,
                size: 36,
                color: secondaryColor,
              ),
              title: customText(
                  text: labelNoJoingFees,
                  size: 16,
                  color: secondaryColor,
                  fontWeight: FontWeight.bold),
              subtitle: customText(text: labelNoHiddenFees, size: 13),
            ),
            const Divider(
              height: 1.0,
            ),
            ListTile(
              leading: SvgPicture.asset(
                mapAustralia,
                height: 36,
                width: 36,
                colorFilter: ColorFilter.mode(secondaryColor, BlendMode.srcIn),
              ),
              title: customText(
                  text: labelAustrliaWide,
                  size: 16,
                  color: secondaryColor,
                  fontWeight: FontWeight.bold),
              subtitle: customText(text: labelThroughoutNetwork, size: 13),
            ),
            const Divider(
              height: 1.0,
            ),
            ListTile(
              leading: Icon(
                Icons.check,
                size: 36,
                color: secondaryColor,
              ),
              title: customText(
                  text: labelUnlimitedCallouts,
                  size: 16,
                  color: secondaryColor,
                  fontWeight: FontWeight.bold),
              subtitle: customText(text: labelYouNeverBe, size: 13),
            ),
            const Divider(
              height: 1.0,
            ),
            ListTile(
              leading: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                    border: Border.all(color: secondaryColor, width: 3),
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.thumb_up_outlined,
                  size: 20,
                  color: secondaryColor,
                ),
              ),
              title: customText(
                  text: labelEasy,
                  size: 16,
                  color: secondaryColor,
                  fontWeight: FontWeight.bold),
              subtitle: customText(text: labelNoPaperwork, size: 13),
            ),
            const SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
