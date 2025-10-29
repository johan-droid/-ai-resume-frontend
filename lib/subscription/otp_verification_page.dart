import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:rezume_app/main.dart';
import 'subscription_page.dart'; // To get the SubscriptionPlan model

class OtpVerificationPage extends StatefulWidget {
  final SubscriptionPlan plan;
  const OtpVerificationPage({super.key, required this.plan});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final pinController = TextEditingController();
  final String dummyOtp = "123456"; // Our hardcoded "correct" OTP

  void _verifyOtp(String pin) {
    if (pin == dummyOtp) {
      // Navigate back to MainScreen, removing OTP/Payment screens
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(
            userRole: 'Organization',
            paymentSuccess: true,
          ),
        ),
        (Route<dynamic> route) => false, // Remove all previous routes
      );
    } else {
      // Show an error message if OTP is wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid OTP. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Payment'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter OTP',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                'An OTP has been sent to your registered email.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // The Pinput widget
              Pinput(
                controller: pinController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                // onCompleted: (pin) {
                //   _verifyOtp(pin); // Automatically verify on complete
                // },
              ),
              const SizedBox(height: 32),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  _verifyOtp(pinController.text);
                },
                child: const Text('Verify & Complete Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
