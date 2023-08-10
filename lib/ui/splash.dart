import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thefirstone/ui/login.dart';
import 'package:thefirstone/ui/options_page.dart';
import 'package:thefirstone/ui/profiles.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => options_page(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 6, 9, 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset('assets/login.png'),
            ),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                      text: 'AD',
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: AutofillHints.countryCode,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 5.0,
                          color: Colors.white)),
                  TextSpan(
                      text: 'kit',
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: AutofillHints.countryCode,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 5.0,
                          color: Colors.redAccent)),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}
