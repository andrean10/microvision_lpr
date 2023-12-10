import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:microvision_lpr/app/data/shared_preferences/user_session.dart';
import 'package:quickalert/quickalert.dart';

import '../../../helpers/encrypt.dart';
import '../../../routes/app_pages.dart';
import '../../init/init_controller.dart';

class LoginController extends GetxController {
  late final InitController _initC;
  final formKey = GlobalKey<FormState>();
  final userIdC = TextEditingController();
  final passwordC = TextEditingController();
  final userIdF = FocusNode();
  final passwordF = FocusNode();

  final userId = ''.obs;
  final password = ''.obs;

  final errorTextUserId = ''.obs;
  final errorTextPassword = ''.obs;

  final isShowPassword = false.obs;
  final isLoading = false.obs;

  final globalAnim = <Effect>[
    FadeEffect(duration: GetNumUtils(3).seconds, curve: Curves.easeInBack),
    // ScaleEffect(begin: Offset.fromDirection(0.8), curve: Curves.easeIn),
  ];

  final logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() {
    if (Get.isRegistered<InitController>()) {
      _initC = Get.find<InitController>();
    }

    userIdC.addListener(setUserId);
  }

  String? validateForm({
    required String title,
    required String? value,
    bool isPassword = false,
  }) {
    if (value != null && value != '') {
      if (isPassword) {
        if (value.length < 6) {
          return 'Password minimal 6 karakter!';
        }
      }
    } else {
      return '$title tidak boleh kosong!';
    }

    return null;
  }

  void setUserId() => userId.value = userIdC.text;

  void setPassword() => password.value = passwordC.text;

  void togglePassword() => isShowPassword.toggle();

  void checkLogin() {
    passwordF.unfocus();
    isLoading.value = true;
    final isValid = formKey.currentState!.validate();

    if (!isValid) {
      isLoading.value = false;
      return;
    }
    formKey.currentState!.save();
    checkIsUserExist();
  }

  void checkIsUserExist() async {
    final userId = userIdC.value.text.toString().trim();
    final password = passwordC.value.text.toString().trim();
    final encryptedPassword = Encrypt.encryptPassword(password);

    try {
      final colRef = _initC.firestore.collection('users');

      final checkUserId =
          await colRef.where('user_id', isEqualTo: userId).get();

      if (checkUserId.docs.isNotEmpty) {
        final checkPassword =
            await colRef.where('password', isEqualTo: encryptedPassword).get();

        if (checkPassword.docs.isNotEmpty) {
          QuickAlert.show(
            context: Get.context!,
            title: 'Login',
            text: 'Berhasil login!',
            type: QuickAlertType.success,
            showConfirmBtn: false,
            autoCloseDuration: GetNumUtils(2).seconds,
          ).whenComplete(() {
            moveToMain(
                id: checkPassword.docs.first.id,
                data: checkPassword.docs.first.data());
          });
        } else {
          errorTextPassword.value = 'Password salah!';
        }
      } else {
        errorTextUserId.value = 'ID User tidak ditemukan!';
      }

      isLoading.value = false;
    } on FirebaseException catch (e) {
      logger.e('Error: ${e.message}');
    }
  }

  void moveToMain({
    required String id,
    required Map<String, dynamic> data,
  }) {
    _initC.setSession(
      UserSession(
        id: id,
        userID: data['user_id'],
        password: data['password'],
      ),
    );
    Get.offAllNamed(Routes.MAIN);
  }

  String checkThemeLogo() {
    return Get.isDarkMode
        ? 'assets/ic/ic_logo_dark.png'
        : 'assets/ic/ic_logo.png';
  }
}
