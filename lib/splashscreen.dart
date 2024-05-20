import 'package:flutter/material.dart';
import 'package:mediscan/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 265,
            ),
            const SizedBox(height: 31),
            const Text(
              'MediScan',
              style: TextStyle(
                color: mainColor,
                fontFamily: 'Inter900',
                fontSize: 36,
              ),
            ),
            const SizedBox(height: 38),
            Image.asset(
              'assets/images/login.png',
              width: 220,
            ),
          ],
        ),
      ),
    );
  }
}
