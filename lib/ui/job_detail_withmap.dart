import 'package:assist/Controllers/jobdetail_with_map_controller.dart';
import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/apis/response/job_data_response.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/utils/Widgets/widgets_file.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_images_path.dart';
import '../utils/common_functions.dart';
import '../utils/custom_widgets.dart';

class JobDetailWithMap extends StatelessWidget {
  JobDetailWithMap({
    super.key,
  });

  final jobdetailMapController = Get.put(JobDetailsWithMapController());

  @override
  Widget build(BuildContext context) {
    var tag = "Job Detail With Map";
    return networkWidget(
        SafeArea(
            child: Scaffold(
          key: jobdetailMapController.scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: const CustomWidgets().appBar(
              context,
              4.0,
              global.themeType == 1
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black
                      : secondaryColor
                  : jobdetailMapController.themeController.isDarkMode.value
                      ? Colors.black
                      : secondaryColor,
              IconThemeData(
                  color: jobdetailMapController.themeController.isDarkMode.value
                      ? secondaryColor
                      : Colors.white),
              Padding(
                // padding: const EdgeInsets.all(60.0),
                padding: const EdgeInsets.only(
                    left: 30, right: 80, bottom: 80, top: 80),
                child: GetBuilder<ThemeController>(builder: (builder) {
                  return SizedBox(
                    height: Get.height * 0.15,
                    width: Get.width * 0.35,
                    child: Image.asset(
                      jobdetailMapController.themeController.isDarkMode.value
                          ? newLogo
                          : newLogoBlack,
                      color: jobdetailMapController
                              .themeController.isDarkMode.value
                          ? null
                          : Colors.white,
                    ),
                  );
                }),
              ),
              true),
          body: StreamBuilder(
              stream: jobdetailMapController.pusherService.eventStream,
              builder: (BuildContext context, AsyncSnapshot data) {
                printLog(tag, "in data manage");
                printLog(tag, data.data);
                printLog(
                    tag,
                    jobdetailMapController.jobsDataListController
                        .getJobsByJobIdResponse.omJobsView?[0].jobNo
                        .toString());
                if (data.data != null) {
                  if (data.data.toString() ==
                      jobdetailMapController.jobsDataListController
                          .getJobsByJobIdResponse.omJobsView?[0].jobNo
                          .toString()) {
                    printMessage(tag, data.data);

                    jobdetailMapController.callApi2();

                    jobdetailMapController.pusherService.clearData();
                  }
                } else {
                  printMessage(tag, "in data null");
                }
                return GetBuilder<JobDetailsWithMapController>(
                    builder: (controller) => Stack(
                          children: [
                            jobdetailMapController.buildMap(),
                            jobdetailMapController.isloading.value
                                ? Container()
                                : _buildSlidingPanel()
                          ],
                        ));
              }),
        )),
        context);
  }

