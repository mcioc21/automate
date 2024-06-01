import 'package:automate/login.dart';
import 'package:automate/register.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterPage extends StatelessWidget {
  final VoidCallback? onLoginSuccess;

  const LoginOrRegisterPage({super.key, this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 350,
                height: 250,
                foregroundDecoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('./assets/AutoMate.png'),
                    fit: BoxFit.none,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65, // 65% of screen width
                height: MediaQuery.of(context).size.height * 0.05, // 5% of screen height
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage(onLoginSuccess: onLoginSuccess)),
                      ),
                  child: const Text('LOGIN'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65, // 65% of screen width
                height: MediaQuery.of(context).size.height * 0.05, // 5% of screen height
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage(onLoginSuccess: onLoginSuccess)),
                      ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text('REGISTER'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
