import 'package:campusmanagement/admin/facutly_info_desc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FacultyInfoPage extends StatelessWidget {
  const FacultyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text(
          'Faculty Information',
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
        stream: FirebaseFirestore.instance.collection('faculty').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.brown));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Faculty Data Available',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown[600]),
              ),
            );
          }
          final facultyData = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: facultyData.length,
            itemBuilder: (context, index) {
              final data = facultyData[index].data();
              final userId = facultyData[index].id;
              return FacultyCard(
                firstname: data['firstname'] ?? 'N/A',
                lastname: data['lastname'] ?? 'N/A',
                designation: data['designation'] ?? 'N/A',
                department: data['department'] ?? 'N/A',
                mobile: data['mobile'] ?? 'N/A',
                email: data['email'] ?? 'N/A',
                userId: userId,
              );
            },
          );
        },
      ),
    );
  }
}

class FacultyCard extends StatelessWidget {
  final String firstname,
      lastname,
      designation,
      department,
      mobile,
      email,
      userId;

  const FacultyCard(
      {Key? key,
      required this.firstname,
      required this.lastname,
      required this.designation,
      required this.department,
      required this.mobile,
      required this.email,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FacultyInfoDescPage(userId: userId))),
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
                  '${firstname[0]}${lastname[0]}',
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
                    Text('$firstname $lastname',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800])),
                    const SizedBox(height: 4),
                    Text(designation,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.brown[600],
                            fontStyle: FontStyle.italic)),
                    const SizedBox(height: 8),
                    Text('Dept: $department',
                        style:
                            TextStyle(fontSize: 14, color: Colors.brown[500])),
                    Text('Mobile: $mobile',
                        style:
                            TextStyle(fontSize: 14, color: Colors.brown[500])),
                    Text('Email: $email',
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
}
