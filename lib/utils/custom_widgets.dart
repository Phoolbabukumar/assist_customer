import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:assist/Controllers/global_controller.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/ui/Singup/signup_screen.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_images_path.dart';
import 'package:assist/ui/account/login_screen.dart';

final global = Get.put(GlobalController());

class CustomWidgets extends StatelessWidget {
  const CustomWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

widgetLoadingData() {
  showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      context: Get.context!,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8),
                child: Image.asset(
                  loadingIcon,
                  width: 80,
                  height: 90,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void snackBar(BuildContext context, String message) {
    Get.snackbar(
      "",
      "",
      titleText: customText(
        text: message,
        textAlign: TextAlign.center,
        fontWeight: FontWeight.bold,
        size: 18,
        color: whiteColor,
      ),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 2500),
      backgroundColor: Get.isDarkMode ? Colors.black : secondaryColor,
      shouldIconPulse: false,
      isDismissible: true,
      maxWidth: 800,
      borderRadius: 0.0,
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 0.0),
      margin: const EdgeInsets.fromLTRB(0.00, 0.00, 0.00, 0.0),
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.fastOutSlowIn,
      reverseAnimationCurve: Curves.bounceInOut,
      animationDuration: const Duration(milliseconds: 250),
      overlayBlur: 1,
    );
  }

  void snackBar1(BuildContext context, String message) {
    Get.snackbar(
      "",
      "",
      titleText: customText(
        text: message,
        textAlign: TextAlign.center,
        fontWeight: FontWeight.bold,
        size: 18,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 2500),
      backgroundColor: secondaryColor,
      shouldIconPulse: false,
      isDismissible: true,
      maxWidth: 800,
      borderRadius: 0.0,
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
      margin: const EdgeInsets.fromLTRB(0.00, 0.00, 0.00, 0.0),
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.fastOutSlowIn,
      reverseAnimationCurve: Curves.bounceInOut,
      animationDuration: const Duration(milliseconds: 250),
      overlayBlur: 1,
    );
  }

  AppBar appBar(BuildContext context, double elevation, Color color,
      IconThemeData iconTheme, Widget widget, bool? autoimplyleading) {
    return AppBar(
      centerTitle: true,
      elevation: elevation,
      backgroundColor: color,
      iconTheme: iconTheme,
      title: widget,
      automaticallyImplyLeading: autoimplyleading ?? true,
    );
  }

  BottomNavigationBarItem bottomNavigationBarItem(
      BuildContext context, IconData icon, var tabBarName) {
    return BottomNavigationBarItem(
      backgroundColor: context.theme.colorScheme.surface,
      icon: Icon(
        icon,
      ),
      label: tabBarName,
    );
  }

  Widget textEditingField(
      BuildContext context,
      bool readOnly,
      TextInputType keyboardType,
      TextEditingController controller,
      var labelText,
      IconData icon,
      [List<TextInputFormatter>? textInputFormatter]) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
            maxLength: 50,
            readOnly: readOnly,
            keyboardType: keyboardType,
            controller: controller,
            inputFormatters: textInputFormatter ?? [],
            decoration: inputDecorationBox(context, labelText, icon)));
  }

  InputDecoration inputDecorationBox(
      BuildContext context, String labelText, IconData iconData) {
    return InputDecoration(
      counterText: "",
      labelText: labelText,
      prefixIcon: Icon(iconData, color: secondaryColor),
      labelStyle: const TextStyle(color: Colors.grey),
      floatingLabelStyle: TextStyle(color: secondaryColor),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: secondaryColor),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: secondaryColor),
      ),
    );
  }

  Widget textEditingFieldChangePassword(
      BuildContext context,
      bool readOnly,
      TextInputType keyboardType,
      TextEditingController controller,
      var labelText,
      IconData icon) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
            readOnly: readOnly,
            keyboardType: keyboardType,
            controller: controller,
            decoration:
                inputDecorationBoxChangePassword(context, labelText, icon)));
  }

  InputDecoration inputDecorationBoxChangePassword(
      BuildContext context, String labelText, IconData iconData) {
    return InputDecoration(
        counterText: "",
        labelText: labelText,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(5.0)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(5.0)),
        labelStyle: const TextStyle(
          fontFamily: "Avenir",
        ));
  }

  Widget moreScreenCard(BuildContext context, title, GestureTapCallback onTap,
      icon, Color textColor) {
    return ListTile(
      minVerticalPadding: 1,
      leading: (icon.toString() == "")
          ? const SizedBox(
              width: 0.0,
            )
          : SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(secondaryColor, BlendMode.srcIn),
              width: 24.0,
              height: 24.0,
            ),
      title: customText(
        text: title,
      ),
      onTap: onTap,
    );
  }

  Widget moreScreenCard1(
      BuildContext context, title, GestureTapCallback onTap, icon) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
      child: ListTile(
        leading: (icon.toString() == "")
            ? const SizedBox(
                width: 0.0,
              )
            : Icon(
                Icons.person,
                size: 24,
                color: secondaryColor,
              ),
        title: customText(
          text: title,
          size: 16,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16.0,
        ),
        onTap: onTap,
      ),
    );
  }

  buildShimmerBlock() {
    return SizedBox(
        child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: whiteColor,
            direction: ShimmerDirection.ltr,
            child: Column(
              children: [
                Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                  ),
                ),
                Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                  ),
                ),
                Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                  ),
                )
              ],
            )));
  }

  infoTilesOffWhite(context, key, value, color, bool isLineThrough) {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customText(
                    text: key,
                    fontWeight: FontWeight.w400,
                    size: 16,
                  ),
                ),
              ),
              const VerticalDivider(
                thickness: 1,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.right,
                  style: isLineThrough
                      ? TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: secondaryColor)
                      : const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  infoTilesOffWhite4(context, key, value, color, bool isLineThrough) {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                child: customText(
                  text: key,
                  fontWeight: FontWeight.w400,
                  size: 16,
                ),
              ),
              // const VerticalDivider(
              //   thickness: 1,
              // ),
              Expanded(
                flex: 6,
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.right,
                  style: isLineThrough
                      ? TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: secondaryColor)
                      : const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  infoTilesOffWhite3(key, value, color, bool isLineThrough) {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 0.0,
          right: 0.0,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 2, 8),
                child: customText(
                  text: key,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.fade,
                ),
              ),
              Text(
                ": ${value.toString()}",
                textAlign: TextAlign.right,
                style: isLineThrough
                    ? TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: secondaryColor)
                    : const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textForJobMap(BuildContext context, String text, double fontSize) {
    return customText(
      text: text,
      size: fontSize,
    );
  }

  Widget textForJobMap1(BuildContext context, String text, double fontSize) {
    return customText(
      text: text,
      textAlign: TextAlign.center,
      size: fontSize,
    );
  }

  InputDecoration dropDownSearchDecorationBox(
      BuildContext context, String labelText, IconData iconData) {
    return InputDecoration(
        labelText: labelText,
        contentPadding: const EdgeInsets.fromLTRB(2.0, 6.0, 0.0, 6.0),
        prefixIcon: Icon(iconData, color: secondaryColor),
        floatingLabelStyle: TextStyle(color: secondaryColor),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: secondaryColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: secondaryColor),
        ),
        labelStyle: const TextStyle(
          fontFamily: "Avenir",
        ));
  }

  void vehicleBodyTypeConfirmationDialogaa(
      BuildContext context, VoidCallback onConfirm) {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 20.0),
      contentPadding: const EdgeInsets.only(
          top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
      title: labelAreYouSure,
      textConfirm: labelConfirm,
      textCancel: labelCancel,
      confirm: ElevatedButton(
        onPressed: onConfirm,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: secondaryColor),
        child: customText(
          text: labelOk,
        ),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: blackColor),
        child: customText(
          text: labelCancel,
        ),
      ),
      middleText: labelMsg,
      middleTextStyle: const TextStyle(fontSize: 14),
    );
  }

  vehicleBodyTypeConfirmationDialog(context, VoidCallback onConfirm) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: labelAreYouSure,
        ),
        content: customText(text: labelMsg),
        actions: <Widget>[
          TextButton(
            onPressed: onConfirm,
            child: customText(text: labelOk, color: secondaryColor),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelCancel, color: cancelColor),
          ),
        ],
      ),
    );
  }

  Widget transactionStatus(Color color, Widget widget) {
    return Center(child: widget);
  }

  buildEmptyBlock(context) {
    return SizedBox(
      height: Get.height * 0.65,
      width: Get.width,
      // color: whiteColor,
      child: Center(
        child: customText(text: labelNoJobFound, size: 16.0),
      ),
    );
  }

  Widget serviceCard(
      {required bool serviceActiveStatus,
      required String serviceName,
      required String serviceImagePath,
      required GestureTapCallback onTap}) {
    return Card(
      elevation: 5.0,
      child: Container(
        height: MediaQuery.of(Get.context!).size.height * 0.2,
        width: MediaQuery.of(Get.context!).size.width / 2.4,
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                serviceImagePath,
                colorFilter: ColorFilter.mode(
                    serviceActiveStatus ? secondaryColor : Colors.grey,
                    BlendMode.srcIn),
                height: MediaQuery.of(Get.context!).size.height * 0.1,
                width: MediaQuery.of(Get.context!).size.width * 0.2,
              ),
              customText(
                  text: serviceName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  fontWeight: FontWeight.bold,
                  size: 12)
            ],
          ),
        ),
      ),
    );
  }

  showDialogForInActiveService(context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: labelPlanNotUpgraded,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelOk, color: secondaryColor),
          ),
        ],
      ),
    );
  }

  showDialogForInActive(context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: dialogInactiveUser,
          // "Your membership plan is not active. please contact customer support for assistance.",
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelOk, color: secondaryColor),
          ),
        ],
      ),
    );
  }

  showDialogForUserNotExist(context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Icon(Icons.error_outline),
        content: Text.rich(TextSpan(children: [
          TextSpan(
              text: dialogUserNotExist,
              //"Oops!\n The phone number does not exist in our records.\n Please sign up to continue.\n For more info please visit \n",
              style: const TextStyle(fontSize: 15.0)),
          TextSpan(
              text: "$websiteUrl\n",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.back();
                  launchURLBrowser("https://www.247roadservices.com.au/");
                },
              style: TextStyle(color: blueColor, fontSize: 15.0)),
        ])),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.to(() => const SignUpScreen(),
                  popGesture: true, arguments: {"screenType": "SignUpScreen"});
            },
            child: customText(
                text: labelSignUp,
                //"Sign up",
                color: secondaryColor),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelCancel, color: cancelColor),
          ),
        ],
      ),
    );
  }

  showDialogForEnableBiometric(
      context, VoidCallback? disableCalled, VoidCallback? enableCalled) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Icon(Icons.fingerprint),
        content: customText(text: dialogEnableBiometric),
        actions: <Widget>[
          TextButton(
            onPressed: enableCalled,
            child: customText(text: labelEnable, color: secondaryColor),
          ),
          TextButton(
            onPressed: disableCalled,
            child: customText(text: labelDisable, color: cancelColor),
          ),
        ],
      ),
    );
  }

  showBiometricEnable(
      context, VoidCallback? disableCalled, VoidCallback? enableCalled) {
    return Get.bottomSheet(StatefulBuilder(builder: (context, setState) {
      return Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            width: Get.width,
            decoration: BoxDecoration(
                color: Get.isDarkMode ? transparentBlack : Colors.white,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(25.0),
                    topLeft: Radius.circular(25.0))),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                              topRight: Radius.circular(20.0))),
                      child: customText(
                          text: labelFingerprint, color: whiteColor, size: 15),
                    ),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.close)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: customText(
                    text: dialogEnableBiometric,
                    size: 18.0,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Icon(
                  Icons.fingerprint,
                  color: secondaryColor,
                  size: Get.height * 0.1,
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: Get.width * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: enableCalled,
                          child: customText(
                            text: labelEnable,
                            size: 18,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blackColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: disableCalled,
                          child: customText(
                            text: labelCancel,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          )
        ],
      );
    }),
        barrierColor: transparentBlack,
        isScrollControlled: true,
        persistent: false,
        isDismissible: false);
  }

  showDialogForDisableBiometric(
      context, VoidCallback? disableCalled, VoidCallback? enableCalled) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Icon(Icons.fingerprint),
        content: customText(text: dialogDisableBiometric),
        actions: <Widget>[
          TextButton(
            onPressed: enableCalled,
            child: customText(text: labelYes, color: secondaryColor),
          ),
          TextButton(
            onPressed: disableCalled,
            child: customText(text: labelNo, color: cancelColor),
          ),
        ],
      ),
    );
  }

  showDialogRegoRequest(context, VoidCallback? onPressed) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Icon(Icons.error_outline),
        content: customText(
          text: dialogUpdateRegono,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            child: customText(text: labelUpdate, color: secondaryColor),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelCancel, color: cancelColor),
          ),
        ],
      ),
    );
  }

  showDialogForLogout() {
    return showDialog(
      context: Get.context!,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
          child: Icon(Icons.logout_outlined),
        ),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: customText(text: dialogSignout, size: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              global.logoutStorage();
              //global.clearStorage();
              Get.offAll(() => const LoginScreen());
            },
            child: customText(text: labelSignOut, color: secondaryColor),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelCancel, color: cancelColor),
          ),
        ],
      ),
    );
  }

  showDialogForExistUser(context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
          child: Icon(Icons.login),
        ),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: customText(text: dialogExistingUser, size: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              global.logoutStorage();
              //global.clearStorage();
              Get.offAll((context) => const LoginScreen());
            },
            child: customText(text: labelSignIn, color: secondaryColor),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelCancel, color: cancelColor),
          ),
        ],
      ),
    );
  }

  showDialogForChangePassword(context, VoidCallback onPressed) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
          child: Icon(Icons.logout_outlined),
        ),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: customText(text: dialogChangePassword, size: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            child: customText(text: labelOk, color: secondaryColor),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelCancel, color: cancelColor),
          ),
        ],
      ),
    );
  }

  showDialogForVerifyPhoneNumber(BuildContext context, String msg, String phone,
      VoidCallback onCancel, VoidCallback onConfirm) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: msg,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onConfirm,
            child: customText(text: labelOk, color: secondaryColor),
          ),
          TextButton(
            onPressed: onCancel,
            child: customText(text: labelEditText, color: cancelColor),
          ),
        ],
      ),
    );
  }

  membershipStatusDialog(context, String membershipStatus) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: "$labelMembershipIs $membershipStatus. $labelForService",
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelOk, color: secondaryColor),
          ),
        ],
      ),
    );
  }

  showDialogSignUpCompletion(context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: dialogSignupCompletion,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelOk, color: secondaryColor),
          ),
        ],
      ),
    );
  }

  jobActiveDialog(context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: labelCurrentlyJobActive,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelOk, color: secondaryColor),
          ),
        ],
      ),
    );
  }

  snackDialog(context) {
    return AlertDialog(content: customText(text: labelErrorFromBackend));
  }

  choosePlanCardDesign(
      BuildContext context, String textLabel, icon, Color cardColor) {
    return Card(
      elevation: 2,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: Get.width * 0.25,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: Get.height * 0.07,
                width: Get.width * 0.16,
                child: SvgPicture.asset(
                  icon,
                  colorFilter:
                      ColorFilter.mode(secondaryColor, BlendMode.srcIn),
                )),
            customText(
              text: textLabel,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Widget starIcon(BuildContext context, bool star, double size) {
    return Icon(
      Icons.star,
      size: size,
      color: star ? secondaryColor : Colors.grey,
    );
  }

  String dateConvertMethod(String date) {
    if (date.isNotEmpty) {
      var inputDate = DateTime.parse(date.toString());
      var outputFormat = DateFormat('dd/MM/yyyy');
      var outputDate = outputFormat.format(inputDate);
      debugPrint(outputDate);
      return outputDate.toString();
    }

    return "NA";
  }

  String dateConvertMethod1(String date) {
    if (date.isNotEmpty) {
      // ignore: unused_local_variable
      DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.S").parse(date);
      var inputDate = DateTime.parse(date.toString());
      var outputFormat = DateFormat('dd/MM/yyyy');
      var outputDate = outputFormat.format(inputDate);
      debugPrint(outputDate);
      return outputDate.toString();
    }

    return "NA";
  }

  void launchURLBrowser(String feedbackURL) async {
    // printMessage(TAG, feedbackURL);
    var url = Uri.parse(feedbackURL.toString());
    // printMessage(TAG, url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  showCustomSnackBar(context, msg) {
    Flushbar(
      margin: const EdgeInsets.only(top: 50.0),
      duration: const Duration(milliseconds: 2500),
      animationDuration: const Duration(milliseconds: 200),
      messageText: Center(
          child: customText(
        text: msg,
      )),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  buildTextFormFieldWidget(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    bool isObscureText,
    TextInputAction textInputAction,
    TextInputType textInputType,
    int maxLines,
  ) {
    return Container(
      width: Get.width * 0.9,
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isObscureText,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines,
      ),
    );
  }

  showDialogForPlanDoNotHaveVehicleType(context, String planName) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: labelPlanNotForThisVehicleType,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelOk, color: secondaryColor),
          )
        ],
      ),
    );
  }

  showDialogForExistUser2(context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
          child: Icon(Icons.login),
        ),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: customText(text: numberAlreadyAssociated, size: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelOk, color: cancelColor),
          ),
        ],
      ),
    );
  }

  Future<bool> showDialogForExit(context) async {
    return await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(8, 2, 8, 4),
          child: Icon(Icons.exit_to_app),
        ),
        content: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: customText(text: sureYouWantExit, size: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              exit(0);

              // await  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: customText(text: labelYes, color: cancelColor),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelNo, color: cancelColor),
          ),
        ],
      ),
    );
  }
}
