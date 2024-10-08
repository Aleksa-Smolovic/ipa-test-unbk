import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unbroken/screens/home.dart';
import 'package:unbroken/screens/login.dart';
import 'package:unbroken/util/global_constants.dart';
import 'package:unbroken/util/widgets/form_field.dart';


// NOT USED
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _showError = false;
  String _errorMessage = "";

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => const HomePage()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logging in')),
      );
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
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 134,
                        width: 134,
                      ),
                    ),
                    const SizedBox(
                      height: 48.0,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create Account',
                          style: GoogleFonts.akshar(
                            color: Colors.white,
                            fontSize: 33.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    DefaultFormField(
                      controller: _fullNameController,
                      labelText: "Fullname",
                      icon: Icons.person_2_rounded,
                    ),
                    const SizedBox(height: 16.0),
                    DefaultFormField(
                      controller: _emailController,
                      labelText: "Email",
                      icon: Icons.email_outlined,
                    ),
                    if (_showError)
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
/*                    DefaultPasswordFormField(
                      controller: _passwordController,
                      labelText: "Password",
                      icon: Icons.password_rounded,
                    ),
                    const SizedBox(height: 16.0),
                    DefaultPasswordFormField(
                      controller: _confirmPasswordController,
                      labelText: "Confirm password",
                      icon: Icons.password_rounded,
                    ),*/
                    const SizedBox(
                      height: 44.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_fullNameController.text.isEmpty) {
                            _errorMessage = "Please enter your name";
                            _showError = true;
                          } else if (_emailController.text.isEmpty) {
                            _errorMessage = "Please enter your email";
                            _showError = true;
                          } else {
                            _register();
                            _showError = false;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(280, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        backgroundColor: GlobalConstants.appColor,
                      ),
                      child: Text('Sign up'.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF2D2D2D),
                          )),
                    ),
                    const SizedBox(height: 22.0),
                    RichText(
                      text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                                text: 'Sing in',
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF2B3FF2)),
                                recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                      context, CupertinoPageRoute(builder: (context) => const LoginScreen()));
                                }
                            )
                          ]),
                    )
                  ],
                ),
              )),
        ));
  }
}



