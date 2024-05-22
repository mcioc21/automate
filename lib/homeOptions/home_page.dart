import 'package:automate/colors.dart';
import 'package:automate/homeOptions/vehicle.dart';
import 'package:automate/otherWidgets/homePageButtons/home_page_ad_carousel_slider.dart';
import 'package:automate/otherWidgets/homePageButtons/home_page_services_button.dart';
import 'package:automate/otherWidgets/homePageButtons/home_page_top_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({super.key, this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _showWelcomeBanner = false;
  bool _showGuestBanner = false;
  int _userAppointmentState = 0;
  Vehicle? _vehicle;
  int _userVehicleState = 0;

  @override
  void initState() {
    super.initState();
    _checkBannerStatus();
    _determineUserState();
  }

  Future<void> _checkBannerStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasSeenWelcome = prefs.getBool('hasSeenWelcomeBanner') ?? false;
    bool hasSeenGuest = prefs.getBool('hasSeenGuestBanner') ?? false;

    setState(() {
      _showWelcomeBanner = widget.user != null && !hasSeenWelcome;
      _showGuestBanner = widget.user == null && !hasSeenGuest;
    });

    if (_showWelcomeBanner || _showGuestBanner) {
      await prefs.setBool('hasSeenWelcomeBanner', true);
      await prefs.setBool('hasSeenGuestBanner', true);
    }
  }

  void _determineUserState() async {
    if (widget.user == null) {
      _userAppointmentState = 0;
      _userVehicleState == 0;  // Guest
    } else {
      // Placeholder for checking if user has appointments

      bool hasAppointments = false; // TO DO: Replace with actual check
      _userAppointmentState = hasAppointments ? 2 : 1; 

      var collection = _firestore.collection('users').doc(widget.user!.uid).collection('vehicles');
      var snapshot = await collection.get();
      //var vehicles = snapshot.docs.map((doc) => Vehicle.fromMap(doc.data())).toList();
      //var vehicle = snapshot.docs.where((element) => false);
      
      
      bool hasVehicle = false; // TO DO: Replace with actual check
      _userVehicleState = hasVehicle ? 2 : 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_showWelcomeBanner || _showGuestBanner)
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _showWelcomeBanner ? 'Welcome to our app!' : 'Welcome! Please log in or create an account.',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (!_showWelcomeBanner && !_showGuestBanner)
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
            homePageServicesButton(context, 'Workshops', Icons.build),
            const SizedBox(height: 5),
            homePageServicesButton(context, 'Partners', Icons.group),
            const SizedBox(height: 5),
            homePageServicesButton(context, 'Discounts', Icons.local_offer),
          ],
        ),
      ),
    );
  }
}
