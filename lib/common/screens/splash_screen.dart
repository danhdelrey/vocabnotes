import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vocabnotes/config/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      navigateTo(
        appRoute: AppRoute.lookup,
        context: context,
        replacement: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            child: Image.asset(
              "assets/images/vocabnotes_logo.png",
              height: 100,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('from'),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    "assets/images/brighttorchstudio_logo.png",
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
