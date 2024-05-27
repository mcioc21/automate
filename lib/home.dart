import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:automate/app_theme.dart';
import 'package:automate/homeOptions/home_page.dart';
import 'package:automate/homeOptions/garage_page.dart';
import 'package:automate/homeOptions/profile_page.dart';
import 'package:automate/homeOptions/services_page.dart';
import 'package:automate/user_provider.dart';

class HomeScreen extends StatefulWidget {
  final int currentPageIndex;

  const HomeScreen({super.key, this.currentPageIndex = 0});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  late List<GlobalKey<NavigatorState>> _navigatorKeys;

  final List<String> _titles = ['Home', 'Garage', 'Services', 'Profile'];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentPageIndex;
    _navigatorKeys = [
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
      GlobalKey<NavigatorState>(),
    ];
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // Pop to first route if user taps the active tab again
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
      _selectedIndex = 2; // Switch to Services tab
    });
  }
    // Push the desired route to the services navigator
    _navigatorKeys.elementAt(2).currentState?.pushNamedAndRemoveUntil(pageRoute, (route) => route.isFirst);
}

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        onGenerateRoute: (settings) {
          // Access user data without listening to changes
          final user = Provider.of<UserProvider>(context, listen: false).user;
          
          if (index == 0) {
            return MaterialPageRoute(
              builder: (context) => HomePage(
                user: user,
                onNavigateToServices: navigateToServicesAndPushPage,
              )
            );
          }
          if (index == 1) {
            return MaterialPageRoute(
              builder: (context) => GaragePage(user: user)
            );
          }
          if (index == 2) {
            return MaterialPageRoute(
              builder: (context) => ServicesPage(user: user, navigatorKey: _navigatorKeys.elementAt(2))
            );
          }
          if (index == 3) {
            return MaterialPageRoute(
              builder: (context) => ProfilePage(user: user)
            );
          }
          return MaterialPageRoute(builder: (_) => Container()); // Default case if needed
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
          child: Text(_titles[_selectedIndex], style: const TextStyle(fontSize: 33, fontWeight: FontWeight.bold), overflow: TextOverflow.visible),
        ),
        automaticallyImplyLeading: false,  // Remove the back button
      ),
      body: Stack(
        children: List.generate(4, (index) => _buildOffstageNavigator(index)),
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
