import 'package:automate/baseFiles/app_theme.dart';
import 'package:flutter/material.dart';

// Adding a navigation function parameter
Widget homePageServicesButton(
    BuildContext context, String title, IconData icon, void Function(String)? navigateToServices) {
  return ElevatedButton.icon(
    onPressed: () {
      if (title == 'Workshops') {
        navigateToServices?.call('chooseWorkshop'); // Call the navigation function
      } else if (title == 'Partners') {
        navigateToServices?.call('choosePartner'); // Call the navigation function
      } else if (title == 'Discounts') {
        navigateToServices?.call('chooseDiscount'); // Call the navigation function
      }
    },
    icon: Icon(icon),
    label: Text(title),
    style: ElevatedButton.styleFrom(
      alignment: const Alignment(-0.9, 0.0),
      fixedSize: Size(MediaQuery.of(context).size.width * 0.85,
          MediaQuery.of(context).size.height * 0.05),
      foregroundColor: AppColors.blue,
      backgroundColor: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    ),
  );
}
