import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:automate/colors.dart';
import 'package:automate/home.dart';
import 'package:automate/login.dart';
import 'package:automate/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Stream<User?> _idTokenStream;

  @override
  void initState() {
    super.initState();
    // Listen for ID token changes
    _idTokenStream = FirebaseAuth.instance.idTokenChanges();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: AppColors.colorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: AppColors.snow,
          ),
        ),
        scaffoldBackgroundColor: AppColors.snow,
      ),
      home: StreamBuilder<User?>(
        stream: _idTokenStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              // No user signed in, show choose login screen
              return const ChooseLoginScreen();
            } else {
              // User is signed in, show home screen
              return const HomeScreen();
            }
          } else {
            // Connection state is not yet active, show loading indicator
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const HomeScreen(),
      },
    );
  }
}

class ChooseLoginScreen extends StatelessWidget {
  const ChooseLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: const ListTile(
          leading: Text(
            'Welcome',
            style: TextStyle(fontSize: 25.0),
          ),
          trailing: Icon(
            Icons.auto_awesome,
            color: AppColors.blue,
          ), //add icon here
        ),
        backgroundColor: Colors.grey,
        foregroundColor: AppColors.blue,
      ),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text('Continue as Guest'),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}