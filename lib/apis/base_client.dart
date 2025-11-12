import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:assist/apis/apis_constant.dart';
import 'package:assist/app_constants/app_colors.dart';
import 'package:assist/ui/app_maintenance.dart';
import 'package:assist/utils/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/common_functions.dart';

class BaseClient {
  // GET Method
  static Future<dynamic> get(String? api, String? service) async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        const CustomWidgets().widgetLoadingData();
      });
      // Check for system maintenance.
      var maintenanceData = await appMaintanenceApi();
      if (maintenanceData != null && maintenanceData["StatusCode"] == "503") {
        Get.offAll(() => AppMaintanenceScreen(
              msg: maintenanceData["StatusMessage"],
            ));
        return;
      }

      // Handle token logic
      if (global.currentToken.isEmpty) {
        await global.getToken();
      }

      String? token = "";
      DateTime now = DateTime.now();
      String accessToken = global.currentToken;
      String accessTokenIssuedAt = global.accesstime;

      Duration accessTokenDiff = now
          .difference(DateTime.tryParse(accessTokenIssuedAt) ?? DateTime.now());

      if (accessTokenDiff.inMinutes < 50) {
        token = accessToken;
      } else {
        token = await global.getRefreshToken();
      }

      var uri = Uri.parse(APIsConstant().apiURL + api!);
      var header = {
        "Authorization": "Bearer $token",
        "AW_DOMAIN": APIsConstant().auDomain,
        "AW_SERVICE": service ?? "",
      };

      printMessage("BaseClient", "uri :$uri");
      printMessage("Token", "token :$token");
      printMessage("Service", "service :$service");

      // Perform the API call
      var response = await http.get(uri, headers: header);
      printMessage("BaseClient", "Request :${response.request}");
      printMessage("BaseClient", "Headers :${response.headers}");
      log("Response : ${response.body}");
      printMessage("Internet connection:", "${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          Get.back();
          return response.body;
        } else {
          Get.snackbar('Something went Wrong', 'Please refresh!!',
              backgroundColor: gray400);
          return null;
        }
      } else if (response.statusCode == 401) {
        // Refresh token and retry
        await global.getRefreshToken();
        return await get(api, service);
      } else {
        Get.back();
        return null;
      }
    } catch (e, stacktrace) {
      Get.back();
      printMessage("BaseClient : ", "Error $e");
      printMessage("BaseClient : ", "Stack Trace : $stacktrace");
      return null;
    }
  }

  // Get with basic Auth
  static Future<dynamic> getTransactionDetail(String accessCode) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const CustomWidgets().widgetLoadingData();
    });
    var maintenanceData = await appMaintanenceApi();
    if (maintenanceData != null && maintenanceData["StatusCode"] == "503") {
      Get.offAll(() => AppMaintanenceScreen(
            msg: maintenanceData["StatusMessage"],
          ));
      return;
    }

    String? token = "";
    DateTime now = DateTime.now();
    String accessToken = global.currentToken;
    String accessTokenIssuedAt = global.accesstime;

    Duration accessTokenDiff = now
        .difference(DateTime.tryParse(accessTokenIssuedAt) ?? DateTime.now());

    if (accessTokenDiff.inMinutes < 50) {
      token = accessToken;
    } else if (accessTokenDiff.inMinutes >= 50) {
      token = await global.getRefreshToken();
    }
    var uri = Uri.parse(APIsConstant().getEwayTransactionURl + accessCode);

    printMessage("BaseClient", "uri :$uri");
    try {
      var response =
          await http.get(uri, headers: {"Authorization": "Bearer $token"});
      printMessage("BaseClient", "Request :${response.request}");
      printMessage("BaseClient", "Response : ${response.body}");
      printMessage("Internet connection:", "${response.statusCode}");

      if (response.statusCode == 200) {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => Get.back(),
        );
        return response.body;
      } else if (response.statusCode == 401) {
        await global.getRefreshToken();
        return await getTransactionDetail(accessCode);
      } else {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => Get.back(),
        );
        return null;
      }
    } catch (e, stacktrace) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => Get.back(),
      );
      printMessage("BaseClient : ", "Error $e");
      printMessage("BaseClient : ", "Stack Trace : $stacktrace");
      return null;
    }
  }

  static Future<dynamic> getEncryptData(String cardNumber, String cvv) async {
    var uri = Uri.parse(APIsConstant().getEncryptData);

    var value = {
      "Method": "eCrypt",
      "Items": [
        {"Name": "card", "Value": cardNumber},
        {"Name": "CVN", "Value": cvv}
      ]
    };
    var buffer = json.encode(value);
    printMessage("BaseClient", "uri :$uri");
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        const CustomWidgets().widgetLoadingData();
      });
      var response = await http.post(uri,
          headers: {"Authorization": APIsConstant().basicAuthForEncrypt},
          body: buffer);
      printMessage("BaseClient", "Request :${response.request}");
      printMessage("BaseClient", "Response : ${response.body}");
      printMessage("Internet connection:", "${response.statusCode}");

      if (response.statusCode == 200) {
        log(response.body);
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => Get.back(),
        );
        return response.body;
      } else {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => Get.back(),
        );
        return null;
      }
    } catch (e, stacktrace) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => Get.back(),
      );
      printMessage("BaseClient : ", "Error $e");
      printMessage("BaseClient : ", "Stack Trace : $stacktrace");
      return null;
    }
  }

  static Future<Map<String, dynamic>> encryptData(
      String cardNumber, String cvv) async {
    const url = 'https://api.sandbox.ewaypayments.com/encrypt';
    const username =
        'epk-0CB9452F-9B73-40FC-82BD-7E5B3A6B901E'; // Replace with your username
    const password = ''; // Replace with your password

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    };

    final data = {
      "Method": "eCrypt",
      "Items": [
        {"Name": "card", "Value": cardNumber},
        {"Name": "CVN", "Value": "123"}
      ]
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      debugPrint("$responseData");
      return responseData;
    } else {
      throw Exception('Failed to make API call');
    }
  }

  static Future<dynamic> postNew(String api, String? service) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const CustomWidgets().widgetLoadingData();
    });
    var maintenanceData = await appMaintanenceApi();
    if (maintenanceData != null && maintenanceData["StatusCode"] == "503") {
      Get.offAll(() => AppMaintanenceScreen(
            msg: maintenanceData["StatusMessage"],
          ));
      return;
    }
    String? token = "";
    DateTime now = DateTime.now();
    String accessToken = global.currentToken;
    String accessTokenIssuedAt = global.accesstime;

    Duration accessTokenDiff = now
        .difference(DateTime.tryParse(accessTokenIssuedAt) ?? DateTime.now());

    if (accessTokenDiff.inMinutes < 50) {
      token = accessToken;
    } else if (accessTokenDiff.inMinutes >= 50) {
      token = await global.getRefreshToken();
    }
    var uri = Uri.parse(APIsConstant().apiURL + api);
    printMessage("BaseClient", "uri :$uri");

    try {
      var response = await http.post(uri, headers: {
        "Authorization": "Bearer $token",
        "AW_DOMAIN": APIsConstant().auDomain,
        "AW_SERVICE": service ?? "",
      });

      printMessage("BaseClient : ", "Request :${response.request}");
      printMessage("BaseClient : ", "Response : ${response.body}");

      if (response.statusCode == 200) {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => Get.back(),
        );
        if (response.body.isNotEmpty) {
          return response.body;
        } else {
          Get.snackbar('Something went Wrong', 'Please refresh!!',
              backgroundColor: gray400);
          return null;
        }
      } else if (response.statusCode == 401) {
        await global.getRefreshToken();
        await postNew(api, service);
      } else {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => Get.back(),
        );
        return null;
      }
    } catch (e, stacktrace) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => Get.back(),
      );
      printMessage("BaseClient : ", "Error $e");
      printMessage("BaseClient : ", "Stack Trace : $stacktrace");
      return null;
    }
  }

  static Future<dynamic> appMaintanenceApi() async {
    try {
      final response = await http
          .get(Uri.parse("${APIsConstant.mainUrl}SystemMaintenance.json"))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var response1 = json.decode(response.body);
          log(response.body);
          return response1;
        }
      }
    } catch (e, stacktrace) {
      if (e is TimeoutException) {
        printMessage("BaseClient : ", "Request Timeout: ${e.message}");
        return {
          "StatusCode": "503",
          "StatusMessage":
              "Scheduled maintenance is in progress. Service is temporarily unavailable. Thank you for your patience."
        };
      } else if (e is SocketException) {
        Get.snackbar('Internet not available',
            'Please connect your device with proper internet connection.',
            backgroundColor: gray400);
      } else {
        printMessage("BaseClient : ", "Error $e");
        printMessage("BaseClient : ", "Stack Trace : $stacktrace");
        return null;
      }
    }
  }
}
