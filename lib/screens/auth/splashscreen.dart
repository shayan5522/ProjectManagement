import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp_navigator/Controllers/BottomBarController.dart';
import 'package:fyp_navigator/Portals/AdminPortal/AdminMainScreen.dart';
import 'package:fyp_navigator/Portals/studentportal/Dashboard/student_dashboard.dart';
import 'package:get/get.dart';
import 'package:fyp_navigator/screens/auth/login.dart';
import 'package:fyp_navigator/Models/AuthenticationModel.dart';
import 'package:fyp_navigator/Models/LoginSharedPreferences.dart';
import '../../Portals/studentportal/Dashboard/BottomBar/bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? uid = await _authService.getUserFromPreferences();
    Timer(Duration(seconds: 3), () {
      if (uid != null) {
        // Redirect based on login status (use appropriate dashboard)
        Get.off(() => LoginPage(), transition: Transition.fadeIn, duration: Duration(seconds: 2));
        //Get.off(() => StudentBottomBarPage(), transition: Transition.fadeIn, duration: Duration(seconds: 2));
       //Get.off(() => AdminBottomBarController(), transition: Transition.fadeIn, duration: Duration(seconds: 2));
      } else {
        Get.off(() => LoginPage(), transition: Transition.fadeIn, duration: Duration(seconds: 2));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.tealAccent.shade700, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(seconds: 2),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.explore_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "FYP Navigator",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Navigate Your Final Year Projects",
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
