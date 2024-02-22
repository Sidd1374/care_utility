import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadAnim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/AnimationLoadBox.json', // Replace with the path to your Lottie JSON file
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
