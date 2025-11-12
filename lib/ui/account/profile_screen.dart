import 'package:assist/Network/networkwidget.dart';
import 'package:assist/utils/Widgets/widgets_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/profile_data_controller.dart';
import '../../app_constants/app_colors.dart';
import '../../app_constants/app_strings.dart';
import '../../utils/custom_widgets.dart';
import '../../utils/size_config.dart';

class ProfileScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  ProfileScreen({super.key, required this.latitude, required this.longitude});

  final profileDataController = Get.find<ProfileDataController>();

  @override
  Widget build(BuildContext context) {
    double defaultSize = 0.0;
    SizeConfig().init(context);
    defaultSize = SizeConfig.defaultSize;
    return networkWidget(GetBuilder<ProfileDataController>(builder: (builder) {
      return SafeArea(
          child: Scaffold(
        appBar: const CustomWidgets().appBar(
            context,
            0.0,
            global.themeType == 1
                ? MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? Colors.black
                    : secondaryColor
                : builder.themecontroller.isDarkMode.value
                    ? Colors.black
                    : secondaryColor,
            IconThemeData(
                color: builder.themecontroller.isDarkMode.value
                    ? secondaryColor
                    : Colors.white),
            customText(
                text: labelMyProfile,
                color: builder.themecontroller.isDarkMode.value
                    ? secondaryColor
                    : Colors.white),
            true),
        body: ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: [
            (builder.isLoading.value)
                ? const CustomWidgets().buildShimmerBlock()
                : buildDataBlock(builder, defaultSize)
          ],
        ),
      ));
    }), context);
  }
}
