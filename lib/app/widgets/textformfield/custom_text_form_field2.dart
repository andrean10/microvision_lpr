import 'package:flutter/material.dart';

class CustomTextField2 extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool isAutoCorrect;
  final String? hintText;
  final String? labelText;
  final bool? isFilled;
  final bool isReadOnly;
  final bool isEnable;
  final bool isObscureText;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? suffixText;
  final bool? suffixIconState;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final String? errorText;

  const CustomTextField2({
    Key? key,
    this.controller,
    this.focusNode,
    this.isAutoCorrect = false,
    this.hintText,
    this.labelText,
    this.isFilled,
    this.isReadOnly = false,
    this.isEnable = true,
    this.isObscureText = false,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.words,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.suffixIconState,
    this.textInputAction = TextInputAction.next,
    this.maxLines,
    this.maxLength,
    this.onTap,
    this.onChanged,
    this.onEditingComplete,
    this.validator,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? builderSuffixIcon() {
      if (suffixIcon != null) {
        return suffixIcon;
      } else {
        if (suffixIconState != null) {
          if (suffixIconState!) {
            return IconButton(
              onPressed: () => controller?.clear(),
              icon: const Icon(
                Icons.cancel_outlined,
              ),
            );
          }
        }
      }
      return null;
    }

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autocorrect: isAutoCorrect,
      obscureText: isObscureText,
      textAlign: textAlign,
      textCapitalization: textCapitalization,
      maxLines: (keyboardType == TextInputType.multiline) ? null : maxLines,
      maxLength: (keyboardType == TextInputType.multiline) ? null : maxLength,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      readOnly: isReadOnly,
      enabled: isEnable,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: theme.textTheme.labelMedium,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: theme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: isFilled,
        contentPadding: const EdgeInsetsDirectional.all(24),
        errorMaxLines: 2,
        errorText: errorText,
        prefixIcon: (prefixIcon != null) ? Icon(prefixIcon) : null,
        suffixIcon: builderSuffixIcon(),
        suffixText: suffixText,
      ),
      style: theme.textTheme.bodyMedium,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onTap: onTap,
      onChanged: onChanged,
      validator: validator,
      onEditingComplete: onEditingComplete,
    );
  }
}
