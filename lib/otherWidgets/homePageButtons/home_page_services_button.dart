import 'package:automate/app_theme.dart';
import 'package:flutter/material.dart';

Widget homePageServicesButton(
    BuildContext context, String title, IconData icon) {
  return ElevatedButton.icon(
    onPressed: () {
      if(title == 'Workshops') {
        // Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => const WorkshopsPage()),
        //           );
      } else if(title == 'Partners') {
        // Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => const PartnersPage()),
        //           );
      } else if(title == 'Discounts') {
        // Navigator.push(
        //             context,
        //             MaterialPageRoute(builder: (context) => const DiscountsPage()),
        //           );
      }
    },
    icon: Icon(icon),
    label: Text(title),
    style: ElevatedButton.styleFrom(
      alignment: const Alignment(-0.9, 0.0), // Align text to the
      fixedSize: Size(MediaQuery.of(context).size.width * 0.85,
          MediaQuery.of(context).size.height * 0.05),
      foregroundColor: AppColors.blue,
      backgroundColor: Colors.grey[300], // Text color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    ),
  );
}
