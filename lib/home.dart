import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:automate/colors.dart';
import 'package:automate/homeOptions/home_page.dart';
import 'package:automate/homeOptions/garage_page.dart';
import 'package:automate/homeOptions/profile_page.dart';
import 'package:automate/homeOptions/services_page.dart';
import 'package:automate/user_provider.dart';

class HomeScreen extends StatefulWidget {
  final int currentPageIndex;

  const HomeScreen({super.key, this.currentPageIndex = 0});

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  final List<String> _titles = ['Home', 'Garage', 'Services', 'Profile'];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentPageIndex;
  }

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
          padding: const EdgeInsets.only(left: 20.0, top: 30.0, bottom: 10),  // Adjust this value to move the title further right
          child: Text(_titles[_selectedIndex], style: const TextStyle(fontSize: 33, fontWeight: FontWeight.bold), overflow: TextOverflow.visible,),
        ),
        automaticallyImplyLeading: false,  // Remove the back button
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
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
