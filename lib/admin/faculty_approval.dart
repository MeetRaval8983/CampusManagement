import 'package:campusmanagement/admin/faculty_approval_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FacultyApproval extends StatefulWidget {
  const FacultyApproval({super.key});

  @override
  State<FacultyApproval> createState() => _FacultyApprovalState();
}

class _FacultyApprovalState extends State<FacultyApproval> {
  String status = 'Pending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text(
          'Faculty Approvals',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown[700]!, Colors.brown[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('faculty')
            .where('status', isEqualTo: status.trim())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.brown));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Faculty Approvals Found',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown[600]),
              ),
            );
          }
          final facultyApprovals = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: facultyApprovals.length,
            itemBuilder: (context, index) {
              final data = facultyApprovals[index].data();
              final userId = facultyApprovals[index].id;
              return FacultyApprovalCard(
                firstName: data['firstname'] ?? 'Unknown',
                lastName: data['lastname'] ?? 'Unknown',
                email: data['email'] ?? 'Unknown',
                mobile: data['mobile'] ?? 'Unknown',
                username: data['username'] ?? 'Unknown',
                designation: data['designation'] ?? 'Unknown',
                department: data['department'] ?? 'Unknown',
                status: data['status'] ?? 'Unknown',
                userId: userId,
              );
            },
          );
        },
      ),
    );
  }
}

class FacultyApprovalCard extends StatelessWidget {
  final String firstName,
      lastName,
      designation,
      department,
      mobile,
      username,
      email,
      status,
      userId;

  const FacultyApprovalCard(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.mobile,
      required this.username,
      required this.designation,
      required this.department,
      required this.status,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FacultyApprovalInfoPage(userId: userId))),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.brown[200],
                child: Text(
                  '${firstName[0]}${lastName[0]}',
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '$firstName $lastName',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[800]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor(status),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(designation,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.brown[600],
                            fontStyle: FontStyle.italic)),
                    const SizedBox(height: 8),
                    Text('Email: $email',
                        style:
                            TextStyle(fontSize: 14, color: Colors.brown[500])),
                    Text('Mobile: $mobile',
                        style:
                            TextStyle(fontSize: 14, color: Colors.brown[500])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[700]!;
      case 'rejected':
        return Colors.red[700]!;
      default:
        return Colors.green[700]!;
    }
  }
}
