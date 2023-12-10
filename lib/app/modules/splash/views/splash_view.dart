import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'logo_splash',
          child: AspectRatio(
            aspectRatio: 1 / 4,
            child: Image(
              image: AssetImage(controller.checkThemeLogo()),
            ).animate().fadeIn(duration: 500.ms),
          ),
        ),
      ),
    );
  }
}
