import 'package:assist/Controllers/renew_plan_controllers.dart';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/apis/response/plan_list_response.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/ui/terms_accordingto_plan.dart';
import 'package:assist/ui/payment_screen.dart';
import 'package:assist/utils/Widgets/coupon_widgets.dart';
import 'package:assist/utils/common_functions.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../app_constants/app_colors.dart';

class RenewPlan extends StatelessWidget {
  final int customerId, contractId;

  RenewPlan({
    super.key,
    required this.customerId,
    required this.contractId,
  });

  final renewPlanController = Get.put(RenewPlanController());

  @override
  Widget build(BuildContext context) {
    return networkWidget(GetBuilder<RenewPlanController>(builder: (builder) {
      return SafeArea(
        child: Scaffold(
          appBar: const CustomWidgets().appBar(
              context,
              0.0,
              global.themeType == 1
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? blackColor
                      : secondaryColor
                  : builder.themecontroller.isDarkMode.value
                      ? blackColor
                      : secondaryColor,
              IconThemeData(
                  color: builder.themecontroller.isDarkMode.value
                      ? secondaryColor
                      : whiteColor),
              customText(
                  text: labelRenewPlan,
                  color: builder.themecontroller.isDarkMode.value
                      ? secondaryColor
                      : whiteColor),
              true),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            children: [
              _buildPlanBlock(), // this is plan detail section
              const SizedBox(
                height: 15,
              ),
              builder.lastPlanName!.contains("Car + Caravan")
                  ? const SizedBox()
                  : _renewViewotherPlanContainer(
                      rpc: builder), // this is view other plan section
              const SizedBox(
                height: 15,
              ),
              _renewTextBoxContainer(
                  rpc: builder,
                  context: context,
                  contractid: contractId,
                  customerid: customerId), // this is apply discount section
              const SizedBox(
                height: 15,
              ),
              _renewYourBillContainer(
                  rpc: builder,
                  discountAmount:
                      builder.finalDiscount), // this is your Bill section
              const SizedBox(
                height: 10,
              ),
              _buildButtonBlock(), // this is T&C and payment section
            ],
          ),
        ),
      );
    }), context);
  }

  // 1st section Done
  _buildPlanBlock() {
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
            customText(text: planChosen, size: 14),
            const Expanded(child: SizedBox()),
            customText(
                text: renewPlanController.lastPlanName ?? na,
                fontWeight: FontWeight.w500),
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
              customText(
                text: labelTerm,
              ),
              const Expanded(child: SizedBox()),
              customText(
                  text: renewPlanController.term ?? na,
                  fontWeight: FontWeight.w500),
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
              customText(
                text: labelNewStartDate,
              ),
              const Expanded(child: SizedBox()),
              customText(
                  text: renewPlanController.newStartDate ?? na,
                  fontWeight: FontWeight.w500),
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
              customText(
                text: labelNewEndDate,
              ),
              const Expanded(child: SizedBox()),
              customText(
                  text: renewPlanController.newEndDate ?? na,
                  fontWeight: FontWeight.w500),
            ],
          ),
        ],
      ),
    );
  }

  // 2nd section is Done
  _renewViewotherPlanContainer({required RenewPlanController rpc}) {
    return detailsContainer(
        padding: const EdgeInsets.only(left: 12, top: 10),
        child: Theme(
            data: ThemeData().copyWith(
                dialogBackgroundColor:
                    Get.isDarkMode ? Colors.black : Colors.white,
                dividerColor: Colors.transparent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                customText(
                    text: labelViewOtherPlans,
                    size: 18,
                    color: secondaryColor,
                    fontWeight: FontWeight.w500),
                SizedBox(
                  width: Get.width * 0.80,
                  height: 50.0,
                  child: DropdownButton(
                    dropdownColor: Get.isDarkMode ? Colors.black : Colors.white,
                    underline: const SizedBox(),
                    value: rpc.chosenValue,
                    isExpanded: true,
                    elevation: 10,
                    style: const TextStyle(fontFamily: "Avenir"),
                    items: rpc.plansList.map((PlanListModel value) {
                      printMessage(tag, 'value$value');
                      return DropdownMenuItem<String>(
                        value: value.planName ?? "",
                        child: customText(
                            text: value.planName ?? "",
                            size: 16,
                            color: Get.isDarkMode ? whiteColor : Colors.black87,
                            fontWeight: FontWeight.w500),
                      );
                    }).toList(),
                    hint: customText(
                        text: labelPleaseChoosePlan,
                        size: 16,
                        fontWeight: FontWeight.w600),
                    onChanged: (value) {
                      if (rpc.renewApplied.value == true) {
                        const CustomWidgets()
                            .snackBar(Get.context!, pleaseRemoveDiscountCode);
                      } else if (rpc.renewApplied.value == false) {
                        renewPlanController.chosenValue = value.toString();
                        for (var item in renewPlanController.plansList) {
                          if (renewPlanController.chosenValue ==
                              item.planName) {
                            rpc.term = item.term;
                            rpc.lastPlanName = item.planName;
                            rpc.price = item.amount.toString();
                            rpc.planId = item.planId!;
                            rpc.discountedPrice = item.discountedPrice ?? 0.0;
                            rpc.forMinus = double.parse(rpc.price);
                            rpc.finalDiscount =
                                rpc.forMinus - rpc.discountedPrice;
                            debugPrint("final Discount: ${rpc.finalDiscount}");
                            debugPrint("changed price: ${rpc.price}");
                            debugPrint(
                                "changed Discountprice: ${rpc.discountedPrice}");
                            rpc.yearIncrement(rpc.term!);
                            rpc.getTermsandConditions(item.npVehicleType);
                          }
                        }
                      }
                    },
                  ),
                ),
              ],
            )));
  }

  // 3rd section in Done
  _renewTextBoxContainer(
      {required RenewPlanController rpc,
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
            Obx(
              () => rpc.renewApplied.value
                  ? Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: customText(
                          text: discountCodeApplyOnRenewalPrice,
                          size: 12,
                          color: activeColor),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => TextFormField(
                readOnly: rpc.renewApplied.value,
                controller: rpc.renewCoupontextController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (rpc.renewApplied.value == false) {
                            if (rpc.renewCoupontextController.text.isEmpty) {
                              const CustomWidgets()
                                  .snackBar(context, enterCouponCode);
                            } else if (screen == "Renew Plan") {
                              // call coupon code api when user renew he plan
                              rpc.renewPlanCouponCodeApi(context, contractid!,
                                  customerid!, rpc.planId);
                            } else {
                              rpc.renewPlanCouponCodeApi(context, contractid!,
                                  customerid!, rpc.planId);
                            }
                          } else {
                            rpc.toggleRenewApplied();
                            rpc.renewCoupontextController.clear();
                            rpc.removeRenewPlanCouponCodeApi(
                                context, contractid!);
                          }
                        },
                        icon: rpc.renewApplied.value
                            ? customText(
                                text: crossSign,
                                size: 25,
                                color: secondaryColor)
                            : Icon(
                                Icons.arrow_forward,
                                color: secondaryColor,
                              )),
                    hintText: typehere),
              ),
            )
          ],
        ));
  }

