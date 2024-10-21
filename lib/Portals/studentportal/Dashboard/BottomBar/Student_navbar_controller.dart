import 'package:flutter/material.dart';
import 'package:fyp_navigator/Portals/AdminPortal/adminProfile.dart';
import 'package:fyp_navigator/Portals/AdminPortal/admin_dashboard.dart';
import 'package:fyp_navigator/Portals/studentportal/Dashboard/student_dashboard.dart';
import 'package:fyp_navigator/Portals/studentportal/Notifications/student_notification.dart';
import 'package:fyp_navigator/Portals/studentportal/Profile/student_profile.dart';
import 'package:get/get.dart';
import '../../Requests/project_req.dart';

class StudentBottomBarController extends GetxController {
  var selectedIndex = 0.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    StudentDashboardPage(),
    ProjectRequest(),
    NotificationScreen(),
    AdminProfilePage(),
  ];
}