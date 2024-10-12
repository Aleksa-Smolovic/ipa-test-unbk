import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:unbroken/screens/announcements.dart';
import 'package:unbroken/screens/calendar.dart';
import 'package:unbroken/screens/profile.dart';
import 'package:unbroken/util/global_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Announcements(),
    const Calendar(),
    const Profile()
  ];

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
              padding: EdgeInsets.fromLTRB(
                  15, Platform.isIOS ? 20 : 10, 15, Platform.isIOS ? 30 : 10),
              child: GNav(
                gap: 8,
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.black,
                tabBackgroundColor: GlobalConstants.appColor,
                rippleColor: Colors.grey.shade800,
                hoverColor: Colors.grey.shade700,
                padding: const EdgeInsets.all(16),
                tabs: const [
                  GButton(icon: Icons.notifications),
                  GButton(icon: Icons.calendar_month),
                  GButton(icon: Icons.person),
                ],
                onTabChange: (index) {
                  _navigateBottomBar(index);
                },
              ))),
    );
  }
}