// 4th section in Progress
  _renewYourBillContainer(
      {required RenewPlanController rpc, required double discountAmount}) {
    return detailsContainer(
        padding: const EdgeInsets.all(10.0),
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
                customText(
                  text: labelRenewalPrice,
                ),
                const Expanded(child: SizedBox()),
                Text(
                    "\$${(rpc.viewAllPlan.value) ? rpc.oldPlanPrice : rpc.price}",
                    style: rpc.discountedPrice > 0.0 &&
                            (rpc.membershipStatus != 'Expired')
                        ? TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: redColor,
                            decorationThickness: 2)
                        : const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // Discount Line is pending bcz the discounted price is not know where from it comes. After receiving we manualy minus the value from amount and discountprice and show the difference value here.
            Row(
              children: [
                const Icon(
                  Icons.circle,
                  size: 5,
                ),
                const SizedBox(
                  width: 10,
                ),
                customText(
                  text: discount,
                ),
                const Expanded(child: SizedBox()),
                Obx(
                  () => rpc.renewApplied.value
                      ? customText(
                          text: "- ${rpc.totalRenewalPrice.value}",
                          fontWeight: FontWeight.w500)
                      : rpc.discountedPrice > 0.0
                          ? customText(
                              text: discountAmount.toStringAsFixed(2),
                              fontWeight: FontWeight.w500)
                          : customText(
                              text: "\$ ${rpc.discountedPrice}",
                              fontWeight: FontWeight.w500),
                )
              ],
            ),

            // Coupon status line
            Obx(() => rpc.renewApplied.value
                ? Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 5,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      customText(
                        text: coupon,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      customText(text: labelApplied, color: secondaryColor),
                      const Expanded(child: SizedBox()),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: activeColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4)),
                        child: customText(
                            text: rpc.renewCoupontextController.value.text,
                            color: activeColor),
                      ),
                    ],
                  )
                : const SizedBox()),
            const Divider(
              thickness: 1,
            ),
            // Show total Amount if coupon applied show the new price otherwise shoew the Disconted Price here.
            Row(
              children: [
                const Icon(
                  Icons.circle,
                  size: 5,
                ),
                const SizedBox(
                  width: 10,
                ),
                customText(
                  text: totalAmount,
                ),
                const Expanded(child: SizedBox()),
                Obx(
                  () => rpc.renewApplied.value
                      ? customText(
                          text: "\$${rpc.renewalDiscountPrice}",
                          size: 18,
                          fontWeight: FontWeight.w600)
                      : rpc.discountedPrice > 0.0
                          ? customText(
                              text: "\$ ${rpc.discountedPrice}",
                              size: 18,
                              fontWeight: FontWeight.w600)
                          : customText(
                              text: "\$ ${rpc.price}",
                              size: 18,
                              fontWeight: FontWeight.w600),
                ),
              ],
            )
          ],
        ));
  }

