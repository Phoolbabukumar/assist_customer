import 'package:assist/ui/Singup/intro_screen.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../Controllers/signup_controller.dart';
import '../../Network/networkwidget.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_images_path.dart';
import '../../app_constants/app_strings.dart';
import '../../utils/common_functions.dart';
import '../../utils/custom_widgets.dart';

class VerifySignUp extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final String? customerId;
  VerifySignUp(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.customerId});

  final signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return networkWidget(
        SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Obx(() => signUpController.isLoading.value == false
                  ? Container(
                      color: Colors.white,
                      height: Get.height,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                width: Get.width,
                                padding: const EdgeInsets.only(
                                    left: 15, top: 11, right: 15, bottom: 11),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          margin: const EdgeInsets.only(
                                              top: 79, right: 91, left: 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              customText(
                                                  text:
                                                      "$hi, ${capitalize(firstName ?? '')}",
                                                  size: 40,
                                                  color: gray700,
                                                  fontWeight: FontWeight.w500,
                                                  textAlign: TextAlign.left),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              customText(
                                                  text: letSetupAccount,
                                                  size: 30,
                                                  color: gray700,
                                                  fontWeight: FontWeight.w500,
                                                  textAlign: TextAlign.left),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),

                                            TextFormField(
                                              controller: signUpController
                                                  .emailController,
                                              readOnly: true,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                labelText: labelEmail,
                                                labelStyle:
                                                    TextStyle(color: gray800),
                                                floatingLabelStyle: TextStyle(
                                                    color: secondaryColor),
                                                errorStyle: TextStyle(
                                                    color: secondaryColor),
                                                helperStyle: TextStyle(
                                                    color: secondaryColor),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),

                                            TextFormField(
                                              readOnly: true,
                                              controller: signUpController
                                                  .mobileNumberController,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 10,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]')),
                                              ],
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                prefixIcon: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                        text: labelAu,
                                                        color: blackColor),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      width: 1,
                                                      height: 20,
                                                      color: Colors.grey,
                                                    )
                                                  ],
                                                ),
                                                counterText: "",
                                                labelText: labelMobile,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 10),
                                                // Adjust the padding values as needed
                                                labelStyle:
                                                    TextStyle(color: gray800),
                                                floatingLabelStyle: TextStyle(
                                                    color: secondaryColor),
                                                errorStyle: TextStyle(
                                                    color: secondaryColor),

                                                helperStyle: TextStyle(
                                                    color: secondaryColor),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),

                                            TextFormField(
                                              controller: signUpController
                                                  .addressController,
                                              focusNode: signUpController
                                                  .addressFocusNode,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              keyboardType:
                                                  TextInputType.multiline,
                                              onChanged: (value) {
                                                signUpController.isAddressChange
                                                    .value = true;
                                                if (value.isNotEmpty) {
                                                  signUpController
                                                      .isCurrentAddSuggestion
                                                      .value = true;
                                                } else {
                                                  signUpController
                                                      .isCurrentAddSuggestion
                                                      .value = false;
                                                }
                                              },
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp("[a-zA-z0-9, ]"))
                                              ],
                                              decoration: InputDecoration(
                                                labelText: labelAddress,
                                                labelStyle:
                                                    TextStyle(color: gray800),
                                                floatingLabelStyle: TextStyle(
                                                    color: secondaryColor),
                                                errorStyle: TextStyle(
                                                    color: secondaryColor),
                                                helperStyle: TextStyle(
                                                    color: secondaryColor),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor),
                                                ),
                                              ),
                                            ),
                                            Obx(() => Visibility(
                                                  visible: signUpController
                                                      .isCurrentAddSuggestion
                                                      .value,
                                                  child: signUpController
                                                          .placeList.isNotEmpty
                                                      ? Container(
                                                          color: Colors.white,
                                                          child:
                                                              ListView.builder(
                                                            physics:
                                                                const BouncingScrollPhysics(),
                                                            itemCount:
                                                                signUpController
                                                                    .placeList
                                                                    .length,
                                                            shrinkWrap: true,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return ListTile(
                                                                title: customText(
                                                                    text: signUpController
                                                                            .placeList[index]
                                                                        [
                                                                        "description"],
                                                                    color:
                                                                        blackColor),
                                                                onTap: () {
                                                                  signUpController
                                                                      .addressController
                                                                      .text = signUpController
                                                                              .placeList[
                                                                          index]
                                                                      [
                                                                      "description"];
                                                                  signUpController
                                                                      .isCurrentAddSuggestion
                                                                      .value = false;
                                                                  signUpController.getLatLangFromCurrentAddress(
                                                                      signUpController
                                                                          .addressController
                                                                          .text);

                                                                  signUpController
                                                                      .addressFocusNode
                                                                      .unfocus();
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 0,
                                                        ),
                                                )),

                                            const SizedBox(
                                              height: 10,
                                            ),

                                            ///password

                                            Obx(() => TextFormField(
                                                  maxLength: 18,
                                                  controller: signUpController
                                                      .passwordController,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  obscureText: signUpController
                                                      .passwordVisible.value,
                                                  decoration: InputDecoration(
                                                    counterText: '',
                                                    labelText: labelPassword,
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        signUpController
                                                                .passwordVisible
                                                                .value
                                                            ? Icons
                                                                .visibility_off
                                                            : Icons.visibility,
                                                        color: secondaryColor,
                                                      ),
                                                      onPressed: () {
                                                        signUpController
                                                            .togglePasswordVisible();
                                                      },
                                                    ),
                                                    labelStyle: TextStyle(
                                                        color: gray800),
                                                    floatingLabelStyle:
                                                        TextStyle(
                                                            color:
                                                                secondaryColor),
                                                    errorStyle: TextStyle(
                                                        color: secondaryColor),
                                                    helperStyle: TextStyle(
                                                        color: secondaryColor),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              secondaryColor),
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              secondaryColor),
                                                    ),
                                                  ),
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),

                                            /// confirm password
                                            Obx(() => TextFormField(
                                                  maxLength: 18,
                                                  controller: signUpController
                                                      .confirmPasswordController,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  obscureText: signUpController
                                                      .confirmPasswordVisible
                                                      .value,
                                                  decoration: InputDecoration(
                                                    counterText: '',
                                                    labelText:
                                                        labelConfirmPassword,
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        signUpController
                                                                .confirmPasswordVisible
                                                                .value
                                                            ? Icons
                                                                .visibility_off
                                                            : Icons.visibility,
                                                        color: secondaryColor,
                                                      ),
                                                      onPressed: () {
                                                        signUpController
                                                            .toggleConfirmPasswordVisible();
                                                      },
                                                    ),
                                                    labelStyle: TextStyle(
                                                        color: gray800),
                                                    floatingLabelStyle:
                                                        TextStyle(
                                                            color:
                                                                secondaryColor),
                                                    errorStyle: TextStyle(
                                                        color: secondaryColor),
                                                    helperStyle: TextStyle(
                                                        color: secondaryColor),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              secondaryColor),
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              secondaryColor),
                                                    ),
                                                  ),
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            customText(
                                                text: passwordWarning,
                                                color: Colors.grey),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            customText(
                                                text:
                                                    labelHowWouldLikeToContact,
                                                color: blackColor),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Obx((() => Checkbox(
                                                          value:
                                                              signUpController
                                                                  .sms.value,
                                                          activeColor:
                                                              secondaryColor,
                                                          fillColor: WidgetStateProperty
                                                              .all(signUpController
                                                                      .sms.value
                                                                  ? secondaryColor
                                                                  : Colors
                                                                      .black),
                                                          onChanged: (value) {
                                                            signUpController.sms
                                                                .value = value!;
                                                          },
                                                        ))),
                                                    customText(
                                                        text: labelSms,
                                                        size: 18,
                                                        color: blackColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Obx(() => Checkbox(
                                                          value:
                                                              signUpController
                                                                  .email.value,
                                                          activeColor:
                                                              secondaryColor,
                                                          fillColor: WidgetStateProperty
                                                              .all(signUpController
                                                                      .email
                                                                      .value
                                                                  ? secondaryColor
                                                                  : Colors
                                                                      .black),
                                                          onChanged: (value) {
                                                            signUpController
                                                                .email
                                                                .value = value!;
                                                          },
                                                        )),
                                                    customText(
                                                        text: labelEmail,
                                                        size: 18,
                                                        color: blackColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Obx(() => Checkbox(
                                                          value:
                                                              signUpController
                                                                  .post.value,
                                                          activeColor:
                                                              secondaryColor,
                                                          fillColor: WidgetStateProperty
                                                              .all(signUpController
                                                                      .post
                                                                      .value
                                                                  ? secondaryColor
                                                                  : Colors
                                                                      .black),
                                                          onChanged: (value) {
                                                            signUpController
                                                                .post
                                                                .value = value!;
                                                          },
                                                        )),
                                                    customText(
                                                        text: labelPost,
                                                        size: 18,
                                                        color: blackColor,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            const SizedBox(
                                              height: 30,
                                            ),

                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              margin: const EdgeInsets.only(
                                                  top: 50),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      secondaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  bool checkCurrentAddress =
                                                      false;

                                                  for (int i = 0;
                                                      i <
                                                          signUpController
                                                              .placeList.length;
                                                      i++) {
                                                    var item = signUpController
                                                            .placeList[i]
                                                        ["description"];

                                                    if (signUpController
                                                            .addressController
                                                            .text ==
                                                        item) {
                                                      checkCurrentAddress =
                                                          true;
                                                      break;
                                                    }
                                                  }

                                                  if (signUpController
                                                      .addressController.text
                                                      .trim()
                                                      .isEmpty) {
                                                    const CustomWidgets()
                                                        .snackBar1(context,
                                                            sbEnterAddress);
                                                    return;
                                                  }
                                                  if (signUpController
                                                      .isAddressChange.value) {
                                                    if (!checkCurrentAddress) {
                                                      const CustomWidgets()
                                                          .snackBar1(context,
                                                              errorSelectYourAddress);
                                                      return;
                                                    }
                                                  }

                                                  if (signUpController
                                                      .passwordController
                                                      .text
                                                      .isEmpty) {
                                                    const CustomWidgets()
                                                        .snackBar1(context,
                                                            sbEnterPassword);
                                                    return;
                                                  } else if (passwrdPattern
                                                          .hasMatch(signUpController
                                                              .passwordController
                                                              .text) ==
                                                      false) {
                                                    const CustomWidgets()
                                                        .snackBar1(context,
                                                            sbEnterValidPassword);
                                                    return;
                                                  } else if (signUpController
                                                      .confirmPasswordController
                                                      .text
                                                      .isEmpty) {
                                                    const CustomWidgets().snackBar1(
                                                        context,
                                                        sbEnterConfirmPassword);
                                                    return;
                                                  } else if (signUpController
                                                          .passwordController
                                                          .text !=
                                                      signUpController
                                                          .confirmPasswordController
                                                          .text) {
                                                    const CustomWidgets()
                                                        .snackBar1(context,
                                                            sbPasswordNotMatch);
                                                    return;
                                                  }

                                                  String checkData = "";

                                                  if (signUpController
                                                          .sms.value &&
                                                      signUpController
                                                          .email.value &&
                                                      signUpController
                                                          .post.value) {
                                                    checkData =
                                                        "SMS@Email@Post";
                                                  } else if (signUpController
                                                          .sms.value &&
                                                      signUpController
                                                          .email.value) {
                                                    checkData = "SMS@Email";
                                                  } else if (signUpController
                                                          .sms.value &&
                                                      signUpController
                                                          .post.value) {
                                                    checkData = "SMS@Post";
                                                  } else if (signUpController
                                                          .email.value &&
                                                      signUpController
                                                          .post.value) {
                                                    checkData = "Email@Post";
                                                  } else if (signUpController
                                                          .email.value &&
                                                      signUpController
                                                          .sms.value) {
                                                    checkData = "SMS@Email";
                                                  } else if (signUpController
                                                          .post.value &&
                                                      signUpController
                                                          .sms.value) {
                                                    checkData = "SMS@Post";
                                                  } else if (signUpController
                                                          .post.value &&
                                                      signUpController
                                                          .email.value) {
                                                    checkData = "Email@Post";
                                                  } else if (signUpController
                                                      .post.value) {
                                                    checkData = "Post";
                                                  } else if (signUpController
                                                      .email.value) {
                                                    checkData = "Email";
                                                  } else if (signUpController
                                                      .sms.value) {
                                                    checkData = "SMS";
                                                  }
                                                  signUpController
                                                      .addRemainingDataToSignUp(
                                                          customerId ?? "",
                                                          signUpController
                                                              .addressController
                                                              .text
                                                              .trim(),
                                                          signUpController.city,
                                                          signUpController
                                                              .state,
                                                          signUpController
                                                              .postalCode,
                                                          signUpController
                                                              .passwordController
                                                              .text,
                                                          checkData.toString())
                                                      .then((value) {
                                                    if (value != null) {
                                                      Get.off(() => IntroScreen(
                                                            mobileNumber:
                                                                signUpController
                                                                    .mobile,
                                                            customerId:
                                                                customerId,
                                                          ));
                                                    } else {
                                                      const CustomWidgets()
                                                          .snackBar1(
                                                              Get.context!,
                                                              sbPleaseTryAgain);
                                                    }
                                                  });
                                                },
                                                child: customText(
                                                    text: becomeAMember,
                                                    size: 16,
                                                    color: whiteColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Image.asset(
                      loadingIcon,
                      width: 80,
                      height: 90,
                      fit: BoxFit.fill,
                    )))),
        ),
        context);
  }
}
