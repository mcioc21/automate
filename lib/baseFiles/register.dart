import 'package:automate/baseFiles/app_theme.dart';
import 'package:automate/baseFiles/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const RegisterPage({super.key, this.onLoginSuccess});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
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
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        User? user = userCredential.user;
        if (user != null) {
          await user.updateDisplayName(_nameController.text);
          await user.reload();
          user = FirebaseAuth.instance.currentUser;
          Provider.of<UserProvider>(context, listen: false).setUser(user);
        }
        Navigator.of(context).popUntil((route) => route.isFirst);
        widget.onLoginSuccess?.call();
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
        title: const Row(
          children: [Column(
            children: <Widget>[
              Text(
                'Register',
                style: TextStyle(color: AppColors.blue),
              ),
            ],
          ),
          ],
        ),
      ),
      body: Center( 
        child:
        SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
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
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('I agree to the terms and conditions'),
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
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Register'),
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
      ),
    );
  }
}
