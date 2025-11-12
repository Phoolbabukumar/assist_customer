import 'package:assist/utils/common_functions.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/login_controller.dart';
import '../Network/networkwidget.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_strings.dart';
import '../utils/custom_widgets.dart';

class ChangePassword extends StatelessWidget {
  final String? mobileNumber;
  const ChangePassword({super.key, this.mobileNumber});

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.put(LoginController());
    return networkWidget(
        SafeArea(
            child: Scaffold(
          appBar: const CustomWidgets().appBar(
              context,
              0.0,
              global.themeType == 1
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black
                      : secondaryColor
                  : loginController.themecontroller.isDarkMode.value
                      ? Colors.black
                      : secondaryColor,
              IconThemeData(
                  color: loginController.themecontroller.isDarkMode.value
                      ? secondaryColor
                      : Colors.white),
              customText(
                  text: changePasswordText,
                  color: loginController.themecontroller.isDarkMode.value
                      ? secondaryColor
                      : Colors.white),
              true),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Obx(
                          () => TextFormField(
                            maxLength: 18,
                            controller: loginController.passwordOldController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return errorEnterOldPassword;
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            obscureText:
                                loginController.passwordOldVisible.value,
                            decoration: InputDecoration(
                              counterText: '',
                              labelText: labelOldPassword,
                              errorStyle: TextStyle(color: secondaryColor),
                              floatingLabelStyle:
                                  TextStyle(color: secondaryColor),
                              // Here is key idea
                              suffixIcon: IconButton(
                                icon: Icon(
                                  loginController.passwordOldVisible.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: secondaryColor,
                                ),
                                onPressed: () {
                                  loginController.togglePasswordOldVisible();
                                },
                              ),

                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: secondaryColor),
                              ),
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Obx(
                            () => TextFormField(
                              maxLength: 18,
                              controller: loginController.passwordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return errorEnterOldPassword;
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              obscureText:
                                  loginController.passwordNewVisible.value,
                              decoration: InputDecoration(
                                counterText: '',
                                labelText: labelNewPassword,
                                errorStyle: TextStyle(color: secondaryColor),
                                floatingLabelStyle:
                                    TextStyle(color: secondaryColor),
                                // Here is key idea
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    loginController.passwordNewVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: secondaryColor,
                                  ),
                                  onPressed: () {
                                    loginController.togglepasswordNewVisible();
                                  },
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: secondaryColor),
                                ),
                              ),
                            ),
                          ),
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
                                keyboardType: TextInputType.text,
                                obscureText:
                                    loginController.passwordReVisible.value,
                                decoration: InputDecoration(
                                  counterText: '',
                                  labelText: labelConfirmNewPassword,
                                  floatingLabelStyle:
                                      TextStyle(color: secondaryColor),
                                  errorStyle: TextStyle(color: secondaryColor),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: secondaryColor),
                                  ),

                                  // Here is key idea
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      loginController.passwordReVisible.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: secondaryColor,
                                    ),
                                    onPressed: () {
                                      loginController.togglepasswordReVisible();
                                    },
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          customText(text: passwordWarning, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: Get.width * 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        var oldPassword = loginController
                            .passwordOldController.value.text
                            .toString();
                        var newPassword = loginController
                            .passwordController.value.text
                            .toString();
                        var rePassword = loginController
                            .confirmNewPasswordController.value.text
                            .toString();

                        closeKeyBoard(Get.context);

                        if (oldPassword.isEmpty) {
                          const CustomWidgets()
                              .snackBar(context, sbEnterOldpassword);
                          return;
                        } else if (newPassword.isEmpty) {
                          const CustomWidgets()
                              .snackBar(context, sbEnterNewpassword);
                          return;
                        } else if (passwrdPattern.hasMatch(newPassword) ==
                            false) {
                          const CustomWidgets()
                              .snackBar(context, sbEnterValidPassword);
                          return;
                        } else if (rePassword.isEmpty) {
                          const CustomWidgets()
                              .snackBar(context, sbEnterConfirmPassword);
                          return;
                        } else if (newPassword.toString() !=
                            rePassword.toString()) {
                          const CustomWidgets()
                              .snackBar(context, sbPasswordNotMatch);
                          return;
                        }

                        const CustomWidgets()
                            .showDialogForChangePassword(context, () {
                          Get.back();

                          loginController
                              .changePassword(
                                  mobileNumber ?? '', oldPassword, newPassword)
                              .then((value) {
                            if (value['error'] != null) {
                              const CustomWidgets()
                                  .snackBar(Get.context!, value['error']);
                            } else if (value['StatusCode'] == 1) {
                              const CustomWidgets().snackBar(
                                  Get.context!, sbPasswordChangeSuccess);
                            } else {
                              const CustomWidgets().snackBar(
                                  Get.context!, sbOldPasswordIncorrect);
                            }
                          });
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
                          color: whiteColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
        context);
  }
}
