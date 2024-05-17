import 'package:automate/colors.dart';
import 'package:automate/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  final User? user;

  const ServicesPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user == null ? const LoginOrRegisterPage(currentPageIndex: 2,) : _buildServiceButtons(),
    );
  }

  Widget _buildServiceButtons() {
    return Center(
      child: SizedBox(
        width: 300, // Adjust the width to fit your design
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildServiceButton(
              label: 'Workshops',
              description: 'Find and book workshops',
              icon: Icons.build,
              onTap: () {
                // Navigate to Workshops page
              },
            ),
            _buildServiceButton(
              label: 'Appointments',
              description: 'Manage your appointments',
              icon: Icons.calendar_today,
              onTap: () {
                // Navigate to Appointments page
              },
            ),
            _buildServiceButton(
              label: 'Partners',
              description: 'View our partners',
              icon: Icons.group,
              onTap: () {
                // Navigate to Partners page
              },
            ),
            _buildServiceButton(
              label: 'Discounts',
              description: 'Check out discounts',
              icon: Icons.local_offer,
              onTap: () {
                // Navigate to Discounts page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButton({
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
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600]), textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
