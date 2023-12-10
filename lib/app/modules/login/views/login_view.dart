import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:microvision_lpr/app/shared/shared_theme.dart';

import '../../../widgets/buttons/custom_filled_button.dart';
import '../../../widgets/textformfield/custom_text_form_field2.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    Widget builderHeadLogo() {
      var colors = [
        theme.colorScheme.primary,
        theme.colorScheme.secondary,
        theme.colorScheme.tertiary,
      ];

      if (Get.isDarkMode) {
        colors = [
          theme.colorScheme.primaryContainer,
          theme.colorScheme.secondaryContainer,
          theme.colorScheme.tertiaryContainer,
        ];
      }

      return Container(
        width: double.infinity,
        height: size.height * 0.4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            stops: const [0, 0.5, 1],
            begin: const AlignmentDirectional(-1, -1),
            end: const AlignmentDirectional(1, 1),
          ),
        ),
        child: Container(
          // width: 100,
          // height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0x00FFFFFF),
                theme.colorScheme.surface,
              ],
              stops: const [0, 1],
              begin: const AlignmentDirectional(0, -1),
              end: const AlignmentDirectional(0, 1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo_splash',
                child: Container(
                  width: size.width * 0.5,
                  padding: const EdgeInsets.all(8),
                  child: Image(
                    image: AssetImage(controller.checkThemeLogo()),
                  ),
                ),
              ),
              ...[
                const Gap(32),
                Text(
                  'Selamat Datang',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: SharedTheme.bold,
                  ),
                ),
                const Gap(2),
                Text(
                  'Gunakan akun di bawah ini untuk masuk',
                  style: theme.textTheme.labelLarge,
                ),
              ].animate(effects: controller.globalAnim),
            ],
          ),
        ),
      );
    }

    Widget builderUserIdInput() {
      return Obx(
        () => CustomTextField2(
          labelText: 'ID User',
          controller: controller.userIdC,
          focusNode: controller.userIdF,
          suffixIconState: controller.userId.value.isNotEmpty,
          maxLines: 1,
          onEditingComplete: () => controller.passwordF.requestFocus(),
          validator: (value) => controller.validateForm(
            title: 'ID User',
            value: value,
          ),
          errorText: (controller.errorTextUserId.value.isNotEmpty)
              ? controller.errorTextUserId.value
              : null,
        ),
      );
    }

    Widget builderPasswordInput() {
      return Obx(
        () => CustomTextField2(
          labelText: 'Password',
          controller: controller.passwordC,
          focusNode: controller.passwordF,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          isObscureText: !controller.isShowPassword.value,
          maxLines: 1,
          suffixIcon: InkWell(
            onTap: controller.togglePassword,
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              controller.isShowPassword.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
          ),
          onEditingComplete: controller.checkLogin,
          validator: (value) => controller.validateForm(
            title: 'Password',
            value: value,
            isPassword: true,
          ),
          errorText: (controller.errorTextPassword.value.isNotEmpty)
              ? controller.errorTextPassword.value
              : null,
        ),
      );
    }

    Widget builderLoginButton() {
      return Obx(
        () => CustomFilledButton(
          width: size.width * 0.5,
          isFilledTonal: false,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              theme.colorScheme.primary,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          onPressed: controller.checkLogin,
          state: controller.isLoading.value,
          child: Text(
            'Login',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ).animate(effects: controller.globalAnim);
    }

    Widget builderAuth() {
      return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              builderUserIdInput(),
              const Gap(12),
              builderPasswordInput(),
            ],
          ),
        ),
      ).animate(effects: controller.globalAnim);
    }

    Widget builderBody() {
      return SingleChildScrollView(
        child: Column(
          children: [
            builderHeadLogo(),
            builderAuth(),
            builderLoginButton(),
          ],
        ),
      );
    }

    return Scaffold(
      body: builderBody(),
    );
  }
}
