import 'package:assist/Controllers/theme_controller.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'network_manager.dart';

class NetworkBinding extends Bindings {
  final BuildContext? context;
  NetworkBinding({ this.context});
  @override
  void dependencies() {
    Get.lazyPut<NetworkManager>(() => NetworkManager());

    ThemeController themeController = Get.put(ThemeController());

    themeController.changeTheme(global.themeType);
  }
}
