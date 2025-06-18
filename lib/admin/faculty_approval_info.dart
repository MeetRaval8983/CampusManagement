import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class FacultyApprovalInfoPage extends StatefulWidget {
  final String userId;
  const FacultyApprovalInfoPage({Key? key, required this.userId})
      : super(key: key);

  @override
  _FacultyApprovalInfoPageState createState() =>
      _FacultyApprovalInfoPageState();
}

class _FacultyApprovalInfoPageState extends State<FacultyApprovalInfoPage> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('student')
          .doc(widget.userId)
          .get();
      if (userDoc.exists) {
        setState(() {
          userDetails = userDoc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User not found')));
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> updateUserStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('faculty')
          .doc(widget.userId)
          .update({'status': status});
      String emailBody =
          'Dear Faculty,\n\nYour registration to the app has been $status.';
      await sendEmail(
          userDetails?[' Uttemail']!, 'Faculty Registration Status', emailBody);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User $status successfully')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> sendEmail(String recipient, String subject, String body) async {
    final Email email = Email(
        body: body, subject: subject, recipients: [recipient], isHTML: false);
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Email failed: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text(
          '${userDetails?['firstname'] ?? ''} ${userDetails?['lastname'] ?? ''}',
          style: const TextStyle(
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : userDetails == null
              ? Center(
                  child: Text(
                    'No Details Available',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.brown[600]),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 24),
                      _buildInfoCard(),
                      const SizedBox(height: 24),
                      _buildStatusSection(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.brown.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.brown[200],
            child: userDetails?['profileImage'] != null
                ? Image.network(userDetails!['profileImage'],
                    fit: BoxFit.cover, width: 80, height: 80)
                : Text(
                    '${userDetails?['firstname']?[0] ?? ''}${userDetails?['lastname']?[0] ?? ''}',
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${userDetails?['firstname']} ${userDetails?['lastname']}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800]),
                ),
                const SizedBox(height: 4),
                Text(
                  '${userDetails?['designation'] ?? 'N/A'}',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown[600],
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.brown.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          _buildInfoTile('Email', userDetails?['email'] ?? 'N/A'),
          _buildInfoTile('Mobile', userDetails?['mobile'] ?? 'N/A'),
          _buildInfoTile('Username', userDetails?['username'] ?? 'N/A'),
          _buildInfoTile('Department', userDetails?['department'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.brown.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Status: ',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800]),
              ),
              Text(
                '${userDetails?['status']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: statusColor(userDetails?['status'] ?? 'Pending'),
                ),
              ),
            ],
          ),
          if (userDetails?['status'] == 'Pending') ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => updateUserStatus('Approved'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Approve',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => updateUserStatus('Rejected'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Reject',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.brown[700]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.brown[600]),
            ),
          ),
        ],
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
