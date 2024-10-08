import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unbroken/util/global_constants.dart';

class DefaultPasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const DefaultPasswordFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.obscureText = true,
    this.validator,
  });

  @override
  State<DefaultPasswordFormField> createState() =>
      _LoginPasswordInputState();

}

class _LoginPasswordInputState extends State<DefaultPasswordFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: GoogleFonts.poppins(
          color: const Color(0xFF585858),
          fontWeight: FontWeight.w300,
        ),
        hintText: widget.labelText,
        hintStyle: GoogleFonts.poppins(
          color: const Color(0xFF585858),
          fontWeight: FontWeight.w300,
        ),
        prefixIcon: Icon(widget.icon),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF2D2D2D),
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: GlobalConstants.inputDefaultBorderColor,
            width: 1.0, // Color for unfocused state
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: GlobalConstants.inputDefaultBorderColor,
            width: 1.0, // Color for focused state
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: GlobalConstants.inputDefaultBorderColor,
            width: 1.0, // Color for error state
          ),
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        floatingLabelBehavior:
        FloatingLabelBehavior.always, // Keeps label visible
      ),
      style: GoogleFonts.poppins(color: Colors.white),
      obscureText: _obscureText,
      validator: widget.validator
    );
  }
}