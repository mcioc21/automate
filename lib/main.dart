import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:automate/app_theme.dart';
import 'package:automate/home.dart';
import 'package:automate/login.dart';
import 'package:automate/register.dart';
import 'package:provider/provider.dart';
import 'package:automate/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider<UserProvider>(
      create: (context) => UserProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (!userProvider.initialized) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            home: userProvider.user == null && !userProvider.isGuest ? const ChooseLoginScreen() : const HomeScreen(),
            routes: {
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/dashboard': (context) => const HomeScreen(),
            },
          );
        }
      },
    );
  }
}

class ChooseLoginScreen extends StatelessWidget {
  const ChooseLoginScreen({super.key});

  Future<void> _continueAsGuest(BuildContext context) async {
    Provider.of<UserProvider>(context, listen: false).setGuest(true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            // ignore: sized_box_for_whitespace
            Container(
              width: MediaQuery.of(context).size.width * 0.65, // 65% of screen width
              height: MediaQuery.of(context).size.height * 0.05, // 5% of screen height
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('LOGIN'),
              ),
            ),
            const SizedBox(height: 20),
            // ignore: sized_box_for_whitespace
            Container(
              width: MediaQuery.of(context).size.width * 0.65, // 65% of screen width
              height: MediaQuery.of(context).size.height * 0.05, // 5% of screen height
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: const Text('REGISTER'),
              ),
            ),
            const SizedBox(height: 20),
            // ignore: sized_box_for_whitespace
            Container(
              width: MediaQuery.of(context).size.width * 0.45, // 45% of screen width
              height: MediaQuery.of(context).size.height * 0.05, // 5% of screen height
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all<Color>(AppColors.blue),
                ),
                onPressed: () => _continueAsGuest(context),
                child: const Text('Continue as Guest'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
