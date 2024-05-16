import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:automate/colors.dart';
import 'package:automate/home.dart';
import 'package:automate/login.dart';
import 'package:automate/register.dart';
import 'package:provider/provider.dart';
import 'package:automate/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Stream<User?> _idTokenStream;
  User? _user;
  bool _isGuest = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();

    _idTokenStream = FirebaseAuth.instance.idTokenChanges();

    _idTokenStream.listen((user) {
      setState(() {
        _user = user;
        context.read<UserProvider>().setUser(user);
        if (user == null) {
          _isGuest = prefs.getBool('isGuest') ?? false;
        } else {
          _isGuest = false;
        }
      });
    }, onError: (error) {
    });

    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      if (_user == null && !_isGuest) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          home: const ChooseLoginScreen(),
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/dashboard': (context) => const HomeScreen(),
          },
        );
      } else {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          home: const HomeScreen(),
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/dashboard': (context) => const HomeScreen(),
          },
        );
      }
    }
  }
}

class ChooseLoginScreen extends StatelessWidget {
  const ChooseLoginScreen({super.key});

  Future<void> _continueAsGuest(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGuest', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

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
