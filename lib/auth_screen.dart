// auth_screen.dart
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'register_form.dart';
import 'login_form.dart';
import 'profile_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool showLogin = true;

  void toggleForm() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  void onSignedIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Auth Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showLogin
                ? LoginForm(onSignedIn: onSignedIn)
                : RegisterForm(onSignedIn: onSignedIn),
            TextButton(
              onPressed: toggleForm,
              child: Text(showLogin ? 'Don\'t have an account? Register' : 'Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