// 5th section for T&C
  _buildButtonBlock() {
    return Column(
      children: [
        Row(
          children: [
            Obx(
              () => Checkbox(
                value: renewPlanController.termAndCondition.value,
                activeColor: secondaryColor,
                onChanged: (value) {
                  renewPlanController.termAndCondition.value = value!;
                },
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(
                  () => TermsAccordingToPlan(renewPlanController.url.value),
                  popGesture: true,
                );
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
              if (renewPlanController.termAndCondition.value) {
                if (renewPlanController.viewAllPlan.value) {
                  DateFormat format = DateFormat("dd/MM/yyyy HH:mm");
                  String newEndFormatDate = format.format(DateTime(
                      int.parse(
                          renewPlanController.newEndDate!.substring(6, 10)),
                      int.parse(
                          renewPlanController.newEndDate!.substring(3, 5)),
                      int.parse(
                          renewPlanController.newEndDate!.substring(0, 2))));
                  payment(
                      renewPlanController.membershipNo!,
                      renewPlanController.lastPlanName!,
                      renewPlanController.newStartDate!,
                      newEndFormatDate,
                      renewPlanController.planId.toString());
                } else {
                  if (!renewPlanController.viewAllPlan.value &&
                      renewPlanController.chosenValue != null) {
                    DateFormat format = DateFormat("dd/MM/yyyy HH:mm");
                    String newEndFormatDate = format.format(DateTime(
                        int.parse(
                            renewPlanController.newEndDate!.substring(6, 10)),
                        int.parse(
                            renewPlanController.newEndDate!.substring(3, 5)),
                        int.parse(
                            renewPlanController.newEndDate!.substring(0, 2))));
                    payment(
                        renewPlanController.membershipNo!,
                        renewPlanController.chosenValue ?? '',
                        renewPlanController.newStartDate!,
                        newEndFormatDate,
                        renewPlanController.planId.toString());
                  } else {
                    //Get.back();
                    const CustomWidgets()
                        .snackBar(Get.context!, errorPleaseChoosePlan);
                  }
                }
              } else {
                const CustomWidgets()
                    .snackBar(Get.context!, errorPleaseAcceptCondition);
              }
            },
            child: customText(
              text: "$labelRenew →",
              size: 16,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () => Get.back(),
            child: customText(
              text: labelCancel,
              size: 18,
              color: Get.isDarkMode ? Colors.white54 : gray500,
            ),
          ),
        ),
      ],
    );
  }

// 6th section for payment process
  void payment(String membershipNo, String planName, String newstartDate,
      String newEndDate, String planId) {
    debugPrint("$newstartDate $newEndDate");
    renewPlanController
        .sendDataForPayment(
            "MembershipNo=$membershipNo&PlanName=$planName&NewTerm=${renewPlanController.term}"
            "&NewStartDate=$newstartDate&NewEndDate=$newEndDate&RetailerID=${renewPlanController.retailerId}&PlanID=$planId")
        ?.then((value) {
      Get.to(
          () => PaymentScreen(
                title: "Payment",
                loginWay: 1,
              ),
          popGesture: true,
          arguments: {"url": value.formActionURL});
    });
  }
}
