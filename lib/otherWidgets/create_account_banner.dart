import 'package:automate/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:automate/register.dart';

class AccountWarningBanner extends StatefulWidget {
  final Function(bool)? onDismiss; // Callback for handling visibility state externally if needed

  const AccountWarningBanner({super.key, this.onDismiss});

  @override
  _AccountWarningBannerState createState() => _AccountWarningBannerState();
}

class _AccountWarningBannerState extends State<AccountWarningBanner> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink(); // Do not render anything if not visible

    return Container(
      decoration: BoxDecoration(
        color: Colors.pink[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch the column to take full width
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "We recommend creating an account to keep all your data saved.",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _isVisible = false;
                  });
                  if (widget.onDismiss != null) widget.onDismiss!(_isVisible);
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0), // Add padding above the button for spacing
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.snow),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                maximumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 60)),
              ),
              child: const Text("Create Account", style: TextStyle(fontWeight: FontWeight.bold),)
            ),
          ),
        ],
      ),
    );
  }
}
