import 'package:assist/Controllers/vehicle_update_controller.dart';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/app_constants/app_strings.dart';
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
import 'vehicle_edit.dart';

class PlanDetails extends StatelessWidget {
  PlanDetails({super.key});

  final vehicleUpdateController = Get.put(VehicleUpdateController());

  @override
  Widget build(BuildContext context) {
    return networkWidget(
        GetBuilder<VehicleUpdateController>(builder: (builder) {
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
                      : builder.themecontroller.isDarkMode.value
                          ? blackColor
                          : secondaryColor,
                  IconThemeData(
                      color: builder.themecontroller.isDarkMode.value
                          ? secondaryColor
                          : whiteColor),
                  customText(
                      text: labelPlanDetails,
                      color: builder.themecontroller.isDarkMode.value
                          ? secondaryColor
                          : whiteColor),
                  true),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        //height: Get.height * 0.25,
                        child: Card(
                          elevation: 10.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        logo247,
                                        height: 60.0,
                                        width: 60,
                                        color: secondaryColor,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: customText(
                                          text: vehicleUpdateController
                                                  .response?.planName ??
                                              "",
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          color: secondaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      const CustomWidgets().textForJobMap(
                                          context,
                                          vehicleUpdateController
                                                  .response?.membershipNo ??
                                              "",
                                          12),
                                      const SizedBox(height: 5.0),
                                      const CustomWidgets().textForJobMap(
                                          context,
                                          "$labelSince ${vehicleUpdateController.response?.memberSince ?? ""}",
                                          13.0),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.62,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(1, 8, 2, 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        const CustomWidgets().textForJobMap1(
                                            context,
                                            vehicleUpdateController
                                                    .response?.retailerName ??
                                                "",
                                            14.0),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const CustomWidgets().textForJobMap(
                                            context,
                                            "$labelTerm ${vehicleUpdateController.response?.term ?? ""}",
                                            12.0),
                                        const SizedBox(
                                          height: 15.0,
                                        ),
                                        const CustomWidgets().textForJobMap(
                                            context, labelValidUpto, 12.0),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const CustomWidgets().textForJobMap(
                                            context,
                                            "${vehicleUpdateController.response?.activationDate ?? ""} To ${(vehicleUpdateController.response?.expiryDate ?? "").isNotEmpty ? (vehicleUpdateController.response?.expiryDate ?? "").substring(0, 10) : ""}",
                                            12.0),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        const CustomWidgets().textForJobMap(
                                            context,
                                            "$labelActivationDate ${vehicleUpdateController.response?.contractDate ?? ""}",
                                            12.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      child: customText(
                        text: labelVehiclesList,
                        size: 18,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    Obx(() => (vehicleUpdateController.loading.value)
                        ? const CustomWidgets().buildShimmerBlock()
                        : _buildVehicleDetails(
                            vehicleType:
                                vehicleUpdateController.response?.planName ??
                                    '',
                            vuc: vehicleUpdateController))
                  ],
                ),
              )));
    }), context);
  }

  _buildVehicleDetails(
      {required String vehicleType, required VehicleUpdateController vuc}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (vuc.myMemberShipsController!.vehicleList.isNotEmpty)
              ? ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: vuc.myMemberShipsController!.vehicleList.length,
                  itemBuilder: (context, index) {
                    return Card(
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 15, bottom: 15),
                          child: Row(children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 0.0, 0.0, 0.0),
                                child: customText(
                                  text:
                                      "${vuc.myMemberShipsController!.vehicleList[index].vehicleDetail}",
                                  size: 16,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  debugPrint(
                                      "${vuc.height} ${vuc.width} ${vuc.length} ${vuc.weight}");
                                  if (vuc.response?.status == "Active") {
                                    Get.to(
                                        () => VehicleEdit(
                                              planName:
                                                  vuc.response?.planName ?? "",
                                            ),
                                        popGesture: true,
                                        arguments: {
                                          "screenType": "VehicleEdit",
                                          "vehicleListResponse": vuc
                                              .myMemberShipsController!
                                              .vehicleList[index],
                                          "membershipNo":
                                              vuc.response?.membershipNo ?? '',
                                          "planId":
                                              vuc.response?.planID.toString() ??
                                                  '',
                                        })?.then((value) => {
                                          const CustomWidgets()
                                              .buildShimmerBlock(),
                                          vuc.loading.value = true,
                                          vuc.getVehicleDetails()
                                        });
                                  } else {
                                    const CustomWidgets().snackBar(
                                        context, labelMembershipNotActive);
                                  }
                                },
                                child: Icon(
                                  CupertinoIcons.pencil,
                                  color: secondaryColor,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  if (vuc.response?.status == "Active") {
                                    showConfirmationDeleteVehicleDialog(
                                        vuc.myMemberShipsController!
                                            .vehicleList[index].vehicleID
                                            .toString(),
                                        vuc);
                                  } else {
                                    const CustomWidgets()
                                        .showDialogForInActive(context);
                                  }
                                },
                                child: Icon(
                                  CupertinoIcons.delete,
                                  color: secondaryColor,
                                )),
                          ]),
                        ));
                  })
              : Container(),
          vehicleType.toLowerCase() == "car + caravan" &&
                  (vuc.myMemberShipsController!.vehicleList.length < 2)
              ? Column(
                  children: [
                    /// for caravan
                    (vuc.myMemberShipsController!.vehicleComing ?? '')
                                .toLowerCase() !=
                            "caravan"
                        ? Card(
                            elevation: 10,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Obx(() {
                                return ExpansionTile(
                                  onExpansionChanged: (value) {
                                    printMessage(tag, " car Expanded : $value");

                                    vuc.isCaravanExpanded.value = value;
                                    vuc.updateVehicleType.value = "Caravan";
                                  },
                                  tilePadding: EdgeInsets.zero,
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        appThemeIcon,
                                        colorFilter: ColorFilter.mode(
                                            secondaryColor, BlendMode.srcIn),
                                        // color: secondaryColor,
                                        width: 24.0,
                                        height: 24.0,
                                      ),
                                      const SizedBox(
                                        width: 30.0,
                                      ),
                                      customText(
                                          text: addCaravanDetails,
                                          size: 16,
                                          color: secondaryColor),
                                    ],
                                  ),
                                  trailing: Icon(
                                    (vuc.isCaravanExpanded.value)
                                        ? Icons.keyboard_arrow_down
                                        : Icons.arrow_forward_ios,
                                    size: (vuc.isCaravanExpanded.value)
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
                                        Container(
                                          height: 15.0,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          //margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                                          child: DropdownSearch<String>(
                                            selectedItem: vuc.chooseMake.value,
                                            popupProps:
                                                PopupProps.modalBottomSheet(
                                              searchDelay: const Duration(
                                                  milliseconds: 0),
                                              showSearchBox: true,
                                              showSelectedItems: true,
                                              modalBottomSheetProps:
                                                  ModalBottomSheetProps(
                                                      elevation: 30,
                                                      //backgroundColor: whiteColor,
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
                                                          Get.isDarkMode
                                                              ? gray800
                                                              : Colors.white),
                                              searchFieldProps: TextFieldProps(
                                                decoration: const CustomWidgets()
                                                    .inputDecorationBox(
                                                        Get.context!,
                                                        labelSearchMakerInfo,
                                                        CupertinoIcons
                                                            .car_detailed),
                                              ),
                                            ),
                                            dropdownDecoratorProps:
                                                DropDownDecoratorProps(
                                              baseStyle: TextStyle(
                                                  color: vuc.chooseMake.value ==
                                                          "Select Make"
                                                      ? Colors.grey
                                                      : null),
                                              dropdownSearchDecoration:
                                                  const CustomWidgets()
                                                      .dropDownSearchDecorationBox(
                                                          Get.context!,
                                                          labelMakerInfo,
                                                          CupertinoIcons
                                                              .car_detailed),
                                            ),
                                            items: vuc.makeItems,
                                            onChanged: (newValue) {
                                              vuc.chooseMake.value =
                                                  newValue.toString();

                                              ///dddddddd
                                              vuc.chooseModel.value =
                                                  'Select Model';
                                              vuc.regoController.text = "";
                                              vuc.chooseYearValue.value =
                                                  'Select Year';
                                              vuc.colorController.text = "";
                                              vuc.modelId = "";
                                              vuc.bodyType.value = "";
                                              vuc.heightController.text = "";
                                              vuc.weightController.text = "";
                                              vuc.widthController.text = "";
                                              vuc.lengthController.text = "";

                                              vuc.heightVisible.value = false;
                                              vuc.widthVisible.value = false;
                                              vuc.weightVisible.value = false;
                                              vuc.lengthVisible.value = false;

                                              for (var item
                                                  in vehicleUpdateController
                                                      .makeList) {
                                                if (newValue == item.make) {
                                                  vuc.makeId = item.makeID;
                                                  break;
                                                }
                                              }

                                              vuc.vehicleModelList(vuc.makeId);
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          //margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                                          child: DropdownSearch<String>(
                                              popupProps:
                                                  PopupProps.modalBottomSheet(
                                                showSearchBox: true,
                                                searchDelay: const Duration(
                                                    milliseconds: 0),
                                                showSelectedItems: true,
                                                searchFieldProps:
                                                    TextFieldProps(
                                                  decoration:
                                                      const CustomWidgets()
                                                          .inputDecorationBox(
                                                              Get.context!,
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
                                                            Get.isDarkMode
                                                                ? gray800
                                                                : Colors.white),
                                              ),
                                              dropdownDecoratorProps:
                                                  DropDownDecoratorProps(
                                                      baseStyle: TextStyle(
                                                          color: vuc.chooseModel
                                                                      .value ==
                                                                  "Select Model"
                                                              ? Colors.grey
                                                              : null),
                                                      dropdownSearchDecoration:
                                                          const CustomWidgets()
                                                              .dropDownSearchDecorationBox(
                                                                  Get.context!,
                                                                  labelModels,
                                                                  CupertinoIcons
                                                                      .car_detailed)),
                                              items: vuc.modelItems,
                                              onChanged: (newValue) {
                                                vuc.chooseModel.value =
                                                    newValue.toString();

                                                for (var item
                                                    in vehicleUpdateController
                                                        .modelList) {
                                                  if (newValue ==
                                                      item.modelName) {
                                                    vuc.modelId =
                                                        item.modelID.toString();
                                                    vuc.bodyType.value =
                                                        item.type.toString();
                                                    if (vuc.bodyType.value ==
                                                            "Caravan" ||
                                                        vuc.bodyType.value ==
                                                            "Marine" ||
                                                        vuc.bodyType.value ==
                                                            "Motorhome") {
                                                      debugPrint(
                                                          "${vuc.height} ${vuc.weight} ${vuc.width} ${vuc.length}");

                                                      if (vuc.height != null &&
                                                          vuc.width != null &&
                                                          vuc.length != null &&
                                                          vuc.weight != null) {
                                                        debugPrint(
                                                            "we in state ");

                                                        vuc.heightEnable.value =
                                                            false;
                                                        vuc.widthEnable.value =
                                                            false;
                                                        vuc.weightEnable.value =
                                                            false;
                                                        vuc.lengthEnable.value =
                                                            false;
                                                        vuc.heightVisible
                                                            .value = true;
                                                        vuc.widthVisible.value =
                                                            true;
                                                        vuc.weightVisible
                                                            .value = true;
                                                        vuc.lengthVisible
                                                            .value = true;
                                                      } else {
                                                        vuc.heightVisible
                                                            .value = false;
                                                        vuc.widthVisible.value =
                                                            false;
                                                        vuc.weightVisible
                                                            .value = false;
                                                        vuc.lengthVisible
                                                            .value = false;
                                                      }
                                                    }
                                                  }
                                                }
                                              },
                                              selectedItem:
                                                  vuc.chooseModel.value),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                                readOnly: false,
                                                maxLength: 8,
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: vuc.regoController,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                          RegExp("[a-zA-z0-9]"))
                                                ],
                                                decoration: const CustomWidgets()
                                                    .inputDecorationBox(
                                                        Get.context!,
                                                        labelRego,
                                                        CupertinoIcons
                                                            .textformat_abc))),
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DropdownSearch<String>(
                                              popupProps:
                                                  PopupProps.modalBottomSheet(
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
                                                              Get.context!,
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
                                                            Get.isDarkMode
                                                                ? gray800
                                                                : Colors.white),
                                              ),
                                              dropdownDecoratorProps:
                                                  DropDownDecoratorProps(
                                                      baseStyle: TextStyle(
                                                          color: vuc.chooseYearValue
                                                                      .value ==
                                                                  "Select year"
                                                              ? Colors.grey
                                                              : null),
                                                      dropdownSearchDecoration:
                                                          const CustomWidgets()
                                                              .dropDownSearchDecorationBox(
                                                                  Get.context!,
                                                                  labelYear,
                                                                  CupertinoIcons
                                                                      .calendar)),
                                              items: vuc.yearsList,
                                              onChanged: (newValue) {
                                                vuc.chooseYearValue.value =
                                                    newValue.toString();
                                              },
                                              selectedItem:
                                                  vuc.chooseYearValue.value),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                                readOnly: false,
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: vuc.colorController,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp("[a-zA-z]"))
                                                ],
                                                decoration: const CustomWidgets()
                                                    .inputDecorationBox(
                                                        Get.context!,
                                                        labelColour,
                                                        Icons
                                                            .color_lens_outlined))),
                                        Visibility(
                                          visible: vuc.weightVisible.value,
                                          child: SizedBox(
                                              child: Column(
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                      readOnly: vuc
                                                          .weightEnable.value,
                                                      // keyboardType: TextInputType.number,
                                                      controller:
                                                          vuc.weightController,
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(
                                                              decimal: true),
                                                      inputFormatters: <TextInputFormatter>[
                                                        // FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'^\d+\.?\d{0,2}')),
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        helperText:
                                                            "$labelMaxAllowedWeight${vuc.weight} $labelTon",
                                                        labelText: labelWeight,
                                                        floatingLabelStyle:
                                                            TextStyle(
                                                                color:
                                                                    secondaryColor),
                                                        prefixIcon: Icon(
                                                            Icons
                                                                .monitor_weight_outlined,
                                                            color:
                                                                secondaryColor),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
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
                                                        enabledBorder:
                                                            UnderlineInputBorder(
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
                                                          fontFamily: "Avenir",
                                                        ),
                                                        helperStyle: TextStyle(
                                                          color: secondaryColor,
                                                          fontFamily: "Avenir",
                                                        ),
                                                      ))),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                      readOnly: vuc
                                                          .lengthEnable.value,
                                                      //keyboardType: TextInputType.number,
                                                      controller:
                                                          vuc.lengthController,
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(
                                                              decimal: true),
                                                      inputFormatters: <TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'^\d+\.?\d{0,2}')),
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        helperText:
                                                            "$labelMaxAllowedLength${vuc.length} $labelMeters",
                                                        floatingLabelStyle:
                                                            TextStyle(
                                                                color:
                                                                    secondaryColor),
                                                        labelText: labelLength,
                                                        prefixIcon: Icon(
                                                            CupertinoIcons
                                                                .arrow_up_down,
                                                            color:
                                                                secondaryColor),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
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
                                                        enabledBorder:
                                                            UnderlineInputBorder(
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
                                                          //  color: primaryColor,
                                                          fontFamily: "Avenir",
                                                        ),
                                                        helperStyle: TextStyle(
                                                          color: secondaryColor,
                                                          fontFamily: "Avenir",
                                                        ),
                                                      ))),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                      readOnly: vuc
                                                          .heightEnable.value,
                                                      controller:
                                                          vuc.heightController,
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(
                                                              decimal: true),
                                                      inputFormatters: <TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'^\d+\.?\d{0,2}')),
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        floatingLabelStyle:
                                                            TextStyle(
                                                                color:
                                                                    secondaryColor),
                                                        helperText:
                                                            "$labelMaxAllowedHeigth${vuc.height}$labelMeters",
                                                        labelText: labelHeigth,
                                                        prefixIcon: Icon(
                                                            CupertinoIcons
                                                                .arrow_up_down,
                                                            color:
                                                                secondaryColor),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
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
                                                        enabledBorder:
                                                            UnderlineInputBorder(
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
                                                          fontFamily: "Avenir",
                                                        ),
                                                        helperStyle: TextStyle(
                                                          color: secondaryColor,
                                                          fontFamily: "Avenir",
                                                        ),
                                                      ))),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                      readOnly:
                                                          vuc.widthEnable.value,
                                                      controller:
                                                          vuc.widthController,
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(
                                                              decimal: true),
                                                      inputFormatters: <TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'^\d+\.?\d{0,2}')),
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        floatingLabelStyle:
                                                            TextStyle(
                                                                color:
                                                                    secondaryColor),
                                                        helperText:
                                                            "$labelMaxAllowedWidth${vuc.width} $labelMeters",
                                                        labelText: labelWidth,
                                                        prefixIcon: Icon(
                                                            CupertinoIcons
                                                                .arrow_left_right,
                                                            color:
                                                                secondaryColor),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
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
                                                        enabledBorder:
                                                            UnderlineInputBorder(
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
                                        SizedBox(
                                          width: Get.width * 0.4,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                backgroundColor:
                                                    secondaryColor),
                                            onPressed: () {
                                              debugPrint(
                                                  "it's caravan vehicle data---------");
                                              callingAPIForUpdateVehicle(
                                                  1,
                                                  vuc.response!.planID
                                                      .toString(),
                                                  vuc.bodyType.value,
                                                  vuc.response?.planName ?? '',
                                                  vuc.response?.membershipNo ??
                                                      '',
                                                  vuc);

                                              debugPrint(
                                                  "${vuc.chooseMake} ${vuc.chooseModel} ${vuc.regoController.text} ${vuc.chooseYearValue} ${vuc.colorController.text} ${vuc.bodyType}");
                                            },
                                            child: customText(
                                                text: labelSave, size: 16),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                );
                              }),
                            ),
                          )
                        : Container(),

                    /// for car add
                    (vuc.myMemberShipsController!.vehicleComing ?? '')
                                .toLowerCase() !=
                            "car/trailer"
                        ? Card(
                            elevation: 10,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: InkWell(
                                child: Obx(() {
                                  return ExpansionTile(
                                    onExpansionChanged: (value) {
                                      printMessage(tag, "Expanded : $value");

                                      vuc.isCarExpanded.value = value;
                                    },
                                    tilePadding: EdgeInsets.zero,
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          appThemeIcon,
                                          colorFilter: ColorFilter.mode(
                                              secondaryColor, BlendMode.srcIn),
                                          // color: secondaryColor,
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
                                      (vuc.isCarExpanded.value)
                                          ? Icons.keyboard_arrow_down
                                          : Icons.arrow_forward_ios,
                                      color: secondaryColor,
                                      size: (vuc.isCarExpanded.value)
                                          ? 25.0
                                          : 16.0,
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: DropdownSearch<String>(
                                              selectedItem:
                                                  vuc.carChooseMake.value,
                                              popupProps:
                                                  PopupProps.modalBottomSheet(
                                                searchDelay: const Duration(
                                                    milliseconds: 0),
                                                showSearchBox: true,
                                                showSelectedItems: true,
                                                modalBottomSheetProps:
                                                    ModalBottomSheetProps(
                                                        elevation: 30,
                                                        //backgroundColor: whiteColor,
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
                                                            Get.isDarkMode
                                                                ? gray800
                                                                : Colors.white),
                                                searchFieldProps:
                                                    TextFieldProps(
                                                  decoration: const CustomWidgets()
                                                      .inputDecorationBox(
                                                          Get.context!,
                                                          labelSearchMakerInfo,
                                                          CupertinoIcons
                                                              .car_detailed),
                                                ),
                                              ),
                                              dropdownDecoratorProps:
                                                  DropDownDecoratorProps(
                                                baseStyle: TextStyle(
                                                    color: vuc.carChooseMake
                                                                .value ==
                                                            "Select Make"
                                                        ? Colors.grey
                                                        : null),
                                                dropdownSearchDecoration:
                                                    const CustomWidgets()
                                                        .dropDownSearchDecorationBox(
                                                            Get.context!,
                                                            labelMakerInfo,
                                                            CupertinoIcons
                                                                .car_detailed),
                                              ),
                                              items: vuc.carMakeItems,
                                              onChanged: (newValue) {
                                                vuc.carChooseMake.value =
                                                    newValue.toString();
                                                vuc.carBodyType.value = '';
                                                vuc.carChooseYearValue.value =
                                                    'Select Year';
                                                vuc.carChooseModel.value =
                                                    'Select Model';
                                                vuc.carRegoController.text = "";
                                                vuc.carColorController.text =
                                                    "";

                                                for (var item
                                                    in vehicleUpdateController
                                                        .makeList) {
                                                  if (newValue == item.make) {
                                                    vuc.carMakeId = item.makeID;
                                                    break;
                                                  }
                                                }

                                                carModelApiCall(
                                                    vuc.carMakeId.toString());
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            //margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                                            child: DropdownSearch<String>(
                                              selectedItem:
                                                  vuc.carChooseModel.value,
                                              popupProps:
                                                  PopupProps.modalBottomSheet(
                                                showSearchBox: true,
                                                searchDelay: const Duration(
                                                    milliseconds: 0),
                                                showSelectedItems: true,
                                                searchFieldProps:
                                                    TextFieldProps(
                                                  decoration:
                                                      const CustomWidgets()
                                                          .inputDecorationBox(
                                                              Get.context!,
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
                                                            Get.isDarkMode
                                                                ? gray800
                                                                : Colors.white),
                                              ),
                                              dropdownDecoratorProps:
                                                  DropDownDecoratorProps(
                                                      baseStyle: TextStyle(
                                                          color: vuc.carChooseModel
                                                                      .value ==
                                                                  "Select Model"
                                                              ? Colors.grey
                                                              : null),
                                                      dropdownSearchDecoration:
                                                          const CustomWidgets()
                                                              .dropDownSearchDecorationBox(
                                                                  Get.context!,
                                                                  labelModels,
                                                                  CupertinoIcons
                                                                      .car_detailed)),
                                              items: vuc.carModelItems,
                                              onChanged: (newValue) {
                                                vuc.carChooseModel.value =
                                                    newValue.toString();

                                                for (var item
                                                    in vuc.carModelList) {
                                                  if (newValue ==
                                                      item.modelName) {
                                                    vuc.carModelId =
                                                        item.modelID.toString();
                                                    vuc.carBodyType.value =
                                                        item.type.toString();
                                                    if (vuc.carBodyType.value ==
                                                            "Caravan" ||
                                                        vuc.carBodyType.value ==
                                                            "Marine" ||
                                                        vuc.carBodyType.value ==
                                                            "Motorhome") {
                                                      if (vuc.height != null &&
                                                          vuc.width != null &&
                                                          vuc.length != null &&
                                                          vuc.weight != null) {
                                                        vuc.heightEnable.value =
                                                            false;
                                                        vuc.widthEnable.value =
                                                            false;
                                                        vuc.weightEnable.value =
                                                            false;
                                                        vuc.lengthEnable.value =
                                                            false;
                                                        vuc.heightVisible
                                                            .value = true;
                                                        vuc.widthVisible.value =
                                                            true;
                                                        vuc.weightVisible
                                                            .value = true;
                                                        vuc.lengthVisible
                                                            .value = true;
                                                      } else {
                                                        vuc.heightVisible
                                                            .value = false;
                                                        vuc.widthVisible.value =
                                                            false;
                                                        vuc.weightVisible
                                                            .value = false;
                                                        vuc.lengthVisible
                                                            .value = false;
                                                      }
                                                    }
                                                  }
                                                }
                                              },
                                            ),
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
                                                      vuc.carRegoController,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            "[a-zA-z0-9]"))
                                                  ],
                                                  decoration: const CustomWidgets()
                                                      .inputDecorationBox(
                                                          Get.context!,
                                                          labelRego,
                                                          CupertinoIcons
                                                              .textformat_abc))),
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            child: DropdownSearch<String>(
                                                popupProps:
                                                    PopupProps.modalBottomSheet(
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
                                                                Get.context!,
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
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        25),
                                                                topRight: Radius
                                                                    .circular(
                                                                        25)),
                                                          ),
                                                          backgroundColor: Get
                                                                  .isDarkMode
                                                              ? gray800
                                                              : Colors.white),
                                                ),
                                                dropdownDecoratorProps: DropDownDecoratorProps(
                                                    baseStyle: TextStyle(
                                                        color:
                                                            vuc.carChooseYearValue
                                                                        .value ==
                                                                    "Select Year"
                                                                ? Colors.grey
                                                                : null),
                                                    dropdownSearchDecoration:
                                                        const CustomWidgets()
                                                            .dropDownSearchDecorationBox(
                                                                Get.context!,
                                                                labelYear,
                                                                CupertinoIcons
                                                                    .calendar)),
                                                items: vuc.yearsList,
                                                onChanged: (newValue) {
                                                  vuc.carChooseYearValue.value =
                                                      newValue.toString();
                                                },
                                                selectedItem: vuc
                                                    .carChooseYearValue.value),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                  readOnly: false,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller:
                                                      vuc.carColorController,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp("[a-zA-z]"))
                                                  ],
                                                  decoration: const CustomWidgets()
                                                      .inputDecorationBox(
                                                          Get.context!,
                                                          labelColour,
                                                          Icons
                                                              .color_lens_outlined))),
                                          SizedBox(
                                            width: MediaQuery.of(Get.context!)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  backgroundColor:
                                                      secondaryColor),
                                              onPressed: () {
                                                debugPrint(
                                                    "it's car vehicle data---------");
                                                callingAPIForUpdateVehicle(
                                                    2,
                                                    vuc.response!.planID
                                                        .toString(),
                                                    vuc.carBodyType.value,
                                                    vuc.response?.planName ??
                                                        '',
                                                    vuc.response
                                                            ?.membershipNo ??
                                                        '',
                                                    vuc);
                                              },
                                              child: customText(
                                                  text: labelSave, size: 16),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                }),
                              ),
                            ),
                          )
                        : Container(),

                    const SizedBox(
                      height: 20,
                    )
                  ],
                )
              : Container(),
          vuc.myMemberShipsController!.vehicleList.isEmpty &&
                  vehicleType.toLowerCase() != "car + caravan"
              ? Card(
                  elevation: 10,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Obx(() {
                      return ExpansionTile(
                        onExpansionChanged: (value) {
                          printMessage(tag, "caravan Expanded : $value");

                          vuc.isCaravanExpanded.value = value;
                          vuc.updateVehicleType.value =
                              vuc.response?.vehicleType ?? '';
                          debugPrint(
                              "car+caravan updated vehicle : ${vuc.updateVehicleType.value}");
                        },
                        tilePadding: EdgeInsets.zero,
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              appThemeIcon,
                              colorFilter: ColorFilter.mode(
                                  secondaryColor, BlendMode.srcIn),
                              // color: secondaryColor,
                              width: 24.0,
                              height: 24.0,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            customText(
                              text: addVehicleDetails,
                              size: 16,
                              color: secondaryColor,
                            ),
                          ],
                        ),
                        trailing: Icon(
                          (vuc.isCaravanExpanded.value)
                              ? Icons.keyboard_arrow_down
                              : Icons.arrow_forward_ios,
                          size: (vuc.isCaravanExpanded.value) ? 25.0 : 16.0,
                          color: secondaryColor,
                        ),
                        childrenPadding:
                            const EdgeInsets.only(left: 30, bottom: 15),
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownSearch<String>(
                                  selectedItem: vuc.chooseMake.value,
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
                                                  topRight:
                                                      Radius.circular(25)),
                                            ),
                                            backgroundColor: Get.isDarkMode
                                                ? gray800
                                                : Colors.white),
                                    searchFieldProps: TextFieldProps(
                                      decoration: const CustomWidgets()
                                          .inputDecorationBox(
                                              Get.context!,
                                              labelSearchMakerInfo,
                                              CupertinoIcons.car_detailed),
                                    ),
                                  ),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration:
                                        const CustomWidgets()
                                            .dropDownSearchDecorationBox(
                                                Get.context!,
                                                labelMakerInfo,
                                                CupertinoIcons.car_detailed),
                                  ),
                                  items: vuc.makeItems,
                                  onChanged: (newValue) {
                                    vuc.chooseMake.value = newValue.toString();

                                    ///dddddddd
                                    vuc.chooseModel.value = 'Select Model';
                                    vuc.regoController.text = "";
                                    vuc.chooseYearValue.value = 'Select Year';
                                    vuc.colorController.text = "";
                                    vuc.modelId = "";
                                    vuc.bodyType.value = "";
                                    vuc.heightController.text = "";
                                    vuc.weightController.text = "";
                                    vuc.widthController.text = "";
                                    vuc.lengthController.text = "";

                                    vuc.heightVisible.value = false;
                                    vuc.widthVisible.value = false;
                                    vuc.weightVisible.value = false;
                                    vuc.lengthVisible.value = false;

                                    for (var item
                                        in vehicleUpdateController.makeList) {
                                      if (newValue == item.make) {
                                        vuc.makeId = item.makeID;
                                        break;
                                      }
                                    }

                                    vuc.vehicleModelList(vuc.makeId);
                                    modelApiCall(vuc.makeId.toString(),
                                        vuc.updateVehicleType.value);
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
                                                Get.context!,
                                                labelSearchModels,
                                                CupertinoIcons.car_detailed),
                                      ),
                                      modalBottomSheetProps:
                                          ModalBottomSheetProps(
                                              elevation: 30,
                                              // backgroundColor: whiteColor,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25),
                                                    topRight:
                                                        Radius.circular(25)),
                                              ),
                                              backgroundColor: Get.isDarkMode
                                                  ? gray800
                                                  : Colors.white),
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                const CustomWidgets()
                                                    .dropDownSearchDecorationBox(
                                                        Get.context!,
                                                        labelModels,
                                                        CupertinoIcons
                                                            .car_detailed)),
                                    items: vuc.modelItems,
                                    onChanged: (newValue) {
                                      vuc.chooseModel.value =
                                          newValue.toString();

                                      for (var item in vehicleUpdateController
                                          .modelList) {
                                        if (newValue == item.modelName) {
                                          vuc.modelId = item.modelID.toString();
                                          vuc.bodyType.value =
                                              item.type.toString();
                                          if (vuc.bodyType.value == "Caravan" ||
                                              vuc.bodyType.value == "Marine" ||
                                              vuc.bodyType.value ==
                                                  "Motorhome") {
                                            debugPrint(
                                                "${vuc.height} ${vuc.weight} ${vuc.width} ${vuc.length}");

                                            if (vuc.height != null &&
                                                vuc.width != null &&
                                                vuc.length != null &&
                                                vuc.weight != null) {
                                              debugPrint("we in state ");

                                              vuc.heightEnable.value = false;
                                              vuc.widthEnable.value = false;
                                              vuc.weightEnable.value = false;
                                              vuc.lengthEnable.value = false;
                                              vuc.heightVisible.value = true;
                                              vuc.widthVisible.value = true;
                                              vuc.weightVisible.value = true;
                                              vuc.lengthVisible.value = true;
                                            } else {
                                              vuc.heightVisible.value = false;
                                              vuc.widthVisible.value = false;
                                              vuc.weightVisible.value = false;
                                              vuc.lengthVisible.value = false;
                                            }
                                          }
                                        }
                                      }
                                    },
                                    selectedItem: vuc.chooseModel.value),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      readOnly: false,
                                      maxLength: 8,
                                      keyboardType: TextInputType.text,
                                      controller: vuc.regoController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-z0-9]"))
                                      ],
                                      decoration: const CustomWidgets()
                                          .inputDecorationBox(
                                              Get.context!,
                                              labelRego,
                                              CupertinoIcons.textformat_abc))),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownSearch<String>(
                                    popupProps: PopupProps.modalBottomSheet(
                                      showSearchBox: true,
                                      showSelectedItems: true,
                                      searchDelay:
                                          const Duration(milliseconds: 0),
                                      searchFieldProps: TextFieldProps(
                                        keyboardType: TextInputType.number,
                                        decoration: const CustomWidgets()
                                            .inputDecorationBox(
                                                Get.context!,
                                                labelSearchYear,
                                                CupertinoIcons.calendar),
                                      ),
                                      modalBottomSheetProps:
                                          ModalBottomSheetProps(
                                        elevation: 30,
                                        // backgroundColor: whiteColor,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25)),
                                        ),
                                        backgroundColor: Get.isDarkMode
                                            ? gray800
                                            : Colors.white,
                                      ),
                                    ),
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                const CustomWidgets()
                                                    .dropDownSearchDecorationBox(
                                                        Get.context!,
                                                        labelYear,
                                                        CupertinoIcons
                                                            .calendar)),
                                    items: vuc.yearsList,
                                    onChanged: (newValue) {
                                      vuc.chooseYearValue.value =
                                          newValue.toString();
                                    },
                                    selectedItem: vuc.chooseYearValue.value),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      readOnly: false,
                                      keyboardType: TextInputType.text,
                                      controller: vuc.colorController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-z]"))
                                      ],
                                      decoration: const CustomWidgets()
                                          .inputDecorationBox(
                                              Get.context!,
                                              labelColour,
                                              Icons.color_lens_outlined))),
                              Visibility(
                                visible: vuc.weightVisible.value,
                                child: SizedBox(
                                    child: Column(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                            readOnly: vuc.weightEnable.value,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: <TextInputFormatter>[
                                              // FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            controller: vuc.weightController,
                                            decoration: InputDecoration(
                                              helperText:
                                                  "$labelMaxAllowedWeight${vuc.weight} $labelTon",
                                              labelText: labelWeight,
                                              floatingLabelStyle: TextStyle(
                                                  color: secondaryColor),
                                              prefixIcon: Icon(
                                                  Icons.monitor_weight_outlined,
                                                  color: secondaryColor),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: secondaryColor,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              labelStyle: TextStyle(
                                                fontFamily: "Avenir",
                                                color: secondaryColor,
                                              ),
                                              helperStyle: TextStyle(
                                                color: secondaryColor,
                                                fontFamily: "Avenir",
                                              ),
                                            ))),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                            readOnly: vuc.lengthEnable.value,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: <TextInputFormatter>[
                                              // FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            controller: vuc.lengthController,
                                            onTap: (() {}),
                                            decoration: InputDecoration(
                                              helperText:
                                                  "$labelMaxAllowedLength${vuc.length} $labelMeters",
                                              labelText: labelLength,
                                              floatingLabelStyle: TextStyle(
                                                  color: secondaryColor),
                                              prefixIcon: Icon(
                                                  CupertinoIcons.arrow_up_down,
                                                  color: secondaryColor),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: secondaryColor,
                                                          width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: secondaryColor,
                                                          width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                              labelStyle: TextStyle(
                                                //  color: primaryColor,
                                                fontFamily: "Avenir",
                                                color: secondaryColor,
                                              ),
                                              helperStyle: TextStyle(
                                                color: secondaryColor,
                                                fontFamily: "Avenir",
                                              ),
                                            ))),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                            readOnly: vuc.heightEnable.value,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: <TextInputFormatter>[
                                              // FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            controller: vuc.heightController,
                                            decoration: InputDecoration(
                                              helperText:
                                                  "$labelMaxAllowedHeigth${vuc.height}$labelMeters",
                                              labelText: labelHeigth,
                                              floatingLabelStyle: TextStyle(
                                                  color: secondaryColor),
                                              prefixIcon: Icon(
                                                  CupertinoIcons.arrow_up_down,
                                                  color: secondaryColor),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: secondaryColor,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: secondaryColor,
                                                          width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                              labelStyle: TextStyle(
                                                // color: primaryColor,
                                                fontFamily: "Avenir",
                                                color: secondaryColor,
                                              ),
                                              helperStyle: TextStyle(
                                                color: secondaryColor,
                                                fontFamily: "Avenir",
                                              ),
                                            ))),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                            readOnly: vuc.widthEnable.value,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d+\.?\d{0,2}')),
                                            ],
                                            controller: vuc.widthController,
                                            decoration: InputDecoration(
                                              helperText:
                                                  "$labelMaxAllowedWidth${vuc.width} $labelMeters",
                                              labelText: labelWidth,
                                              floatingLabelStyle: TextStyle(
                                                  color: secondaryColor),
                                              prefixIcon: Icon(
                                                  CupertinoIcons
                                                      .arrow_left_right,
                                                  color: secondaryColor),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: secondaryColor,
                                                          width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: secondaryColor,
                                                          width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                              labelStyle: TextStyle(
                                                //  color: primaryColor,
                                                fontFamily: "Avenir",
                                                color: secondaryColor,
                                              ),
                                              helperStyle: TextStyle(
                                                color: secondaryColor,
                                                fontFamily: "Avenir",
                                              ),
                                            ))),
                                  ],
                                )),
                              ),
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
                                        "it's caravan vehicle data---------");
                                    callingAPIForUpdateVehicle(
                                        3,
                                        vuc.response!.planID.toString(),
                                        vuc.bodyType.value,
                                        vuc.response?.planName ?? '',
                                        vuc.response?.membershipNo ?? '',
                                        vuc);

                                    debugPrint(
                                        "${vuc.chooseMake} ${vuc.chooseModel} ${vuc.regoController.text} ${vuc.chooseYearValue} ${vuc.colorController.text} ${vuc.bodyType}");
                                  },
                                  child: customText(text: labelSave, size: 16),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    }),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  showConfirmationDeleteVehicleDialog(
      String vehicleId, VehicleUpdateController vuc) {
    return showDialog(
      context: Get.context!,
      useRootNavigator: false,
      builder: (context) => CupertinoAlertDialog(
        title: customText(
          text: confirmDeleteVehicleText,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();

              vuc.myMemberShipsController!
                  .vehicleDelete(vehicleId)
                  .then((value) {
                if (value['StatusCode'] == 1) {
                  vuc.myMemberShipsController!.myVehicleListResponse = vuc
                      .myMemberShipsController!
                      .getVehicleList(vuc.customerId.toString())
                      .whenComplete(() {
                    printMessage(tag,
                        "Vehicle Length : ${vuc.myMemberShipsController!.vehicleList.length}");

                    const CustomWidgets()
                        .snackBar(Get.context!, vehicleDeleteSuccessfully);
                  });
                } else {
                  const CustomWidgets().snackBar(Get.context!, backendError);
                }
              });
            },
            child: customText(text: labelConfirm, color: secondaryColor),
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

  callingAPIForUpdateVehicle(int value, String planId, String bodyType,
      planName, membershipNo, VehicleUpdateController vuc) {
    if (value == 1) {
      debugPrint("check make model");
      debugPrint("${vuc.chooseMake.toString().isNotEmpty}");
      debugPrint("${vuc.chooseModel.toString().isNotEmpty}");

      if (vuc.chooseMake.toString().isNotEmpty &&
          vuc.chooseMake.toString() != "Select Make") {
        if (vuc.chooseModel.toString().isNotEmpty &&
            vuc.chooseModel.toString() != "Select Model") {
          if (vuc.regoController.text.isNotEmpty) {
            if (vuc.chooseYearValue.value != "Select Year") {
              if (vuc.colorController.text.isNotEmpty) {
                if (bodyType == "Caravan" ||
                    bodyType == "Marine" ||
                    bodyType == "Motorhome") {
                  if (vuc.height != null &&
                      vuc.width != null &&
                      vuc.weight != null &&
                      vuc.length != null) {
                    if (vuc.weightController.text.isNotEmpty) {
                      if (double.parse(vuc.weight!) >=
                          double.parse(vuc.weightController.text)) {
                        if (vuc.lengthController.text.isNotEmpty) {
                          if (double.parse(vuc.length!) >=
                              double.parse(vuc.lengthController.text)) {
                            if (vuc.heightController.text.isNotEmpty) {
                              if (double.parse(vuc.height!) >=
                                  double.parse(vuc.heightController.text)) {
                                if (vuc.widthController.text.isNotEmpty) {
                                  if (double.parse(vuc.width!) >=
                                      double.parse(vuc.widthController.text)) {
                                    // Get.back();
                                    closeKeyBoard(Get.context!);
                                    const CustomWidgets()
                                        .vehicleBodyTypeConfirmationDialog(
                                            Get.context!, () {
                                      Get.back();

                                      vehicleUpdateController
                                          .secondVehicleUpdate(
                                              planId.toString(),
                                              vuc.chooseMake.toString(),
                                              vuc.chooseModel.toString(),
                                              vuc.colorController.text,
                                              vuc.chooseYearValue,
                                              vuc.regoController.text,
                                              bodyType,
                                              double.parse(
                                                  vuc.weightController.text),
                                              double.parse(
                                                  vuc.widthController.text),
                                              double.parse(
                                                  vuc.heightController.text),
                                              double.parse(
                                                  vuc.lengthController.text),
                                              membershipNo,
                                              "",
                                              "",
                                              "",
                                              "",
                                              "",
                                              "")
                                          .then((value) {
                                        vuc.loading.value = true;

                                        vuc.getVehicleDetails();
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
                          const CustomWidgets()
                              .snackBar(Get.context!, enterLength);
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
                }
              } else {
                const CustomWidgets()
                    .snackBar(Get.context!, errorColorNotEmpty);
              }
            } else {
              const CustomWidgets()
                  .snackBar(Get.context!, errorPleaseChooseYear);
            }
          } else {
            const CustomWidgets()
                .snackBar(Get.context!, errorVehicleNumberNotCorrect);
          }
        } else {
          const CustomWidgets().snackBar(Get.context!, errorPleaseChooseModel);
        }
      } else {
        const CustomWidgets().snackBar(Get.context!, sbSelectVehicleMake);
      }
    } else if (value == 2) {
      if (vuc.carChooseMake.toString().isNotEmpty &&
          vuc.carChooseMake.toString() != "Select Make") {
        if (vuc.carChooseModel.toString().isNotEmpty &&
            vuc.carChooseModel.toString() != "Select Model") {
          if (vuc.carRegoController.text.isNotEmpty) {
            if (vuc.carChooseYearValue.value != "Select Year") {
              if (vuc.carColorController.text.isNotEmpty) {
                closeKeyBoard(Get.context!);
                const CustomWidgets()
                    .vehicleBodyTypeConfirmationDialog(Get.context!, () {
                  Get.back();

                  vehicleUpdateController
                      .secondVehicleUpdate(
                    planId.toString(),
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    membershipNo,
                    vuc.carRegoController.text,
                    vuc.carChooseYearValue,
                    vuc.carBodyType,
                    vuc.carChooseModel,
                    vuc.carChooseMake,
                    vuc.carColorController.text,
                  )
                      .then((value) {
                    vuc.loading.value = true;

                    vuc.getVehicleDetails();
                  });
                });
              } else {
                const CustomWidgets()
                    .snackBar(Get.context!, errorColorNotEmpty);
              }
            } else {
              const CustomWidgets()
                  .snackBar(Get.context!, errorPleaseChooseYear);
            }
          } else {
            const CustomWidgets()
                .snackBar(Get.context!, errorVehicleNumberNotCorrect);
          }
        } else {
          const CustomWidgets().snackBar(Get.context!, errorPleaseChooseModel);
        }
      } else {
        const CustomWidgets().snackBar(Get.context!, sbSelectVehicleMake);
      }
    } else if (value == 3) {
      debugPrint("check make model");
      debugPrint("${vuc.chooseMake.toString().isNotEmpty}");
      debugPrint("${vuc.chooseModel.toString().isNotEmpty}");

      if (vuc.chooseMake.toString().isNotEmpty &&
          vuc.chooseMake.toString() != "Select Make") {
        if (vuc.chooseModel.toString().isNotEmpty &&
            vuc.chooseModel.toString() != "Select Model") {
          if (vuc.regoController.text.isNotEmpty) {
            if (vuc.chooseYearValue.value != "Select Year") {
              if (vuc.colorController.text.isNotEmpty) {
                if (bodyType == "Caravan" ||
                    bodyType == "Marine" ||
                    bodyType == "Motorhome") {
                  if (vuc.height != null &&
                      vuc.width != null &&
                      vuc.weight != null &&
                      vuc.length != null) {
                    if (double.parse(vuc.weight!) >=
                        double.parse(vuc.weightController.text)) {
                      if (double.parse(vuc.length!) >=
                          double.parse(vuc.lengthController.text)) {
                        if (double.parse(vuc.height!) >=
                            double.parse(vuc.heightController.text)) {
                          if (double.parse(vuc.width!) >=
                              double.parse(vuc.widthController.text)) {
                            // Get.back();
                            closeKeyBoard(Get.context!);
                            const CustomWidgets()
                                .vehicleBodyTypeConfirmationDialog(Get.context!,
                                    () {
                              Get.back();

                              vehicleUpdateController
                                  .addVehicleDetailByPlanDetail(
                                      vuc.chooseMake.toString(),
                                      vuc.chooseModel.toString(),
                                      vuc.colorController.text,
                                      vuc.chooseYearValue,
                                      vuc.regoController.text,
                                      bodyType,
                                      double.parse(vuc.weightController.text),
                                      double.parse(vuc.widthController.text),
                                      double.parse(vuc.heightController.text),
                                      double.parse(vuc.lengthController.text),
                                      membershipNo)
                                  .then((value) {
                                vuc.loading.value = true;

                                vuc.getVehicleDetails();
                              });
                            });
                          } else {
                            const CustomWidgets()
                                .snackBar(Get.context!, errorWidthSize);
                          }
                        } else {
                          const CustomWidgets()
                              .snackBar(Get.context!, errorHeigthSize);
                        }
                      } else {
                        const CustomWidgets()
                            .snackBar(Get.context!, errorLengthSize);
                      }
                    } else {
                      const CustomWidgets()
                          .snackBar(Get.context!, errorWeightSize);
                    }
                  } else {
                    const CustomWidgets().showDialogForPlanDoNotHaveVehicleType(
                        Get.context!, planName);
                  }
                } else {
                  closeKeyBoard(Get.context!);
                  const CustomWidgets()
                      .vehicleBodyTypeConfirmationDialog(Get.context!, () {
                    Get.back();

                    vehicleUpdateController
                        .addVehicleDetailByPlanDetail(
                            vuc.chooseMake.toString(),
                            vuc.chooseModel.toString(),
                            vuc.colorController.text,
                            vuc.chooseYearValue,
                            vuc.regoController.text,
                            bodyType,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            membershipNo)
                        .then((value) {
                      vuc.loading.value = true;
                      vuc.getVehicleDetails();
                    });
                  });
                }
              } else {
                const CustomWidgets()
                    .snackBar(Get.context!, errorColorNotEmpty);
              }
            } else {
              const CustomWidgets()
                  .snackBar(Get.context!, errorPleaseChooseYear);
            }
          } else {
            const CustomWidgets()
                .snackBar(Get.context!, errorVehicleNumberNotCorrect);
          }
        } else {
          const CustomWidgets().snackBar(Get.context!, errorPleaseChooseModel);
        }
      } else {
        const CustomWidgets().snackBar(Get.context!, sbSelectVehicleMake);
      }
    }
  }

  Future<void> modelApiCall(String makeId, String vehicleType) async {
    debugPrint("vehicle type: $vehicleType");

    vehicleUpdateController.modelItems = [];
    await vehicleUpdateController
        .vehicleModelList(makeId.toString())
        .then((value) {
      printMessage(tag, "it's in side");

      for (var item in value ?? []) {
        if (item.type == vehicleType) {
          vehicleUpdateController.modelItems.add(item.modelName.toString());
        }
      }
    });
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
}
