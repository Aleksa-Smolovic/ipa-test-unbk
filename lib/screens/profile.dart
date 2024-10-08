import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unbroken/api/api_endpoints.dart';
import 'package:unbroken/main.dart';
import 'package:unbroken/models/user.dart';
import 'package:unbroken/screens/login.dart';
import 'package:unbroken/screens/modals/password_update.dart';
import 'package:unbroken/screens/modals/profile_info_update.dart';
import 'package:unbroken/services/auth_service.dart';
import 'package:unbroken/util/error_messages.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<User> _futureUserData;

  final authService = getIt<AuthService>();

  @override
  void initState() {
    super.initState();
    _futureUserData = _getData();
  }

  Future<User> _getData() async {
    return await authService.getAccount();
  }

  void _logOut(BuildContext context) {
    authService.logout();
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Profile',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              Image.asset('assets/images/logo.png', width: 150)
            ],
          ),
        ),
        body: FutureBuilder<User>(
            future: _futureUserData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                final user = snapshot.data!;
                return Container(
                  color: const Color(0xff141414),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 45,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(color: const Color(0xff141414)),
                              Image.network(
                                  ApiEndpoints.imagesUrl + user.image!,
                                  fit: BoxFit.fitWidth),
                              Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Color(0xff141414),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(22),
                                      ),
                                    ),
                                  ))
                            ],
                          )),
                      Expanded(
                        flex: 55,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(22, 5, 22, 22),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName,
                                  style: GoogleFonts.poppins(
                                      fontSize: 35,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  user.workoutType.value,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  'Member since: ${user.createdAt}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (context) =>
                                                      ProfileInfoUpdateModal(
                                                          user: user))
                                              .whenComplete(() {
                                            setState(() {
                                              _futureUserData = _getData();
                                            });
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                9), // Sets the corner radius
                                          ),
                                          backgroundColor:
                                              const Color(0xFF0A3037),
                                        ),
                                        child: Text(
                                            "Edit profile data".toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFFFFFFFF),
                                                fontSize: 14)),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) =>
                                                  const PasswordUpdateModal());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            // Sets the corner radius
                                          ),
                                          backgroundColor:
                                              const Color(0xFF0A3037),
                                        ),
                                        child: Text(
                                            "Change password".toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                color: const Color(0xFFFFFFFF),
                                                fontSize: 14)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                LogOutButton(onPressed: () {
                                  _logOut(context);
                                })
                              ],
                            )),
                      )
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                            child: Text(
                          ErrorMessages.defaultMessage,
                          style: GoogleFonts.poppins(
                              color: const Color(0xffDA0000), fontSize: 16),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 5, 22, 22),
                        // Optional padding at the bottom
                        child: LogOutButton(
                          onPressed: () {
                            _logOut(context);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}

class LogOutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogOutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffDA0000),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
              // Sets the corner radius
            )),
        child: Text(
          'LOG OUT',
          style: GoogleFonts.akshar(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
