import 'dart:convert';
import 'package:automate/baseFiles/app_theme.dart';
import 'package:automate/baseFiles/classes/partner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnersPage extends StatelessWidget {
  const PartnersPage({super.key});

  Future<List<Partner>> loadPartners() async {
    final jsonString = await rootBundle.loadString('assets/partners.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((data) => Partner.fromJson(data)).toList();
  }

  Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Can launch returned false $url';
    }
  } catch (e) {
    debugPrint('Failed to launch URL: $e');
    throw 'Could not launch $url, Error: $e';
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child:
    Scaffold(
      appBar: AppBar(
        title: const Text("Partners"),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.snow,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Partner>>(
        future: loadPartners(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final partner = snapshot.data![index];
                return Padding(padding: const EdgeInsets.all(8.0), 
                child:
                InkWell(
                  onTap: () => _launchURL(partner.url),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      partner.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                ),
                );
              },
            );
          } else {
            return const Center(child: Text('No partners found.'));
          }
        },
      ),
    )
    );
  }
}
