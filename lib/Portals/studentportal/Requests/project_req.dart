import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_navigator/CustomWidgets/Snakbar.dart';
import 'package:fyp_navigator/Portals/studentportal/Requests/project_req_controller.dart';
import 'package:get/get.dart';

class ProjectRequest extends StatefulWidget {
  @override
  State<ProjectRequest> createState() => _ProjectRequestState();
}

class _ProjectRequestState extends State<ProjectRequest> {
  final ProjectRequestController controller = Get.put(ProjectRequestController());
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // Fetch the project details when the screen loads
    controller.fetchProjectDetails(currentUser!.uid);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Text("Your Project"),
        backgroundColor: Colors.teal.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.projectList.isNotEmpty) {
            var project = controller.projectList;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: project.length,
                      itemBuilder: (context,index){
                       var projectdata=project[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          shadowColor: Colors.grey.withOpacity(0.4),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProjectInfo(
                                  title: "Project Name:",
                                  content: projectdata['projectName'] ?? 'N/A',
                                  icon: Icons.book,
                                ),
                                _buildProjectInfo(
                                  title: "Description:",
                                  content: projectdata['description'] ?? 'N/A',
                                  icon: Icons.description,
                                ),
                                _buildProjectInfo(
                                  title: "Partner:",
                                  content: projectdata['partner'] ?? 'None',
                                  icon: Icons.people,
                                ),
                                _buildProjectInfo(
                                  title: "Supervisor:",
                                  content: projectdata['supervisor'] ?? 'N/A',
                                  icon: Icons.person,
                                ),
                                _buildProjectInfo(
                                  title: "Status:",
                                  content: projectdata['status'] ?? 'Pending',
                                  icon: Icons.info_outline,
                                  statusColor: _getStatusColor(
                                      projectdata['status'] ?? 'Pending'),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        if (projectdata['projectId'] != null) {
                                          // Delete the project using the stored projectId
                                          await controller.deleteProject(projectdata['projectId']);
                                        } else {
                                          showErrorSnackbar('No project found to delete');
                                        }
                                      } catch (e) {
                                        showErrorSnackbar('Failed to delete project');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      'Delete Request',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                )
              ],
            );
          } else {
            // No project found
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "You have not added a project to review.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  // Helper method to build the project information layout
  Widget _buildProjectInfo({
    required String title,
    required String content,
    required IconData icon,
    Color? statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.teal.shade700),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal.shade700),
                ),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: statusColor ?? Colors.black87,
                    fontWeight: statusColor != null ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
