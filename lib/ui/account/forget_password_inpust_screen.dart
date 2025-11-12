import 'package:assist/ui/account/login_type.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/login_controller.dart';
import '../../Network/networkwidget.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_images_path.dart';
import '../../app_constants/app_strings.dart';
import '../../utils/custom_widgets.dart';

class ForgetPasswordInputScreen extends StatelessWidget {
  final String mobileNumber;
  ForgetPasswordInputScreen({super.key, required this.mobileNumber});

  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return networkWidget(
        SafeArea(
            child: Scaffold(
          body: Container(
            height: Get.height,
            color: Colors.white,
            child: SingleChildScrollView(
              child: SizedBox(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Container(
                      height: Get.height * 0.7,
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customText(
                              text: labelResetPassword,
                              size: 25,
                              color: blackColor),
                          const SizedBox(
                            height: 25,
                          ),
                          customText(
                              text: setNewPasswordForYourAccount,
                              size: 15,
                              color: gray800),
                          const SizedBox(
                            height: 25,
                          ),
                          Column(
                            children: [
                              Obx(() => TextFormField(
                                    controller:
                                        loginController.passwordController,
                                    maxLength: 18,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return errorEnterOldPassword;
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.text,
                                    obscureText: loginController
                                        .passwordNewVisible.value,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      labelText: labelNewPassword,
                                      labelStyle: TextStyle(color: gray800),

                                      floatingLabelStyle:
                                          TextStyle(color: secondaryColor),
                                      errorStyle:
                                          TextStyle(color: secondaryColor),

                                      // Here is key idea
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          loginController
                                                  .passwordNewVisible.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: secondaryColor,
                                        ),
                                        onPressed: () {
                                          loginController
                                              .togglepasswordNewVisible();
                                        },
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: secondaryColor),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: secondaryColor),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(() => TextFormField(
                                    maxLength: 18,
                                    controller: loginController
                                        .confirmNewPasswordController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return errorEnterOldPassword;
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.text,
                                    obscureText:
                                        loginController.passwordReVisible.value,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      labelText: labelConfirmNewPassword,
                                      labelStyle: TextStyle(color: gray800),
                                      floatingLabelStyle:
                                          TextStyle(color: secondaryColor),
                                      errorStyle:
                                          TextStyle(color: secondaryColor),

                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: secondaryColor),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: secondaryColor),
                                      ),

                                      // Here is key idea
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          loginController
                                                  .passwordReVisible.value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: secondaryColor,
                                        ),
                                        onPressed: () {
                                          loginController
                                              .togglepasswordReVisible();
                                        },
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              customText(
                                  text: passwordWarning, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: Get.width * 0.91,
                                child: ElevatedButton(
                                  onPressed: () {
                                    var newPassword = loginController
                                        .passwordController.text
                                        .toString();
                                    var rePassword = loginController
                                        .confirmNewPasswordController.text
                                        .toString();

                                    debugPrint(loginController
                                        .passwordController.text
                                        .toString());
                                    debugPrint(loginController
                                        .confirmNewPasswordController.text
                                        .toString());
                                    debugPrint(
                                        "${loginController.passwrdPattern.hasMatch(loginController.passwordController.text.toString())}");

                                    if (newPassword.isEmpty) {
                                      const CustomWidgets().snackBar1(
                                          context, sbEnterNewpassword);
                                      return;
                                    } else if (loginController.passwrdPattern
                                            .hasMatch(loginController
                                                .passwordController.text
                                                .toString()) ==
                                        false) {
                                      const CustomWidgets().snackBar1(
                                          context, enterValidPassword);
                                      return;
                                    } else if (rePassword.isEmpty) {
                                      const CustomWidgets().snackBar1(
                                          context, sbEnterConfirmPassword);
                                      return;
                                    } else if (newPassword.toString() !=
                                        rePassword.toString()) {
                                      const CustomWidgets()
                                          .snackBar1(context, passwordNotMatch);
                                      return;
                                    }

                                    loginController
                                        .resetPassword(
                                            mobileNumber, newPassword)
                                        .then((value) {
                                      if (value['StatusCode'] == 1) {
                                        const CustomWidgets().snackBar1(
                                            Get.context!,
                                            passChangeSuccessfully);
                                        Get.off(() => LoginType(
                                            mobileNumber: mobileNumber));
                                      } else {
                                        const CustomWidgets().snackBar1(
                                            Get.context!, labelIncorrectCode);
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: secondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Center(
                                    child: customText(
                                        text: updatePassword,
                                        size: 18,
                                        color: whiteColor),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )),
        context);
  }
}
