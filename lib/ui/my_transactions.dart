import 'package:assist/Controllers/my_transactions_controller.dart';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/utils/Widgets/widgets_file.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/theme_controller.dart';
import '../app_constants/app_colors.dart';
import '../utils/custom_widgets.dart';

class MyTransactions extends StatelessWidget {
  MyTransactions({Key? key}) : super(key: key);

  final myTransactionsController = Get.put(MyTransactionsController());

  @override
  Widget build(BuildContext context) {
    return networkWidget(GetBuilder<ThemeController>(builder: (builder) {
      return SafeArea(
          child: Scaffold(
              appBar: const CustomWidgets().appBar(
                  context,
                  0.0,
                  global.themeType == 1
                      ? MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? blackColor
                          : secondaryColor
                      : builder.isDarkMode.value
                          ? blackColor
                          : secondaryColor,
                  IconThemeData(
                      color: builder.isDarkMode.value
                          ? secondaryColor
                          : whiteColor),
                  customText(
                      text: labelTransactions,
                    
                      color: builder.isDarkMode.value
                          ? secondaryColor
                          : whiteColor),
                  true),
              body: Obx(() => myTransactionsController.isLoading.value
                  ? const CustomWidgets().buildShimmerBlock()
                  : myTransactionsController.transactionsList.isEmpty
                      ? SizedBox(
                          height: Get.height * 0.8,
                          width: Get.width,
                          child: Center(
                            child: customText(
                                text: noTransactionsAvailable, size: 18),
                          ),
                        )
                      : buildListBlock(
                          myTransactionsController:
                              myTransactionsController))));
    }), context);
  }
}
