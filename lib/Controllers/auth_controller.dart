import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class AuthController extends GetxController {
  final LocalAuthentication localAuthentication = LocalAuthentication();
  bool fingerPrintSupport = false;
  // ignore: unused_field
  List<BiometricType> _availableBiometricType = [];
  // ignore: unused_field
  final _canCheckBiometric = false;

  @override
  void onInit() {
    super.onInit();
    getBiometricsSupport();
    getAvailableSupport();
  }

  Future<void> getBiometricsSupport() async {
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await localAuthentication.canCheckBiometrics;
      debugPrint("<<<<<<<<<< Fingerprint");
      debugPrint("$hasFingerPrintSupport");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    fingerPrintSupport = hasFingerPrintSupport;
    update();
  }

/* Find device privacy things */
  Future<void> getAvailableSupport() async {
    List<BiometricType> availableBiometricType = [];
    try {
      availableBiometricType =
          await localAuthentication.getAvailableBiometrics();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    _availableBiometricType = availableBiometricType;
    update();
  }

/* this function return status of user authentication */
  Future<bool> authenticateMe() async {
    bool authenticated = false;
    try {
      authenticated = await localAuthentication.authenticate(
        localizedReason: "Scan your finger to authenticate",
      );
      return authenticated;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("error==============");
        print(e);
      }
      return false;
    }
  }
}
