import 'package:assist/Controllers/login_controller.dart';
import 'package:assist/app_constants/app_colors.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/ui/account/login_with_credential.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Network/networkwidget.dart';
import '../../app_constants/app_images_path.dart';
import '../../utils/custom_widgets.dart';

class LoginType extends StatelessWidget {
  final String? mobileNumber;
  const LoginType({super.key, this.mobileNumber});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    return networkWidget(
        SafeArea(
          child: Scaffold(
            body: Container(
                width: Get.width,
                height: Get.height,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: Get.height * 0.18,
                            width: Get.width * 0.4,
                            decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(120))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    appLogo,
                                    height: Get.height * 0.15,
                                    width: Get.width * 0.35,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                                text: chooseWay,
                                size: 25,
                                color: blackColor,
                                fontWeight: FontWeight.w600),
                            const SizedBox(
                              height: 30,
                            ),
                            /* login with otp works from here */
                            InkWell(
                              onTap: () async {
                                final value = await loginController
                                    .oTPToLogin(mobileNumber);

                                if (value != null) {
                                  Get.to(
                                      () => LoginWithCredential(
                                            loginType: 2,
                                            mobileNumber: mobileNumber,
                                            customerId:
                                                value.customerID.toString(),
                                          ),
                                      popGesture: true);
                                } else {
                                  const CustomWidgets()
                                      .snackBar1(Get.context!, backendError);
                                }
                              },
                              child: Container(
                                  height: Get.height * 0.1,
                                  width: Get.width * 0.9,
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.password,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: customText(
                                            text: signInWithCode,
                                            size: 15,
                                            color: blackColor,
                                            textAlign: TextAlign.left),
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            /* login with Password works from here */
                            InkWell(
                              onTap: () {
                                Get.to(
                                    () => LoginWithCredential(
                                          loginType: 1,
                                          mobileNumber: mobileNumber,
                                          customerId: "",
                                        ),
                                    popGesture: true);
                              },
                              child: Container(
                                  height: Get.height * 0.1,
                                  width: Get.width * 0.9,
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: Colors.black),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.lock_open_outlined,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: customText(
                                            text: signInWithPassword,
                                            size: 15,
                                            color: blackColor,
                                            textAlign: TextAlign.center),
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                width: Get.width * 0.85,
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: labelNote,
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontSize: 15.0)),
                                  TextSpan(
                                      text: usePasswordAsWebPortal,
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontSize: 15.0)),
                                ]))),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                )),
          ),
        ),
        context);
  }
}
