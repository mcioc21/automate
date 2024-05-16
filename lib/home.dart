import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:automate/colors.dart';
import 'package:automate/homeOptions/home_page.dart';
import 'package:automate/homeOptions/garage_page.dart';
import 'package:automate/homeOptions/profile_page.dart';
import 'package:automate/homeOptions/services_page.dart';
import 'package:automate/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user; // Access the user from UserProvider

    final List<Widget> pages = [
      HomePage(user: user),  // Pass the user to HomePage
      GaragePage(user: user),  // Pass the user to GaragePage
      ServicesPage(user: user),  // Pass the user to ServicesPage
      ProfilePage(user: user),  // Pass the user to ProfilePage
    ];

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(left: 25.0),  // Adjust this value to move the title further right
          child: const Text('AutoMate'),
        ),
        automaticallyImplyLeading: false,  // Remove the back button
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.garage),
            label: 'Garage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.blue,
        showUnselectedLabels: true,
        unselectedItemColor: AppColors.beaver,
        onTap: _onItemTapped,
      ),
    );
  }
}
