import 'package:assist/Controllers/couponcode_controller.dart';
import 'package:assist/app_constants/app_images_path.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_strings.dart';
import '../custom_widgets.dart';

Widget detailsContainer({required Widget child, EdgeInsetsGeometry? padding}) {
  return Container(
    padding: padding,
    decoration: BoxDecoration(
        border: Border.all(color: black12, width: 2),
        borderRadius: BorderRadius.circular(8)),
    child: child,
  );
}

Widget planDetailsContainer(
    {required CouponCodeController cc,
    String? planName,
    String? planTerm,
    String? startdate,
    String? enddate}) {
  final DateTime now = DateTime.now();
  String today = DateFormat('dd-MM-yyyy').format(now);
  // String endDate = DateFormat('dd-MM-yyyy').format(enddate as DateTime);
  return detailsContainer(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.co_present_rounded,
              size: 18,
            ),
            const SizedBox(
              width: 10,
            ),
            customText(
              text: labelPlanDetails,
              size: 18,
              color: secondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(children: [
          const Icon(
            Icons.circle,
            size: 5,
          ),
          const SizedBox(
            width: 10,
          ),
          customText(text: planChosen,),
          const Expanded(child: SizedBox()),
          customText(text: planName ?? '', fontWeight: FontWeight.w500),
        ]),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Icon(
              Icons.circle,
              size: 5,
            ),
            const SizedBox(
              width: 10,
            ),
            customText(text: labelTerm),
            const Expanded(child: SizedBox()),
            customText(text: planTerm ?? "", fontWeight: FontWeight.w500),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.circle,
              size: 5,
            ),
            const SizedBox(
              width: 10,
            ),
            customText(text: labelActivationDate),
            IconButton(
                onPressed: () {
                  cc.showActivationDateContainer.value =
                      !cc.showActivationDateContainer.value;
                },
                icon: Icon(
                  Icons.report_gmailerrorred_rounded,
                  color: activeColor,
                )),
            const Expanded(child: SizedBox()),
            customText(text: today, fontWeight: FontWeight.w500),
          ],
        ),
        Obx(
          () => cc.showActivationDateContainer.value
              ? Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: customText(
                    text: membershipActive2Days,
                    color: activeColor,
                  ),
                )
              : const SizedBox(),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            const Icon(
              Icons.circle,
              size: 5,
            ),
            const SizedBox(
              width: 10,
            ),
            customText(text: expiryDate),
            const Expanded(child: SizedBox()),
            customText(text: enddate!, fontWeight: FontWeight.w500),
          ],
        ),
      ],
    ),
  );
}

Widget textBoxContainer(
    {required CouponCodeController cc,
    required BuildContext context,
    String? screen,
    int? contractid,
    int? customerid}) {
  return detailsContainer(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.stars_outlined,
                size: 18,
              ),
              const SizedBox(
                width: 10,
              ),
              customText(
                text: applyDiscountCode,
                size: 18,
                color: secondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => TextFormField(
              focusNode: cc.focusNode,
              readOnly: cc.applyCoupon.value,
              controller: cc.coupontextController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  suffixIcon: IconButton(
                      onPressed: () {
                        if (cc.coupontextController.text.isEmpty) {
                          const CustomWidgets()
                              .snackBar(context, enterCouponCode);
                        } else {
                          cc.couponCodeApi(context, contractid!, customerid!);
                        }
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: secondaryColor,
                      )),
                  hintText: typehere),
            ),
          )
        ],
      ));
}

Future<void> couponSuccessMsg(BuildContext context) {
  return Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: activeColor.withOpacity(.2),
              ),
              child: SvgPicture.asset(
                couponSuccess,
                height: 30,
                width: 30,
              ),
            ),
            const SizedBox(height: 20),
            customText(
              text: discountApplied,
              size: 20,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      secondaryColor, // Replace with your secondaryColor
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  // redirect to Payment screen. call payment api
                  Get.back();
                },
                child: customText(
                    text: okay, size: 16, textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ), // Replace with your whiteColor
    ),
  );
}

Widget yourBillContainer(
    {context,
    required CouponCodeController cc,
    String? planAmount,
    required int contractid}) {
  return detailsContainer(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.co_present_rounded,
              size: 18,
            ),
            const SizedBox(
              width: 10,
            ),
            customText(
              text: yourBill,
              size: 18,
              color: secondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Icon(
              Icons.circle,
              size: 5,
            ),
            const SizedBox(
              width: 10,
            ),
            customText(text: planPrice),
            const Expanded(child: SizedBox()),
            customText(text: "\$$planAmount", fontWeight: FontWeight.w500),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Icon(
              Icons.circle,
              size: 5,
            ),
            const SizedBox(
              width: 10,
            ),
            customText(text: discount),
            const Expanded(child: SizedBox()),
            Obx(
              () => cc.applyCoupon.value
                  ? customText(
                      text: "- ${cc.discountAmount.value}",
                      fontWeight: FontWeight.w500)
                  : customText(text: "0", fontWeight: FontWeight.w500),
            )
          ],
        ),
        Obx(() => cc.applyCoupon.value
            ? Row(
                children: [
                  const Icon(
                    Icons.circle,
                    size: 5,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  customText(text: coupon),
                  const SizedBox(
                    width: 10,
                  ),
                  customText(text: labelApplied, color: secondaryColor),
                  const Expanded(child: SizedBox()),
                  Container(
                    height: Get.height / 20,
                    decoration: BoxDecoration(
                        color: activeColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4)),
                    child: TextButton(
                      onPressed: () {
                        cc.toggleApplyCoupon();
                        cc.removeCouponCodeApi(contractid);
                      },
                      child: customText(
                          text: "${cc.couponCode.value} ×", color: activeColor),
                    ),
                  )
                ],
              )
            : const SizedBox()),
        const Divider(
          thickness: 1,
        ),
        Row(
          children: [
            const Icon(
              Icons.circle,
              size: 5,
            ),
            const SizedBox(
              width: 10,
            ),
            customText(text: totalAmount),
            const Expanded(child: SizedBox()),
            Obx(
              () => cc.applyCoupon.value
                  ? customText(
                      text: "\$${cc.couponAmount}",
                      size: 18,
                      fontWeight: FontWeight.w600)
                  : customText(
                      text: "\$$planAmount",
                      size: 18,
                      fontWeight: FontWeight.w600),
            ),
          ],
        )
      ],
    ),
  );
}

Future fillAddressDialog(context) {
  return showDialog(
    context: context,
    useRootNavigator: false,
    builder: (context) => CupertinoAlertDialog(
      title: customText(text: pleaseUpdateYourAddressText),
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
