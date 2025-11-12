import 'package:assist/ui/account/login_screen.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Controllers/signup_controller.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_images_path.dart';
import '../../app_constants/app_strings.dart';
import '../../utils/custom_widgets.dart';
import '../../utils/Widgets/widgets_file.dart';
import 'signup_otp.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpController = Get.put(SignUpController());
    return SafeArea(
      child: Scaffold(
          body: commonLoginDesign(
        context,
        Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(
                height: 40,
              ),
              customText(text: labelLetsGetKnow, size: 30, color: gray800),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: signUpController.firstNameController,
                focusNode: signUpController.firstNameFocusNode,
                maxLength: 50,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-z ]'))
                ],
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  counterText: "",
                  labelText: labelFirstName,
                  labelStyle: TextStyle(color: gray800),
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
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                focusNode: signUpController.lastNameFocusNode,
                maxLength: 50,
                controller: signUpController.lastNameController,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-z ]"))
                ],
                decoration: InputDecoration(
                  counterText: "",
                  labelText: labelLastName,
                  labelStyle: TextStyle(color: gray800),
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
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                focusNode: signUpController.emailFocusNode,
                maxLength: 50,
                controller: signUpController.emailController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  counterText: "",
                  labelText: labelEmail,
                  labelStyle: TextStyle(color: gray800),
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
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                focusNode: signUpController.mobileNumberFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return errorUserName;
                  }
                  if (value.length < 9) {
                    return errorUserNameLength;
                  }
                  return null;
                },
                controller: signUpController.mobileNumberController,
                maxLength: 9,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                ],
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
                      customText(text: labelAu, color: blackColor),
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
                  labelStyle: TextStyle(color: gray800),
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
              ),
              /* In this button check all text fields isEmpty or not and show error,if no error then perform api call for verify phone number if number doesn't exist then it send the otp and move to signUp otp screen  */
              Container(
                width: Get.width * 0.9,
                margin: const EdgeInsets.only(top: 50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  /* Here first check teh empty fields and then hit VerifyMobileNo. api*/
                  onPressed: () {
                    if (signUpController.firstNameController.value.text
                        .trim()
                        .isEmpty) {
                      const CustomWidgets()
                          .snackBar1(context, sbEnterFirstname);
                      FocusScope.of(context)
                          .requestFocus(signUpController.firstNameFocusNode);
                      return;
                    } else if (signUpController.lastNameController.value.text
                        .trim()
                        .isEmpty) {
                      const CustomWidgets().snackBar1(context, sbEnterLastname);
                      FocusScope.of(context)
                          .requestFocus(signUpController.lastNameFocusNode);
                      return;
                    } else if (signUpController.emailController.value.text
                        .trim()
                        .isEmpty) {
                      const CustomWidgets().snackBar1(context, sbEnterEmailid);
                      FocusScope.of(context)
                          .requestFocus(signUpController.emailFocusNode);
                      return;
                    } else if (signUpController.emailRegex.hasMatch(
                            signUpController.emailController.value.text
                                .trim()) ==
                        false) {
                      const CustomWidgets()
                          .snackBar1(context, sbEnterValidEmail);
                      FocusScope.of(context)
                          .requestFocus(signUpController.emailFocusNode);
                      return;
                    } else if (signUpController
                        .mobileNumberController.value.text
                        .trim()
                        .isEmpty) {
                      const CustomWidgets()
                          .snackBar1(context, sbEnterPhoneNumber);
                      FocusScope.of(context)
                          .requestFocus(signUpController.mobileNumberFocusNode);
                      return;
                    } else if (signUpController
                            .mobileNumberController.value.text.length <
                        9) {
                      const CustomWidgets()
                          .snackBar1(context, sbEnterValidPhone);
                      return;
                    }

                    signUpController.loginController
                        .verifyMobileNumber(signUpController
                            .mobileNumberController.value.text
                            .trim())
                        .then((value) {
                      if (value != null) {
                        if (value['StatusCode'] == 1) {
                          const CustomWidgets()
                              .showDialogForExistUser(Get.context);
                        } else {
                          const CustomWidgets().showDialogForVerifyPhoneNumber(
                              Get.context!,
                              "$dialogVerificationCode ${signUpController.mobileNumberController.value.text.trim()}.$dialogSentOnPhone",
                              signUpController
                                  .mobileNumberController.value.text, () {
                            Get.back();
                          }, () {
                            Get.back();

                            signUpController
                                .sendOTPToSignUp(
                              signUpController.firstNameController.value.text
                                  .trim(),
                              signUpController.lastNameController.value.text
                                  .trim(),
                              signUpController.mobileNumberController.value.text
                                  .trim(),
                              signUpController.emailController.value.text
                                  .trim(),
                            )
                                .then((value) {
                              if (value != null) {
                                if (value['StatusCode'] == 1) {
                                  Get.off(
                                      () => SignUpOTP(
                                            mobileNumber: signUpController
                                                .mobileNumberController
                                                .value
                                                .text
                                                .trim(),
                                            firstName: signUpController
                                                .firstNameController.value.text
                                                .trim(),
                                            lastName: signUpController
                                                .lastNameController.value.text
                                                .trim(),
                                            email: signUpController
                                                .emailController.value.text
                                                .trim(),
                                            customerId:
                                                value['CustomerID'].toString(),
                                          ),
                                      arguments: {"screenType": "SignUpOtp"});
                                } else {
                                  const CustomWidgets()
                                      .showDialogForExistUser(Get.context);
                                }
                              } else {
                                const CustomWidgets()
                                    .snackBar1(Get.context!, labelErrorText);
                              }
                            });
                          });
                        }
                      }
                    });
                  },
                  child:
                      customText(text: labelNext, size: 16, color: whiteColor),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: labelAlreadyAMemberText,
                        style: TextStyle(color: gray500, fontSize: 15.0)),
                    TextSpan(
                      text: labelSignIn,
                      style: TextStyle(color: secondaryColor, fontSize: 15.0),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.off(() => const LoginScreen());
                        },
                    ),
                  ])),
                ],
              ),
            ])),
      )),
    );
  }
}
