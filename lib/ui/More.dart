import 'package:assist/Controllers/home_screen_controller.dart';
import 'package:assist/apis/apis_constant.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/ui/my_transactions.dart';
import 'package:assist/ui/terms_condition.dart';
import 'package:assist/ui/version_history.dart';
import 'package:assist/ui/view_plan_details.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_images_path.dart';
import '../utils/common_functions.dart';
import '../utils/custom_widgets.dart';
import 'authenticate_fingerprint.dart';
import 'change_password.dart';
import 'job_booking_list.dart';

class More extends StatelessWidget {
  final String? profileUrl;
  final HomeScreenController hsc;
  final String? name;

  const More(
      {Key? key,
      required this.profileUrl,
      required this.name,
      required this.hsc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tag = "More";
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() => Container(
              width: Get.width * 0.7,
              decoration: BoxDecoration(
                  color: global.themeType == 1
                      ? MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Colors.black
                          : whiteColor
                      : hsc.themeController.isDarkMode.value
                          ? Colors.black
                          : whiteColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0))),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    // height: Get.height * 0.07,
                    child: Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                                bottom: 0.0, right: 10, left: 0), //10
                            height: Get.height * 0.1, //140
                            width: Get.width * 0.2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: secondaryColor,
                                width: 2, //8
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    profileUrl ?? '',
                                  )),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            customText(
                                text: hi, size: 20, color: secondaryColor),
                            Flexible(
                              child: SizedBox(
                                width: Get.width / 2.6,
                                child: customText(
                                    text: name ?? '',
                                    size: 18,
                                    overflow: TextOverflow.ellipsis,
                                    color: secondaryColor,
                                    maxLines: 1),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const CustomWidgets()
                      .moreScreenCard(context, labelMyTransaction, () {
                    Get.back();
                    Get.to(() => MyTransactions(), popGesture: true);
                  },
                          transactionIcon,
                          hsc.themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black),
                  const CustomWidgets().moreScreenCard(context, labelJobBooking,
                      () {
                    Get.back();
                    Get.to(() => JobBookingList(),
                        popGesture: true,
                        arguments: {"screenType": "JobBookingList"});
                  },
                      bookingIcon,
                      hsc.themeController.isDarkMode.value
                          ? Colors.white
                          : Colors.black),
                  const CustomWidgets()
                      .moreScreenCard(context, labelBuyRoadsideAssistance, () {
                    Get.back();
                    Get.to(
                        () => ViewPlanDetails(
                              userId: global.userId,
                              loginWay: 4,
                            ),
                        popGesture: true);
                  },
                          buyIcon,
                          hsc.themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black),
                  const CustomWidgets()
                      .moreScreenCard(context, labelTremsConditions, () {
                    Get.back();
                    Get.to(() => TermsCondition(), popGesture: true);
                  },
                          tncIcon,
                          hsc.themeController.isDarkMode.value
                              ? Colors.white
                              : Colors.black),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: ExpansionTile(
                        onExpansionChanged: (value) {
                          printMessage(tag, "Expanded : $value");
                          hsc.toggleExpanded();
                        },
                        tilePadding: EdgeInsets.zero,
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              appThemeIcon,
                              colorFilter: ColorFilter.mode(
                                  secondaryColor, BlendMode.srcIn),
                              width: 24.0,
                              height: 24.0,
                            ),
                            const SizedBox(
                              width: 32.0,
                            ),
                            customText(
                                text: labelAppTheme,
                                color: hsc.themeController.isDarkMode.value
                                    ? whiteColor
                                    : blackColor),
                          ],
                        ),
                        trailing: Icon(
                          (hsc.isExpanded.value)
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: (hsc.isExpanded.value) ? 25.0 : 25.0,
                          color: secondaryColor,
                        ),
                        childrenPadding: const EdgeInsets.only(left: 30),
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: hsc.appTheme.value,
                                onChanged: (value) {
                                  hsc.themeController.changeTheme(
                                    value,
                                  );
                                  hsc.changeAppTheme(value);
                                  printMessage(tag, hsc.appTheme.value);
                                  hsc.themeController
                                      .changeTheme(hsc.appTheme.value);
                                },
                                activeColor: secondaryColor,
                              ),
                              InkWell(
                                onTap: () {
                                  hsc.changeAppTheme(1);
                                  printMessage(tag, hsc.appTheme.value);
                                  hsc.themeController.changeTheme(
                                    hsc.appTheme.value,
                                  );
                                },
                                child: customText(
                                    text: labelSystemTheme, ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 1.0,
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: hsc.appTheme.value,
                                onChanged: (value) {
                                  hsc.themeController.changeTheme(
                                    value,
                                  );
                                  hsc.changeAppTheme(value);

                                  printMessage(tag, hsc.appTheme.value);

                                  hsc.themeController.changeTheme(
                                    hsc.appTheme.value,
                                  );
                                },
                                activeColor: secondaryColor,
                              ),
                              InkWell(
                                onTap: () {
                                  hsc.changeAppTheme(2);
                                  printMessage(tag, hsc.appTheme.value);
                                  hsc.themeController.changeTheme(
                                    hsc.appTheme.value,
                                  );
                                },
                                child:
                                    customText(text: labelLightTheme, ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 1.0,
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 3,
                                groupValue: hsc.appTheme.value,
                                onChanged: (value) {
                                  hsc.themeController.changeTheme(
                                    value,
                                  );
                                  hsc.changeAppTheme(value);
                                  printMessage(tag, hsc.appTheme.value);
                                  hsc.themeController.changeTheme(
                                    hsc.appTheme.value,
                                  );
                                },
                                activeColor: secondaryColor,
                              ),
                              InkWell(
                                onTap: () {
                                  hsc.changeAppTheme(3);
                                  printMessage(tag, hsc.appTheme.value);
                                  hsc.themeController.changeTheme(
                                    hsc.appTheme.value,
                                  );
                                },
                                child:
                                    customText(text: labelDarkTheme, ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          )
                        ]),
                  ),
                  const CustomWidgets()
                      .moreScreenCard(context, "Version History", () {
                    Get.back();
                    Get.to(() => const VersionHistory(), popGesture: true);
                  },
                          verisonHistoryIcon,
                          hsc.themeController.isDarkMode.value
                              ? whiteColor
                              : blackColor),
                  hsc.authController.fingerPrintSupport
                      ? ListTile(
                          leading: Icon(
                            Icons.fingerprint,
                            color: secondaryColor,
                          ),
                          title: customText(text: biometric,),
                          trailing: CupertinoSwitch(
                            value: hsc.switchValue.value,
                            activeColor: secondaryColor,
                            onChanged: (value) {
                              if (value) {
                                Get.to(() => const AuthenticateFingerprint(),
                                        popGesture: true)
                                    ?.then((values) {
                                  if (values == false) {
                                    global.setUserWantAddBiometric(false);
                                  } else {
                                    hsc.authController
                                        .authenticateMe()
                                        .then((data) {
                                      debugPrint("ddddddd$data");
                                      global.setUserWantAddBiometric(data);
                                      hsc.switchValue.value = value;
                                    });
                                  }
                                });
                              } else {
                                const CustomWidgets()
                                    .showDialogForDisableBiometric(context, () {
                                  Get.back();
                                }, () {
                                  hsc.switchValue.value = value;
                                  hsc.global.setUserWantAddBiometric(false);
                                  Get.back();
                                });
                              }
                            },
                          ),
                        )
                      : const SizedBox(),
                  const CustomWidgets().moreScreenCard(
                      context, labelChangePassword, () {
                    Get.back();
                    Get.to(
                        () => ChangePassword(
                              mobileNumber: global.customerPhoneNumber,
                            ),
                        popGesture: true);
                  },
                      changePasswordIcon,
                      hsc.themeController.isDarkMode.value
                          ? whiteColor
                          : blackColor),
                  const CustomWidgets().moreScreenCard(context, labelSignOut,
                      () {
                    Get.back();
                    const CustomWidgets().showDialogForLogout();
                  },
                      logoutIcon,
                      hsc.themeController.isDarkMode.value
                          ? whiteColor
                          : blackColor),
                  const SizedBox(height: 50),
                  customText(
                      text: "Version : ${APIsConstant.version}",
                      size: 12,
                      textAlign: TextAlign.center,
                      color: secondaryColor),
                ],
              ),
            )),
      ),
    ));
  }
}
