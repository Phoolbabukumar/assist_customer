import 'package:assist/Controllers/vehicle_update_controller.dart';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/ui/coupon_code_screen.dart';
import 'package:assist/utils/Widgets/cupertino_dialog.dart';
import 'package:assist/utils/size_config.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_images_path.dart';
import '../utils/common_functions.dart';
import '../utils/custom_widgets.dart';

class VehicleAdd extends StatelessWidget {
  VehicleAdd({
    super.key,
  });

  final vehicleUpdateController = Get.put(VehicleUpdateController());

  @override
  Widget build(BuildContext context) {
    var tag = "Vehicle Add";
    // vehicleUpdateController.planid = planID;
    // vehicleUpdateController.vehicletype = vehicleType;
    return networkWidget(
        SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: global.themeType == 1
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? blackColor
                      : secondaryColor
                  : vehicleUpdateController.themecontroller.isDarkMode.value
                      ? blackColor
                      : secondaryColor,
              iconTheme: IconThemeData(
                  color:
                      vehicleUpdateController.themecontroller.isDarkMode.value
                          ? secondaryColor
                          : whiteColor),
              centerTitle: true,
              title: customText(
                  text: labelVehiclesAdd,
                  color:
                      vehicleUpdateController.themecontroller.isDarkMode.value
                          ? secondaryColor
                          : whiteColor),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  //this column only for car_caravan type vehilce.

                  vehicleUpdateController.vehicleType == 'Caravan' &&
                          vehicleUpdateController.otherVehicleAdd == 'Yes'
                      ? Column(
                          children: [
                            /// for caravan add
                            Card(
                              elevation: 10,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 6),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Obx(() {
                                    return ExpansionTile(
                                      onExpansionChanged: (value) {
                                        printMessage(tag, "Expanded : $value");
                                        vehicleUpdateController
                                            .isCaravanExpanded.value = value;
                                      },
                                      tilePadding: EdgeInsets.zero,
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            appThemeIcon,
                                            colorFilter: ColorFilter.mode(
                                                secondaryColor,
                                                BlendMode.srcIn),
                                            width: 24.0,
                                            height: 24.0,
                                          ),
                                          const SizedBox(
                                            width: 30.0,
                                          ),
                                          customText(
                                            text: addCaravanDetails,
                                            size: 16,
                                            color: secondaryColor,
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(
                                        (vehicleUpdateController
                                                .isCaravanExpanded.value)
                                            ? Icons.keyboard_arrow_down
                                            : Icons.arrow_forward_ios,
                                        size: (vehicleUpdateController
                                                .isCaravanExpanded.value)
                                            ? 25.0
                                            : 16.0,
                                        color: secondaryColor,
                                      ),
                                      childrenPadding: const EdgeInsets.only(
                                          left: 30, bottom: 15),
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 15.0,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: DropdownSearch<String>(
                                                selectedItem:
                                                    vehicleUpdateController
                                                        .chooseMake.value,
                                                popupProps:
                                                    PopupProps.modalBottomSheet(
                                                  searchDelay: const Duration(
                                                      milliseconds: 0),
                                                  showSearchBox: true,
                                                  showSelectedItems: true,
                                                  modalBottomSheetProps:
                                                      ModalBottomSheetProps(
                                                    elevation: 30,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(25),
                                                              topRight: Radius
                                                                  .circular(
                                                                      25)),
                                                    ),
                                                    backgroundColor:
                                                        vehicleUpdateController
                                                                .themecontroller
                                                                .isDarkMode
                                                                .value
                                                            ? gray800
                                                            : Colors.white,
                                                  ),
                                                  searchFieldProps:
                                                      TextFieldProps(
                                                    decoration: const CustomWidgets()
                                                        .inputDecorationBox(
                                                            context,
                                                            labelSearchMakerInfo,
                                                            CupertinoIcons
                                                                .car_detailed),
                                                  ),
                                                ),
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  baseStyle: TextStyle(
                                                      color:
                                                          vehicleUpdateController
                                                                      .chooseMake
                                                                      .value ==
                                                                  "Select Make"
                                                              ? Colors.grey
                                                              : null),
                                                  dropdownSearchDecoration:
                                                      const CustomWidgets()
                                                          .dropDownSearchDecorationBox(
                                                              context,
                                                              labelMakerInfo,
                                                              CupertinoIcons
                                                                  .car_detailed),
                                                ),
                                                items: vehicleUpdateController
                                                    .makeItems,
                                                onChanged: (newValue) {
                                                  vehicleUpdateController
                                                          .chooseMake.value =
                                                      newValue.toString();

                                                  ///dddddddd
                                                  vehicleUpdateController
                                                      .chooseModel
                                                      .value = 'Select Model';
                                                  vehicleUpdateController
                                                      .regoController.text = "";
                                                  vehicleUpdateController
                                                      .chooseYearValue
                                                      .value = 'Select Year';
                                                  vehicleUpdateController
                                                      .colorController
                                                      .text = "";
                                                  vehicleUpdateController
                                                      .modelId = "";
                                                  vehicleUpdateController
                                                      .bodyType.value = "";
                                                  vehicleUpdateController
                                                      .heightController
                                                      .text = "";
                                                  vehicleUpdateController
                                                      .weightController
                                                      .text = "";
                                                  vehicleUpdateController
                                                      .widthController
                                                      .text = "";
                                                  vehicleUpdateController
                                                      .lengthController
                                                      .text = "";

                                                  for (var item
                                                      in vehicleUpdateController
                                                          .makeList) {
                                                    if (newValue == item.make) {
                                                      vehicleUpdateController
                                                          .makeId = item.makeID;
                                                      break;
                                                    }
                                                  }

                                                  vehicleUpdateController
                                                      .modelApiCall(
                                                          vehicleUpdateController
                                                              .makeId
                                                              .toString());
                                                },
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: DropdownSearch<String>(
                                                  popupProps: PopupProps
                                                      .modalBottomSheet(
                                                    showSearchBox: true,
                                                    searchDelay: const Duration(
                                                        milliseconds: 0),
                                                    showSelectedItems: true,
                                                    searchFieldProps:
                                                        TextFieldProps(
                                                      decoration: const CustomWidgets()
                                                          .inputDecorationBox(
                                                              context,
                                                              labelSearchModels,
                                                              CupertinoIcons
                                                                  .car_detailed),
                                                    ),
                                                    modalBottomSheetProps:
                                                        ModalBottomSheetProps(
                                                            elevation: 30,
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          25),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          25)),
                                                            ),
                                                            backgroundColor:
                                                                vehicleUpdateController
                                                                        .themecontroller
                                                                        .isDarkMode
                                                                        .value
                                                                    ? gray800
                                                                    : Colors
                                                                        .white),
                                                  ),
                                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                                      baseStyle: TextStyle(
                                                          color: vehicleUpdateController
                                                                      .chooseModel
                                                                      .value ==
                                                                  "Select Model"
                                                              ? Colors.grey
                                                              : null),
                                                      dropdownSearchDecoration:
                                                          const CustomWidgets()
                                                              .dropDownSearchDecorationBox(
                                                                  context,
                                                                  labelModels,
                                                                  CupertinoIcons
                                                                      .car_detailed)),
                                                  items: vehicleUpdateController
                                                      .modelItems,
                                                  onChanged: (newValue) {
                                                    vehicleUpdateController
                                                            .chooseModel.value =
                                                        newValue.toString();
                                                    for (var item
                                                        in vehicleUpdateController
                                                            .modelList) {
                                                      if (newValue ==
                                                          item.modelName) {
                                                        vehicleUpdateController
                                                                .modelId =
                                                            item.modelID
                                                                .toString();
                                                        vehicleUpdateController
                                                                .bodyType
                                                                .value =
                                                            item.type
                                                                .toString();
                                                        if (vehicleUpdateController
                                                                    .bodyType
                                                                    .value ==
                                                                "Caravan" ||
                                                            vehicleUpdateController
                                                                    .bodyType
                                                                    .value ==
                                                                "Marine" ||
                                                            vehicleUpdateController
                                                                    .bodyType
                                                                    .value ==
                                                                "Motorhome") {
                                                          debugPrint(
                                                              "caravan heights values ${vehicleUpdateController.height} ${vehicleUpdateController.weight} ${vehicleUpdateController.width} ${vehicleUpdateController.length}");

                                                          debugPrint(
                                                              "we in state ");
                                                          vehicleUpdateController
                                                              .heightEnable
                                                              .value = false;
                                                          vehicleUpdateController
                                                              .widthEnable
                                                              .value = false;
                                                          vehicleUpdateController
                                                              .weightEnable
                                                              .value = false;
                                                          vehicleUpdateController
                                                              .lengthEnable
                                                              .value = false;
                                                          vehicleUpdateController
                                                              .heightVisible
                                                              .value = true;
                                                          vehicleUpdateController
                                                              .widthVisible
                                                              .value = true;
                                                          vehicleUpdateController
                                                              .weightVisible
                                                              .value = true;
                                                          vehicleUpdateController
                                                              .lengthVisible
                                                              .value = true;
                                                        }
                                                      }
                                                    }
                                                  },
                                                  selectedItem:
                                                      vehicleUpdateController
                                                          .chooseModel.value),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                    readOnly: false,
                                                    maxLength: 8,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller:
                                                        vehicleUpdateController
                                                            .regoController,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              "[a-zA-z0-9]"))
                                                    ],
                                                    decoration:
                                                        const CustomWidgets()
                                                            .inputDecorationBox(
                                                                context,
                                                                labelRego,
                                                                CupertinoIcons
                                                                    .textformat_abc))),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: DropdownSearch<String>(
                                                  popupProps: PopupProps
                                                      .modalBottomSheet(
                                                    showSearchBox: true,
                                                    showSelectedItems: true,
                                                    searchDelay: const Duration(
                                                        milliseconds: 0),
                                                    searchFieldProps:
                                                        TextFieldProps(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const CustomWidgets()
                                                              .inputDecorationBox(
                                                                  context,
                                                                  labelSearchYear,
                                                                  CupertinoIcons
                                                                      .calendar),
                                                    ),
                                                    modalBottomSheetProps:
                                                        ModalBottomSheetProps(
                                                      elevation: 30,
                                                      // backgroundColor: whiteColor,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        25),
                                                                topRight: Radius
                                                                    .circular(
                                                                        25)),
                                                      ),
                                                      backgroundColor:
                                                          vehicleUpdateController
                                                                  .themecontroller
                                                                  .isDarkMode
                                                                  .value
                                                              ? gray800
                                                              : Colors.white,
                                                    ),
                                                  ),
                                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                                      baseStyle: TextStyle(
                                                          color: vehicleUpdateController
                                                                      .chooseYearValue
                                                                      .value ==
                                                                  "Select Year"
                                                              ? Colors.grey
                                                              : null),
                                                      dropdownSearchDecoration:
                                                          const CustomWidgets()
                                                              .dropDownSearchDecorationBox(
                                                                  context,
                                                                  labelYear,
                                                                  CupertinoIcons
                                                                      .calendar)),
                                                  items: vehicleUpdateController
                                                      .yearsList,
                                                  onChanged: (newValue) {
                                                    vehicleUpdateController
                                                            .chooseYearValue
                                                            .value =
                                                        newValue.toString();
                                                  },
                                                  selectedItem:
                                                      vehicleUpdateController
                                                          .chooseYearValue
                                                          .value),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                    readOnly: false,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller:
                                                        vehicleUpdateController
                                                            .colorController,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              "[a-zA-z]"))
                                                    ],
                                                    decoration:
                                                        const CustomWidgets()
                                                            .inputDecorationBox(
                                                                context,
                                                                labelColour,
                                                                Icons
                                                                    .color_lens_outlined))),
                                            Visibility(
                                              visible: vehicleUpdateController
                                                  .weightVisible.value,
                                              child: SizedBox(
                                                  child: Column(
                                                children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextField(
                                                          readOnly:
                                                              vehicleUpdateController
                                                                  .weightEnable
                                                                  .value,
                                                          keyboardType:
                                                              const TextInputType
                                                                  .numberWithOptions(
                                                                  decimal:
                                                                      true),
                                                          inputFormatters: <TextInputFormatter>[
                                                            // FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    r'^\d+\.?\d{0,2}')),
                                                          ],
                                                          controller:
                                                              vehicleUpdateController
                                                                  .weightController,
                                                          decoration:
                                                              InputDecoration(
                                                            helperText:
                                                                "$labelMaxAllowedWeight${vehicleUpdateController.weight} $labelTon",
                                                            floatingLabelStyle:
                                                                TextStyle(
                                                                    color:
                                                                        secondaryColor),
                                                            labelText:
                                                                labelWeight,
                                                            prefixIcon: Icon(
                                                                Icons
                                                                    .monitor_weight_outlined,
                                                                color:
                                                                    secondaryColor),
                                                            focusedBorder: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            enabledBorder: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            labelStyle:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  "Avenir",
                                                            ),
                                                            helperStyle:
                                                                TextStyle(
                                                              color:
                                                                  secondaryColor,
                                                              fontFamily:
                                                                  "Avenir",
                                                            ),
                                                          ))),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextField(
                                                          readOnly:
                                                              vehicleUpdateController
                                                                  .lengthEnable
                                                                  .value,
                                                          //keyboardType: TextInputType.number,
                                                          controller:
                                                              vehicleUpdateController
                                                                  .lengthController,
                                                          keyboardType:
                                                              const TextInputType
                                                                  .numberWithOptions(
                                                                  decimal:
                                                                      true),
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    r'^\d+\.?\d{0,2}')),
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                            helperText:
                                                                "$labelMaxAllowedLength${vehicleUpdateController.length} $labelMeters",
                                                            floatingLabelStyle:
                                                                TextStyle(
                                                                    color:
                                                                        secondaryColor),
                                                            labelText:
                                                                labelLength,
                                                            prefixIcon: Icon(
                                                                CupertinoIcons
                                                                    .arrow_up_down,
                                                                color:
                                                                    secondaryColor),
                                                            focusedBorder: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryColor,
                                                                        width:
                                                                            2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            enabledBorder: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryColor,
                                                                        width:
                                                                            2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            labelStyle:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  "Avenir",
                                                            ),
                                                            helperStyle:
                                                                TextStyle(
                                                              color:
                                                                  secondaryColor,
                                                              fontFamily:
                                                                  "Avenir",
                                                            ),
                                                          ))),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextField(
                                                          readOnly:
                                                              vehicleUpdateController
                                                                  .heightEnable
                                                                  .value,
                                                          controller:
                                                              vehicleUpdateController
                                                                  .heightController,
                                                          keyboardType:
                                                              const TextInputType
                                                                  .numberWithOptions(
                                                                  decimal:
                                                                      true),
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    r'^\d+\.?\d{0,2}')),
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                            helperText:
                                                                "$labelMaxAllowedHeigth${vehicleUpdateController.height}$labelMeters",
                                                            floatingLabelStyle:
                                                                TextStyle(
                                                                    color:
                                                                        secondaryColor),
                                                            labelText:
                                                                labelHeigth,
                                                            prefixIcon: Icon(
                                                                CupertinoIcons
                                                                    .arrow_up_down,
                                                                color:
                                                                    secondaryColor),
                                                            focusedBorder: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryColor,
                                                                        width:
                                                                            2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            enabledBorder: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryColor,
                                                                        width:
                                                                            2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            labelStyle:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  "Avenir",
                                                            ),
                                                            helperStyle:
                                                                TextStyle(
                                                              color:
                                                                  secondaryColor,
                                                              fontFamily:
                                                                  "Avenir",
                                                            ),
                                                          ))),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextField(
                                                          readOnly:
                                                              vehicleUpdateController
                                                                  .widthEnable
                                                                  .value,
                                                          controller:
                                                              vehicleUpdateController
                                                                  .widthController,
                                                          keyboardType:
                                                              const TextInputType
                                                                  .numberWithOptions(
                                                                  decimal:
                                                                      true),
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .allow(RegExp(
                                                                    r'^\d+\.?\d{0,2}')),
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                            helperText:
                                                                "$labelMaxAllowedWidth${vehicleUpdateController.width} $labelMeters",
                                                            floatingLabelStyle:
                                                                TextStyle(
                                                                    color:
                                                                        secondaryColor),
                                                            labelText:
                                                                labelWidth,
                                                            //CupertinoIcons.arrow_up_down
                                                            prefixIcon: Icon(
                                                                CupertinoIcons
                                                                    .arrow_left_right,
                                                                color:
                                                                    secondaryColor),
                                                            focusedBorder: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryColor,
                                                                        width:
                                                                            2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            enabledBorder: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            secondaryColor,
                                                                        width:
                                                                            2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            labelStyle:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  "Avenir",
                                                            ),
                                                            helperStyle:
                                                                TextStyle(
                                                              color:
                                                                  secondaryColor,
                                                              fontFamily:
                                                                  "Avenir",
                                                            ),
                                                          ))),
                                                ],
                                              )),
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  })),
                            ),

                            /// for car add
                            Card(
                              elevation: 10,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 6),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Obx(() {
                                    return ExpansionTile(
                                      onExpansionChanged: (value) {
                                        printMessage(tag, "Expanded : $value");
                                        vehicleUpdateController
                                            .isCarExpanded.value = value;
                                      },
                                      tilePadding: EdgeInsets.zero,
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            appThemeIcon,
                                            colorFilter: ColorFilter.mode(
                                                secondaryColor,
                                                BlendMode.srcIn),
                                            width: 24.0,
                                            height: 24.0,
                                          ),
                                          const SizedBox(
                                            width: 30.0,
                                          ),
                                          customText(
                                            text: addCarDetails,
                                            size: 16,
                                            color: secondaryColor,
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(
                                        (vehicleUpdateController
                                                .isCarExpanded.value)
                                            ? Icons.keyboard_arrow_down
                                            : Icons.arrow_forward_ios,
                                        size: (vehicleUpdateController
                                                .isCarExpanded.value)
                                            ? 25.0
                                            : 16.0,
                                        color: secondaryColor,
                                      ),
                                      childrenPadding: const EdgeInsets.only(
                                          left: 30, bottom: 15),
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 15.0,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: DropdownSearch<String>(
                                                selectedItem:
                                                    vehicleUpdateController
                                                        .carChooseMake.value,
                                                popupProps:
                                                    PopupProps.modalBottomSheet(
                                                  searchDelay: const Duration(
                                                      milliseconds: 0),
                                                  showSearchBox: true,
                                                  showSelectedItems: true,
                                                  modalBottomSheetProps:
                                                      ModalBottomSheetProps(
                                                          elevation: 30,
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        25),
                                                                topRight: Radius
                                                                    .circular(
                                                                        25)),
                                                          ),
                                                          backgroundColor:
                                                              vehicleUpdateController
                                                                      .themecontroller
                                                                      .isDarkMode
                                                                      .value
                                                                  ? gray800
                                                                  : Colors
                                                                      .white),
                                                  searchFieldProps:
                                                      TextFieldProps(
                                                    decoration: const CustomWidgets()
                                                        .inputDecorationBox(
                                                            context,
                                                            labelSearchMakerInfo,
                                                            CupertinoIcons
                                                                .car_detailed),
                                                  ),
                                                ),
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  baseStyle: TextStyle(
                                                      color: vehicleUpdateController
                                                                  .carChooseMake
                                                                  .value ==
                                                              "Select Make"
                                                          ? Colors.grey
                                                          : null),
                                                  dropdownSearchDecoration:
                                                      const CustomWidgets()
                                                          .dropDownSearchDecorationBox(
                                                              context,
                                                              labelMakerInfo,
                                                              CupertinoIcons
                                                                  .car_detailed),
                                                ),
                                                items: vehicleUpdateController
                                                    .carMakeItems,
                                                onChanged: (newValue) {
                                                  vehicleUpdateController
                                                          .carChooseMake.value =
                                                      newValue.toString();
                                                  vehicleUpdateController
                                                      .carBodyType.value = '';
                                                  vehicleUpdateController
                                                      .carChooseYearValue
                                                      .value = 'Select Year';
                                                  vehicleUpdateController
                                                      .carChooseModel
                                                      .value = 'Select Model';
                                                  vehicleUpdateController
                                                      .carRegoController
                                                      .text = "";
                                                  vehicleUpdateController
                                                      .carColorController
                                                      .text = "";

                                                  for (var item
                                                      in vehicleUpdateController
                                                          .makeList) {
                                                    if (newValue == item.make) {
                                                      vehicleUpdateController
                                                              .carMakeId =
                                                          item.makeID;
                                                      break;
                                                    }
                                                  }

                                                  carModelApiCall(
                                                      vehicleUpdateController
                                                          .carMakeId
                                                          .toString());
                                                },
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: DropdownSearch<String>(
                                                  popupProps: PopupProps
                                                      .modalBottomSheet(
                                                    showSearchBox: true,
                                                    searchDelay: const Duration(
                                                        milliseconds: 0),
                                                    showSelectedItems: true,
                                                    searchFieldProps:
                                                        TextFieldProps(
                                                      decoration: const CustomWidgets()
                                                          .inputDecorationBox(
                                                              context,
                                                              labelSearchModels,
                                                              CupertinoIcons
                                                                  .car_detailed),
                                                    ),
                                                    modalBottomSheetProps:
                                                        ModalBottomSheetProps(
                                                            elevation: 30,
                                                            // backgroundColor: whiteColor,
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          25),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          25)),
                                                            ),
                                                            backgroundColor:
                                                                vehicleUpdateController
                                                                        .themecontroller
                                                                        .isDarkMode
                                                                        .value
                                                                    ? gray800
                                                                    : Colors
                                                                        .white),
                                                  ),
                                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                                      baseStyle: TextStyle(
                                                          color: vehicleUpdateController
                                                                      .carChooseModel
                                                                      .value ==
                                                                  "Select Model"
                                                              ? Colors.grey
                                                              : null),
                                                      dropdownSearchDecoration:
                                                          const CustomWidgets()
                                                              .dropDownSearchDecorationBox(
                                                                  context,
                                                                  labelModels,
                                                                  CupertinoIcons
                                                                      .car_detailed)),
                                                  items: vehicleUpdateController
                                                      .carModelItems,
                                                  onChanged: (newValue) {
                                                    vehicleUpdateController
                                                            .carChooseModel
                                                            .value =
                                                        newValue.toString();

                                                    for (var item
                                                        in vehicleUpdateController
                                                            .carModelList) {
                                                      if (newValue ==
                                                          item.modelName) {
                                                        vehicleUpdateController
                                                                .carModelId =
                                                            item.modelID
                                                                .toString();
                                                        vehicleUpdateController
                                                                .carBodyType
                                                                .value =
                                                            item.type
                                                                .toString();
                                                      }
                                                    }
                                                  },
                                                  selectedItem:
                                                      vehicleUpdateController
                                                          .carChooseModel
                                                          .value),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                    readOnly: false,
                                                    maxLength: 8,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller:
                                                        vehicleUpdateController
                                                            .carRegoController,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              "[a-zA-z0-9]"))
                                                    ],
                                                    decoration:
                                                        const CustomWidgets()
                                                            .inputDecorationBox(
                                                                context,
                                                                labelRego,
                                                                CupertinoIcons
                                                                    .textformat_abc))),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: DropdownSearch<String>(
                                                  popupProps: PopupProps
                                                      .modalBottomSheet(
                                                    showSearchBox: true,
                                                    showSelectedItems: true,
                                                    searchDelay: const Duration(
                                                        milliseconds: 0),
                                                    searchFieldProps:
                                                        TextFieldProps(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const CustomWidgets()
                                                              .inputDecorationBox(
                                                                  context,
                                                                  labelSearchYear,
                                                                  CupertinoIcons
                                                                      .calendar),
                                                    ),
                                                    modalBottomSheetProps:
                                                        ModalBottomSheetProps(
                                                            elevation: 30,
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          25),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          25)),
                                                            ),
                                                            backgroundColor:
                                                                vehicleUpdateController
                                                                        .themecontroller
                                                                        .isDarkMode
                                                                        .value
                                                                    ? gray800
                                                                    : Colors
                                                                        .white),
                                                  ),
                                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                                      baseStyle: TextStyle(
                                                          color: vehicleUpdateController
                                                                      .carChooseYearValue
                                                                      .value ==
                                                                  "Select Year"
                                                              ? Colors.grey
                                                              : null),
                                                      dropdownSearchDecoration:
                                                          const CustomWidgets()
                                                              .dropDownSearchDecorationBox(
                                                                  context,
                                                                  labelYear,
                                                                  CupertinoIcons
                                                                      .calendar)),
                                                  items: vehicleUpdateController
                                                      .carYearsList,
                                                  onChanged: (newValue) {
                                                    vehicleUpdateController
                                                            .carChooseYearValue
                                                            .value =
                                                        newValue.toString();
                                                  },
                                                  selectedItem:
                                                      vehicleUpdateController
                                                          .carChooseYearValue
                                                          .value),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                    readOnly: false,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller:
                                                        vehicleUpdateController
                                                            .carColorController,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              "[a-zA-z]"))
                                                    ],
                                                    decoration:
                                                        const CustomWidgets()
                                                            .inputDecorationBox(
                                                                context,
                                                                labelColour,
                                                                Icons
                                                                    .color_lens_outlined))),
                                          ],
                                        )
                                      ],
                                    );
                                  })),
                            ),
                          ],
                        )
                      :

                      /// this column and container for add normal vehicle.
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
                                      vehicleUpdateController.chooseMake.value,
                                  popupProps: PopupProps.modalBottomSheet(
                                    searchDelay:
                                        const Duration(milliseconds: 0),
                                    showSearchBox: true,
                                    showSelectedItems: true,
                                    modalBottomSheetProps:
                                        ModalBottomSheetProps(
                                      elevation: 30,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25)),
                                      ),
                                      backgroundColor: vehicleUpdateController
                                              .themecontroller.isDarkMode.value
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
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    baseStyle: TextStyle(
                                        color: vehicleUpdateController
                                                    .chooseMake.value ==
                                                "Select Make"
                                            ? Colors.grey
                                            : null),
                                    dropdownSearchDecoration:
                                        const CustomWidgets()
                                            .dropDownSearchDecorationBox(
                                                context,
                                                labelMakerInfo,
                                                CupertinoIcons.car_detailed),
                                  ),
                                  items: vehicleUpdateController.makeItems,
                                  onChanged: (newValue) {
                                    vehicleUpdateController.chooseMake.value =
                                        newValue.toString();
                                    vehicleUpdateController.modelId = "";

                                    vehicleUpdateController.chooseModel.value =
                                        'Select Model';
                                    vehicleUpdateController
                                        .regoController.text = "";
                                    vehicleUpdateController
                                        .chooseYearValue.value = 'Select Year';
                                    vehicleUpdateController
                                        .colorController.text = "";
                                    vehicleUpdateController.modelId = "";
                                    vehicleUpdateController.bodyType.value = "";
                                    vehicleUpdateController
                                        .heightController.text = "";
                                    vehicleUpdateController
                                        .weightController.text = "";
                                    vehicleUpdateController
                                        .widthController.text = "";
                                    vehicleUpdateController
                                        .lengthController.text = "";

                                    for (var item
                                        in vehicleUpdateController.makeList) {
                                      if (newValue == item.make) {
                                        vehicleUpdateController.makeId =
                                            item.makeID;
                                        break;
                                      }
                                    }

                                    vehicleUpdateController.modelApiCall(
                                        vehicleUpdateController.makeId
                                            .toString());
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownSearch<String>(
                                    popupProps: PopupProps.modalBottomSheet(
                                      showSearchBox: true,
                                      searchDelay:
                                          const Duration(milliseconds: 0),
                                      showSelectedItems: true,
                                      searchFieldProps: TextFieldProps(
                                        decoration: const CustomWidgets()
                                            .inputDecorationBox(
                                                context,
                                                labelSearchModels,
                                                CupertinoIcons.car_detailed),
                                      ),
                                      modalBottomSheetProps:
                                          ModalBottomSheetProps(
                                        elevation: 30,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25)),
                                        ),
                                        backgroundColor: vehicleUpdateController
                                                .themecontroller
                                                .isDarkMode
                                                .value
                                            ? gray800
                                            : Colors.white,
                                      ),
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                            baseStyle: TextStyle(
                                                color:
                                                    vehicleUpdateController
                                                                .chooseModel
                                                                .value ==
                                                            "Select Model"
                                                        ? Colors.grey
                                                        : null),
                                            dropdownSearchDecoration:
                                                const CustomWidgets()
                                                    .dropDownSearchDecorationBox(
                                                        context,
                                                        labelModels,
                                                        CupertinoIcons
                                                            .car_detailed)),
                                    items: vehicleUpdateController.modelItems,
                                    onChanged: (newValue) {
                                      vehicleUpdateController.chooseModel
                                          .value = newValue.toString();

                                      for (var item in vehicleUpdateController
                                          .modelList) {
                                        if (newValue == item.modelName) {
                                          vehicleUpdateController.modelId =
                                              item.modelID.toString();
                                          vehicleUpdateController.bodyType
                                              .value = item.type.toString();

                                          debugPrint(
                                              "in call ---${vehicleUpdateController.bodyType}");
                                          if (vehicleUpdateController
                                                      .bodyType.value ==
                                                  "Caravan" ||
                                              vehicleUpdateController
                                                      .bodyType.value ==
                                                  "Marine" ||
                                              vehicleUpdateController
                                                      .bodyType.value ==
                                                  "Motorhome") {
                                            debugPrint(
                                                "${vehicleUpdateController.height} ${vehicleUpdateController.width} ${vehicleUpdateController.weight} ${vehicleUpdateController.length}");

                                            debugPrint("we in state");
                                            vehicleUpdateController
                                                .heightEnable.value = false;
                                            vehicleUpdateController
                                                .widthEnable.value = false;
                                            vehicleUpdateController
                                                .weightEnable.value = false;
                                            vehicleUpdateController
                                                .lengthEnable.value = false;
                                            vehicleUpdateController
                                                .heightVisible.value = true;
                                            vehicleUpdateController
                                                .widthVisible.value = true;
                                            vehicleUpdateController
                                                .weightVisible.value = true;
                                            vehicleUpdateController
                                                .lengthVisible.value = true;

                                            debugPrint(
                                                "we in state  with weight ${vehicleUpdateController.heightEnable}");
                                          }
                                        }
                                      }
                                    },
                                    selectedItem: vehicleUpdateController
                                        .chooseModel.value),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      readOnly: false,
                                      maxLength: 8,
                                      keyboardType: TextInputType.text,
                                      controller: vehicleUpdateController
                                          .regoController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-z0-9]"))
                                      ],
                                      decoration: const CustomWidgets()
                                          .inputDecorationBox(
                                              context,
                                              labelRego,
                                              CupertinoIcons.textformat_abc))),
                              Obx(
                                () => Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownSearch<String>(
                                      popupProps: PopupProps.modalBottomSheet(
                                        showSearchBox: true,
                                        showSelectedItems: true,
                                        searchDelay:
                                            const Duration(milliseconds: 0),
                                        searchFieldProps: TextFieldProps(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[a-zA-z0-9]"))
                                          ],
                                          decoration: const CustomWidgets()
                                              .inputDecorationBox(
                                                  context,
                                                  labelSearchYear,
                                                  CupertinoIcons.calendar),
                                        ),
                                        modalBottomSheetProps:
                                            ModalBottomSheetProps(
                                                elevation: 30,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  25),
                                                          topRight:
                                                              Radius.circular(
                                                                  25)),
                                                ),
                                                backgroundColor:
                                                    vehicleUpdateController
                                                            .themecontroller
                                                            .isDarkMode
                                                            .value
                                                        ? gray800
                                                        : Colors.white),
                                      ),
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                              baseStyle: TextStyle(
                                                  color: vehicleUpdateController
                                                              .chooseYearValue
                                                              .value ==
                                                          "Select Year"
                                                      ? Colors.grey
                                                      : null),
                                              dropdownSearchDecoration:
                                                  const CustomWidgets()
                                                      .dropDownSearchDecorationBox(
                                                          context,
                                                          labelYear,
                                                          CupertinoIcons
                                                              .calendar)),
                                      items: vehicleUpdateController.yearsList,
                                      onChanged: (newValue) {
                                        vehicleUpdateController.chooseYearValue
                                            .value = newValue.toString();
                                      },
                                      selectedItem: vehicleUpdateController
                                          .chooseYearValue.value),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      readOnly: false,
                                      keyboardType: TextInputType.text,
                                      controller: vehicleUpdateController
                                          .colorController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-z]"))
                                      ],
                                      decoration: const CustomWidgets()
                                          .inputDecorationBox(
                                              context,
                                              labelColour,
                                              Icons.color_lens_outlined))),
                              Visibility(
                                visible:
                                    vehicleUpdateController.weightVisible.value,
                                child: SizedBox(
                                    child: Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                            readOnly: vehicleUpdateController
                                                .weightEnable.value,
                                            controller: vehicleUpdateController
                                                .weightController,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            decoration: InputDecoration(
                                              helperText:
                                                  "$labelMaxAllowedWeight${vehicleUpdateController.weight} $labelTon",
                                              floatingLabelStyle: TextStyle(
                                                  color: secondaryColor),
                                              labelText: labelWeight,
                                              prefixIcon: Icon(
                                                  Icons.monitor_weight_outlined,
                                                  color: secondaryColor),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              secondaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              secondaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
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
                                            readOnly: vehicleUpdateController
                                                .lengthEnable.value,
                                            controller: vehicleUpdateController
                                                .lengthController,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            decoration: InputDecoration(
                                              helperText:
                                                  "$labelMaxAllowedLength${vehicleUpdateController.length} $labelMeters",
                                              floatingLabelStyle: TextStyle(
                                                  color: secondaryColor),
                                              labelText: labelLength,
                                              prefixIcon: Icon(
                                                  CupertinoIcons.arrow_up_down,
                                                  color: secondaryColor),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              secondaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              secondaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
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
                                            readOnly: vehicleUpdateController
                                                .heightEnable.value,
                                            controller: vehicleUpdateController
                                                .heightController,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            decoration: InputDecoration(
                                              helperText:
                                                  "$labelMaxAllowedHeigth${vehicleUpdateController.height}$labelMeters",
                                              floatingLabelStyle: TextStyle(
                                                  color: secondaryColor),
                                              labelText: labelHeigth,
                                              prefixIcon: Icon(
                                                  CupertinoIcons
                                                      .arrow_left_right,
                                                  color: secondaryColor),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              secondaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              secondaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                              labelStyle: const TextStyle(
                                                // color: primaryColor,
                                                fontFamily: "Avenir",
                                              ),
                                              helperStyle: TextStyle(
                                                color: secondaryColor,
                                                fontFamily: "Avenir",
                                              ),
                                            ))),

                                    ///width
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                            readOnly: vehicleUpdateController
                                                .widthEnable.value,
                                            controller: vehicleUpdateController
                                                .widthController,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            decoration: InputDecoration(
                                              helperText:
                                                  "$labelMaxAllowedWidth${vehicleUpdateController.width} $labelMeters",
                                              floatingLabelStyle: TextStyle(
                                                  color: secondaryColor),
                                              labelText: labelWidth,
                                              prefixIcon: Icon(
                                                  CupertinoIcons
                                                      .arrow_left_right,
                                                  color: secondaryColor),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              secondaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              secondaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                              labelStyle: const TextStyle(
                                                //  color: primaryColor,
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
                    width: Get.width,
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.fromLTRB(15, 40, 15, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // for car + caravan vehicle add pay button
                        vehicleUpdateController.vehicleType == 'Caravan' &&
                                vehicleUpdateController.otherVehicleAdd == 'Yes'
                            ? SizedBox(
                                width: Get.width * 0.4,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: secondaryColor),
                                  onPressed: () {
                                    debugPrint(
                                        "it's car +caravan vehicle data---------");

                                    if (vehicleUpdateController
                                                .chooseMake.value !=
                                            "Select Make" &&
                                        vehicleUpdateController
                                                .carChooseMake.value !=
                                            "Select Make") {
                                      buyCarCaravanPlanCall(
                                          vehicleUpdateController.userId ?? '',
                                          vehicleUpdateController
                                              .chooseMake.value,
                                          vehicleUpdateController
                                              .chooseModel.value,
                                          vehicleUpdateController
                                              .regoController.text,
                                          vehicleUpdateController
                                              .chooseYearValue.value,
                                          vehicleUpdateController
                                              .colorController.text,
                                          vehicleUpdateController
                                              .bodyType.value,
                                          vehicleUpdateController
                                              .carChooseMake.value,
                                          vehicleUpdateController
                                              .carChooseModel.value,
                                          vehicleUpdateController
                                              .carRegoController.text,
                                          vehicleUpdateController
                                              .carChooseYearValue.value,
                                          vehicleUpdateController
                                              .carColorController.text,
                                          vehicleUpdateController
                                              .carBodyType.value);
                                    } else if (vehicleUpdateController
                                                .chooseMake.value ==
                                            "Select Make" &&
                                        vehicleUpdateController
                                                .carChooseMake.value ==
                                            "Select Make") {
                                      const CustomWidgets().snackBar(
                                          Get.context!, fillVehicleDetails);
                                    } else {
                                      CupertinoDialogClass()
                                          .customCupertinoDialog(
                                              title: "",
                                              content: vehicleAddConfermation,
                                              onTapYes: () {
                                                buyCarCaravanPlanCall(
                                                    vehicleUpdateController.userId ??
                                                        '',
                                                    vehicleUpdateController
                                                        .chooseMake.value,
                                                    vehicleUpdateController
                                                        .chooseModel.value,
                                                    vehicleUpdateController
                                                        .regoController.text,
                                                    vehicleUpdateController
                                                        .chooseYearValue.value,
                                                    vehicleUpdateController
                                                        .colorController.text,
                                                    vehicleUpdateController
                                                        .bodyType.value,
                                                    vehicleUpdateController
                                                        .carChooseMake.value,
                                                    vehicleUpdateController
                                                        .carChooseModel.value,
                                                    vehicleUpdateController
                                                        .carRegoController.text,
                                                    vehicleUpdateController
                                                        .carChooseYearValue
                                                        .value,
                                                    vehicleUpdateController
                                                        .carColorController
                                                        .text,
                                                    vehicleUpdateController
                                                        .carBodyType.value);
                                              },
                                              onTapNo: () => Get.back(),
                                              yesText: labelProceed,
                                              notext: labelAdd);
                                    }

                                    debugPrint(
                                        "${vehicleUpdateController.carChooseMake} ${vehicleUpdateController.carChooseModel} ${vehicleUpdateController.carRegoController.text} ${vehicleUpdateController.carChooseYearValue} ${vehicleUpdateController.carColorController.text} ${vehicleUpdateController.carBodyType}");
                                    debugPrint(
                                        "${vehicleUpdateController.chooseMake} ${vehicleUpdateController.chooseModel} ${vehicleUpdateController.regoController.text} ${vehicleUpdateController.chooseYearValue} ${vehicleUpdateController.colorController.text} ${vehicleUpdateController.bodyType.value}");
                                  },
                                  child: customText(text: labelSave, size: 16),
                                ),
                              )
                            :

                            // for normal vehicle add pay button
                            SizedBox(
                                width: Get.width * 0.4,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: secondaryColor),
                                  onPressed: () {
                                    debugPrint(
                                        "it's normal vehicle data---------");

                                    debugPrint(
                                        "${vehicleUpdateController.chooseMake} ${vehicleUpdateController.chooseModel} ${vehicleUpdateController.regoController.text} ${vehicleUpdateController.chooseYearValue} ${vehicleUpdateController.colorController.text} ${vehicleUpdateController.bodyType.value}");

                                    buyPlanCall(
                                        vehicleUpdateController.userId ?? '',
                                        vehicleUpdateController
                                            .chooseMake.value,
                                        vehicleUpdateController
                                            .chooseModel.value,
                                        vehicleUpdateController
                                            .regoController.text,
                                        vehicleUpdateController
                                            .chooseYearValue.value,
                                        vehicleUpdateController
                                            .colorController.text,
                                        vehicleUpdateController.bodyType.value);
                                  },
                                  child: customText(text: labelSave, size: 16),
                                ),
                              ),

                        SizedBox(
                          width: Get.width * 0.4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: blackColor),
                            onPressed: () {
                              // callingAPIForUpdateVehicle();
                              vehicleUpdateController.height = null;
                              vehicleUpdateController.width = null;
                              vehicleUpdateController.length = null;
                              vehicleUpdateController.weight = null;
                              vehicleUpdateController.makeId = null;
                              vehicleUpdateController.modelId = null;
                              vehicleUpdateController.vehicleId = null;
                              vehicleUpdateController.bodyType.value = '';
                              vehicleUpdateController.chooseYearValue.value =
                                  'Select Year';
                              vehicleUpdateController.chooseMake.value =
                                  'Select Make';
                              vehicleUpdateController.chooseModel.value =
                                  'Select Model';
                              vehicleUpdateController.heightEnable.value = true;
                              vehicleUpdateController.widthEnable.value = true;
                              vehicleUpdateController.weightEnable.value = true;
                              vehicleUpdateController.lengthEnable.value = true;

                              vehicleUpdateController.heightVisible.value =
                                  false;
                              vehicleUpdateController.widthVisible.value =
                                  false;
                              vehicleUpdateController.weightVisible.value =
                                  false;
                              vehicleUpdateController.lengthVisible.value =
                                  false;

                              Get.back();
                            },
                            child: customText(text: labelCancel, size: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        context);
  }

  showDialogForConfirmation() {
    return showDialog(
      context: Get.context!,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: confirmVehicleDetailsText,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();

              ///
              membershipHoldDialog();
            },
            child: customText(text: labelConfirm, color: secondaryColor),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(text: labelCancel, color: cancelColor),
          )
        ],
      ),
    );
  }

  void membershipHoldDialog() {
    if (vehicleUpdateController.carChooseMake.toLowerCase() ==
        "Select Make".toLowerCase()) {
      vehicleUpdateController.carChooseMake.value = '';
    }
    if (vehicleUpdateController.carChooseModel.toLowerCase() ==
        "Select Model".toLowerCase()) {
      vehicleUpdateController.carChooseModel.value = '';
    }
    if (vehicleUpdateController.carChooseYearValue.value.toLowerCase() ==
        "Select Year".toLowerCase()) {
      vehicleUpdateController.carChooseYearValue.value = '';
    }

    if (vehicleUpdateController.chooseMake.toLowerCase() ==
        "Select Make".toLowerCase()) {
      vehicleUpdateController.chooseMake.value = "";
    }

    if (vehicleUpdateController.chooseModel.toLowerCase() ==
        "Select Model".toLowerCase()) {
      vehicleUpdateController.chooseModel.value = '';
    }
    if (vehicleUpdateController.chooseYearValue.toLowerCase() ==
        "Select Year".toLowerCase()) {
      vehicleUpdateController.chooseYearValue.value = '';
    }

    vehicleUpdateController.vehicleType == 'Caravan' &&
            vehicleUpdateController.otherVehicleAdd == 'Yes'
        ? buyPlanApiCallMultipleVehicle(
            vehicleUpdateController.planName ?? "",
            vehicleUpdateController.userId ?? '',
            vehicleUpdateController.chooseMake.value,
            vehicleUpdateController.chooseModel.value,
            vehicleUpdateController.regoController.text,
            vehicleUpdateController.chooseYearValue.value,
            vehicleUpdateController.colorController.text,
            vehicleUpdateController.bodyType.value,
            vehicleUpdateController.heightController.text.toString(),
            vehicleUpdateController.widthController.text.toString(),
            vehicleUpdateController.weightController.text.toString(),
            vehicleUpdateController.lengthController.text.toString(),
            vehicleUpdateController.carChooseMake.value,
            vehicleUpdateController.carChooseModel.value,
            vehicleUpdateController.carRegoController.text,
            vehicleUpdateController.carChooseYearValue.value,
            vehicleUpdateController.carColorController.text,
            vehicleUpdateController.carBodyType.value)
        : buyPlanApiCall(
            vehicleUpdateController.planName ?? '',
            vehicleUpdateController.userId ?? '',
            vehicleUpdateController.chooseMake.value,
            vehicleUpdateController.chooseModel.value,
            vehicleUpdateController.regoController.text,
            vehicleUpdateController.chooseYearValue.value,
            vehicleUpdateController.colorController.text,
            vehicleUpdateController.bodyType.value,
            vehicleUpdateController.heightController.text.toString(),
            vehicleUpdateController.widthController.text.toString(),
            vehicleUpdateController.weightController.text.toString(),
            vehicleUpdateController.lengthController.text.toString());
  }

  fillAddressDialog() {
    return showDialog(
      context: Get.context!,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: pleaseUpdateYourAddressText,
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

  void buyPlanCall(String userId, String makeName, String modelName,
      String rego, String year, String color, String bodyType) {
    if (makeName.toLowerCase() != 'Select Make'.toLowerCase()) {
      if (modelName.toLowerCase() != 'Select Model'.toLowerCase()) {
        if (rego.isNotEmpty) {
          if (year.toLowerCase() != 'select year'.toLowerCase()) {
            if (color.isNotEmpty) {
              if (bodyType == "Caravan" ||
                  bodyType == "Marine" ||
                  bodyType == "Motorhome") {
                if (vehicleUpdateController.height != null &&
                    vehicleUpdateController.width != null &&
                    vehicleUpdateController.weight != null &&
                    vehicleUpdateController.length != null) {
                  if (vehicleUpdateController
                      .weightController.text.isNotEmpty) {
                    if (double.parse(vehicleUpdateController.weight!) >=
                        double.parse(vehicleUpdateController
                                .weightController.text.isEmpty
                            ? "0.0"
                            : vehicleUpdateController.weightController.text)) {
                      if (vehicleUpdateController
                          .lengthController.text.isNotEmpty) {
                        if (double.parse(vehicleUpdateController.length!) >=
                            double.parse(vehicleUpdateController
                                    .lengthController.text.isEmpty
                                ? "0.0"
                                : vehicleUpdateController
                                    .lengthController.text)) {
                          if (vehicleUpdateController
                              .heightController.text.isNotEmpty) {
                            if (double.parse(vehicleUpdateController.height!) >=
                                double.parse(vehicleUpdateController
                                        .heightController.text.isEmpty
                                    ? "0.0"
                                    : vehicleUpdateController
                                        .heightController.text)) {
                              if (vehicleUpdateController
                                  .widthController.text.isNotEmpty) {
                                if (double.parse(
                                        vehicleUpdateController.width!) >=
                                    double.parse(vehicleUpdateController
                                            .widthController.text.isEmpty
                                        ? "0.0"
                                        : vehicleUpdateController
                                            .widthController.text)) {
                                  closeKeyBoard(Get.context!);
                                  membershipHoldDialog();
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
                        const CustomWidgets()
                            .snackBar(Get.context!, enterLength);
                      }
                    } else {
                      const CustomWidgets()
                          .snackBar(Get.context!, errorWeightSize);
                    }
                  } else {
                    const CustomWidgets()
                        .snackBar(Get.context!, enterWeightTon);
                  }
                }
              } else {
                membershipHoldDialog();
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
    } else {
      const CustomWidgets().snackBar(Get.context!, errorPleaseChooseMake);
    }
  }

  bool validateData(String userId, String makeName, String modelName,
      String rego, String year, String color, String bodyType) {
    if (makeName.toLowerCase() != 'Select Make'.toLowerCase()) {
      if (modelName.toLowerCase() != 'Select Model'.toLowerCase()) {
        if (year.toLowerCase() != 'select year'.toLowerCase()) {
          if (rego.isNotEmpty) {
            if (color.isNotEmpty) {
              if (bodyType == "Caravan" ||
                  bodyType == "Marine" ||
                  bodyType == "Motorhome") {
                if (vehicleUpdateController.height != null &&
                    vehicleUpdateController.width != null &&
                    vehicleUpdateController.weight != null &&
                    vehicleUpdateController.length != null) {
                  if (double.parse(vehicleUpdateController.weight!) >=
                      double.parse(
                          vehicleUpdateController.weightController.text)) {
                    if (double.parse(vehicleUpdateController.length!) >=
                        double.parse(
                            vehicleUpdateController.lengthController.text)) {
                      if (double.parse(vehicleUpdateController.height!) >=
                          double.parse(
                              vehicleUpdateController.heightController.text)) {
                        if (double.parse(vehicleUpdateController.width!) >=
                            double.parse(
                                vehicleUpdateController.widthController.text)) {
                          closeKeyBoard(Get.context!);

                          return true;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    return false;
  }

  void buyCarCaravanPlanCall(
    String userId,
    String makeName,
    String modelName,
    String rego,
    String year,
    String color,
    String bodyType,
    String makeNameSecondVehicle,
    String modelNameSecondVehicle,
    String regoSecondVehicle,
    String yearSecondVehicle,
    String colorSecondVehicle,
    String bodyTypeSecondVehicle,
  ) {
    vehicleUpdateController.isCarAdd.value = false;
    vehicleUpdateController.isCaravanAdd.value = false;

    bool isNotCaravanAdded = false;
    bool isNotCarAdded = false;

    if (makeName.toLowerCase() != 'Select Make'.toLowerCase() &&
        modelName.toLowerCase() != 'Select Model'.toLowerCase()) {
      if (rego.isNotEmpty) {
        if (year.toLowerCase() != 'select year'.toLowerCase()) {
          if (color.isNotEmpty) {
            if (bodyType == "Caravan" ||
                bodyType == "Marine" ||
                bodyType == "Motorhome") {
              if (vehicleUpdateController.weight != null) {
                if (vehicleUpdateController.length != null) {
                  if (vehicleUpdateController.height != null) {
                    if (vehicleUpdateController.width != null) {
                      if (vehicleUpdateController
                          .weightController.text.isNotEmpty) {
                        if (double.parse(vehicleUpdateController.weight!) >=
                            double.parse(vehicleUpdateController
                                    .weightController.text.isEmpty
                                ? "0.0"
                                : vehicleUpdateController
                                    .weightController.text)) {
                          if (vehicleUpdateController
                              .lengthController.text.isNotEmpty) {
                            if (double.parse(vehicleUpdateController.length!) >=
                                double.parse(vehicleUpdateController
                                        .lengthController.text.isEmpty
                                    ? "0.0"
                                    : vehicleUpdateController
                                        .lengthController.text)) {
                              if (vehicleUpdateController
                                  .heightController.text.isNotEmpty) {
                                if (double.parse(
                                        vehicleUpdateController.height!) >=
                                    double.parse(vehicleUpdateController
                                            .heightController.text.isEmpty
                                        ? "0.0"
                                        : vehicleUpdateController
                                            .heightController.text)) {
                                  if (vehicleUpdateController
                                      .widthController.text.isNotEmpty) {
                                    if (double.parse(
                                            vehicleUpdateController.width!) >=
                                        double.parse(vehicleUpdateController
                                                .widthController.text.isEmpty
                                            ? "0.0"
                                            : vehicleUpdateController
                                                .widthController.text)) {
                                      closeKeyBoard(Get.context!);

                                      vehicleUpdateController
                                          .isCaravanAdd.value = true;
                                    } else {
                                      const CustomWidgets().snackBar(
                                          Get.context!, errorWidthSize);
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
                            const CustomWidgets()
                                .snackBar(Get.context!, enterLength);
                          }
                        } else {
                          const CustomWidgets()
                              .snackBar(Get.context!, errorWeightSize);
                        }
                      } else {
                        const CustomWidgets()
                            .snackBar(Get.context!, enterWeightTon);
                      }
                    } else {
                      const CustomWidgets()
                          .snackBar(Get.context!, sbEnterWidth);
                    }
                  } else {
                    const CustomWidgets().snackBar(Get.context!, sbEnterHeight);
                  }
                } else {
                  const CustomWidgets().snackBar(Get.context!, sbEnterLength);
                }
              } else {
                const CustomWidgets().snackBar(Get.context!, sbEnterWeight);
              }
            } else {
              membershipHoldDialog();
            }
          } else {
            const CustomWidgets()
                .snackBar(Get.context!, errorCaravanColorNotEmpty);
          }
        } else {
          const CustomWidgets()
              .snackBar(Get.context!, errorCaravanPleaseChooseYear);
        }
      } else {
        const CustomWidgets()
            .snackBar(Get.context!, errorVehicleNumberNotCorrect);
      }
    } else {
      isNotCaravanAdded = true;
    }

    if (makeNameSecondVehicle.toLowerCase() != 'Select Make'.toLowerCase() &&
        modelNameSecondVehicle.toLowerCase() != 'Select Model'.toLowerCase()) {
      if (regoSecondVehicle.isNotEmpty) {
        if (yearSecondVehicle.toLowerCase() != 'select year'.toLowerCase()) {
          if (colorSecondVehicle.isNotEmpty) {
            vehicleUpdateController.isCarAdd.value = true;
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
      isNotCarAdded = true;
    }

    if (vehicleUpdateController.isCarAdd.value ||
        vehicleUpdateController.isCaravanAdd.value) {
      membershipHoldDialog();
    } else {
      if (isNotCarAdded && isNotCaravanAdded) {
        const CustomWidgets().snackBar(Get.context!, fillVehicleDetails);
      }
    }
  }

  Future<void> carModelApiCall(String makeId) async {
    vehicleUpdateController.carModelItems = [];
    await vehicleUpdateController
        .vehicleModelList(makeId.toString())
        .then((value) {
      printMessage(tag, "it's in side");
      vehicleUpdateController.carModelList.value = value ?? [];
      for (var item in vehicleUpdateController.modelList) {
        if (vehicleUpdateController.vehicleType == "Caravan" &&
            vehicleUpdateController.otherVehicleAdd == "Yes") {
          if (item.type == 'Car/Trailer') {
            vehicleUpdateController.carModelItems
                .add(item.modelName.toString());
          }
        } else {
          if (item.type == vehicleUpdateController.vehicleType) {
            vehicleUpdateController.carModelItems
                .add(item.modelName.toString());
          }
        }
      }
    });
  }

  Future<dynamic> buyPlanApiCall(
      String planname,
      String userId,
      String makeName,
      String modelName,
      String rego,
      String year,
      String color,
      String bodyType,
      String height,
      String width,
      String weight,
      String length) async {
    vehicleUpdateController.loginWay == 0 ||
            vehicleUpdateController.loginWay == 2
        ? await vehicleUpdateController.buyAssistanceController
            .buyPlanSignUp(
                userId,
                vehicleUpdateController.planID.toString(),
                makeName,
                modelName,
                rego,
                year,
                color,
                bodyType,
                height,
                width,
                weight,
                length,
                vehicleUpdateController.loginWay == 0 ? "App" : "AppUser")
            .then((value) async {
            debugPrint(value?.statusMessage.toString());

            if (value!.statusMessage!.isNotEmpty) {
              debugPrint(value.membershipNo.toString());
              if (value.membershipNo != null) {
                Get.back();
                vehicleUpdateController
                    .getTermsandConditions(vehicleUpdateController.vehicleType);
                Get.to(
                    () => CouponCodeScreen(
                          planname: planname,
                          term: value.term ?? "",
                          startdate: value.contractDate ?? "",
                          enddate: value.expiryDate ?? "",
                          amount: value.planAmount ?? "0",
                          membershipNo: value.membershipNo ?? "",
                          contractID: value.contractId ?? 0,
                          customerId: value.customerId ?? 0,
                          loginway: vehicleUpdateController.loginWay ?? 0,
                          url: vehicleUpdateController.url,
                        ),
                    popGesture: true);
              } else {
                Get.back();
              }

              return value;
            } else {
              Get.back();
              fillAddressDialog();
            }
          })
        : await vehicleUpdateController.buyAssistanceController
            .buyPlan(
                userId,
                vehicleUpdateController.planID.toString(),
                makeName,
                modelName,
                rego,
                year,
                color,
                bodyType,
                height,
                width,
                weight,
                length,
                "AppUser")
            .then((value) async {
            debugPrint(value?.statusMessage.toString());

            if (value!.statusMessage!.isNotEmpty) {
              debugPrint(value.membershipNo.toString());
              if (value.membershipNo != null) {
                Get.back();
                vehicleUpdateController
                    .getTermsandConditions(vehicleUpdateController.vehicleType);
                Get.to(
                    () => CouponCodeScreen(
                          planname: planname,
                          term: value.term ?? "",
                          startdate: value.contractDate ?? "",
                          enddate: value.expiryDate ?? "",
                          amount: value.planAmount ?? "0",
                          membershipNo: value.membershipNo ?? "",
                          contractID: value.contractId ?? 0,
                          customerId: value.customerId ?? 0,
                          loginway: vehicleUpdateController.loginWay ?? 0,
                          url: vehicleUpdateController.url,
                        ),
                    popGesture: true);
              } else {
                Get.back();
              }

              return value;
            } else {
              Get.back();
              fillAddressDialog();
            }
          });
  }

  Future<dynamic> buyPlanApiCallMultipleVehicle(
    String planname,
    String userId,
    String makeName,
    String modelName,
    String rego,
    String year,
    String color,
    String bodyType,
    String height,
    String width,
    String weight,
    String length,
    String makeNameSecondVehicle,
    String modelNameSecondVehicle,
    String regoSecondVehicle,
    String yearSecondVehicle,
    String colorSecondVehicle,
    String bodyTypeSecondVehicle,
  ) async {
    vehicleUpdateController.loginWay == 0 ||
            vehicleUpdateController.loginWay == 2
        ? await vehicleUpdateController.buyAssistanceController
            .buyPlanMultipleVehicleForSignUp(
                userId,
                vehicleUpdateController.planID.toString(),
                makeName,
                modelName,
                rego,
                year,
                color,
                bodyType,
                height,
                width,
                weight,
                length,
                makeNameSecondVehicle,
                modelNameSecondVehicle,
                regoSecondVehicle,
                yearSecondVehicle,
                colorSecondVehicle,
                bodyTypeSecondVehicle,
                vehicleUpdateController.loginWay == 0 ? "App" : "AppUser")
            .then((value) async {
            if (value!.statusMessage!.isNotEmpty) {
              if (value.membershipNo != null) {
                Get.back();
                vehicleUpdateController
                    .getTermsandConditions(vehicleUpdateController.vehicleType);
                Get.to(
                    () => CouponCodeScreen(
                          planname: planname,
                          term: value.term ?? "",
                          startdate: value.contractDate ?? "",
                          enddate: value.expiryDate ?? "",
                          amount: value.planAmount ?? "0",
                          membershipNo: value.membershipNo ?? "",
                          contractID: value.contractId ?? 0,
                          customerId: value.customerId ?? 0,
                          loginway: vehicleUpdateController.loginWay ?? 0,
                          url: vehicleUpdateController.url,
                        ),
                    popGesture: true);
              } else {
                Get.back();
              }

              return value;
            } else {
              Get.back();
              fillAddressDialog();
            }

            debugPrint(value.membershipNo.toString());
          })
        : await vehicleUpdateController.buyAssistanceController
            .buyPlanMultipleVehicle(
                userId,
                vehicleUpdateController.planID.toString(),
                makeName,
                modelName,
                rego,
                year,
                color,
                bodyType,
                height,
                width,
                weight,
                length,
                makeNameSecondVehicle,
                modelNameSecondVehicle,
                regoSecondVehicle,
                yearSecondVehicle,
                colorSecondVehicle,
                bodyTypeSecondVehicle,
                "AppUser")
            .then((value) async {
            if (value!.statusMessage!.isNotEmpty) {
              if (value.membershipNo != null) {
                Get.back();
                vehicleUpdateController
                    .getTermsandConditions(vehicleUpdateController.vehicleType);
                Get.to(
                    () => CouponCodeScreen(
                          planname: planname,
                          term: value.term ?? "",
                          startdate: value.contractDate ?? "",
                          enddate: value.expiryDate ?? "",
                          amount: value.planAmount ?? "0",
                          membershipNo: value.membershipNo ?? "",
                          contractID: value.contractId ?? 0,
                          customerId: value.customerId ?? 0,
                          loginway: vehicleUpdateController.loginWay ?? 0,
                          url: vehicleUpdateController.url,
                        ),
                    popGesture: true);
              } else {
                Get.back();
              }

              return value;
            } else {
              Get.back();
              fillAddressDialog();
            }

            debugPrint(value.membershipNo.toString());
          });
  }
}
