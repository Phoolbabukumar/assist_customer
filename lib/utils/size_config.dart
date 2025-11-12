import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    defaultSize = orientation == Orientation.landscape
        ? screenHeight * 0.024
        : screenWidth * 0.024;
  }
}

Widget customText(
    {required String text,
    double? size,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    int? maxLines,
    TextDecoration? decoration,
    double? decorationThickness,
    TextOverflow? overflow}) {
  return Text(
    text,
    style: TextStyle(
        color: color,
        fontSize: size?.sp ?? 14.sp,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontFamily: "Avenir",
        decoration: decoration ?? TextDecoration.none,
        decorationThickness: decorationThickness ?? 0,
        overflow: overflow ?? TextOverflow.clip),
    textAlign: textAlign ?? TextAlign.start,
    softWrap: true,
    // maxLines: maxLines ?? DefaultTextStyle.of(Get.context!).maxLines,
  );
}
