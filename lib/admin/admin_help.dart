import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminHelpPage extends StatelessWidget {
  const AdminHelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text(
          'Student Help Requests',
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
        stream: FirebaseFirestore.instance.collection('userHelp').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.brown));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Help Requests Available',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown[600]),
              ),
            );
          }
          final helpRequests = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: helpRequests.length,
            itemBuilder: (context, index) {
              final data = helpRequests[index].data();
              return HelpRequestCard(
                firstname: data['firstname'] ?? 'Unknown',
                lastname: data['lastname'] ?? 'Unknown',
                subject: data['subject'] ?? 'No Subject',
                description: data['description'] ?? 'No Description',
                timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
              );
            },
          );
        },
      ),
    );
  }
}

class HelpRequestCard extends StatelessWidget {
  final String firstname, lastname, subject, description;
  final DateTime timestamp;

  const HelpRequestCard(
      {Key? key,
      required this.firstname,
      required this.lastname,
      required this.subject,
      required this.description,
      required this.timestamp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.brown[200],
                  child: Text(
                    '${firstname[0]}${lastname[0]}',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$firstname $lastname',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Subject: $subject',
                style: TextStyle(fontSize: 16, color: Colors.brown[600])),
            const SizedBox(height: 8),
            Text('Description: $description',
                style: TextStyle(fontSize: 16, color: Colors.brown[600])),
            const SizedBox(height: 8),
            Text(
                'Submitted: ${timestamp.day}/${timestamp.month}/${timestamp.year}',
                style: TextStyle(fontSize: 14, color: Colors.brown[500])),
          ],
        ),
      ),
    );
  }
}
