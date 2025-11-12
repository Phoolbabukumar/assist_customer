import 'package:assist/Controllers/login_with_credential_controller.dart';
import 'package:assist/utils/common_functions.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../Network/networkwidget.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_images_path.dart';
import '../../app_constants/app_strings.dart';
import '../../utils/custom_widgets.dart';
import '../authenticate_fingerprint.dart';
import '../map_home_screen.dart';

class LoginWithCredential extends StatelessWidget {
  final String? mobileNumber;
  final String? customerId;
  final int loginType;
  LoginWithCredential(
      {super.key,
      required this.loginType,
      required this.mobileNumber,
      required this.customerId});

  final loginWithCredetialController = Get.put(LoginWithCredentialController());
  @override
  Widget build(BuildContext context) {
    String tag = "Login with Credential";
    /* Here we can Set the values in obs variables, because it will be changed further */
    loginWithCredetialController.loginType.value = loginType;
    loginWithCredetialController.mobileNumber.value = mobileNumber!;
    loginWithCredetialController.customerid.value = customerId!;
    if (loginType != 1) {
      loginWithCredetialController.startTimer();
    }
    return networkWidget(
        SafeArea(
          child: Scaffold(
            body: Container(
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
                    Obx(
                      () => loginWithCredetialController.loginType.value == 1
                          ? Container(
                              height: Get.height * 0.6,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  customText(
                                      text: hintEnterPassword,
                                      size: 22,
                                      color: blackColor,
                                      fontWeight: FontWeight.w700,
                                      textAlign: TextAlign.center),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 0.0),
                                    child: TextFormField(
                                      maxLength: 18,
                                      focusNode: loginWithCredetialController
                                          .passwordFocusNode,
                                      controller: loginWithCredetialController
                                          .userPasswordController,
                                      keyboardType: TextInputType.text,
                                      obscureText: loginWithCredetialController
                                          .passwordVisible.value,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: hintEnterPassword,
                                        labelStyle: TextStyle(color: gray800),
                                        floatingLabelStyle:
                                            TextStyle(color: secondaryColor),
                                        errorStyle:
                                            TextStyle(color: secondaryColor),
                                        counterText: '',
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
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            loginWithCredetialController
                                                    .passwordVisible.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: secondaryColor,
                                          ),
                                          onPressed: () {
                                            loginWithCredetialController
                                                .togglePasswordVisibility();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 0.0),
                                        child: Text.rich(
                                          textAlign: TextAlign.end,
                                          TextSpan(children: [
                                            TextSpan(
                                              text: forgotPassword,
                                              style: TextStyle(
                                                color: secondaryColor,
                                                fontSize: 14,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              /* First verify the number and then send the opt on that number and change the values and rebuild the ui as otp screen */
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  loginWithCredetialController
                                                      .loginController
                                                      .verifyMobileNumber(
                                                          mobileNumber
                                                              .toString())
                                                      .then((value) {
                                                    if (value != null &&
                                                        value['StatusCode'] ==
                                                            1) {
                                                      loginWithCredetialController
                                                          .loginController
                                                          .sendOTPToLogin(
                                                              mobileNumber
                                                                  .toString())
                                                          .then((value) {
                                                        if (value != null) {
                                                          loginWithCredetialController
                                                              .enableResendOption
                                                              .value = false;
                                                          loginWithCredetialController
                                                              .startTimer();
                                                          loginWithCredetialController
                                                              .loginType
                                                              .value = 3;
                                                          loginWithCredetialController
                                                                  .mobileNumber
                                                                  .value =
                                                              value.phone
                                                                  .toString();
                                                          customerId;
                                                          value.customerID
                                                              .toString();
                                                        } else {
                                                          const CustomWidgets()
                                                              .snackBar1(
                                                                  Get.context!,
                                                                  backendError);
                                                        }
                                                      });
                                                    } else {
                                                      const CustomWidgets()
                                                          .showDialogForUserNotExist(
                                                              Get.context);
                                                    }
                                                  });
                                                },
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      width: Get.width,
                                      padding: const EdgeInsets.fromLTRB(
                                          20.0, 50.0, 20.0, 0.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: secondaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        /* perform api and set values in global and check the biometric and then move to the next screen accordingly */
                                        onPressed: () {
                                          loginWithCredetialController
                                              .passwordFocusNode
                                              ?.unfocus();

                                          if (loginWithCredetialController
                                              .userPasswordController
                                              .value
                                              .text
                                              .isNotEmpty) {
                                            loginWithCredetialController
                                                .loginController
                                                .getLogin(
                                                    mobileNumber ?? "",
                                                    loginWithCredetialController
                                                        .userPasswordController
                                                        .value
                                                        .text)
                                                .then((onValue) async {
                                              debugPrint(
                                                  "in onValue   $onValue");
                                              debugPrint(
                                                  "${onValue ?? [].length}");

                                              if (onValue != null) {
                                                int? statusCode =
                                                    onValue.statusCode;

                                                if (statusCode == 1) {
                                                  int? userId = onValue.uID;
                                                  String? phoneNumber =
                                                      onValue.phone;

                                                  saveUserIdPhoneToPrefs(
                                                      userId, phoneNumber);

                                                  if (!global.isFirstTime &&
                                                      loginWithCredetialController
                                                          .authController
                                                          .fingerPrintSupport) {
                                                    Get.to(
                                                            () =>
                                                                const AuthenticateFingerprint(),
                                                            popGesture: true)
                                                        ?.then((value) {
                                                      if (value == false) {
                                                        global
                                                            .setUserWantAddBiometric(
                                                                false);
                                                        Get.back();
                                                        Get.offAll(() =>
                                                            MapHomeScreen(
                                                                currentIndexValue:
                                                                    0));
                                                        // Get.offAll(()=>HomeScreen());
                                                      } else {
                                                        Get.back();
                                                        loginWithCredetialController
                                                            .authController
                                                            .authenticateMe()
                                                            .then((data) {
                                                          debugPrint(
                                                              "ddddddd$data");

                                                          if (data) {
                                                            Get.offAll(() =>
                                                                MapHomeScreen(
                                                                    currentIndexValue:
                                                                        0));
                                                          }
                                                          global
                                                              .setUserWantAddBiometric(
                                                                  data);
                                                        });
                                                      }
                                                    });
                                                  } else {
                                                    Get.offAll(() =>
                                                        MapHomeScreen(
                                                            currentIndexValue:
                                                                0));
                                                  }
                                                } else {
                                                  // bbhag ja
                                                  const CustomWidgets()
                                                      .snackBar1(Get.context!,
                                                          sbInvalidPassword);
                                                }
                                              } else {
                                                debugPrint("is not login");
                                                const CustomWidgets().snackBar1(
                                                    Get.context!,
                                                    sbInvalidPassword);
                                              }
                                            }, onError: (error) {
                                              Get.back();
                                              printMessage("ffffff", error);
                                              const CustomWidgets().snackBar1(
                                                  Get.context!,
                                                  sbInvalidPassword);
                                            });
                                          } else {
                                            const CustomWidgets().snackBar1(
                                                context, sbEnterPassword);
                                            FocusScope.of(context).requestFocus(
                                                loginWithCredetialController
                                                    .passwordFocusNode);
                                          }
                                        },
                                        child: customText(
                                            text: labelSignIn,
                                            size: 16,
                                            color: whiteColor),
                                      )),
                                ],
                              ))
                          : Wrap(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  width: Get.width,
                                  child: Column(
                                    children: [
                                      customText(
                                          text: labelVerifyAuthCode,
                                          size: 22,
                                          color: blackColor,
                                          fontWeight: FontWeight.w700,
                                          textAlign: TextAlign.center),
                                      const SizedBox(
                                        height: 30.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: customText(
                                            text:
                                                "$labelEnterAuthCode$mobileNumber",
                                            size: 16,
                                            color: blackColor,
                                            fontWeight: FontWeight.w700,
                                            textAlign: TextAlign.center),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 40.0,
                                            right: 40.0,
                                            bottom: 15.0),
                                        child: Center(
                                            child: PinFieldAutoFill(
                                          controller:
                                              loginWithCredetialController
                                                  .optTextController,
                                          codeLength: 6,
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          decoration: UnderlineDecoration(
                                            textStyle: const TextStyle(
                                                fontSize: 30,
                                                color: Colors.black),
                                            colorBuilder: FixedColorBuilder(
                                              secondaryColor,
                                            ),
                                          ),
                                          cursor: Cursor(
                                            width: 1.5,
                                            height: 20,
                                            color: secondaryColor,
                                            radius: const Radius.circular(1),
                                            enabled: true,
                                          ),
                                          currentCode:
                                              loginWithCredetialController
                                                  .optTextController.value.text,
                                          onCodeSubmitted: (code) {
                                            printMessage(tag, "Code : $code");
                                          },
                                          /* when 6 digits filled it check the loginType 2 is for direct otp and 3 is when user tap on forgot password and then come on this section it perform the second api call */
                                          onCodeChanged: (code) {
                                            if (code?.length == 6) {
                                              closeKeyBoard(context);
                                              loginType == 2
                                                  ? loginWithCredetialController
                                                      .sendOTPToHomePage(
                                                          code.toString(),
                                                          mobileNumber,
                                                          customerId)
                                                  : loginWithCredetialController
                                                      .forgetPasswordOTP(
                                                          code.toString(),
                                                          mobileNumber);
                                            }
                                          },
                                        )),
                                      ),
                                      const SizedBox(
                                        height: 30.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: secondaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            child: customText(
                                                text: loginType == 2
                                                    ? labelSignIn
                                                    : labelVerify,
                                                size: 18),
                                            onPressed: () {
                                              final otp =
                                                  loginWithCredetialController
                                                      .optTextController
                                                      .value
                                                      .text
                                                      .toString();
                                              printMessage(
                                                  tag, "OTP is : $otp");

                                              loginType == 2
                                                  ? loginWithCredetialController
                                                      .sendOTPToHomePage(
                                                          otp.toString(),
                                                          mobileNumber,
                                                          customerId)
                                                  : loginWithCredetialController
                                                      .forgetPasswordOTP(
                                                          otp.toString(),
                                                          mobileNumber);
                                            },
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 8, 8, 8),
                                            child: loginWithCredetialController
                                                    .enableResendOption.value
                                                ? InkWell(
                                                    onTap: () {
                                                      loginWithCredetialController
                                                          .loginController
                                                          .sendOTPToLogin(
                                                              mobileNumber)
                                                          .then((value) {
                                                        if (value != null) {
                                                          loginWithCredetialController
                                                              .enableResendOption
                                                              .value = false;
                                                          loginWithCredetialController
                                                              .startTimer();
                                                          const CustomWidgets()
                                                              .snackBar1(
                                                                  Get.context!,
                                                                  labelCodeSent);
                                                        } else {
                                                          const CustomWidgets()
                                                              .snackBar1(
                                                                  Get.context!,
                                                                  backEndErrorText);
                                                        }
                                                      });
                                                    },
                                                    child: customText(
                                                        text: labelResendCode,
                                                        size: 15,
                                                        color: secondaryColor),
                                                  )
                                                : customText(
                                                    text:
                                                        "00:${loginWithCredetialController.start.value < 10 ? "0${loginWithCredetialController.start.value}" : loginWithCredetialController.start.value}",
                                                    size: 15,
                                                    color: blackColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        context);
  }
}
