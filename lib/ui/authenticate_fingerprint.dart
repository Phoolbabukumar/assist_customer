import 'package:assist/app_constants/app_colors.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_constants/app_strings.dart';

class AuthenticateFingerprint extends StatelessWidget {
  const AuthenticateFingerprint({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async => false,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              height: Get.height,
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Get.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: Get.width * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: customText(
                                        text: authenticateFingerprint,
                                        size: 25,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w800,
                                        textAlign: TextAlign.center,
                                        maxLines: 2),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: customText(
                                        text: allowAssistToUseFingerprint,
                                        size: 18,
                                        fontWeight: FontWeight.w800,
                                        textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(50), // Image radius
                            child: Container(
                              height: Get.height * 0.2,
                              width: Get.width * 0.2,
                              color: secondaryColor,
                              child: const Icon(
                                Icons.fingerprint,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(30, 25, 30, 25),
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              )),
                          child: customText(text: loginQuickly, size: 15),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 8),
                          width: Get.width,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.75,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: customText(text: allow, size: 18),
                                    onPressed: () {
                                      Get.back(result: true);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.4,
                                  child: TextButton(
                                    child: customText(
                                      text: skip,
                                      size: 18,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    onPressed: () {
                                      Get.back(result: false);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
