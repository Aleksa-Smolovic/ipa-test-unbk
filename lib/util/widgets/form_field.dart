import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unbroken/util/global_constants.dart';

class DefaultFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? icon;
  final String? value;
  final String? Function(String?)? validator;

  const DefaultFormField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.icon,
      this.value,
      this.validator
  });

  @override
  Widget build(BuildContext context) {
    if (controller.text.isEmpty && value != null) {
      controller.text = value!;
    }

    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            color: const Color(0xFF585858),
            fontWeight: FontWeight.w300,
          ),
          hintText: labelText,
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF585858),
            fontWeight: FontWeight.w300,
          ),
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
              borderRadius: GlobalConstants.inputBorderRadius,
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
            borderRadius: GlobalConstants.inputBorderRadius,
            borderSide: const BorderSide(
                color: GlobalConstants.inputDefaultBorderColor,
                width: 1.0), // Color for unfocused state
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: GlobalConstants.inputBorderRadius,
            borderSide: const BorderSide(
                color: Color(0xFF2D2D2D),
                width: 1.0), // Color for focused state
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: GlobalConstants.inputBorderRadius,
            borderSide: const BorderSide(
                color: Color(0xFFFF0000),
                width: 1.0), // Color for focused state
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        style: GoogleFonts.poppins(color: Colors.white),
        validator: validator);
  }
}
