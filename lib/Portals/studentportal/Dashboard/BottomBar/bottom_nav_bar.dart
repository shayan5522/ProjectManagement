import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:fyp_navigator/Portals/studentportal/Dashboard/BottomBar/Student_navbar_controller.dart';
import 'package:get/get.dart';
class StudentBottomBarPage extends StatelessWidget {
  final StudentBottomBarController _controller = Get.put(StudentBottomBarController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return _controller.pages[_controller.selectedIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        return ConvexAppBar(
          backgroundColor: Colors.teal.shade700,
          color: Colors.white,
          activeColor: Colors.white,
          style: TabStyle.reactCircle,
          items: const [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.request_page, title: 'Requests'),
            TabItem(icon: Icons.notifications, title: 'Notifications'),
            TabItem(icon: Icons.person, title: 'Profile'),
          ],
          initialActiveIndex: _controller.selectedIndex.value,
          onTap: _controller.onItemTapped,
          height: 60,
          curveSize: 0,
        );
      }),
    );
  }
}