import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../routes/app_pages.dart';
import '../../init/init_controller.dart';

class SplashController extends GetxController {
  late final InitController _initC;

  final logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(4000.ms, () => _checkSession());
  }

  void _init() {
    if (Get.isRegistered<InitController>()) {
      _initC = Get.find<InitController>();
    }
  }

  Future<void> _checkSession() async {
    final session = await _initC.getSession();

    if (session != null) {
      Get.offAllNamed(Routes.MAIN);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  String checkThemeLogo() {
    return Get.isDarkMode
        ? 'assets/ic/ic_logo_dark.png'
        : 'assets/ic/ic_logo.png';
  }
}
