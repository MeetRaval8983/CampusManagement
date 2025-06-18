import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String firstname = "";
  String lastname = "";
  String designation = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      print("Current User UID: ${user?.uid}");

      if (user != null) {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('adminlogin')
                .doc(user.uid)
                .get();

        if (snapshot.exists) {
          print("Firestore Document Data: ${snapshot.data()}");
          setState(() {
            firstname = snapshot.data()?['firstname'] ?? "Unknown";
            lastname = snapshot.data()?['lastname'] ?? "Unknown";
            designation = snapshot.data()?['designation'] ?? "Unknown";
            isLoading = false;
          });
        } else {
          print("No document found for UID: ${user.uid}");
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Admin sign out failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin sign out failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with college building
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg/dit.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay with light blue gradient
          Container(
            decoration: const BoxDecoration(
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

          // Main Content
          SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      const SizedBox(height: 20),

                      // Header with logo and institute name
                      Column(
                        children: [
                          Image.asset(
                            'assets/bg/dit_logo.png',
                            height: 80,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Dr. D. Y. Patil Institute of Technology",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Text(
                            "Admin Dashboard",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Admin Profile Card
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: Card(
                      //     elevation: 6,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: Container(
                      //       width: double.infinity,
                      //       padding: const EdgeInsets.all(16),
                      //       decoration: BoxDecoration(
                      //         gradient: LinearGradient(
                      //           colors: [
                      //             const Color.fromARGB(255, 139, 101, 67),
                      //             const Color.fromARGB(255, 139, 101, 67)
                      //                 .withOpacity(0.8),
                      //           ],
                      //           begin: Alignment.topLeft,
                      //           end: Alignment.bottomRight,
                      //         ),
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //       child: Column(
                      //         children: [
                      //           CircleAvatar(
                      //             radius: 40,
                      //             backgroundColor:
                      //                 Colors.white.withOpacity(0.9),
                      //             child: const Icon(
                      //               Icons.person,
                      //               size: 50,
                      //               color: Color.fromARGB(255, 139, 101, 67),
                      //             ),
                      //           ),
                      //           const SizedBox(height: 12),
                      //           Text(
                      //             "$firstname $lastname",
                      //             style: const TextStyle(
                      //               fontSize: 22,
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //           const SizedBox(height: 4),
                      //           Text(
                      //             designation,
                      //             style: TextStyle(
                      //               fontSize: 16,
                      //               color: Colors.white.withOpacity(0.9),
                      //               fontStyle: FontStyle.italic,
                      //             ),
                      //           ),
                      //           const SizedBox(height: 16),
                      //           Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               ElevatedButton(
                      //                 onPressed: () {},
                      //                 style: ElevatedButton.styleFrom(
                      //                   backgroundColor: Colors.white,
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 16, vertical: 10),
                      //                   shape: RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(8),
                      //                   ),
                      //                 ),
                      //                 child: Text(
                      //                   'Month Info',
                      //                   style: TextStyle(
                      //                     color: const Color.fromARGB(
                      //                         255, 139, 101, 67),
                      //                     fontWeight: FontWeight.w600,
                      //                   ),
                      //                 ),
                      //               ),
                      //               const SizedBox(width: 16),
                      //               ElevatedButton(
                      //                 onPressed: () {},
                      //                 style: ElevatedButton.styleFrom(
                      //                   backgroundColor: Colors.white,
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 16, vertical: 10),
                      //                   shape: RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(8),
                      //                   ),
                      //                 ),
                      //                 child: Text(
                      //                   'Edit Profile',
                      //                   style: TextStyle(
                      //                     color: const Color.fromARGB(
                      //                         255, 139, 101, 67),
                      //                     fontWeight: FontWeight.w600,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // const SizedBox(height: 20),

                      // Features Grid
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            children: [
                              _buildFeatureCard(
                                onTap: () {
                                  Navigator.pushNamed(context, '/faculty_info');
                                },
                                title: "Student Info",
                                subtitle: "View and manage student data",
                                icon: Icons.info,
                                color: const Color.fromARGB(255, 139, 101, 67),
                              ),
                              _buildFeatureCard(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/faculty_approval');
                                },
                                title: "Student Approval",
                                subtitle: "Approve student registrations",
                                icon: Icons.check_circle,
                                color: const Color.fromARGB(255, 139, 101, 67),
                              ),
                              _buildFeatureCard(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/leave_applications');
                                },
                                title: "Leave Applications",
                                subtitle: "Manage leave requests",
                                icon: Icons.calendar_month,
                                color: const Color.fromARGB(255, 139, 101, 67),
                              ),
                              _buildFeatureCard(
                                onTap: () {
                                  Navigator.pushNamed(context, '/map_page');
                                },
                                title: "Campus Map",
                                subtitle: "View campus locations",
                                icon: Icons.map,
                                color: const Color.fromARGB(255, 139, 101, 67),
                              ),
                              _buildFeatureCard(
                                onTap: () {},
                                title: "Settings",
                                subtitle: "Manage system settings",
                                icon: Icons.settings,
                                color: Colors.white,
                                textColor:
                                    const Color.fromARGB(255, 139, 101, 67),
                                borderColor:
                                    const Color.fromARGB(255, 139, 101, 67),
                              ),
                              _buildFeatureCard(
                                onTap: () {
                                  Navigator.pushNamed(context, '/admin_help');
                                },
                                title: "Help",
                                subtitle: "Get support and resources",
                                icon: Icons.help,
                                color: Colors.white,
                                textColor:
                                    const Color.fromARGB(255, 139, 101, 67),
                                borderColor:
                                    const Color.fromARGB(255, 139, 101, 67),
                              ),
                              _buildFeatureCard(
                                onTap: () {
                                  Navigator.pushNamed(context, '/aboutus');
                                },
                                title: "About Us",
                                subtitle: "Learn about the institute",
                                icon: Icons.groups,
                                color: Colors.white,
                                textColor:
                                    const Color.fromARGB(255, 139, 101, 67),
                                borderColor:
                                    const Color.fromARGB(255, 139, 101, 67),
                              ),
                              _buildFeatureCard(
                                onTap: () {
                                  signOut(context);
                                },
                                title: "Logout",
                                subtitle: "Sign out from the system",
                                icon: Icons.logout,
                                color: Colors.white,
                                textColor:
                                    const Color.fromARGB(255, 139, 101, 67),
                                borderColor:
                                    const Color.fromARGB(255, 139, 101, 67),
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
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: borderColor != null
              ? Border.all(color: borderColor, width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
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
              const SizedBox(height: 12),
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
