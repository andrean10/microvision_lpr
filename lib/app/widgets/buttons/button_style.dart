import 'package:flutter/material.dart';

ButtonStyle buttonStyle({
  required Orientation orientation,
  required Size size,
}) {
  return ButtonStyle(
    minimumSize: MaterialStateProperty.all(
      Size(
        double.infinity,
        (orientation == Orientation.portrait)
            ? size.height * 0.06
            : size.height * 0.14,
      ),
    ),
  );
}
