import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:fyp_navigator/Controllers/BottomBarController.dart';
import 'package:fyp_navigator/CustomWidgets/TextWidget.dart';
import 'package:fyp_navigator/Models/LoginSharedPreferences.dart';
import 'package:get/get.dart';
class AdminDashboardPage extends StatelessWidget {
  final AdminBottomBarController _controller = Get.put(AdminBottomBarController());
  final AuthService _authService = AuthService();

  AdminDashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const TextWidget(title: 'Admin Portal',color: Colors.white,),
        backgroundColor: Colors.teal.shade700,
      ),
      body: Obx(() {
        return _controller.pages[_controller.selectedIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        return ConvexAppBar(
          backgroundColor: Colors.teal.shade700,
          color: Colors.white,
          activeColor: Colors.white,
          style: TabStyle.reactCircle,
          items: [
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