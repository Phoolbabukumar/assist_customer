import 'package:assist/Controllers/login_controller.dart';
import 'package:assist/Controllers/profile_data_controller.dart';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/ui/account/otp_screen.dart';
import 'package:assist/utils/common_functions.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_images_path.dart';
import '../../app_constants/app_strings.dart';
import '../../utils/custom_widgets.dart';

class EditPhoneScreen extends StatelessWidget {
  final String oldPhone;
  final ProfileDataController profileDataController;
  const EditPhoneScreen(
      {super.key, required this.oldPhone, required this.profileDataController});

  @override
  Widget build(BuildContext context) {
    final newPhoneController = TextEditingController();
    final oldPhoneController = TextEditingController(text: oldPhone);
    return networkWidget(GetBuilder<ProfileDataController>(builder: (builder) {
      return SafeArea(
          child: Scaffold(
        appBar: const CustomWidgets().appBar(
            context,
            0.0,
            global.themeType == 1
                ? MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? Colors.black
                    : secondaryColor
                : builder.themecontroller.isDarkMode.value
                    ? Colors.black
                    : secondaryColor,
            IconThemeData(
                color: builder.themecontroller.isDarkMode.value
                    ? secondaryColor
                    : Colors.white),
            Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 80, bottom: 80, top: 80),
                child: SizedBox(
                  height: Get.height * 0.15,
                  width: Get.width * 0.35,
                  child: Image.asset(
                    builder.themecontroller.isDarkMode.value
                        ? newLogo
                        : newLogoBlack,
                    color: builder.themecontroller.isDarkMode.value
                        ? null
                        : Colors.white,
                  ),
                )),
            true),
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: oldPhoneController,
                  readOnly: true,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return enterOldPhoneNumber;
                    }
                    if (value.length < 9) {
                      return enterCorrectOldPhoneNumber;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          austrailiaFlagImage,
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 4),
                        customText(
                          text: labelAu,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          width: 1,
                          height: 20,
                          color: Colors.grey,
                        )
                      ],
                    ),
                    labelText: labelOldMobileNumber,
                    counterText: "",
                    contentPadding: const EdgeInsets.only(left: 10),
                    floatingLabelStyle: TextStyle(color: secondaryColor),
                    errorStyle: TextStyle(color: secondaryColor),
                    helperStyle: TextStyle(color: secondaryColor),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor),
                    ),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: TextFormField(
                  maxLength: 9,
                  keyboardType: TextInputType.number,
                  controller: newPhoneController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return enterNewPhoneNumber;
                    }
                    if (value.length < 9) {
                      return enterCorrectNewPhoneNumber;
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          austrailiaFlagImage,
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 4),
                        customText(
                          text: labelAu,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          width: 1,
                          height: 20,
                          color: Colors.grey,
                        )
                      ],
                    ),
                    labelText: enter9DigitNumber,
                    counterText: "",
                    contentPadding: const EdgeInsets.only(left: 10),
                    floatingLabelStyle: TextStyle(color: secondaryColor),
                    errorStyle: TextStyle(color: secondaryColor),
                    helperStyle: TextStyle(color: secondaryColor),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor),
                    ),
                  ),
                )),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: customText(text: labelUpdate, size: 18),
                  onPressed: () {
                    if (builder.isValidEditPhone(
                        text: oldPhoneController.text)) {
                      LoginController()
                          .verifyMobileNumber(newPhoneController.text)
                          .then((value) {
                        if (value['StatusCode'] == 1) {
                          const CustomWidgets()
                              .showDialogForExistUser2(Get.context);
                        } else {
                          builder
                              .sendOTP(newPhoneController.text,
                                  oldPhoneController.text)
                              .then((value) async {
                            closeKeyBoard(Get.context);

                            if (value['StatusCode'] == 1) {
                              // ignore: unused_local_variable
                              var xFormatMobile =
                                  hidePhone(newPhoneController.text.toString());

                              Get.to(
                                  () => OTPScreen(
                                      newPhoneNumber:
                                          newPhoneController.text.toString(),
                                      oldPhoneNumber:
                                          oldPhoneController.text.toString(),
                                      otpLength: value['OTP']),
                                  popGesture: true,
                                  arguments: {"screenType": "EditPhoneScreen"});
                            } else {
                              const CustomWidgets().snackBar(Get.context!,
                                  errorSomethingWentWorngTryLater);
                            }
                          });
                        }
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ));
    }), context);
  }
}
