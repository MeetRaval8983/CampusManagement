import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FacultyInfoDescPage extends StatefulWidget {
  final String userId;
  const FacultyInfoDescPage({Key? key, required this.userId}) : super(key: key);

  @override
  _FacultyInfoDescPageState createState() => _FacultyInfoDescPageState();
}

class _FacultyInfoDescPageState extends State<FacultyInfoDescPage> {
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
          .collection('faculty')
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
            .showSnackBar(const SnackBar(content: Text('Faculty not found')));
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
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
                    'No Faculty Details Available',
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
            child: Text(
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
                  '${userDetails?['designation'] ?? 'N/A'}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown[800]),
                ),
                const SizedBox(height: 4),
                Text(
                  '${userDetails?['department'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16, color: Colors.brown[600]),
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
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Faculty Details',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700]),
          ),
          const Divider(color: Colors.brown, thickness: 0.5),
          const SizedBox(height: 12),
          _buildInfoTile('Email', userDetails?['email'] ?? 'N/A'),
          _buildInfoTile('Mobile', userDetails?['mobile'] ?? 'N/A'),
          _buildInfoTile('Username', userDetails?['username'] ?? 'N/A'),
          _buildInfoTile('Status', userDetails?['status'] ?? 'Pending',
              valueColor: statusColor(userDetails?['status'] ?? 'Pending')),
        ],
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
