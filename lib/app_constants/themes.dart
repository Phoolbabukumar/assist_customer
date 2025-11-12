import 'package:assist/app_constants/app_colors.dart';
import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData(
      useMaterial3: false,
      fontFamily: 'Avenir',
      primaryColor: const Color(0xFF283e4a),
      primaryColorDark: const Color(0xFF283e4a),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: const Color(0xFFf05c30))
          .copyWith(
            surface: whiteColor,
          ));

  // R57043

  static final dark = ThemeData.dark(useMaterial3: false).copyWith(
    buttonTheme: const ButtonThemeData(
        buttonColor: Colors.deepPurple, textTheme: ButtonTextTheme.primary),
    textTheme: const TextTheme().apply(
      bodyColor: whiteColor,
      displayColor: whiteColor,
    ),
  );
}
