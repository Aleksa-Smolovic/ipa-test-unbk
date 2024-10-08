import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unbroken/screens/login.dart';
import 'package:unbroken/screens/register.dart';
import 'package:unbroken/util/global_constants.dart';

// NOT USED
class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/intro_bg_new.jpg', fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 114,
                      width: 114,
                    ),
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                        style: GoogleFonts.akshar(
                            fontSize: 44,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        children: [
                          const TextSpan(text: "CHALLENGE YOUR\n"),
                          TextSpan(
                            text: 'LIMITS',
                            style: GoogleFonts.akshar(
                                fontSize: 44,
                                color: GlobalConstants.appColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ', ELEVATE\nYOUR '),
                          TextSpan(
                            text: 'STRENGTH',
                            style: GoogleFonts.akshar(
                                fontSize: 44,
                                color: GlobalConstants.appColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                  Text(
                    "Elevate Your Fitness Journey with Cutting Edge to Fuel your Motivation & Crush Your Goal",
                    style: GoogleFonts.poppins(
                        fontSize: 12.0, color: const Color(0xFFC7C7C7)),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  9), // Sets the corner radius
                            ),
                            backgroundColor: GlobalConstants.appColor,
                          ),
                          child: Text("Sign In".toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF2D2D2D),
                              )),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const Register()));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                              // Sets the corner radius
                            ),
                            backgroundColor: const Color(0xFF1f1f1f),
                          ),
                          child: Text("Sign Up".toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFFC7C7C7),
                              )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
