import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../CustomWidgets/Snakbar.dart';

class AddProjectController extends GetxController {
  // Text controllers for fields
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController sessionController = TextEditingController();
  final TextEditingController partnerController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  var selectedSupervisor = ''.obs;
  var selectedDomain = ''.obs;

  // Firebase reference to the 'users' collection
  final CollectionReference usersRef = FirebaseFirestore.instance.collection('Users');

  // Domains list (can be modified)
  final List<String> domains = ['Machine Learning', 'Mobile Development', 'Web Development', 'Data Science','Other'];

  // Supervisors list
  var supervisors = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSupervisors();
  }

  // Fetch supervisors from Firestore based on role 'supervisor'
  Future<void> fetchSupervisors() async {
    try {
      QuerySnapshot querySnapshot = await usersRef.where('role', isEqualTo: 'supervisor').get();
      supervisors.value = querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
    } catch (e) {
      print('Failed to fetch supervisors');
    }
  }

  // Submit project data to Firestore
  Future<void> submitProject() async {
    if (projectNameController.text.isEmpty ||
        sessionController.text.isEmpty ||
        selectedSupervisor.isEmpty ||
        selectedDomain.isEmpty ||
        descriptionController.text.isEmpty) {
      showErrorSnackbar('Please fill all required fields');
      return;
    }
    User? currentUser = FirebaseAuth.instance.currentUser;
    try {
      await FirebaseFirestore.instance.collection('projects').add({
        'studentId' : currentUser!.uid,
        'projectName': projectNameController.text,
        'session': sessionController.text,
        'partner': partnerController.text.isEmpty ? 'None' : partnerController.text,
        'supervisor': selectedSupervisor.value,
        'domain': selectedDomain.value,
        'description': descriptionController.text,
        'status': 'pending',
      });
      dispose();
      showSuccessSnackbar("Project Added Successfully");
    } catch (error) {
      showErrorSnackbar("Failed to add the project");
    }
  }

  @override
  void dispose(){
    super.dispose();
    projectNameController.clear();
    sessionController.clear();
    descriptionController.clear();
    partnerController.clear();
  }
}
