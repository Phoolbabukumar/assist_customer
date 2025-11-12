import 'package:assist/Controllers/buy_assistance_controller.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Network/networkwidget.dart';
import '../apis/response/tabledata_model.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_strings.dart';
import '../utils/custom_widgets.dart';

class MoreInfoScreen extends StatelessWidget {
  final TableDataModel moreItem;
  final String vehicleType;
  final BuyAssistanceController bac;

  const MoreInfoScreen(
      {super.key,
      required this.moreItem,
      required this.vehicleType,
      required this.bac});

  @override
  Widget build(BuildContext context) {
    return networkWidget(
        SafeArea(
          child: Scaffold(
              appBar: const CustomWidgets().appBar(
                  context,
                  0.0,
                  global.themeType == 1
                      ? MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Colors.black
                          : secondaryColor
                      : bac.themecontroller.isDarkMode.value
                          ? Colors.black
                          : secondaryColor,
                  IconThemeData(
                      color: bac.themecontroller.isDarkMode.value
                          ? secondaryColor
                          : Colors.white),
                  customText(
                      text: moreItem.planName ?? '',
                    
                      color: bac.themecontroller.isDarkMode.value
                          ? secondaryColor
                          : whiteColor),
                  true),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      customText(
                          text: planInclusions,
                          size: 16,
                          fontWeight: FontWeight.bold),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                          itemCount: moreItem.servicesDataList?.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, itemCount) {
                            return Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                                margin:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  children: [
                                    ClipRect(
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        //padding: EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                            color: Colors.greenAccent,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                        width: Get.width * 0.7,
                                        child: customText(
                                            text: moreItem
                                                .servicesDataList![itemCount],
                                           ))
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              )),
        ),
        context);
  }
}
