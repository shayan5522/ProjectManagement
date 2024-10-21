import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_navigator/CustomWidgets/Snakbar.dart';
import 'package:fyp_navigator/screens/auth/login.dart';
import '../../CustomWidgets/ElevatedButton.dart';
import '../../CustomWidgets/TextWidget.dart';
class StudentSignUpPage extends StatefulWidget {
  @override
  State<StudentSignUpPage> createState() => _StudentSignUpPageState();
}

class _StudentSignUpPageState extends State<StudentSignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

  final TextEditingController _rollNoController = TextEditingController();

  String? _selectedSemester;

  String? _selectedDepartment;

  bool loading = false;

  final List<String> _semesters = ['Semester 1', 'Semester 2', 'Semester 3', 'Semester 4', 'Semester 5', 'Semester 6', 'Semester 7', 'Semester 8'];

  final List<String> _departments = ['Computer Science', 'Software Engineering', 'Data Science', 'Electrical Engineering'];

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        User? user = userCredential.user;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
          showSuccessSnackbar('Email verification sent. Check your email.');

          _firestore.collection('Users').doc(user.uid).set({
            'name': _nameController.text,
            'email': _emailController.text.trim(),
            'role': 'Student',
            'uid': user.uid,
            'semester': _selectedSemester,
            'department': _selectedDepartment,
            'roll_no': _rollNoController.text,
          });
          await _auth.signOut();
          Get.off(LoginPage());
        }
      } on FirebaseAuthException catch (e) {
        showErrorSnackbar(e.message.toString());
      }finally {
        setState(() {
          loading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.tealAccent.shade700.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.explore_rounded,
                          size: 50,
                          color: Colors.tealAccent.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Student Sign Up Now',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please fill the details to create an account',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _rollNoController,
                      decoration: InputDecoration(
                        labelText: 'Roll Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your roll number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedSemester,
                      hint: Text('Select Semester'),
                      items: _semesters.map((semester) {
                        return DropdownMenuItem(
                          value: semester,
                          child: Text(semester),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedSemester = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a semester';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedDepartment,
                      hint: Text('Select Department'),
                      items: _departments.map((department) {
                        return DropdownMenuItem(
                          value: department,
                          child: Text(department),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedDepartment = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a department';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: Elevated_button(
                        path: () => loading ? null : _signUp(),
                        color: Colors.white,
                        backcolor: Colors.teal.shade700,
                        text: loading ? 'Please wait...' : 'Signup',
                        radius: 10,
                        padding: 10,
                      ),
                    ),
                    if (loading)
                      SizedBox(
                        height: 20,
                      ),
                    if (loading)
                      CircularProgressIndicator(),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(title: "Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Get.to(LoginPage());
                          },
                          child: TextWidget(
                            title: 'Log In',
                            color: Colors.teal.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Or connect with'),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.facebook),
                          color: Colors.blue,
                          onPressed: () {
                            // Facebook Sign Up functionality
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.mail_outline),
                          color: Colors.red,
                          onPressed: () {
                            // Google Sign Up functionality
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.mail),
                          color: Colors.blue[700],
                          onPressed: () {
                            // LinkedIn Sign Up functionality
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
