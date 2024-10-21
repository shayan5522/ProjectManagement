import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ManageSupervioser/ManageSupervisorsPage.dart';
import 'ManageUser/ManageUserPage.dart';
import 'admin_add_projects.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overview',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 20),
              _buildKeyMetrics(isSmallScreen),
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => AddProjects());
                  },
                  child: Text('Add Project'))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyMetrics(bool isSmallScreen) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 16.0,
      alignment: WrapAlignment.spaceEvenly,
      children: [
        _buildMetricCard('Manage', "Users", Icons.people, Colors.blue),
        _buildMetricCard(
            'Manage', "Supervioser", Icons.supervised_user_circle, Colors.blue),
        _buildMetricCard('Manage', 'Projects', Icons.work, Colors.orange),
        _buildMetricCard('Manage', 'Feedback', Icons.feedback, Colors.green),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String count, IconData icon, Color color) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 150, maxWidth: 200),
      child: GestureDetector(
        onTap: () {
          if (title == 'Manage' && count == "Users") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManageUsersPage()),
            );
          } else if (title == 'Manage' && count == "Supervioser") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManageSupervisorsPage()),
            );
          }
        },
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 40, color: color),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  count,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
