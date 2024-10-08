import 'package:flutter/material.dart';
import 'package:unbroken/util/global_constants.dart';

class Themes {
  final InputDecorationTheme defaultInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xff346ff6),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade800),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: GlobalConstants.appColor),
    ),
    labelStyle: const TextStyle(color: GlobalConstants.appColor),
  );
}
