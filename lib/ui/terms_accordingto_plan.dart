import 'package:assist/Network/networkwidget.dart';
import 'package:assist/app_constants/app_colors.dart';
import 'package:assist/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../Controllers/theme_controller.dart';
import '../app_constants/app_strings.dart';
import '../utils/custom_widgets.dart';

class TermsAccordingToPlan extends StatelessWidget {
  final String url;
  const TermsAccordingToPlan(this.url, {super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return networkWidget(GetBuilder<ThemeController>(builder: (builder) {
      return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: global.themeType == 1
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black
                      : secondaryColor
                  : builder.isDarkMode.value
                      ? Colors.black
                      : secondaryColor,
              title: customText(
                  text: labelTremsConditions,
                  color:
                      builder.isDarkMode.value ? secondaryColor : whiteColor),
            ),
            body: SfPdfViewer.network(
              url,
              onDocumentLoaded: (details) {
                debugPrint(details.document.pages.count.toString());
              },
              onDocumentLoadFailed: (details) {
                debugPrint("Error");
                const CustomWidgets()
                    .snackBar(context, "Document loading failed");
              },
            )),
      );
    }), context);
  }
}
