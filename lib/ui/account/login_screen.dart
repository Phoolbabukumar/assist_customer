import 'package:assist/Network/networkwidget.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/ui/Singup/signup_screen.dart';
import 'package:assist/ui/account/login_type.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Controllers/login_controller.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_images_path.dart';
import '../../utils/custom_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController());
    return networkWidget(
        SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: Container(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
                  child: InkWell(
                    onTap: () {
                      const CustomWidgets().launchURLBrowser(
                          "https://www.247roadservices.com.au/");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.language_rounded,
                          color: secondaryColor,
                        ),
                        Text(
                          redirectLinkText,
                          style: TextStyle(
                            color: secondaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            body: Container(
                height: Get.height,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                    text: welcomeTo,
                                    size: 35,
                                    color: blackColor),
                                customText(
                                    text: assist,
                                    size: 30,
                                    color: secondaryColor),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 0.0, 0.0),
                                child: customText(
                                    text: signInToContinue,
                                    size: 15,
                                    color: blackColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 10.0, 20.0, 20.0),
                                child: TextFormField(
                                  focusNode: loginController.userNameFocusNode,
                                  controller: loginController.userIDController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    prefixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          austrailiaFlagImage,
                                          height: 20,
                                          width: 20,
                                        ),
                                        const SizedBox(width: 4),
                                        customText(
                                            text: labelAu, color: blackColor),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          width: 1,
                                          height: 20,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                    counterText: "",
                                    labelText: labelPhone,
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    // Adjust the padding values as needed
                                    labelStyle: TextStyle(color: gray800),
                                    floatingLabelStyle:
                                        TextStyle(color: secondaryColor),
                                    errorStyle:
                                        TextStyle(color: secondaryColor),

                                    helperStyle:
                                        TextStyle(color: secondaryColor),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: secondaryColor),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: secondaryColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              width: Get.width,
                              padding: const EdgeInsets.fromLTRB(
                                  30.0, 30.0, 30.0, 0.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: secondaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onPressed: () async {
                                  if (loginController
                                      .userIDController.text.isEmpty) {
                                    const CustomWidgets()
                                        .snackBar1(context, errorUserName);
                                    return;
                                  } else if (loginController
                                          .userIDController.text.length <
                                      9) {
                                    const CustomWidgets().snackBar1(
                                        context, errorUserNameLength);
                                    return;
                                  }

                                  await loginController
                                      .verifyMobileNumber(loginController
                                          .userIDController.text
                                          .toString())
                                      .then((value) {
                                    if (value != null &&
                                        value['StatusCode'] == 1) {
                                      Get.to(
                                        () => LoginType(
                                          mobileNumber: loginController
                                              .userIDController.text,
                                        ),
                                      );
                                    } else if (value != null &&
                                        value['StatusCode'] == 0) {
                                      const CustomWidgets()
                                          .showDialogForUserNotExist(
                                              Get.context);
                                    }
                                  });
                                },
                                child: customText(
                                    text: labelSignIn,
                                    size: 16,
                                    color: whiteColor),
                              )),
                          SizedBox(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 25),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: dontHaveAccount,
                                      style: const TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15.0)),
                                  TextSpan(
                                    text: labelSignUp,
                                    style: TextStyle(
                                        color: secondaryColor, fontSize: 15.0),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.to(() => const SignUpScreen(),
                                            popGesture: true,
                                            arguments: {
                                              "screenType": "SignUpScreen"
                                            });
                                      },
                                  ),
                                ])),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ),
        context);
  }
}
