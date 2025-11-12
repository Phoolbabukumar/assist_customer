import 'package:assist/Controllers/profile_data_controller.dart';
import 'package:assist/Network/networkwidget.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../app_constants/app_colors.dart';
import '../../utils/custom_widgets.dart';
import '../../utils/size_config.dart';
import '../map_home_screen.dart';

class DeleteAccount extends StatelessWidget {
  final ProfileDataController profileDataController;
  const DeleteAccount({super.key, required this.profileDataController});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final reasonController = TextEditingController();
    return networkWidget(
        SafeArea(
            child: Scaffold(
          appBar: const CustomWidgets().appBar(
              context,
              0.0,
              global.themeType == 1
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black
                      : secondaryColor
                  : profileDataController.themecontroller.isDarkMode.value
                      ? Colors.black
                      : secondaryColor,
              IconThemeData(
                  color: profileDataController.themecontroller.isDarkMode.value
                      ? secondaryColor
                      : Colors.white),
              customText(
                  text: labelDeleteAccount,
                  color: profileDataController.themecontroller.isDarkMode.value
                      ? secondaryColor
                      : Colors.white),
              true),
          body: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Icon(
                  Icons.delete,
                  color: secondaryColor,
                  size: 130,
                ),
              ),
              ListTile(
                leading: customText(text: '.', size: 50, color: secondaryColor),
                title: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: customText(
                      text: allMembershipsAssociatedWithYourAccount, size: 14),
                ),
              ),
              ListTile(
                leading: customText(text: '.', size: 50, color: secondaryColor),
                title: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: customText(text: accountDeleteNonReversible, size: 14),
                ),
              ),
              ListTile(
                leading: customText(text: '.', size: 50, color: secondaryColor),
                title: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: customText(
                      text: restoreMembershipsOrMoveToOtherVehicles, size: 14),
                ),
              ),
              ListTile(
                leading: customText(text: '.', size: 50, color: secondaryColor),
                title: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: customText(text: signOutFromAllDevices, size: 14),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: secondaryColor, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(5.0), // Border radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: reasonController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-z ]"))
                        ],
                        maxLines: 3,
                        maxLength: 200,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: reasonForDeleteAccount,
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: customText(
                        text: labelConfirm, size: 18, color: whiteColor),
                    onPressed: () {
                      profileDataController
                          .deleteProfile(global.customerPhoneNumber.toString(),
                              reasonController.text)
                          .then((value) {
                        Get.offAll(() => MapHomeScreen(currentIndexValue: 0));
                      });
                    },
                  ),
                ),
              ),
            ]),
          ),
        )),
        context);
  }
}
