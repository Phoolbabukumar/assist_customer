import 'dart:convert';
import 'package:intl/intl.dart';

import '../utils/common_functions.dart';

class APIsConstant {
  ///  app version
  static String version = ''; // This line is update on every release manually
//----------------------------

  /// Test server url

  static String mainUrl = "https://247rsa.softservtest.com/";
  // static String mainUrl = 'https://assist.247roadservices.com.au/'; // This is prod api link.
  String apiKeyStartPoint = "2F1KC0X1KO7L629H97ED08TK176J4LHA";

  String basicAuth =
      "Basic NjBDRjNDVDRaWUlJck1VOTI4L2NiOTkwU2ljd29DcSszQWZGMGhXN3QxbjhQOWYwd0xqRmo0Y29JVVFOOXdBWVVrZFQ4ajpidmJCWDdHRQ==";

  String basicAuthForEncrypt =
      'Basic ${base64.encode(utf8.encode('epk-0CB9452F-9B73-40FC-82BD-7E5B3A6B901E:'))}';

  ///--------------------------------
  /// production server url
  /*static const String mainUrl = "https://assist.247roadservices.com.au/";
  String APIKeyStartPoint = "2F1KC0X1KO7L629H97ED08TK176J4LHA";*/

  String getEwayTransactionURl =
      "https://api.sandbox.ewaypayments.com/AccessCode/";
  String getEncryptData = "https://api.sandbox.ewaypayments.com/encrypt";

  // String apiURL = '${mainUrl}app/REST/ASSIST/';

  // String apiURL = 'https://247rsa.softservtest.com/app/REST/ASSIST/';
  //  String apiURL = 'https://assist.247roadservices.com.au/app/REST/ASSIST/';  // ise bhi use nahi karna hai

  String picURL = '${mainUrl}UpdateProfilePicture/pic/profile';

  String apiGetOfficeOpenOrClosed = "GetOfficeOpenOrClosed";

  //String APIKeyStartPoint ="LQ69S27TM138HO4C90JSV5M50S0U66WS";

  String googleApiKey = "AIzaSyD3M7-Pvk2UkUhJ8oSKGVO2ZvJvn0sqL7I";

  // Test URL - https://247rsa.softservtest.com/AwareIM/REST/ASSIST/

  // Live URL - https://assist.247roadservices.com.au/azpp/REST/ASSIST/

  String mapBaseURL =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  String getAPIKey() {
    var dateFormat =
        DateFormat("yyyMMddHHmmss"); // you can change the format here
    var utcDate = dateFormat.format(DateTime.now()); // pass the UTC time here
    printMessage("API constant ", utcDate);

    return "$apiKeyStartPoint$utcDate";
  }

  var carTermConditionURl = "${mainUrl}app/TermsandConditions/Car.pdf";
  var bikeTermConditionURl = "${mainUrl}app/TermsandConditions/Bike.pdf";
  var caravanTermConditionURl = "${mainUrl}app/TermsandConditions/Caravan.pdf";
  var motorhomeTermConditionURl =
      "${mainUrl}app/TermsandConditions/Motorhome.pdf";
  var mobilityScooterTermConditionURl =
      "${mainUrl}app/TermsandConditions/Mobility%20Scooter.pdf";

  var playStoreURl =
      "https://play.google.com/store/apps/details?id=au.com.roadservices.assist";
  var appStoreURl = "${mainUrl}app/mobileApp.html";

  String versionHistoryUrl = "${mainUrl}app/VersionHistory.html";

  String versionHistoryUrlIOS = "${mainUrl}app/VersionHistory_ios.html";

  // for test server
  static String grantType = "refresh_token";

  static String clientId = "ASSIST00556181";
  // static String clientId = "ASSIST29098754"; // for Prod

  static String clientSecret = "08119167294972074";
  // static String clientSecret = "9262646938992628";  // for Prod

  String auDomain = "ASSIST";

  String apiURL = '${mainUrl}CXF/services/serviceCall/awareim?';

  // https://247rsa.softservtest.com/CXF/services/serviceCall/awareim?Phone=0321123123
}
