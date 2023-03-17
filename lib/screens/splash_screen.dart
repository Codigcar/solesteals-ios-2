import 'package:flutter/material.dart';
import 'package:solesteals/config/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _splash();
  }

  void _splash() async {
    await Future.delayed(const Duration(seconds: 4));
    appRouter.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/splash.gif');
  }
}
