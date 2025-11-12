import 'dart:convert';
import 'package:assist/apis/base_client.dart';
import 'package:assist/apis/response/coupon_code_response.dart';
import 'package:assist/utils/Widgets/coupon_widgets.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ui/payment_screen.dart';
import 'buy_assistance_controller.dart';

class CouponCodeController extends GetxController {
  final FocusNode focusNode = FocusNode();
  final showActivationDateContainer = false.obs;
  final isChecked = false.obs;
  final applyCoupon = false.obs;
  final discountAmount = "0".obs;
  final couponAmount = "0".obs;
  final couponCode = "".obs;
  final coupontextController = TextEditingController();

  @override
  void onClose() {
    focusNode.dispose();
    coupontextController.dispose();
    super.onClose();
  }

  void toggleCheckbox() {
    isChecked.value = !isChecked.value;
  }

  void toggleApplyCoupon() {
    applyCoupon.value = !applyCoupon.value;
    coupontextController.clear();
    couponAmount.value = "0";
  }

  void focusTextField() {
    focusNode.requestFocus();
  }

  Future<CouponCodeApiResponse?> couponCodeApi(
    context,
    int contractid,
    int customerid,
  ) async {
    try {
      debugPrint(
          ">>> Cupon Code  Api <<<<"); // print coupon code here for check
      // Make API call
      final response = await BaseClient.get(
          //   "APIDiscountCode?"
          // "APIKey=${APIsConstant().getAPIKey()}"
          "ContractID=$contractid"
              "&DiscountCode=${coupontextController.value.text.toUpperCase()}"
              "&CustomerID=$customerid",
          "APIDiscountCode");

      // Parse response
      final responseData = json.decode(response);

      if (responseData['StatusCode'] == 1) {
        CouponCodeApiResponse couponResponse =
            CouponCodeApiResponse.fromJson(responseData);

        // Update state
        applyCoupon.value = !applyCoupon.value;
        couponAmount.value = couponResponse.planAmount ?? "0";
        coupontextController.clear();
        couponCode.value = couponResponse.discountCode ?? "";
        discountAmount.value = couponResponse.totalDiscount ?? "0";
        couponSuccessMsg(context);
        return couponResponse;
      } else if (responseData['StatusCode'] == 0) {
        // Show error message
        const CustomWidgets().snackBar(context, responseData['StatusMessage']);
      } else {
        const CustomWidgets().snackBar(context, "Something went wrong");
      }
    } catch (e, stacktrace) {
      debugPrint("$e");
      debugPrint("$stacktrace");
      // Show error message
      const CustomWidgets()
          .snackBar(context, "An error occurred. Please try again.");
    }
    return null;
  }

  Future<void> paymentPageAPICall(String membershipNo, String amount,
      BuyAssistanceController bac, int loginway, context) async {
    await bac.paymentOfNewMembership(membershipNo, amount).then((value) {
      if (value?.formActionURL != null) {
        Get.to(
            () => PaymentScreen(
                  title: "Payment",
                  loginWay: loginway,
                ),
            popGesture: true,
            arguments: {"url": value?.formActionURL});
      }
    });
  }

  // coupon code api for remove cooupon code
  Future<void> removeCouponCodeApi(
    int contractid,
  ) async {
    try {
      debugPrint(
          ">>> Cupon Code  Api <<<<"); // print coupon code here for check
      // Make API call
      final response =
          await BaseClient.get("ContractID=$contractid", "APIRemoveDiscount");

      // Parse response
      final responseData = json.decode(response);
      debugPrint(responseData);

      if (responseData['StatusCode'] == 200) {
        // Update state
        const CustomWidgets()
            .snackBar(Get.context!, "Discount code removed successfully");
      } else {
        const CustomWidgets()
            .snackBar(Get.context!, "Oops! Something went wrong");
      }
    } catch (e, stacktrace) {
      debugPrint("$e");
      debugPrint("$stacktrace");
      // Show error message
      const CustomWidgets()
          .snackBar(Get.context!, "An error occurred. Please try again.");
    }
  }
}
