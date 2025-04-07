// register_form.dart
import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onSignedIn;
  RegisterForm({required this.onSignedIn});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String error = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService().signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        widget.onSignedIn();
      } catch (e) {
        setState(() {
          error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (val) => val!.contains('@') ? null : 'Enter a valid email',
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
            validator: (val) => val!.length >= 6 ? null : 'Password must be 6+ chars',
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text('Register'),
          ),
          if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(error, style: TextStyle(color: Colors.red)),
            )
        ],
      ),
    );
  }
}
