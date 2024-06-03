import 'package:flutter/material.dart';
import 'package:automate/app_theme.dart';
import 'package:automate/homeOptions/homePage/home_page.dart';
import 'package:automate/homeOptions/garagePage/garage_page.dart';
import 'package:automate/homeOptions/profilePage/profile_page.dart';
import 'package:automate/homeOptions/servicesPage/services_page.dart';

class HomeScreen extends StatefulWidget {
  final int currentPageIndex;

  const HomeScreen({super.key, this.currentPageIndex = 0});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  final List<String> _titles = ['Home', 'Garage', 'Services', 'Profile'];

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentPageIndex;
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void navigateToServicesAndPushPage(String pageRoute) {
    if (_selectedIndex != 2) {
      setState(() {
        _selectedIndex = 2;
      });
    }
    _navigatorKeys[2].currentState?.pushNamedAndRemoveUntil(pageRoute, (route) => route.isFirst);
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        onGenerateRoute: (settings) {
          Widget page;
          switch (index) {
            case 0:
              page = HomePage(onNavigateToServices: navigateToServicesAndPushPage);
              break;
            case 1:
              page = const GaragePage();
              break;
            case 2:
              page = ServicesPage(navigatorKey: _navigatorKeys[2]);
              break;
            case 3:
              page = const ProfilePage();
              break;
            default:
              page = Container();
          }
          return MaterialPageRoute(builder: (context) => page);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(left: 20.0, top: 30.0, bottom: 10),
          child: Text(_titles[_selectedIndex],
              style: const TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
              overflow: TextOverflow.visible),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: List.generate(4, (index) => _buildOffstageNavigator(index)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.garage), label: 'Garage'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
