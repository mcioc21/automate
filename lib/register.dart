import 'package:automate/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _termsChecked = false;
  bool _emailNotificationsChecked = false;
  bool _pushNotificationsChecked = false;
  bool _isLoading = false;
  String _error = '';

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_termsChecked) {
        setState(() {
          _error = 'Please accept the terms and conditions';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _error = '';
      });

      try {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        // Registration successful, you can navigate to the home page or show a success message
        //print('Registration successful: ${userCredential.user?.email}');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
          _error = e.message!;
        });
      }
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child:  Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Text('Register',
              style: TextStyle(color: AppColors.blue),
              ),
            ],
           ),
          ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 80.0), // Works only for this screen size
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                CheckboxListTile(
                  title: const Text('By pressing the register button I declare to have read terms and conditions'),
                  value: _termsChecked,
                  onChanged: (value) {
                    setState(() {
                      _termsChecked = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('I agree to receive email notifications'),
                  value: _emailNotificationsChecked,
                  onChanged: (value) {
                    setState(() {
                      _emailNotificationsChecked = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('I agree to receive push notifications'),
                  value: _pushNotificationsChecked,
                  onChanged: (value) {
                    setState(() {
                      _pushNotificationsChecked = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Register'),
                ),
                if (_error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
