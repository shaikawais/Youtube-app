import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/controllers/network_controller.dart';
import 'package:frontend/controllers/video_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkController());
    Get.put(AuthController());
    Get.lazyPut(
      () => VideoController(),
    );
  }
}
