import 'package:automate/homeOptions/choose_discount.dart';
import 'package:automate/homeOptions/choose_partner.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:automate/app_theme.dart';
import 'package:automate/homeOptions/choose_workshop.dart';
import 'package:automate/login_or_register.dart';

class ServicesPage extends StatelessWidget {
  final User? user;
  final GlobalKey<NavigatorState>? navigatorKey;

  const ServicesPage({super.key, this.user, this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user == null
          ? const LoginOrRegisterPage(currentPageIndex: 2)
          : Navigator(
              key: navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case 'chooseWorkshop':
                    return MaterialPageRoute(
                        builder: (context) => const ChooseWorkshopPage());
                  case 'choosePartner':
                    return MaterialPageRoute(
                        builder: (context) => const PartnersPage());
                  case 'chooseDiscount':
                    return MaterialPageRoute(
                        builder: (context) => const DiscountsPage());
                  default:
                    return MaterialPageRoute(
                        builder: (context) => _buildServiceButtons(context));
                }
              },
            ),
    );
  }

  Widget _buildServiceButtons(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildServiceButton(
              context: context,
              label: 'Workshops',
              description: 'Find and book workshops',
              icon: Icons.build,
              onTap: () {
                Navigator.of(context).pushNamed('chooseWorkshop');
              },
            ),
            _buildServiceButton(
              context: context,
              label: 'Appointments',
              description: 'Manage your appointments',
              icon: Icons.calendar_today,
              onTap: () {
                // Navigate to Appointments page
              },
            ),
            _buildServiceButton(
              context: context,
              label: 'Partners',
              description: 'View our partners',
              icon: Icons.group,
              onTap: () {
                Navigator.of(context).pushNamed('choosePartner');
              },
            ),
            _buildServiceButton(
              context: context,
              label: 'Discounts',
              description: 'Check out discounts',
              icon: Icons.local_offer,
              onTap: () {
                Navigator.of(context).pushNamed('chooseDiscount');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButton({
    required BuildContext context,
    required String label,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 35, color: AppColors.blue),
            const SizedBox(height: 10),
            Text(label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
