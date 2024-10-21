import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_navigator/CustomWidgets/Snakbar.dart';
class ForgotPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  Future<void> resetPassword(String email) async {
    isLoading.value = true;
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      showSuccessSnackbar('Passsword Reset Sucessfully');
    } catch (e) {
      showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
