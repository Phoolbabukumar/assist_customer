import 'package:assist/Network/networkwidget.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/utils/Widgets/widgets_file.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/jobs_datalist_controller.dart';
import '../app_constants/app_colors.dart';
import '../utils/common_functions.dart';
import '../utils/custom_widgets.dart';

class JobBookingList extends StatelessWidget {
  JobBookingList({super.key});

  final jobsDataListController = Get.put(JobsDataListController());

  @override
  Widget build(BuildContext context) {
    return networkWidget(
        SafeArea(
          child: Scaffold(
            appBar: const CustomWidgets().appBar(
                context,
                0.0,
                jobsDataListController.global.themeType == 1
                    ? MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.black
                        : secondaryColor
                    : jobsDataListController.themeController.isDarkMode.value
                        ? Colors.black
                        : secondaryColor,
                IconThemeData(
                    color:
                        jobsDataListController.themeController.isDarkMode.value
                            ? secondaryColor
                            : Colors.white),
                customText(
                    text: labelMyJobs,
                    color:
                        jobsDataListController.themeController.isDarkMode.value
                            ? secondaryColor
                            : whiteColor),
                true),
            body: RefreshIndicator(
              onRefresh: jobsDataListController.refreshData,
              child: ListView(
                children: [
                  Container(
                    height: Get.height * 0.1,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        leading: const Icon(Icons.search),
                        title: TextField(
                          controller: jobsDataListController.searchController,
                          decoration: InputDecoration(
                            hintText: lableSearchBy,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            jobsDataListController.onSearchTextChanged(value);
                          },
                        ),
                        trailing: (jobsDataListController
                                    .searchController.value.text
                                    .toString() ==
                                "")
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  jobsDataListController.searchController
                                      .clear();
                                  closeKeyBoard(context);
                                  jobsDataListController
                                      .onSearchTextChanged('');
                                },
                              ),
                      ),
                    ),
                  ),
                  Obx(() => (jobsDataListController.loading.value)
                      ? const CustomWidgets().buildShimmerBlock()
                      : (jobsDataListController.responseList.isEmpty)
                          ? const CustomWidgets().buildEmptyBlock(context)
                          : jobsDataListController
                                      .searchController.text.isEmpty &&
                                  jobsDataListController.searchList.isEmpty
                              ? buildListDataBlock(
                                  jobsDataListController:
                                      jobsDataListController)
                              : jobsDataListController
                                          .searchController.text.isNotEmpty &&
                                      jobsDataListController
                                          .searchList.isNotEmpty
                                  ? buildListDataSearchBlock(
                                      jobsDataListController:
                                          jobsDataListController)
                                  : SizedBox(
                                      height: Get.height * 0.4,
                                      child: Center(
                                        child: customText(
                                          text: labelNoDataFound,
                                        ),
                                      ),
                                    ))
                ],
              ),
            ),
          ),
        ),
        context);
  }
}
