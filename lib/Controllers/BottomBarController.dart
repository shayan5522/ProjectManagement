import 'package:flutter/material.dart';
import 'package:fyp_navigator/Portals/AdminPortal/admin_dashboard.dart';
import 'package:get/get.dart';

import '../Portals/AdminPortal/adminProfile.dart';

class AdminBottomBarController extends GetxController {
  var selectedIndex = 0.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    AdminHomePage(),
    AdminHomePage(),
    AdminHomePage(),
    AdminProfilePage(),
  ];
}