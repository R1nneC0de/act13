// profile_screen.dart
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  void _logout(BuildContext context) async {
    await _authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthenticationScreen()),
    );
  }

  void _changePassword(BuildContext context) async {
    final TextEditingController _newPassController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Change Password"),
        content: TextField(
          controller: _newPassController,
          obscureText: true,
          decoration: InputDecoration(hintText: 'New password (min 6 chars)'),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Change"),
            onPressed: () async {
              try {
                await _authService.changePassword(_newPassController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Password updated")),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed: ${e.toString()}")),
                );
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Logged in as:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(user?.email ?? 'No email', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _changePassword(context),
              child: Text("Change Password"),
            )
          ],
        ),
      ),
    );
  }
}
