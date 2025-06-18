import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class LeaveApplicationApproval extends StatefulWidget {
  final String userId;
  const LeaveApplicationApproval({Key? key, required this.userId})
      : super(key: key);

  @override
  _LeaveApplicationApprovalState createState() =>
      _LeaveApplicationApprovalState();
}

class _LeaveApplicationApprovalState extends State<LeaveApplicationApproval> {
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
          .collection('leaveApplication')
          .doc(widget.userId)
          .get();
      if (userDoc.exists) {
        setState(() {
          userDetails = userDoc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Leave application not found')));
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
          .collection('leaveApplication')
          .doc(widget.userId)
          .update({'status': status});
      String emailBody =
          'Dear ${userDetails?['firstname']},\n\nYour leave from ${userDetails?['startDate']} to ${userDetails?['endDate']} has been $status.';
      await sendEmail(
          userDetails?['email']!, 'Leave Application Update', emailBody);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Leave $status')));
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
                    'No Details',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.brown[600]),
                  ),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoTile('Name',
                              '${userDetails?['firstname']} ${userDetails?['lastname']}'),
                          _buildInfoTile(
                              'Email', userDetails?['email'] ?? 'N/A'),
                          _buildInfoTile(
                              'Mobile', userDetails?['mobile'] ?? 'N/A'),
                          _buildInfoTile('Department',
                              userDetails?['department'] ?? 'N/A'),
                          _buildInfoTile('Dates',
                              '${userDetails?['startDate']} - ${userDetails?['endDate']}'),
                          _buildInfoTile(
                              'Type', userDetails?['leaveType'] ?? 'N/A'),
                          _buildInfoTile(
                              'Reason', userDetails?['reason'] ?? 'N/A'),
                          _buildInfoTile(
                              'Status', userDetails?['status'] ?? 'Pending',
                              valueColor: statusColor(
                                  userDetails?['status'] ?? 'Pending')),
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
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
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
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoTile(String label, String value, {Color? valueColor}) {
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
              style: TextStyle(
                  fontSize: 16, color: valueColor ?? Colors.brown[600]),
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
