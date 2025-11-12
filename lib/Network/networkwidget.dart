import 'package:assist/app_constants/app_colors.dart';
import 'package:assist/app_constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_constants/app_images_path.dart';
import 'network_manager.dart';

Widget networkWidget(Widget widget, BuildContext context) {
  NetworkManager networkManager = Get.put(NetworkManager());
  return GetBuilder<NetworkManager>(builder: (builder) {
    return networkManager.connectionType == 0
        ? SafeArea(
            child: Scaffold(
              backgroundColor: whiteColor,
              body: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Image.asset(
                          noInternetImage,
                          height: Get.height / 2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          noInternet,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: blueAccent,
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          enableInternet,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: blackColor,
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ])),
            ),
          )
        : widget;
  });
}
