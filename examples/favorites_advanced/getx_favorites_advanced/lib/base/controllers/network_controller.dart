import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final connectivityStatus = 0.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void onInit() {
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((event) => _updateConnectivity(event));
    super.onInit();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
      _updateConnectivity(result);
    } on PlatformException catch (e) {
      print(e.toString());
      connectivityStatus(0);
    }
  }

  void _updateConnectivity(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      connectivityStatus(1);
    } else {
      connectivityStatus(0);
    }
  }
}
