import 'package:auth_handler/auth_handler.dart';
import 'package:flutter/material.dart';

class OTPscreen extends StatefulWidget {
  final String email;
  const OTPscreen({Key? key, required this.email, required String token}) : super(key: key);

  @override
  State<OTPscreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPscreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  AuthHandler authHandler = AuthHandler();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Handler')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(controller: emailController),
            ElevatedButton(
              onPressed: () => authHandler.sendOtp(emailController.text),
              child: const Text('Send OTP'),
            ),
            TextFormField(controller: otpController),
            ElevatedButton(
              onPressed: () async {
                bool isValid = await authHandler.verifyOtp(otpController.text);

                if (!isValid) {
                  setState(() {
                    errorMessage = 'Invalid OTP ${otpController.text}';
                  });
                }
              },
              child: const Text('Verify OTP'),
            ),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
