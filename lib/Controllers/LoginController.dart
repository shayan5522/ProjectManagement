import 'package:fyp_navigator/Portals/AdminPortal/AdminMainScreen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_navigator/CustomWidgets/Snakbar.dart';
import '../Models/AuthenticationModel.dart';
import '../Models/LoginSharedPreferences.dart';
import '../Portals/SupervioserPortal/supervisor_dashboard.dart';
import '../Portals/studentportal/Dashboard/student_dashboard.dart';
class LoginController extends GetxController {
  var isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();

  Future<void> login() async {
    isLoading.value = false;
    if (emailController.text != '' && passwordController.text != '') {
      isLoading.value = true;
      try {
        User? user = await authService.signIn(emailController.text, passwordController.text);
        if (user != null) {
          isLoading.value = false;
          await authService.saveUserToPreferences(user.uid);
          String? uid = await authService.getUserFromPreferences();
          UserModel? userModel = await authService.getUserRole(uid!);
          if (userModel != null) {
            isLoading.value = false;
            if (userModel.role == 'admin') {
              Get.offAll(() => AdminDashboardPage(), transition: Transition.fadeIn, duration: const Duration(seconds: 2));
              showSuccessSnackbar('Login Successfully');
            } else if (userModel.role == 'Student') {
              Get.offAll(() => StudentDashboardPage(), transition: Transition.fadeIn, duration: const Duration(seconds: 2));
              showSuccessSnackbar('Login Successfully');
            } else if (userModel.role == 'supervisor') {
              authService.saveSuperVisorName(userModel.username);
              Get.offAll(() => SupervisorDashboardPage(), transition: Transition.fadeIn, duration: const Duration(seconds: 2));
              showSuccessSnackbar('Login Successfully');
            }
          } else {
            isLoading.value = false;
            showErrorSnackbar(userModel!.role.toString());
            print(userModel!.role.toString());
          }
        } else {
          isLoading.value = false;
          showErrorSnackbar('Wrong Credentials');
        }
      } catch (e) {
        isLoading.value = false;
        showErrorSnackbar('Wrong Credentials ${e.toString()}');
      }
    } else {
      isLoading.value = false;
      showErrorSnackbar('Please fill all the fields first');
    }
  }

}
