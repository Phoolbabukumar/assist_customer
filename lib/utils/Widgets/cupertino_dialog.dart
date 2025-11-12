import 'package:assist/app_constants/app_colors.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CupertinoDialogClass {
  customCupertinoDialog(
      {required String title,
      required String content,
      required Function()? onTapYes,
      required Function()? onTapNo,
      required String yesText,
      required String notext}) {
    return showDialog(
      context: Get.context!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title.isEmpty? const SizedBox.shrink(): customText(text: title, size: 12,textAlign: TextAlign.center),
          content: customText(text: content,textAlign: TextAlign.center,size: 15),
          actions: [
            TextButton(onPressed: onTapYes, child: customText(text: yesText, color: secondaryColor)),
            TextButton(onPressed: onTapNo, child: customText(text: notext, color: cancelColor)),
          ],
        );
      },
    );
  }
}
