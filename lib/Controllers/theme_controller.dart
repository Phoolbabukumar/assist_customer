import 'dart:ui';

import 'package:assist/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

/* This Function Change theme Mode at Runtime */
  Future<void> changeTheme(themeValue) async {
    if (themeValue == 1) {
     global.setThemeMode(themeValue);
      Get.changeThemeMode(ThemeMode.system);
      //final isLight = Get.mediaQuery.platformBrightness == Brightness.light;
      /* Below line is depricated so I replace this from the above line */
       final isLight = PlatformDispatcher.instance.platformBrightness == Brightness.light;

      debugPrint('isDarkMode theme ..1${isDarkMode.value}');
      debugPrint('isDarkMode isLight ..1$isLight');
      if (isLight) {
        isDarkMode.value = false;
        refresh();
      } else {
        isDarkMode.value = true;
        refresh();
      }

      refresh();
    } else if (themeValue == 2) {
     global.setThemeMode(themeValue);
      Get.changeThemeMode(ThemeMode.light);
      if (isDarkMode.value == true) {
        isDarkMode.value = false;
        debugPrint('isDarkMode theme ..2${isDarkMode.value}');
      }
      refresh();
    } else if (themeValue == 3) {
      global.setThemeMode(themeValue);
      Get.changeThemeMode(ThemeMode.dark);
      if (isDarkMode.value == false) {
        isDarkMode.value = true;
        debugPrint('isDarkMode theme ..3${isDarkMode.value}');
      }
      refresh();
    }
  }
}
