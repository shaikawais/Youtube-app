import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_networkChange);
  }

  void _networkChange(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      Get.rawSnackbar(
        messageText: const Text(
          'Please check your internet connection',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        mainButton: IconButton(
          onPressed: () {
            Get.closeCurrentSnackbar();
          },
          icon: const Icon(Icons.close),
        ),
        isDismissible: true,
        duration: const Duration(days: 1),
        backgroundColor: Colors.red[400]!,
        icon: const Icon(
          Icons.wifi_off,
          color: Colors.white,
          size: 35,
        ),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED,
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
