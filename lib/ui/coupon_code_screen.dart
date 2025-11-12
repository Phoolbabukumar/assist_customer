import 'package:assist/Controllers/buy_assistance_controller.dart';
import 'package:assist/Controllers/couponcode_controller.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/ui/view_plan_details.dart';
import 'package:assist/utils/Widgets/coupon_widgets.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/theme_controller.dart';
import '../app_constants/app_colors.dart';
import 'terms_accordingto_plan.dart';

class CouponCodeScreen extends StatelessWidget {
  final String planname;
  final String term;
  final String startdate;
  final String enddate;
  final String amount;
  final String membershipNo;
  final int contractID;
  final int customerId;
  final int loginway;
  final String url;

  const CouponCodeScreen({
    super.key,
    required this.planname,
    required this.term,
    required this.startdate,
    required this.enddate,
    required this.amount,
    required this.membershipNo,
    required this.contractID,
    required this.customerId,
    required this.loginway,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final cuponController = Get.put(CouponCodeController());
    final bac = Get.find<BuyAssistanceController>();
    return SafeArea(
      child: GetBuilder<ThemeController>(builder: (builder) {
        return Scaffold(
          appBar: const CustomWidgets().appBar(
              context,
              0.0,
              global.themeType == 1
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black
                      : secondaryColor
                  : builder.isDarkMode.value
                      ? Colors.black
                      : secondaryColor,
              IconThemeData(
                  color:
                      builder.isDarkMode.value ? secondaryColor : Colors.white),
              customText(
                  text: buyPlan,
                 
                  color:
                      builder.isDarkMode.value ? secondaryColor : Colors.white),
              true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                planDetailsContainer(
                  cc: cuponController,
                  planName: planname,
                  planTerm: term,
                  startdate: startdate,
                  enddate: enddate,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    if (cuponController.applyCoupon.value == true) {
                      const CustomWidgets()
                          .snackBar(Get.context!, pleaseRemoveDiscountCode);
                    } else if (cuponController.applyCoupon.value == false) {
                      Get.to(
                          () => ViewPlanDetails(
                              userId: global.userId,
                              loginWay: global.isLogin ? 1 : 2),
                          popGesture: true);
                    }
                  },
                  child: customText(
                    text: stillNotSure,
                    size: 16,
                    color: Get.isDarkMode ? Colors.white54 : blacklight,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                textBoxContainer(
                    cc: cuponController,
                    context: context,
                    contractid: contractID,
                    customerid: customerId),
                const SizedBox(
                  height: 20,
                ),
                yourBillContainer(
                    cc: cuponController,
                    planAmount: amount,
                    contractid: contractID),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: cuponController.isChecked.value,
                        onChanged: (bool? value) {
                          cuponController.toggleCheckbox();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(TermsAccordingToPlan(url), popGesture: true);
                      },
                      child: customText(
                          text: labelTermCondition,
                          size: 18,
                          color: secondaryColor,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: Get.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      cuponController.isChecked.value
                          ? showDialogForConfirmation(
                              context, cuponController, bac)
                          : const CustomWidgets()
                              .snackBar(context, checkTermConditions);
                      // redirect to Payment screen.
                    },
                    child: customText(
                      text: confirmSelection,
                      size: 16,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: customText(
                        text: labelCancel,
                        size: 18,
                        color: Get.isDarkMode ? Colors.white54 : gray500),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  showDialogForConfirmation(
    context,
    CouponCodeController cc,
    BuyAssistanceController bac,
  ) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(text: youWillBeRedirect, ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
              cc.couponAmount.value == "0"
                  ? cc.paymentPageAPICall(
                      membershipNo, amount, bac, loginway, context)
                  : cc.paymentPageAPICall(membershipNo, cc.couponAmount.value,
                      bac, loginway, context);
            },
            child:
                customText(text: labelConfirm,  color: secondaryColor),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelCancel,  color: cancelColor),
          )
        ],
      ),
    );
  }
}
