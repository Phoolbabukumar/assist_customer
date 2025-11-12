import 'package:assist/Controllers/home_screen_controller.dart';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:assist/ui/account/profile_screen.dart';
import 'package:assist/ui/customer_access.dart';
import 'package:assist/ui/account/deactivated_screen.dart';
import 'package:assist/utils/Widgets/widgets_file.dart';
import 'package:assist/utils/size_config.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../app_constants/app_colors.dart';
import '../app_constants/app_images_path.dart';
import '../utils/common_functions.dart';
import '../utils/custom_widgets.dart';
import 'home_screen.dart';
import 'more.dart';
import 'my_memberships.dart';
import 'road_side_services2.dart';

class MapHomeScreen extends StatelessWidget {
  final int currentIndexValue;
  MapHomeScreen({super.key, required this.currentIndexValue});

  final homeScreenController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    homeScreenController.currentIndex.value = currentIndexValue;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        var tag = "back";
        printMessage(tag, '$currentIndexValue');
        if (currentIndexValue != 0) {
          homeScreenController.currentIndex.value = 0;
          homeScreenController.tabMethod(currentIndexValue);
        }
      },
      child: networkWidget(
          StreamBuilder(
              stream: homeScreenController.pusherService.eventStream,
              builder: (BuildContext context, AsyncSnapshot data) {
                printLog("customer access data", data.data);

                if (data.data.toString() == "101") {
                  homeScreenController.checkCustomerContract().then((value) {
                    debugPrint('Process');
                    Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
                    homeScreenController.pusherService.clearData();
                  });
                } else {
                  printMessage(tag, "in data null");
                }

                return SafeArea(
                    /*When data not loaded the loading occur otherwise first it check customer access and then activation and contract existance finally the screen was shown */
                    child: Obx(
                  () => homeScreenController.isLoading.value
                      ? Scaffold(
                          body: Center(
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, left: 8),
                                  child: Image.asset(
                                    loadingIcon,
                                    width: 80,
                                    height: 90,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                      : homeScreenController.isCustomerAccess.value == false
                          ? CustomerAccessScreen(
                              hsc: homeScreenController,
                            )
                          /* Agar account deActivate hai to deactive screen otherwise set screen according to contract exist condition */
                          : homeScreenController.isDeactivated.value
                              ? DeactivatedScreen(
                                  hsc: homeScreenController,
                                )
                              /* Agar contract hai to map screen show hogi otherwise HomeScreen show hogi. */
                              : homeScreenController.contractExists.value
                                  ? Scaffold(
                                      resizeToAvoidBottomInset: false,
                                      drawer: More(
                                        profileUrl: global.profileUserImageUrl,
                                        name: global.profileUserFirstName,
                                        hsc: homeScreenController,
                                      ),
                                      appBar: homeScreenController
                                                  .currentIndex.value ==
                                              4
                                          ? null
                                          : const CustomWidgets().appBar(
                                              context,
                                              4.0,
                                              global.themeType == 1
                                                  ? MediaQuery.of(context)
                                                              .platformBrightness ==
                                                          Brightness.dark
                                                      ? Colors.black26
                                                      : secondaryColor
                                                  : homeScreenController
                                                          .themeController
                                                          .isDarkMode
                                                          .value
                                                      ? Colors.black26
                                                      : secondaryColor,
                                              IconThemeData(
                                                  color: global.themeType == 1
                                                      ? MediaQuery.of(context)
                                                                  .platformBrightness ==
                                                              Brightness.dark
                                                          ? secondaryColor
                                                          : Colors.white
                                                      : homeScreenController
                                                              .themeController
                                                              .isDarkMode
                                                              .value
                                                          ? secondaryColor
                                                          : Colors.white),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.2,
                                                  vertical:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.2,
                                                ),
                                                child: SizedBox(
                                                  child: Image.asset(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.15,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                    homeScreenController
                                                            .themeController
                                                            .isDarkMode
                                                            .value
                                                        ? newLogo
                                                        : newLogo,
                                                    color: global.themeType == 1
                                                        ? MediaQuery.of(context)
                                                                    .platformBrightness ==
                                                                Brightness.dark
                                                            ? null
                                                            : Colors.white
                                                        : homeScreenController
                                                                .themeController
                                                                .isDarkMode
                                                                .value
                                                            ? null
                                                            : Colors.white,
                                                  ),
                                                ),
                                              ),
                                              true),
                                      body: homeScreenController
                                                  .currentIndex.value ==
                                              0
                                          /*Here it check location permission, officeOpen status, and contract availablity and then select the screen. */
                                          ? homeScreenController
                                                  .permissionsEnabled.value
                                              ? homeScreenController
                                                      .isOfficeOpen.value
                                                  ? homeScreenController
                                                      .buildMap()
                                                  : buildOfficeOff()
                                              : buildNoLocation(
                                                  homeScreenController:
                                                      homeScreenController)
                                          : homeScreenController
                                                      .currentIndex.value ==
                                                  1
                                              ? RoadsideServices2()
                                              : homeScreenController
                                                          .currentIndex.value ==
                                                      3
                                                  ? MyMemberShips()
                                                  : homeScreenController
                                                              .currentIndex
                                                              .value ==
                                                          4
                                                      ? ProfileScreen(
                                                          latitude: 0.0,
                                                          longitude: 0.0)
                                                      : Container(),
                                      bottomNavigationBar: Obx(() =>
                                          ConvexAppBar(
                                            key: homeScreenController.appBarKey,
                                            style: TabStyle.fixed,
                                            backgroundColor: global.themeType ==
                                                    1
                                                ? MediaQuery.of(context)
                                                            .platformBrightness ==
                                                        Brightness.dark
                                                    ? Colors.black
                                                    : Colors.white
                                                : homeScreenController
                                                        .themeController
                                                        .isDarkMode
                                                        .value
                                                    ? Colors.black
                                                    : whiteColor,
                                            activeColor: secondaryColor,
                                            color: global.themeType == 1
                                                ? MediaQuery.of(context)
                                                            .platformBrightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : transparentBlack
                                                : homeScreenController
                                                        .themeController
                                                        .isDarkMode
                                                        .value
                                                    ? Colors.white
                                                    : transparentBlack,
                                            height: 50.0,
                                            elevation: 10.0,
                                            curveSize: 100.0,
                                            initialActiveIndex:
                                                homeScreenController
                                                    .currentIndex.value,
                                            items: [
                                              TabItem(
                                                  icon: Icons.map_outlined,
                                                  title: labelMap),
                                              TabItem(
                                                  icon: Icons.directions_car,
                                                  title: labelRoadside),
                                              TabItem(
                                                  icon: Icons.phone,
                                                  title: labelSupport),
                                              TabItem(
                                                  icon: Icons.group,
                                                  title: labelMembership),
                                              TabItem(
                                                  icon: Icons.person,
                                                  title: labelProfile),
                                            ],
                                            onTap: (int i) {
                                              homeScreenController
                                                  .currentIndex.value = i;
                                              homeScreenController.tabMethod(i);
                                            },
                                          )),
                                    )
                                  : const HomeScreen(),
                ));
              }),
          context),
    );
  }
/*NOTE :-  Here we have a _buildWaitingForLocation widget that is not usable after using Getx so I can remove it from code */
}

Widget buildWaitingForLocation() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SpinKitDoubleBounce(
        color: secondaryColor,
        duration: const Duration(milliseconds: 1000),
      ),
      const SizedBox(
        height: 15.0,
      ),
      customText(
        text: labelGettingCurrentLocation,
        size: 18,
        textAlign: TextAlign.center,
        color: secondaryColor,
      ),
    ],
  );
}
