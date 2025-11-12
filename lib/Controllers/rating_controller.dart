import 'dart:convert';
import 'package:assist/apis/base_client.dart';
import 'package:get/get.dart';
import '../utils/common_functions.dart';

class RatingController extends GetxController {
  var tag = "RatingController";
  Future<dynamic> sendRating(int rating, String jobNo) async {
    try {
      return BaseClient.get(
              "Rating=$rating&ClaimID=$jobNo", "RateServiceProvider")
          .then((value) {
        dynamic data = json.decode(value);
        if (value != null && data['StatusCode'] == 200) {
          return data;
        } else {
          return null;
        }
      });
    } catch (e, stacktrace) {
      printMessage(tag, e);
      printMessage(tag, stacktrace);
      return null;
    }
  }
}
