import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unbroken/api/api_endpoints.dart';
import 'package:unbroken/api/api_error.dart';
import 'package:unbroken/api/api_service.dart';
import 'package:unbroken/main.dart';
import 'package:unbroken/util/error_messages.dart';
import 'package:unbroken/util/global_constants.dart';
import 'package:unbroken/util/widgets/form_field.dart';

import 'login.dart';

class PasswordResetEmail extends StatefulWidget {
  const PasswordResetEmail({super.key});

  @override
  State<PasswordResetEmail> createState() => _PasswordReset();
}

class _PasswordReset extends State<PasswordResetEmail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String? _serverError;

  final apiService = getIt<ApiService>();

  void _showMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Password reset email sent, check your email!"),
          backgroundColor: Colors.blue),
    );
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> _resetPassword() async {
    _serverError = null;
    if (!_formKey.currentState!.validate()) return;
    try {
      await apiService.post(ApiEndpoints.resetPassword + _emailController.text);
      _showMessage();
    } on ApiError catch (e) {
      setState(() {
        _serverError = ErrorMessages.defaultMessage;
      });
      _formKey.currentState!.validate();
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Reset your password",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Enter your email address and we'll \n send you a new temporary one",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: const Color(0XFF585858),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  DefaultFormField(
                      controller: _emailController,
                      labelText: "Email",
                      icon: Icons.email_outlined,
                      validator: (value) {
                        if (_serverError != null) return _serverError;
                        return null;
                      }),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        onPressed: _emailController.text.isNotEmpty
                            ? () {
                                _resetPassword();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(280, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ).copyWith(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                            if (states.contains(WidgetState.disabled)) {
                              return const Color(
                                  0xFF121111); // Disabled background color
                            }
                            return GlobalConstants
                                .appColor; // Enabled background color
                          }),
                        ),
                        child: Text(
                          "Reset Password",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: _emailController.text.isEmpty
                                  ? const Color(0XFF585858)
                                  : Colors.black),
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
