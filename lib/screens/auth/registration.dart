import 'package:flutter/material.dart';
import 'dart:ui';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBranch;
  final List<String> _branches = [
    'Computer Science Engineering',
    'Information Technology',
    'Electronics & Communication',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Biotechnology',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with opacity
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dit.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Blur and opacity overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white.withOpacity(0.85),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // College Logo
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "DIT",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 222, 103, 24),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 24),

                            // App Title
                            Text(
                              "Campus Connect",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 222, 103, 24),
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              "Create New Account",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),

                            SizedBox(height: 32),

                            // Full Name Field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Full Name",
                                prefixIcon: Icon(Icons.person,
                                    color: Color.fromARGB(255, 222, 103, 24)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 222, 103, 24),
                                      width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16),

                            // ERP ID Field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "ERP ID",
                                prefixIcon: Icon(Icons.badge,
                                    color: Color.fromARGB(255, 222, 103, 24)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 222, 103, 24),
                                      width: 2),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your ERP ID';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16),

                            // Branch Dropdown
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Select Branch",
                                prefixIcon: Icon(Icons.school,
                                    color: Color.fromARGB(255, 222, 103, 24)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 222, 103, 24),
                                      width: 2),
                                ),
                              ),
                              value: _selectedBranch,
                              items: _branches.map((branch) {
                                return DropdownMenuItem(
                                  value: branch,
                                  child: Text(branch),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedBranch = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your branch';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16),

                            // Email Field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Email Address",
                                prefixIcon: Icon(Icons.email,
                                    color: Color.fromARGB(255, 222, 103, 24)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 222, 103, 24),
                                      width: 2),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                // Basic email validation
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16),

                            // Password Field
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Create Password",
                                prefixIcon: Icon(Icons.lock,
                                    color: Color.fromARGB(255, 222, 103, 24)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 222, 103, 24),
                                      width: 2),
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please create a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 24),

                            // Register Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Implement registration logic
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 222, 103, 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "REGISTER",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 24),

                            // Already have an account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigate back to login screen
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 222, 103, 24),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
