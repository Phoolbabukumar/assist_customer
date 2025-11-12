import 'package:assist/Controllers/vehicle_edit_controller.dart';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/utils/size_config.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../app_constants/app_colors.dart';
import '../utils/common_functions.dart';
import '../utils/custom_widgets.dart';

class VehicleEdit extends StatelessWidget {
  final String planName;
  VehicleEdit({
    super.key,
    required this.planName,
  });

  final vehicleUpdateController = Get.put(VehicleEditController());

  @override
  Widget build(BuildContext context) {
    return networkWidget(GetBuilder<VehicleEditController>(builder: (vuc) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: global.themeType == 1
                ? MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? blackColor
                    : secondaryColor
                : vuc.edit!.themecontroller.isDarkMode.value
                    ? blackColor
                    : secondaryColor,
            iconTheme: IconThemeData(
                color: vuc.edit!.themecontroller.isDarkMode.value
                    ? secondaryColor
                    : whiteColor),
            centerTitle: true,
            title: customText(
                text: labelVehiclesEdit,
                color: vuc.edit!.themecontroller.isDarkMode.value
                    ? secondaryColor
                    : whiteColor),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  Obx(() {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<String>(
                            selectedItem:
                                vehicleUpdateController.edit!.chosenMakeValue,
                            popupProps: PopupProps.modalBottomSheet(
                              searchDelay: const Duration(milliseconds: 0),
                              showSearchBox: true,
                              showSelectedItems: true,
                              modalBottomSheetProps: ModalBottomSheetProps(
                                elevation: 30,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25)),
                                ),
                                backgroundColor:
                                    vuc.edit!.themecontroller.isDarkMode.value
                                        ? gray800
                                        : Colors.white,
                              ),
                              searchFieldProps: TextFieldProps(
                                decoration: const CustomWidgets()
                                    .inputDecorationBox(
                                        context,
                                        labelSearchMakerInfo,
                                        CupertinoIcons.car_detailed),
                              ),
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: const CustomWidgets()
                                  .dropDownSearchDecorationBox(
                                      context,
                                      labelMakerInfo,
                                      CupertinoIcons.car_detailed),
                            ),
                            items: vuc.edit!.makeItems,
                            onChanged: (newValue) {
                              debugPrint(vuc.edit!.bodyType.value);
                              if (vuc.edit!.bodyType.value == "Caravan") {
                                vuc.edit!.heightEnable.value = false;
                                vuc.edit!.widthEnable.value = false;
                                vuc.edit!.weightEnable.value = false;
                                vuc.edit!.lengthEnable.value = false;
                                vuc.edit!.heightVisible.value = true;
                                vuc.edit!.widthVisible.value = true;
                                vuc.edit!.weightVisible.value = true;
                                vuc.edit!.lengthVisible.value = true;
                              }

                              vuc.edit!.chosenMakeValue = newValue;
                              for (var item in vuc.edit!.makeList) {
                                if (newValue == item.make) {
                                  vuc.edit!.makeId = item.makeID;
                                }
                              }
                              vuc.edit!.modelItems = [];
                              vuc.edit!.chosenModelValue = null;
                              vuc.edit!.regoController.text = "";
                              vuc.edit!.colorController.text = "";
                              vuc.edit!.chooseYearValue.value = "Select Year";
                              vuc.edit!.weightController.text = "0.0";
                              vuc.edit!.lengthController.text = "0.0";
                              vuc.edit!.heightController.text = "0.0";
                              vuc.edit!.widthController.text = "0.0";

                              vuc.modelGetMethod();
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<String>(
                              popupProps: PopupProps.modalBottomSheet(
                                showSearchBox: true,
                                searchDelay: const Duration(milliseconds: 0),
                                showSelectedItems: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: const CustomWidgets()
                                      .inputDecorationBox(
                                          context,
                                          labelSearchModels,
                                          CupertinoIcons.car_detailed),
                                ),
                                modalBottomSheetProps: ModalBottomSheetProps(
                                  elevation: 30,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25)),
                                  ),
                                  backgroundColor:
                                      vuc.edit!.themecontroller.isDarkMode.value
                                          ? gray800
                                          : Colors.white,
                                ),
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration:
                                      const CustomWidgets()
                                          .dropDownSearchDecorationBox(
                                              context,
                                              labelModels,
                                              CupertinoIcons.car_detailed)),
                              items: vuc.edit!.modelItems,
                              onChanged: (newValue) {
                                vehicleUpdateController.edit!.chosenModelValue =
                                    newValue.toString();
                                for (var item in vehicleUpdateController
                                    .edit!.modelList) {
                                  if (newValue == item.modelName) {
                                    vuc.edit!.modelId = item.modelID.toString();
                                    vuc.edit!.bodyType.value = item.type!;
                                    if (vuc.edit!.bodyType.value == "Caravan" ||
                                        vuc.edit!.bodyType.value == "Marine" ||
                                        vuc.edit!.bodyType.value ==
                                            "Motorhome") {
                                      if (vuc.edit!.height != null &&
                                          vuc.edit!.width != null &&
                                          vuc.edit!.length != null &&
                                          vuc.edit!.weight != null) {
                                        vuc.edit!.heightEnable.value = false;
                                        vuc.edit!.widthEnable.value = false;
                                        vuc.edit!.weightEnable.value = false;
                                        vuc.edit!.lengthEnable.value = false;
                                        vuc.edit!.heightVisible.value = true;
                                        vuc.edit!.widthVisible.value = true;
                                        vuc.edit!.weightVisible.value = true;
                                        vuc.edit!.lengthVisible.value = true;
                                      } else {
                                        vuc.edit!.heightVisible.value = false;
                                        vuc.edit!.widthVisible.value = false;
                                        vuc.edit!.weightVisible.value = false;
                                        vuc.edit!.lengthVisible.value = false;
                                      }
                                    }
                                  }
                                }
                              },
                              selectedItem: vuc.edit!.chosenModelValue),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                readOnly: false,
                                maxLength: 8,
                                keyboardType: TextInputType.text,
                                controller: vuc.edit!.regoController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[a-zA-z0-9]")),
                                ],
                                decoration: const CustomWidgets()
                                    .inputDecorationBox(context, labelRego,
                                        CupertinoIcons.textformat_abc))),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<String>(
                              popupProps: PopupProps.modalBottomSheet(
                                showSearchBox: true,
                                showSelectedItems: true,
                                searchDelay: const Duration(milliseconds: 0),
                                searchFieldProps: TextFieldProps(
                                  keyboardType: TextInputType.number,
                                  decoration: const CustomWidgets()
                                      .inputDecorationBox(
                                          context,
                                          labelSearchYear,
                                          CupertinoIcons.calendar),
                                ),
                                modalBottomSheetProps: ModalBottomSheetProps(
                                  elevation: 30,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25)),
                                  ),
                                  backgroundColor:
                                      vuc.edit!.themecontroller.isDarkMode.value
                                          ? gray800
                                          : Colors.white,
                                ),
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration:
                                      const CustomWidgets()
                                          .dropDownSearchDecorationBox(
                                              context,
                                              labelYear,
                                              CupertinoIcons.calendar)),
                              items: vuc.edit!.yearsList,
                              onChanged: (newValue) {
                                vuc.edit!.chooseYearValue.value =
                                    newValue.toString();
                              },
                              selectedItem: vuc.edit!.chooseYearValue.value),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                readOnly: false,
                                keyboardType: TextInputType.text,
                                controller: vuc.edit!.colorController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[a-zA-Z ]"))
                                ],
                                decoration: const CustomWidgets()
                                    .inputDecorationBox(context, labelColour,
                                        Icons.color_lens_outlined))),
                        Visibility(
                          visible: vuc.edit!.weightVisible.value,
                          child: SizedBox(
                              child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      readOnly: vuc.edit!.weightEnable.value,
                                      controller: vuc.edit!.weightController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}')),
                                      ],
                                      decoration: InputDecoration(
                                        helperText:
                                            "$labelMaxAllowedWeight${vuc.edit!.weight} $labelTon",
                                        labelText: labelWeight,
                                        floatingLabelStyle:
                                            TextStyle(color: secondaryColor),
                                        prefixIcon: Icon(
                                            Icons.monitor_weight_outlined,
                                            color: secondaryColor),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        labelStyle: const TextStyle(
                                          fontFamily: "Avenir",
                                        ),
                                        helperStyle: TextStyle(
                                          color: secondaryColor,
                                          fontFamily: "Avenir",
                                        ),
                                      ))),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      readOnly: vuc.edit!.lengthEnable.value,
                                      controller: vuc.edit!.lengthController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}')),
                                      ],
                                      onTap: (() {}),
                                      decoration: InputDecoration(
                                        helperText:
                                            "$labelMaxAllowedLength${vuc.edit!.length} $labelMeters",
                                        floatingLabelStyle:
                                            TextStyle(color: secondaryColor),
                                        labelText: labelLength,
                                        prefixIcon: Icon(
                                            CupertinoIcons.arrow_up_down,
                                            color: secondaryColor),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        labelStyle: const TextStyle(
                                          fontFamily: "Avenir",
                                        ),
                                        helperStyle: TextStyle(
                                          color: secondaryColor,
                                          fontFamily: "Avenir",
                                        ),
                                      ))),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      readOnly: vuc.edit!.heightEnable.value,
                                      controller: vuc.edit!.heightController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}')),
                                      ],
                                      decoration: InputDecoration(
                                        helperText:
                                            "$labelMaxAllowedHeigth${vuc.edit!.height}$labelMeters",
                                        floatingLabelStyle:
                                            TextStyle(color: secondaryColor),
                                        labelText: labelHeigth,
                                        prefixIcon: Icon(
                                            CupertinoIcons.arrow_up_down,
                                            color: secondaryColor),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        labelStyle: const TextStyle(
                                          fontFamily: "Avenir",
                                        ),
                                        helperStyle: TextStyle(
                                          color: secondaryColor,
                                          fontFamily: "Avenir",
                                        ),
                                      ))),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      readOnly: vuc.edit!.widthEnable.value,
                                      controller: vuc.edit!.widthController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}')),
                                      ],
                                      decoration: InputDecoration(
                                        helperText:
                                            "$labelMaxAllowedWidth${vuc.edit!.width} $labelMeters",
                                        floatingLabelStyle:
                                            TextStyle(color: secondaryColor),
                                        labelText: labelWidth,
                                        prefixIcon: Icon(
                                            CupertinoIcons.arrow_left_right,
                                            color: secondaryColor),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: secondaryColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        labelStyle: const TextStyle(
                                          fontFamily: "Avenir",
                                        ),
                                        helperStyle: TextStyle(
                                          color: secondaryColor,
                                          fontFamily: "Avenir",
                                        ),
                                      ))),
                            ],
                          )),
                        ),
                      ],
                    );
                  }),
                  Container(
                    height: Get.height * 0.35,
                    width: Get.width,
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      width: Get.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: secondaryColor),
                        onPressed: () {
                          callingAPIForUpdateVehicle();
                        },
                        child: customText(
                            text: labelUpdateVehicle,
                            size: 16,
                            color: whiteColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }), context);
  }

  callingAPIForUpdateVehicle() {
    if (vehicleUpdateController.edit!.chosenModelValue != null) {
      if (vehicleUpdateController.edit!.regoController.text.isNotEmpty) {
        if (vehicleUpdateController.edit!.chooseYearValue.value !=
            "Select Year") {
          if (vehicleUpdateController.edit!.colorController.text.isNotEmpty) {
            if (vehicleUpdateController.edit!.bodyType.value !=
                    vehicleUpdateController
                        .edit!.vehicleListResponse?.modelInfo?.type
                        .toString() ||
                vehicleUpdateController.edit!.bodyType.value == "Caravan" ||
                vehicleUpdateController.edit!.bodyType.value == "Marine" ||
                vehicleUpdateController.edit!.bodyType.value == "Motorhome") {
              if (vehicleUpdateController.edit!.height != null &&
                  vehicleUpdateController.edit!.width != null &&
                  vehicleUpdateController.edit!.weight != null &&
                  vehicleUpdateController.edit!.length != null) {
                if (vehicleUpdateController
                    .edit!.weightController.text.isNotEmpty) {
                  if (double.parse(vehicleUpdateController.edit!.weight!) >=
                      double.parse(vehicleUpdateController
                          .edit!.weightController.text)) {
                    if (vehicleUpdateController
                        .edit!.lengthController.text.isNotEmpty) {
                      if (double.parse(vehicleUpdateController.edit!.length!) >=
                          double.parse(vehicleUpdateController
                              .edit!.lengthController.text)) {
                        if (vehicleUpdateController
                            .edit!.heightController.text.isNotEmpty) {
                          if (double.parse(
                                  vehicleUpdateController.edit!.height!) >=
                              double.parse(vehicleUpdateController
                                  .edit!.heightController.text)) {
                            if (vehicleUpdateController
                                .edit!.widthController.text.isNotEmpty) {
                              if (double.parse(
                                      vehicleUpdateController.edit!.width!) >=
                                  double.parse(vehicleUpdateController
                                      .edit!.widthController.text)) {
                                closeKeyBoard(Get.context!);
                                const CustomWidgets()
                                    .vehicleBodyTypeConfirmationDialog(
                                        Get.context!, () {
                                  Get.back();

                                  vehicleUpdateController.edit!
                                      .vehicleUpdate(
                                          vehicleUpdateController
                                              .edit!.vehicleId
                                              .toString(),
                                          vehicleUpdateController.edit!.makeId,
                                          vehicleUpdateController.edit!.modelId,
                                          vehicleUpdateController
                                              .edit!.colorController.text,
                                          vehicleUpdateController
                                              .edit!.chooseYearValue,
                                          vehicleUpdateController.edit!
                                            ..regoController.text,
                                          vehicleUpdateController
                                              .edit!.bodyType,
                                          double.parse(vehicleUpdateController
                                              .edit!.weightController.text),
                                          double.parse(vehicleUpdateController
                                              .edit!.widthController.text),
                                          double.parse(vehicleUpdateController
                                              .edit!.heightController.text),
                                          double.parse(vehicleUpdateController
                                              .edit!.lengthController.text),
                                          vehicleUpdateController
                                                  .edit!.membershipNo ??
                                              "")
                                      .then((value) {
                                    Get.back();
                                    Get.back();
                                    Get.back();
                                    Get.back();
                                  });
                                });
                              } else {
                                const CustomWidgets()
                                    .snackBar(Get.context!, errorWidthSize);
                              }
                            } else {
                              const CustomWidgets()
                                  .snackBar(Get.context!, enterWidth);
                            }
                          } else {
                            const CustomWidgets()
                                .snackBar(Get.context!, errorHeigthSize);
                          }
                        } else {
                          const CustomWidgets()
                              .snackBar(Get.context!, enterHeight);
                        }
                      } else {
                        const CustomWidgets()
                            .snackBar(Get.context!, errorLengthSize);
                      }
                    } else {
                      const CustomWidgets().snackBar(Get.context!, enterLength);
                    }
                  } else {
                    const CustomWidgets()
                        .snackBar(Get.context!, errorWeightSize);
                  }
                } else {
                  const CustomWidgets().snackBar(Get.context!, enterWeight);
                }
              } else {
                const CustomWidgets().showDialogForPlanDoNotHaveVehicleType(
                    Get.context!, planName);
              }
            } else {
              const CustomWidgets()
                  .vehicleBodyTypeConfirmationDialog(Get.context!, () {
                vehicleUpdateController.edit!
                    .vehicleUpdate(
                        vehicleUpdateController.edit!.vehicleId.toString(),
                        vehicleUpdateController.edit!.makeId,
                        vehicleUpdateController.edit!.modelId,
                        vehicleUpdateController.edit!.colorController.text,
                        vehicleUpdateController.edit!.chooseYearValue,
                        vehicleUpdateController.edit!.regoController.text,
                        vehicleUpdateController.edit!.bodyType,
                        vehicleUpdateController.edit!.weightController.text,
                        vehicleUpdateController.edit!.widthController.text,
                        vehicleUpdateController.edit!.heightController.text,
                        vehicleUpdateController.edit!.lengthController.text,
                        vehicleUpdateController.edit!.membershipNo ?? "")
                    .then((value) {
                  Get.back();
                  Get.back();
                  Get.back();
                  Get.back();
                });
              });
            }
          } else {
            const CustomWidgets().snackBar(Get.context!, errorColorNotEmpty);
          }
        } else {
          const CustomWidgets().snackBar(Get.context!, errorPleaseChooseYear);
        }
      } else {
        const CustomWidgets()
            .snackBar(Get.context!, errorVehicleNumberNotCorrect);
      }
    } else {
      const CustomWidgets().snackBar(Get.context!, errorPleaseChooseModel);
    }
  }
}
