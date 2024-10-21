import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp_navigator/Models/AuthenticationModel.dart';
import 'package:fyp_navigator/Models/AuthenticationModel.dart';
import 'package:fyp_navigator/screens/auth/splashscreen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = result.user;

    if (user != null) {
      await saveUserToPreferences(user.uid);
    }

    return user;
  }

  // Fetch user role
  Future<UserModel?> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('Users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
    } catch (e) {
      print('Error getting user role: $e');
    }
    return null;
  }


  // Save user ID to shared preferences
  Future<void> saveUserToPreferences(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
  }

  Future<String?> getUserFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  Future<void> signOut() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('userName');
    Get.offAll(SplashScreen());
  }

  Future<void> saveSuperVisorName(String? SuperVisorName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', SuperVisorName!);
  }
  Future<String?> getSuperVisorFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

}
