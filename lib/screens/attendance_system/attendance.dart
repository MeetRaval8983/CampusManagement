import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceControlScreen extends StatefulWidget {
  const AttendanceControlScreen({Key? key}) : super(key: key);

  @override
  _AttendanceControlScreenState createState() =>
      _AttendanceControlScreenState();
}

class _AttendanceControlScreenState extends State<AttendanceControlScreen> {
  bool _isAttendanceActive = false;
  bool _isLoading = true;
  String _serverAddress =
      "http://192.168.1.100:5000"; // Replace with your server IP
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _checkAttendanceStatus();
  }

  Future<void> _checkAttendanceStatus() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Checking attendance status...";
    });

    try {
      final response = await http
          .get(
            Uri.parse('$_serverAddress/attendance/status'),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _isAttendanceActive = data['active'];
          _statusMessage = "";
        });
      } else {
        setState(() {
          _statusMessage = "Failed to get status: Server error";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Failed to connect to server: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleAttendance() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Sending request...";
    });

    try {
      final response = await http
          .post(
            Uri.parse('$_serverAddress/attendance/toggle'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, bool>{
              'active': !_isAttendanceActive,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _isAttendanceActive = !_isAttendanceActive;
          _statusMessage = data['message'];
        });
      } else {
        setState(() {
          _statusMessage = "Failed to toggle: Server error";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Failed to connect to server: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance System Control'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkAttendanceStatus,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Attendance System',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Icon(
                      _isAttendanceActive ? Icons.check_circle : Icons.cancel,
                      color: _isAttendanceActive ? Colors.green : Colors.red,
                      size: 80,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _isAttendanceActive ? 'ACTIVE' : 'INACTIVE',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isAttendanceActive ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (_statusMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          _statusMessage,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: _toggleAttendance,
                      icon: Icon(
                          _isAttendanceActive ? Icons.stop : Icons.play_arrow),
                      label: Text(_isAttendanceActive
                          ? 'Stop Attendance'
                          : 'Start Attendance'),
                      style: ElevatedButton.styleFrom(
                        // primary: _isAttendanceActive ? Colors.red : Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Show dialog to change server address
                        showDialog(
                          context: context,
                          builder: (context) => _buildServerAddressDialog(),
                        );
                      },
                      child: const Text('Change Server Address'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildServerAddressDialog() {
    final TextEditingController controller =
        TextEditingController(text: _serverAddress);

    return AlertDialog(
      title: const Text('Server Address'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'http://192.168.1.100:5000',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _serverAddress = controller.text;
            });
            Navigator.pop(context);
            _checkAttendanceStatus();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class AttendanceControlPage extends StatefulWidget {
  @override
  _AttendanceControlPageState createState() => _AttendanceControlPageState();
}

class _AttendanceControlPageState extends State<AttendanceControlPage> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('attendance_system');
  bool _isAttendanceActive = false;

  @override
  void initState() {
    super.initState();
    // Load initial state
    _database.child('status').get().then((snapshot) {
      setState(() {
        _isAttendanceActive = snapshot.value == 'active';
      });
    });
    // Listen for real-time updates
    _database.child('status').onValue.listen((event) {
      print('Firebase status: ${event.snapshot.value}');
      setState(() {
        _isAttendanceActive = event.snapshot.value == 'active';
      });
    });
  }

  void _toggleAttendance() {
    String newStatus = _isAttendanceActive ? 'inactive' : 'active';
    print('Setting status to: $newStatus');
    _database.child('status').set(newStatus).then((_) {
      print('Status updated successfully');
    }).catchError((error) {
      print('Error updating status: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with college building
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg/dit.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay with light blue gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(220, 173, 216, 230),
                  Color.fromARGB(180, 173, 216, 230),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/bg/dit_logo.png',
                        height: 60,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Attendance System Control",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 139, 101, 67),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.assignment_turned_in,
                            color: Colors.white,
                            size: 32,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'System Status:',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _isAttendanceActive ? 'ACTIVE' : 'INACTIVE',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: _isAttendanceActive
                                  ? Colors.green[200]
                                  : Colors.red[200],
                            ),
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            child: Text(
                              _isAttendanceActive
                                  ? 'Stop Attendance'
                                  : 'Start Attendance',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 139, 101, 67),
                              ),
                            ),
                            onPressed: _toggleAttendance,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: Color.fromARGB(255, 139, 101, 67),
                                    width: 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
