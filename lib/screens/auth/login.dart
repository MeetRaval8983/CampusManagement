import 'package:campusmanagement/screens/auth/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class CampusAuth extends StatefulWidget {
  @override
  _CampusAuthState createState() => _CampusAuthState();
}

class _CampusAuthState extends State<CampusAuth> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  Future<void> loginWithEmail(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        Navigator.of(context).pop();

        if (userCredential.user != null) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format.';
            break;
          case 'user-disabled':
            errorMessage = 'This account has been disabled.';
            break;
          default:
            errorMessage = 'Login failed: ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
    }
  }

  Future<void> createAccount(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        Navigator.of(context).pop();

        if (userCredential.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Account created successfully! Please login.')),
          );
          // Clear the form
          _emailController.clear();
          _passController.clear();
        }
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        String errorMessage;
        switch (e.code) {
          case 'weak-password':
            errorMessage = 'Password is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage = 'An account already exists with this email.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format.';
            break;
          default:
            errorMessage = 'Account creation failed: ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const brownColor = Colors.brown;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg/dit.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
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
                            Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
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
                                child: Image.asset(
                                  'assets/bg/dit_logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              "Campus Connect",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: brownColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Sign in to your account",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.person),
                                // border: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(12),
                                //),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@dypvp.edu.in')) {
                                  return 'Please use your @dypvp.edu.in email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passController,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              obscureText: !_isPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                    ),
                                    const Text("Remember me"),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Add forgot password functionality
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: brownColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  loginWithEmail(
                                    _emailController.text,
                                    _passController.text,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: brownColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                createAccount(
                                  _emailController.text,
                                  _passController.text,
                                );
                              },
                              child: const Text(
                                "New user? Create account",
                                style: TextStyle(
                                  color: brownColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                const Expanded(child: Divider(thickness: 1)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    "Or sign in with",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                                const Expanded(child: Divider(thickness: 1)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSocialButton(Icons.mail, Colors.red),
                                const SizedBox(width: 16),
                                _buildSocialButton(Icons.school, brownColor),
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

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
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
      child: IconButton(
        icon: Icon(
          icon,
          color: color,
          size: 28,
        ),
        onPressed: () {},
      ),
    );
  }
}
