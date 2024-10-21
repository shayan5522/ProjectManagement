import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_navigator/CustomWidgets/Snakbar.dart';
import 'package:fyp_navigator/Portals/AdminPortal/DatabaseSavingData/SupervisorSavinData.dart';
import 'package:get/get.dart';

class ManageSupervisorsPage extends StatefulWidget {
  @override
  _ManageSupervisorsPageState createState() => _ManageSupervisorsPageState();
}

class _ManageSupervisorsPageState extends State<ManageSupervisorsPage> {
   User? user =FirebaseAuth.instance.currentUser;
  void _showAddEditSupervisorDialog(
      {String? name, String? email, String? password, String? department, int? index,String? uid}) {
    TextEditingController supervisorNameController = TextEditingController(text: name ?? '');
    TextEditingController supervisorEmailController = TextEditingController(text: email ?? '');
    TextEditingController supervisorPasswordController = TextEditingController(text: password ?? '');
    TextEditingController supervisorDepartmentController =
    TextEditingController(text: department ?? '');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            index == null ? 'Add New Supervisor' : 'Edit Supervisor',
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: index == null?
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Supervisor Name', supervisorNameController),
                SizedBox(height: 10),
                _buildTextField('Supervisor Email', supervisorEmailController),
                SizedBox(height: 10),
                _buildTextField('Supervisor Password', supervisorPasswordController),
                SizedBox(height: 10),
                _buildTextField('Supervisor Department', supervisorDepartmentController),
              ],
            ): Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Supervisor Name', supervisorNameController),
                SizedBox(height: 10),
                _buildTextField('Supervisor Department', supervisorDepartmentController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                   if(index == null){
                     try{
                       createSuperVisorAndAddData(
                           supervisorNameController.text,
                           supervisorEmailController.text,
                           supervisorPasswordController.text,
                           supervisorDepartmentController.text
                       );
                     }catch (e){
                       showErrorSnackbar(e.toString());
                     }
                   }else
                     {
                       try{
                         updateSupervisor(
                           uid ?? '',
                           supervisorNameController.text,
                           supervisorDepartmentController.text,
                         );
                         showSuccessSnackbar('Data Added sUCESSFULLY');
                       } catch (e){
                         showErrorSnackbar(e.toString());
                       }finally{
                         Get.back();
                       }
                     }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(index == null ? 'Add' : 'Update', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Helper widget for text fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Supervisors',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade700,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'List of Supervisors',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 20),
            Expanded(
              // StreamBuilder to listen to Firestore in real-time
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Users').where('role', isEqualTo: 'supervisor').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No Supervisors found'));
                  }

                  final supervisors = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: supervisors.length,
                    itemBuilder: (context, index) {
                      final supervisor = supervisors[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade700,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            supervisor['name'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          trailing: Icon(Icons.arrow_drop_down, color: Colors.teal),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow('Email:', supervisor['email']),
                                  _buildDetailRow('Password:', supervisor['password']),
                                  _buildDetailRow('Department:', supervisor['department']),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Edit Button
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          _showAddEditSupervisorDialog(
                                            name: supervisor['name'],
                                            email: supervisor['email'],
                                            password: supervisor['password'],
                                            department: supervisor['department'],
                                            index: index,
                                            uid: supervisor['uid'],
                                          );
                                        },
                                        icon: Icon(Icons.edit, size: 16, color: Colors.white),
                                        label: Text('Edit', style: TextStyle(fontSize: 16, color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal.shade700,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      // Delete Button
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          // Passing the UID, email, and password to deleteSupervisor
                                          deleteSupervisor(supervisor['uid'], supervisor['email'], supervisor['password']);
                                        },
                                        icon: Icon(Icons.delete, size: 16, color: Colors.white),
                                        label: Text('Delete', style: TextStyle(fontSize: 16, color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditSupervisorDialog();
        },
        backgroundColor: Colors.teal.shade700,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Supervisor',
      ),
    );
  }

  // Helper widget for displaying supervisor details
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
