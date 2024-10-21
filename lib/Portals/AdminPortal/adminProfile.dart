import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_navigator/Models/LoginSharedPreferences.dart';
import '../../CustomWidgets/ConfirmDialogBox.dart';
import '../../CustomWidgets/ElevatedButton.dart';
import '../../CustomWidgets/TextWidget.dart';
import '../../Models/LoginSharedPreferences.dart';

class AdminProfilePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  void logout(BuildContext context) async {
    await Get.dialog(
      ConfirmDialog(
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        confirmText: 'Confirm',
        cancelText: 'Cancel',
        onConfirm: () {
          _authService.signOut();
        },
        onCancel: () {
          Get.back();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              title: 'FYP Navigator',
              size: 28,
              weight: FontWeight.bold,
              color: Colors.teal.shade700,
            ),
            SizedBox(height: 10),
            TextWidget(
              title: 'http://www.upr.edu.pk',
              size: 18,
              color: Colors.grey[700],
            ),
            SizedBox(height: 30),
            Divider(height: 20, thickness: 2),
            TextWidget(
              title: 'App Information',
              size: 22,
              weight: FontWeight.bold,
              color: Colors.teal.shade700,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.store, color:Colors.teal.shade700),
                SizedBox(width: 10),
                Expanded(
                  child: TextWidget(
                      title: 'FYP Navigator is a platform that helps students and faculty manage and navigate Final Year Projects with essential resources and collaboration tools. ',
                      size: 16, color: Colors.grey[800]),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.teal.shade700),
                SizedBox(width: 10),
                Expanded(
                  child: TextWidget(
                      title: "Whether it's for project resources, mentorship, or collaboration, FYP Navigator offers a seamless way for students and faculty to connect and succeed in their Final Year Projects",
                      size: 16, color: Colors.grey[800]
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(height: 20, thickness: 2),
            Spacer(),
            Elevated_button(
              text: 'Logout',
              color: Colors.white,
              path: () {
                logout(context);
              },
              padding: 12,
              radius: 10,
              width: Get.width,
              height: 50,
              backcolor: Colors.red,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
