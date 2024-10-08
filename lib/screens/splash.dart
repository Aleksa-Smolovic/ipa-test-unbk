import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:unbroken/api/api_error.dart';
import 'package:unbroken/main.dart';
import 'package:unbroken/screens/home.dart';
import 'package:unbroken/screens/login.dart';
import 'package:unbroken/services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final authService = getIt<AuthService>();

  @override
  void initState() {
    super.initState();

    // removing battery, time bar and bottom mobile navigation bar (back, home, stack)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _loadData();
  }

  @override
  void dispose() {
    // return removed bars
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  void _showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("There was an error, try again later."),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _navigate(Widget locationToNavigate) async {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context) => locationToNavigate));
    });
  }

  Future<void> _loadData() async {
    bool isAuthenticated = await authService.isAuthenticated();
    if (isAuthenticated) {
      try {
        await authService.getAccountAndSaveToStorage();
        _navigate(const HomePage());
      } catch (e) {
        ApiError a = e as ApiError;
        if (mounted) _showErrorMessage();
      }
    } else {
      _navigate(const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover),
              Container(
                color: Colors.black
                    .withOpacity(0.7), // Black color with 80% opacity
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 250,
                height: 250,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Lottie.network(
                'https://lottie.host/adb5e8de-7ada-4b3c-af9c-f95b2c440067/nM9BHwegjR.json',
                width: 125,
                height: 125),
          )
        ],
      ),
    );
  }
}
