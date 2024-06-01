import 'package:automate/app_theme.dart';
import 'package:automate/homeOptions/classes/vehicle.dart';
import 'package:automate/otherWidgets/homePageButtons/home_page_ad_carousel_slider.dart';
import 'package:automate/otherWidgets/homePageButtons/home_page_services_button.dart';
import 'package:automate/otherWidgets/homePageButtons/home_page_top_buttons.dart';
import 'package:automate/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final void Function(String)? onNavigateToServices;

  const HomePage({super.key, this.onNavigateToServices});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _showWelcomeBanner = false;
  int _userAppointmentState = 0;
  Vehicle? _vehicle;
  int _userVehicleState = 0;

  @override
  void initState() {
    super.initState();
    _determineUserState();
  }

  Future<void> _checkBannerStatus() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
        _showWelcomeBanner = !userProvider.hasSeenWelcomeBanner;
    });

    if (_showWelcomeBanner) {
      await userProvider.setHasSeenWelcomeBanner(true);
      Provider.of<UserProvider>(context, listen: false).notifyListeners();
    }
  }

  void _determineUserState() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user == null) {
      _userAppointmentState = 0;
      _userVehicleState = 0; // Guest
    } else {
      // Placeholder for checking if user has appointments
      bool hasAppointments = false; // TODO: Replace with actual check
      _userAppointmentState = hasAppointments ? 2 : 1;

      // Placeholder for checking if user has vehicles
      bool hasVehicle = false; // TODO: Replace with actual check
      _userVehicleState = hasVehicle ? 2 : 1;
    }
    _checkBannerStatus();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_showWelcomeBanner)
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    !userProvider.isGuest ? 'Welcome to our app!' : 'Welcome! Please log in or create an account.',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (!_showWelcomeBanner)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                  [
                    homePageAppointmentButton(context, _userAppointmentState),
                    homePageVehicleDetailsButton(context, _userVehicleState),
                  ]
              ),
            ),
          homePageAdCarouselSlider(context),
          ListTile(
              title: Container(
          padding: const EdgeInsets.only(left: 15.0, top: 5),
          child: const Text(
            'Services', 
            style: TextStyle(fontSize: 25, color: AppColors.blue),),
            ),
          ),
            homePageServicesButton(context, 'Workshops', Icons.build, widget.onNavigateToServices),
            const SizedBox(height: 5),
            homePageServicesButton(context, 'Partners', Icons.group, widget.onNavigateToServices),
            const SizedBox(height: 5),
            homePageServicesButton(context, 'Discounts', Icons.local_offer, widget.onNavigateToServices),
          ],
        ),
      ),
    );
  }
}
