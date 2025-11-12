import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/common_functions.dart';

class NetworkManager extends GetxController {
  var tag = "NetworkManager";
  var connectionType = 1;

  //Instance of Flutter Connectivity
  final Connectivity _connectivity = Connectivity();

  //Stream to keep listening to network change state
  StreamSubscription? _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    getConnectionType();
    _streamSubscription = _connectivity.onConnectivityChanged.listen(
      (event) => _updateState,
    );
  }

  // a method to get which connection result, if you we connected to internet or no if yes then which network
  Future<void> getConnectionType() async {
    ConnectivityResult? connectivityResult;
    try {
      var connectivityResultList = await _connectivity.checkConnectivity();
      if (connectivityResultList.isNotEmpty) {
        connectivityResult = connectivityResultList[0];
      }
    } on PlatformException catch (e) {
      printMessage(tag, e);
    }
    _updateState(connectivityResult);
  }

  // state update, of network, if you are connected to WIFI connectionType will get set to 1,
  // and update the state to the consumer of that variable.
  _updateState(ConnectivityResult? result) {
    printMessage(tag, 'text$result');
    switch (result) {
      case ConnectivityResult.wifi:
        connectionType = 1;
        refresh();
        break;
      case ConnectivityResult.mobile:
        connectionType = 2;
        refresh();
        printMessage(tag, 'connectionType $connectionType');
        break;
      case ConnectivityResult.none:
        connectionType = 0;
        refresh();
        printMessage(tag, 'connectionType $connectionType');
        break;
      default:
        Get.snackbar('Network Error', 'Failed to get Network Status');
        break;
    }
  }

  @override
  void onClose() {
    //stop listening to network state when app is closed
    _streamSubscription!.cancel();
  }
}
