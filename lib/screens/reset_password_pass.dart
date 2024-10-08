import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unbroken/screens/password_reset_email.dart';
import 'package:unbroken/util/global_constants.dart';
import 'package:unbroken/util/widgets/form_field.dart';
import 'package:unbroken/util/widgets/password_form_field.dart';

import 'login.dart';

// NOT USED
class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordReset();
}

class _PasswordReset extends State<PasswordReset> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordResetController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  bool _showError = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _passwordResetController.addListener(() {
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
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
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
                      "Set your password",
                      style: GoogleFonts.akshar(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Enter a new password for your account.\nMake sure it's strong and easy to remember.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0XFF585858),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  DefaultPasswordFormField(
                      controller: _passwordResetController,
                      labelText: "New Password",
                      icon: Icons.password_rounded
                  ),
                  const SizedBox(height: 32),
                  DefaultPasswordFormField(
                      controller: _passwordConfirmController,
                      labelText: "Confirm Password",
                      icon: Icons.password_rounded
                  ),
                  if(_showError)
                    Container(
                        alignment: Alignment.centerLeft,
                        child:  Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                _errorMessage,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    color: Color(0xffDA0000),
                                    fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        onPressed: (_passwordResetController.text.isNotEmpty && _passwordConfirmController.text.isNotEmpty)
                            ? () {
                          setState(() {
                            if (_passwordResetController.text.isEmpty) {
                              _errorMessage = "Please enter your password";
                              _showError = true;
                            } else if (_passwordResetController.text != _passwordConfirmController.text &&
                                _passwordConfirmController.text.isNotEmpty) {
                              _errorMessage = "Passwords don't match";
                              _showError = true;
                            } else if (_passwordConfirmController.text.isEmpty) {
                              _errorMessage = "Please confirm password";
                            } else {
                              _showError = false;
                            }
                          });
                        } : null,

                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(280, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ).copyWith(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return const Color(0xFF121111); // Disabled background color
                            }
                            return GlobalConstants.appColor; // Enabled background color
                          }),
                        ),
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _passwordResetController.text.isEmpty ?  const Color(0XFF585858) : Colors.black
                          ),
                        )
                    ),
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