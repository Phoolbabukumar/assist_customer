import 'package:assist/Controllers/login_controller.dart';
import 'package:assist/Controllers/otp_controller.dart';
import 'package:assist/ui/Singup/verify_signup.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../Network/networkwidget.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_images_path.dart';
import '../../app_constants/app_strings.dart';
import '../../utils/common_functions.dart';
import '../../utils/custom_widgets.dart';

class SignUpOTP extends StatelessWidget {
  final String? mobileNumber;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? customerId;
  SignUpOTP(
      {super.key,
      required this.mobileNumber,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.customerId});

  final loginController = Get.put(LoginController());
  final otpController = Get.put(OTPController());

  final defaultPinTheme = const PinTheme(
    width: 56,
    height: 60,
    textStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
    ),
    decoration: BoxDecoration(),
  );

  @override
  Widget build(BuildContext context) {
    var tag = "Login with Credential";
    return networkWidget(
        SafeArea(
          child: Scaffold(
              body: Container(
            height: Get.height,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                  Wrap(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: Get.width,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: customText(
                                  text: "$labelEnterAuthCode$mobileNumber",
                                  size: 16,
                                  color: blackColor,
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.center),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 40.0, right: 40.0, bottom: 15.0),
                              child: Center(
                                  child: PinFieldAutoFill(
                                controller: otpController.optTextController,
                                codeLength: 6,
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                decoration: UnderlineDecoration(
                                  textStyle: const TextStyle(
                                      fontSize: 30, color: Colors.black),
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
                                    otpController.optTextController.text,
                                onCodeSubmitted: (code) {
                                  printMessage(tag, "Code : $code");
                                },
                                onCodeChanged: (code) {
                                  if (code!.length == 6) {
                                    closeKeyBoard(context);

                                    loginController
                                        .verifyOTP(mobileNumber ?? '', code)
                                        .then((value) {
                                      if (value['StatusCode'] == 1) {
                                        Get.off(
                                            () => VerifySignUp(
                                                  firstName: firstName,
                                                  lastName: lastName,
                                                  customerId: customerId,
                                                ),
                                            arguments: {
                                              "screenType": "VerifySignUp",
                                              "mobile": mobileNumber,
                                              "email": email
                                            });
                                      } else {
                                        const CustomWidgets().snackBar1(
                                            Get.context!, labelIncorrectCode);
                                      }
                                    });
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
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: customText(
                                      text: labelGetVerified, size: 18),
                                  onPressed: () {
                                    var otp = otpController
                                        .optTextController.text
                                        .toString();
                                    printMessage(tag, "OTP is : $otp");

                                    if (otp.length == 6) {
                                      loginController
                                          .verifyOTP(mobileNumber ?? '', otp)
                                          .then((value) {
                                        if (value['StatusCode'] == 1) {
                                          Get.off(
                                              () => VerifySignUp(
                                                  firstName: firstName,
                                                  lastName: lastName,
                                                  customerId: customerId),
                                              arguments: {
                                                "screenType": "VerifySignUp",
                                                "mobile": mobileNumber,
                                                "email": email
                                              });
                                        } else {
                                          const CustomWidgets().snackBar1(
                                              Get.context!, labelIncorrectCode);
                                        }
                                      });
                                    } else {
                                      if (otpController
                                          .optTextController.text.isNotEmpty) {
                                        const CustomWidgets().snackBar1(
                                            context, labelErrorDigitLength);
                                      } else {
                                        const CustomWidgets().snackBar1(
                                            context, labelErrorEmptyCode);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    child: Obx(
                                      () => otpController.resendVisible.value
                                          ? InkWell(
                                              onTap: () {
                                                loginController
                                                    .sendOTPToLogin(
                                                        mobileNumber)
                                                    .then((value) {
                                                  if (value != null) {
                                                    otpController.resendVisible
                                                        .value = false;
                                                    otpController.timerActive
                                                        .value = true;
                                                    otpController.startTimer();

                                                    const CustomWidgets()
                                                        .snackBar1(Get.context!,
                                                            labelCodeSent);
                                                  } else {
                                                    const CustomWidgets()
                                                        .snackBar1(Get.context!,
                                                            backEndErrorText);
                                                  }
                                                });
                                              },
                                              child: customText(
                                                  text: labelResendCode,
                                                  size: 15,
                                                  color: secondaryColor),
                                            )
                                          : Visibility(
                                              visible: otpController
                                                  .timerActive.value,
                                              child: customText(
                                                  text:
                                                      "00:${otpController.timer.value < 10 ? "0${otpController.timer.value}" : otpController.timer.value}",
                                                  size: 15,
                                                  color: blackColor),
                                            ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
        ),
        context);
  }
}
