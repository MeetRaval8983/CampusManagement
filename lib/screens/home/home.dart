import 'package:campusmanagement/admin/admin_home.dart';
import 'package:campusmanagement/screens/attendance_system/attendance.dart';
import 'package:campusmanagement/screens/auth/login.dart';
import 'package:campusmanagement/screens/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with college building
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg/dit.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay with light blue gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(220, 173, 216, 230),
                  Color.fromARGB(180, 173, 216, 230),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20),
                Column(
                  children: [
                    // Students icon
                    Image.asset(
                      'assets/bg/dit_logo.png',
                      height: 80,
                    ),
                    SizedBox(height: 10),

                    Text(
                      "Dr. D. Y. Patil Institute of Technology",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    Text(
                      "Classroom Management",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    if (FirebaseAuth.instance.currentUser == null)
                      Text(
                        "Login or Register to user first!",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 40),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        _buildFeatureCard(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) {
                              return AdminHome();
                            }));
                          },
                          title: "Student Tracking",
                          subtitle: "Track Student Data and Record",
                          icon: Icons.assessment,
                          color: Color.fromARGB(255, 139, 101, 67),
                        ),
                        _buildFeatureCard(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return AttendanceControlPage();
                            }));
                          },
                          title: "Student Attendance Management",
                          subtitle: "Manage Student Attendance",
                          icon: Icons.assignment_turned_in,
                          color: Color.fromARGB(255, 139, 101, 67),
                        ),
                        _buildFeatureCard(
                          onTap: () {},
                          title: "Student Stress Management",
                          subtitle: "Analyze and help students in stress",
                          icon: Icons.warning,
                          color: Color.fromARGB(255, 139, 101, 67),
                        ),
                        _buildFeatureCard(
                          onTap: () {},
                          title: "Leave Management",
                          subtitle: "Manage student leave approvals",
                          icon: Icons.leave_bags_at_home,
                          color: Color.fromARGB(255, 139, 101, 67),
                        ),
                        _buildFeatureCard(
                          onTap: () {},
                          title: "Automations",
                          icon: Icons.rocket,
                          color: Colors.white,
                          textColor: Color.fromARGB(255, 139, 101, 67),
                          borderColor: Color.fromARGB(255, 139, 101, 67),
                        ),
                        _buildFeatureCard(
                          onTap: () {
                            showSettingsPopup(context);
                          },
                          title: "Settings",
                          icon: Icons.settings,
                          color: Colors.white,
                          textColor: Color.fromARGB(255, 139, 101, 67),
                          borderColor: Color.fromARGB(255, 139, 101, 67),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required Color color,
    Color textColor = Colors.white,
    Color? borderColor,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: borderColor != null
              ? Border.all(color: borderColor, width: 1)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: textColor,
                size: 32,
              ),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
