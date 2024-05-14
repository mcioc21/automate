import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatelessWidget {
  final User? user;

  const ServicesPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Services Page'),
    );
  }
}