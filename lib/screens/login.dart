import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unbroken/api/api_error.dart';
import 'package:unbroken/main.dart';
import 'package:unbroken/screens/password_reset_email.dart';
import 'package:unbroken/services/auth_service.dart';
import 'package:unbroken/util/error_messages.dart';
import 'package:unbroken/util/global_constants.dart';
import 'package:unbroken/util/widgets/form_field.dart';
import 'package:unbroken/util/widgets/password_form_field.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _serverError;

  final authService = getIt<AuthService>();

  void _showErrorMessage(final String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _logIn() async {
    _serverError = null;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await authService.login(_emailController.text, _passwordController.text);
      if (mounted) {
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => const HomePage()));
      }
    } on ApiError catch (e) {
      setState(() {
        if (e.status == 401) {
          _serverError = ErrorMessages.getMessage(e.code);
        } else {
          _serverError = ErrorMessages.defaultMessage;
        }
      });
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 150,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign in',
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                DefaultFormField(
                  controller: _emailController,
                  labelText: 'Email',
                  icon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                DefaultPasswordFormField(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.password_rounded,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password!';
                    } else if (_serverError != null) {
                      return _serverError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 52.0),
                ElevatedButton(
                  onPressed: () {
                    _logIn();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(280, 50),
                    // Makes the button width fill its container and sets height
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(9), // Sets the corner radius
                    ),
                    backgroundColor: GlobalConstants.appColor,
                  ),
                  child: Text('Sign in'.toUpperCase(),
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w300)),
                ),
                const SizedBox(height: 22.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const PasswordResetEmail()));
                  },
                  child: Text('Forgot your password?',
                      style: GoogleFonts.poppins(
                          color: const Color(0xFF009945),
                          fontWeight: FontWeight.w500)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