  _buildSlidingPanel() {
    return SlidingUpPanel(
      color: Get.context!.theme.colorScheme.surface,
      minHeight: 65.0,
      defaultPanelState: PanelState.OPEN,
      maxHeight: Get.height * .38,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      collapsed: Container(
        decoration: BoxDecoration(
          color: primaryColorDark,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Get.width * 0.7,
                padding: const EdgeInsets.all(8.0),
                child: customText(
                  text:
                      "${jobdetailMapController.jobsDataListController.getJobsByJobIdResponse.omJobsView?[0].title ?? ""} ${jobdetailMapController.jobsDataListController.getJobsByJobIdResponse.omJobsView?[0].jobNo ?? ""}",
                  size: 18,
                  color: whiteColor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.keyboard_arrow_up_sharp,
                  color: secondaryColor,
                ),
              )
            ],
          ),
        ),
      ),
      panel: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: Get.width * 0.8,
                  child: customText(
                      text:
                          "${jobdetailMapController.jobsDataListController.getJobsByJobIdResponse.omJobsView?[0].title ?? na} ${jobdetailMapController.jobsDataListController.getJobsByJobIdResponse.omJobsView?[0].jobNo}",
                      size: 18,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            /// job status
            Padding(
              padding: const EdgeInsets.only(
                top: 5.0,
                bottom: 5.0,
              ),
              child: Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: Get.width * 0.3,
                        child: const CustomWidgets()
                            .textForJobMap(Get.context!, labelJobStatus, 12.0),
                      ),
                      Container(
                        width: Get.width * 0.03,
                      ),
                      SizedBox(
                        width: Get.width * 0.55,
                        child: const CustomWidgets().textForJobMap(
                            Get.context!,
                            jobdetailMapController
                                    .jobsDataListController
                                    .getJobsByJobIdResponse
                                    .omJobsView?[0]
                                    .status
                                    .toString() ??
                                na,
                            12.0),
                      )
                    ],
                  ),
                ],
              ),
            ),

            /// vehicle detail
            Padding(
              padding: const EdgeInsets.only(
                top: 5.0,
                bottom: 5.0,
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: Get.width * 0.3,
                    child: const CustomWidgets()
                        .textForJobMap(Get.context!, labelVehicleDetail, 12.0),
                  ),
                  Container(
                    width: Get.width * 0.03,
                  ),
                  SizedBox(
                    width: Get.width * 0.6,
                    child: const CustomWidgets().textForJobMap(
                        Get.context!,
                        jobdetailMapController
                                .jobsDataListController
                                .getJobsByJobIdResponse
                                .omJobsView?[0]
                                .vehicleDetail ??
                            na,
                        Get.width * .031),
                  )
                ],
              ),
            ),

            /// customer number
            Padding(
              padding: const EdgeInsets.only(
                top: 5.0,
                bottom: 5.0,
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: Get.width * 0.3,
                    child: const CustomWidgets()
                        .textForJobMap(Get.context!, labelCustomerNumber, 12.0),
                  ),
                  Container(
                    width: Get.width * 0.03,
                  ),
                  SizedBox(
                    width: Get.width * 0.55,
                    child: const CustomWidgets().textForJobMap(
                        Get.context!,
                        jobdetailMapController
                                .jobsDataListController
                                .getJobsByJobIdResponse
                                .omJobsView?[0]
                                .customerPhone ??
                            na,
                        12.0),
                  )
                ],
              ),
            ),

            /// towing distance
            jobdetailMapController.jobsDataListController.getJobsByJobIdResponse
                        .omJobsView?[0].title ==
                    "TOWING"
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      bottom: 5.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: Get.width * 0.3,
                          child: const CustomWidgets().textForJobMap(
                              Get.context!, labelTowDistance, 12.0),
                        ),
                        Container(
                          width: Get.width * 0.03,
                        ),
                        SizedBox(
                          width: Get.width * 0.55,
                          child: const CustomWidgets().textForJobMap(
                              Get.context!,
                              jobdetailMapController
                                      .jobsDataListController
                                      .getJobsByJobIdResponse
                                      .omJobsView?[0]
                                      .towDistance
                                      .toString() ??
                                  na,
                              12.0),
                        )
                      ],
                    ),
                  )
                : Container(),

            /// pickup / service location
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: Get.width * 0.3,
                      child: const CustomWidgets().textForJobMap(
                          Get.context!,
                          jobdetailMapController
                                      .jobsDataListController
                                      .getJobsByJobIdResponse
                                      .omJobsView?[0]
                                      .title ==
                                  "TOWING"
                              ? labelPickUpLocation
                              : labelServiceLocation,
                          12.0),
                    ),
                    Container(
                      width: Get.width * 0.03,
                    ),
                    SizedBox(
                        width: Get.width * 0.55,
                        child: const CustomWidgets().textForJobMap(
                            Get.context!,
                            jobdetailMapController
                                    .jobsDataListController
                                    .getJobsByJobIdResponse
                                    .omJobsView?[0]
                                    .customerAddress ??
                                na,
                            12.0)),
                  ],
                ),
              ),
            ),
            jobdetailMapController.jobsDataListController.getJobsByJobIdResponse
                        .omJobsView?[0].status ==
                    "Completed"
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                    child: getStarWidget(
                        jobdetailMapController
                                .jobsDataListController
                                .getJobsByJobIdResponse
                                .omJobsView?[0]
                                .jobRating ??
                            0,
                        jobdetailMapController.jobsDataListController
                                .getJobsByJobIdResponse.omJobsView?[0] ??
                            JobDataResponse()),
                  )
                : Container()
          ],
        ),
      )),
    );
  }

  getStarWidget(int ratValue, JobDataResponse responseBody) {
    printMessage(tag, "Rating - ${responseBody.jobRating}ratValue$ratValue");
    bool firstStar = false;
    bool secondStar = false;
    bool thirdStar = false;
    bool fourthStar = false;
    bool fifthStar = false;

    switch (ratValue) {
      case 1:
        firstStar = true;
        secondStar = false;
        thirdStar = false;
        fourthStar = false;
        fifthStar = false;
        break;
      case 2:
        firstStar = true;
        secondStar = true;
        thirdStar = false;
        fourthStar = false;
        fifthStar = false;
        break;
      case 3:
        firstStar = true;
        secondStar = true;
        thirdStar = true;
        fourthStar = false;
        fifthStar = false;
        break;
      case 4:
        firstStar = true;
        secondStar = true;
        thirdStar = true;
        fourthStar = true;
        fifthStar = false;
        break;
      case 5:
        firstStar = true;
        secondStar = true;
        thirdStar = true;
        fourthStar = true;
        fifthStar = true;
        break;
      case 0:
        firstStar = false;
        secondStar = false;
        thirdStar = false;
        fourthStar = false;
        fifthStar = false;
        break;
    }

    // printMessage(tag,ratValue);

    if (ratValue != 0) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CustomWidgets().starIcon(Get.context!, firstStar, 25),
          Container(
            width: 5.0,
          ),
          const CustomWidgets().starIcon(Get.context!, secondStar, 25),
          Container(
            width: 5.0,
          ),
          const CustomWidgets().starIcon(Get.context!, thirdStar, 25),
          Container(
            width: 5.0,
          ),
          const CustomWidgets().starIcon(Get.context!, fourthStar, 25),
          Container(
            width: 5.0,
          ),
          const CustomWidgets().starIcon(Get.context!, fifthStar, 25),
        ],
      );
    } else {
      return SizedBox(
        height: 25,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: secondaryColor),
          //color:  Constants.secondaryColor,
          onPressed: () {
            //getFeedBack();
            showRatingBox(
                responsebody: responseBody,
                isFeedbackBox: jobdetailMapController.isFeedbackBox,
                fBUrl: jobdetailMapController.feedBackURL,
                jobdetailMapController: jobdetailMapController);
          },
          child: customText(text: labelPleaseRateUs, ),
        ),
      );
    }
  }
}
