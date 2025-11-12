import 'dart:developer';
import 'dart:ui' as ui;
import 'package:assist/Controllers/global_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

var tag = "Common functions";

printMessage(tag, msg) {
  if (kDebugMode) {
    print("$tag : $msg");
  }
}

printLog(tag, msg) {
  log("$tag : $msg");
}

closeKeyBoard(context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

String hidePhone(mobile) {
  String newNumber = mobile;
  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  for (int i = 4; i < mobile.length; i++) {
    newNumber = replaceCharAt(newNumber, i, "X");
    if (i == 10) {
      break;
    }
  }

  return newNumber;
}

Future saveUserIdPhoneToPrefs(userId, phoneNo) async {
  final global = Get.put(GlobalController());
  global.setLoginData(userId, true, phoneNo);
}

Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
    String path, int width) async {
  final Uint8List imageData = await getBytesFromAsset(path, width);
  // ignore: deprecated_member_use
  return BitmapDescriptor.fromBytes(imageData);
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Future<void> makePhoneCall(phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

Future<String?> getAddressFromLatLng(lat, lng) async {
  try {
    List<Placemark> p = await placemarkFromCoordinates(lat, lng);
    Placemark placeMark = p[0];
    // ignore: unused_local_variable
    String? name = placeMark.name;
    // ignore: unused_local_variable
    String? subLocality = placeMark.subLocality;
    String? street = placeMark.street;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;

    log(placeMark.toString());
    debugPrint(
        "current address details==========$street, $locality, $administrativeArea $postalCode, $country ");
    //String address = "$name, $street, $subLocality, $locality, $administrativeArea $postalCode, $country";
    String address =
        "$street, $locality, $administrativeArea $postalCode, $country";

    printMessage(tag, address);
    return address;
  } catch (e) {
    printMessage(tag, "ERROR----> $e");
  }
  return null;
}

String capitalize(String status) {
  String sCapitalized = status;
  return "${sCapitalized[0].toUpperCase()}${sCapitalized.substring(1).toLowerCase()}";
}

List<String> exceptions = [
  'a',
  'abaft',
  'about',
  'above',
  'afore',
  'after',
  'along',
  'amid',
  'among',
  'an',
  'apud',
  'as',
  'aside',
  'at',
  'atop',
  'below',
  'but',
  'by',
  'circa',
  'down',
  'for',
  'from',
  'given',
  'in',
  'into',
  'lest',
  'like',
  'mid',
  'midst',
  'minus',
  'near',
  'and',
  'next',
  'of',
  'off',
  'on',
  'onto',
  'over',
  'pace',
  'past',
  'per',
  'plus',
  'pro',
  'qua',
  'round',
  'sans',
  'save',
  'since',
  'than',
  'thru',
  'till',
  'times',
  'to',
  'under',
  'until',
  'unto',
  'up',
  'upon',
  'via',
  'vice',
  'with',
  'worth',
  'the","and',
  'nor',
  'or',
  'yet',
  'so'
];

RegExp passwrdPattern =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,18}$');

extension StringExtension on String {
  String toSentenceCase() {
    // '${this[0].toUpperCase()}${substring(1).toLowerCase()}'

    return toLowerCase().replaceAllMapped(
        RegExp(
            r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
        (Match match) {
      if (exceptions.contains(match[0])) {
        return match[0].toString();
      }
      return "${match[0]![0].toUpperCase()}${match[0]!.substring(1).toLowerCase()}";
    }).replaceAll(RegExp(r'(_|-)+'), ' ');
  }
}
