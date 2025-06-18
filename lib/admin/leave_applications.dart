import 'package:campusmanagement/admin/leave_application_approval.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaveApplicationsPage extends StatelessWidget {
  const LeaveApplicationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text(
          'Leave Applications',
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('leaveApplication')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.brown));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Leave Applications',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown[600]),
              ),
            );
          }
          final leaveApplications = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: leaveApplications.length,
            itemBuilder: (context, index) {
              final data = leaveApplications[index].data();
              final userId = leaveApplications[index].id;
              return LeaveApplicationCard(
                firstname: data['firstname'] ?? 'Unknown',
                lastname: data['lastname'] ?? 'Unknown',
                startDate: data['startDate'] ?? 'Unknown',
                endDate: data['endDate'] ?? 'Unknown',
                status: data['status'] ?? 'Pending',
                userId: userId,
              );
            },
          );
        },
      ),
    );
  }
}

class LeaveApplicationCard extends StatelessWidget {
  final String firstname, lastname, startDate, endDate, status, userId;

  const LeaveApplicationCard(
      {Key? key,
      required this.firstname,
      required this.lastname,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LeaveApplicationApproval(userId: userId))),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$firstname $lastname',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$startDate - $endDate',
                      style: TextStyle(fontSize: 14, color: Colors.brown[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        ),
      ),
    );
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green[700]!;
      case 'rejected':
        return Colors.red[700]!;
      default:
        return Colors.orange[700]!;
    }
  }
}
