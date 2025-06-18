import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPopup extends StatefulWidget {
  const SettingsPopup({Key? key}) : super(key: key);

  @override
  _SettingsPopupState createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  Future<void> _logout() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      FirebaseAuth.instance.signOut();

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully')),
      );
    } catch (e) {
      // Navigator.of(context).pop(); // Remove loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during logout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const brownColor = Colors.brown;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            const Text(
              "Settings",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: brownColor,
              ),
            ),
            const SizedBox(height: 16),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: brownColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "LOGOUT",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Close button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Close",
                style: TextStyle(
                  color: brownColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage example:
void showSettingsPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const SettingsPopup();
    },
  );
}
