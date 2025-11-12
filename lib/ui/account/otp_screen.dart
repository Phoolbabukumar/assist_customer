import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../Controllers/otp_controller.dart';
import '../../Network/networkwidget.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_images_path.dart';
import '../../app_constants/app_strings.dart';
import '../../utils/common_functions.dart';
import '../../utils/custom_widgets.dart';

class OTPScreen extends StatelessWidget {
  final String? newPhoneNumber;
  final String? oldPhoneNumber;
  final String? otpLength;

  OTPScreen(
      {super.key,
      required this.newPhoneNumber,
      required this.oldPhoneNumber,
      required this.otpLength});

  final otpController = Get.put(OTPController());

  @override
  Widget build(BuildContext context) {
    return networkWidget(GetBuilder<OTPController>(builder: (builder) {
      return SafeArea(
        child: Scaffold(
          appBar: const CustomWidgets().appBar(
              context,
              0.0,
              global.themeType == 1
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black
                      : secondaryColor
                  : builder.profileController!.themecontroller.isDarkMode.value
                      ? Colors.black
                      : secondaryColor,
              IconThemeData(
                  color: builder
                          .profileController!.themecontroller.isDarkMode.value
                      ? secondaryColor
                      : Colors.white),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 80, bottom: 80, top: 80),
                  child: Image.asset(
                    global.themeType == 1
                        ? MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? newLogo
                            : newLogoBlack
                        : builder.profileController!.themecontroller.isDarkMode
                                .value
                            ? newLogo
                            : newLogoBlack,

                    //themeController.isDarkMode.value ? newLogo : newLogoBlack,
                    color: global.themeType == 1
                        ? MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? null
                            : Colors.white
                        : builder.profileController!.themecontroller.isDarkMode
                                .value
                            ? null
                            : Colors.white,

                    // themeController.isDarkMode.value ? null : Colors.white,
                  )),
              true),
          body: SizedBox(
            height: Get.height,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                width: Get.width,
                //height: Get.height*0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    customText(
                        text: labelVerifyAuthCode,
                        size: 22,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: customText(
                          text: "$labelEnterAuthCode$newPhoneNumber",
                          size: 16,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40.0, right: 40.0, bottom: 15.0),
                      child: Center(
                          child: PinFieldAutoFill(
                        controller: builder.optTextController,
                        codeLength: 6,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: UnderlineDecoration(
                          textStyle: TextStyle(
                            fontSize: 30,
                            color: global.themeType == 1
                                ? MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black
                                : builder.profileController!.themecontroller
                                        .isDarkMode.value
                                    ? Colors.white
                                    : Colors.black,
                          ),
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
                        currentCode: builder.optTextController.text,
                        onCodeSubmitted: (code) {},
                        onCodeChanged: (code) {
                          if (code?.length == 6) {
                            closeKeyBoard(context);
                            builder.validateOtp(
                                realOtp: code,
                                otpLength: otpLength,
                                oldPhoneNumber: oldPhoneNumber,
                                newPhoneNumber: newPhoneNumber);
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
                          child: customText(text: labelVerify, size: 18),
                          onPressed: () {
                            var otp = builder.optTextController.text.toString();

                            builder.validateOtp(
                              realOtp: otp,
                              otpLength: otpLength,
                              oldPhoneNumber: oldPhoneNumber,
                              newPhoneNumber: newPhoneNumber,
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: builder.resendVisible.value
                              ? InkWell(
                                  onTap: () {
                                    otpController.profileController!
                                        .sendOTP(newPhoneNumber,
                                            oldPhoneNumber ?? '')
                                        .then((value) async {
                                      closeKeyBoard(Get.context);

                                      builder.optTextController.text = "";
                                      if (value != null) {
                                        builder.resendVisible.value = false;
                                        builder.startTimer();

                                        const CustomWidgets().snackBar1(
                                            Get.context!,
                                            "Code sent successfully.");
                                      } else {
                                        const CustomWidgets().snackBar1(
                                            Get.context!, backEndErrorText);
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
                                      "00:${builder.timer.value < 10 ? "0${builder.timer.value}" : builder.timer.value}",
                                  size: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }), context);
  }
}
