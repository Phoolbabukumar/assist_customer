import 'package:assist/app_constants/app_images_path.dart';
import 'package:assist/ui/view_plan_details.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_constants/app_colors.dart';
import '../../app_constants/app_strings.dart';

class IntroScreen extends StatelessWidget {
  final String? mobileNumber;
  final String? customerId;

  const IntroScreen(
      {super.key, required this.mobileNumber, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            backgroundColor: gray900,
            body: Container(
                decoration: BoxDecoration(
                    color: gray900,
                    image: DecorationImage(
                        image: AssetImage(test), fit: BoxFit.fill)),
                child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(
                        left: 32, top: 45, right: 32, bottom: 45),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: Get.width * 0.62,
                                margin: const EdgeInsets.only(top: 50),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: opacitySecondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.off(() => ViewPlanDetails(
                                        userId: customerId ?? '', loginWay: 0));
                                  },
                                  child: customText(
                                      text: letGetStarted,
                                      size: 16,
                                      color: whiteColor),
                                ),
                              ),
                            ],
                          ),
                        ])))));
  }
}
