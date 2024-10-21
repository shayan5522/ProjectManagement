import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_navigator/screens/auth/ForgetPassword.dart';
import 'package:fyp_navigator/Controllers/LoginController.dart';
import 'package:fyp_navigator/Controllers/PasswordControllers.dart';
import 'package:fyp_navigator/CustomWidgets/ElevatedButton.dart';
import 'package:fyp_navigator/CustomWidgets/IconButton.dart';
import 'package:fyp_navigator/CustomWidgets/TextWidget.dart';
import 'package:fyp_navigator/screens/auth/signupscreen.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());
  final Password_controller _visibilityController = Get.put(Password_controller());

  // Method to show signup type dialog
  void SignUpPageSelector() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Choose Signup Type',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.tealAccent.shade700,
          ),
        ),
        content: Text(
          'Please select the type of account you want to create:',
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent.shade700, // Button color
              foregroundColor: Colors.white, // Text color
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Get.to(() => StudentSignUpPage());
            },
            child: Text('Student Signup'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Add the WavyHeader at the top of the screen
            WavyHeader(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Log In Header Text
                  Text(
                    'Log In Now',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent.shade700,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Subheader Text
                  TextWidget(
                    title: 'Please login to continue using our app',
                    size: 16,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 30),

                  // Email Input Field
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: loginController.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Password Input Field with Visibility Toggle
                  Obx(() {
                    return TextFormField(
                      keyboardType: TextInputType.text,
                      controller: loginController.passwordController,
                      obscureText: _visibilityController.show.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Icon_Button(
                          onPressed: () {
                            _visibilityController.show_password();
                          },
                          icon: _visibilityController.show.value
                              ? Icon(Icons.remove_red_eye_outlined)
                              : Icon(Icons.remove_red_eye),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 10),

                  // Forgot Password Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(ForgotPasswordPage());
                      },
                      child: TextWidget(
                        title: 'Forgot Password?',
                        color: Colors.tealAccent.shade700,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() {
                      return loginController.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : Elevated_button(
                        path: loginController.login,
                        color: Colors.white,
                        backcolor: Colors.tealAccent.shade700,
                        text: 'Login',
                        radius: 10,
                        padding: 10,
                      );
                    }),
                  ),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(title: "Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          SignUpPageSelector();
                        },
                        child: TextWidget(
                          title: 'Sign Up',
                          color: Colors.tealAccent.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  TextWidget(title: 'Or connect with'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.facebook),
                        color: Colors.blue,
                        onPressed: () {
                          // Facebook Login functionality
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.mail_outline),
                        color: Colors.red,
                        onPressed: () {
                          // Google Login functionality
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.g_mobiledata),
                        color: Colors.blue[700],
                        onPressed: () {
                          // LinkedIn Login functionality
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class WavyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WavyClipper(),
      child: Container(
        height: 250, // Increased the height here
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            'Welcome Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class WavyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
    Offset(size.width - (size.width / 4), size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
