import 'package:campusmanagement/admin/admin_help.dart';
import 'package:campusmanagement/admin/admin_home.dart';
import 'package:campusmanagement/admin/faculty_approval.dart';
import 'package:campusmanagement/admin/faculty_info.dart';
import 'package:campusmanagement/admin/leave_applications.dart';
import 'package:campusmanagement/firebase_options.dart';
import 'package:campusmanagement/screens/attendance_system/attendance.dart';
import 'package:campusmanagement/screens/auth/login.dart';
import 'package:campusmanagement/screens/home/home.dart';
import 'package:campusmanagement/screens/map/map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(CampusManagement());
}

class CampusManagement extends StatefulWidget {
  const CampusManagement({super.key});

  @override
  State<CampusManagement> createState() => _CampusManagementState();
}

class _CampusManagementState extends State<CampusManagement> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/admin_home': (context) => AdminHome(),
        '/faculty_info': (context) => FacultyInfoPage(),
        '/leave_applications': (context) => LeaveApplicationsPage(),
        '/admin_help': (context) => AdminHelpPage(),
        '/faculty_approval': (context) => FacultyApproval(),
        '/map_page': (context) => MapPage(),
      },
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshots.hasData) {
              return HomeScreen();
            }
            return CampusAuth();
          }),
    );
  }
}
