import 'package:flutter/material.dart';
import 'package:dignito/constants.dart';

import 'package:dignito/custom_colors.dart';
import 'package:dignito/styles.dart';

Widget button(String buttonText, Function() onPressedCallback, Color col) {
  return GestureDetector(
    onTap: onPressedCallback,
    child: Container(
      margin: const EdgeInsets.symmetric(
          horizontal: Constants.buttonContainerMargin),
      padding: const EdgeInsets.all(Constants.buttonContainerPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
        color: col,
      ),
      child: Center(
        child: Text(buttonText, style: CustomStyles.buttonTextStyle),
      ),
    ),
  );
}
