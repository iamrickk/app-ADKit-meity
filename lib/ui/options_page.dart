// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thefirstone/resources/auth_provider.dart';
import 'package:thefirstone/ui/admin_panel/LogInPage/log_in_page.dart';
// import 'package:thefirstone/ui/doctors_page/doctors_information_page.dart';
import 'package:thefirstone/ui/doctors_page/doctors_register_page.dart';
import 'package:thefirstone/ui/login.dart';
import 'package:thefirstone/ui/profiles.dart';
import 'package:thefirstone/ui/test_page.dart';

final _auth = FirebaseAuth.instance;

class options_page extends StatefulWidget {
  @override
  State<options_page> createState() => _options_pageState();
}

class _options_pageState extends State<options_page> {
  _getScreen() {
    // print(_auth.currentUser!.uid);
    if (_auth != null) {
      if (_auth.currentUser != null) {
        // if (!_auth.currentUser!.uid.isEmpty)
        // return DoctorsPage();
        return const Profiles();
      }
    }
    // return Profiles();
    return LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            RiverBackground(),
            Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  const Center(
                      child: Text(
                    'Role',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 8, // Adjust the elevation as needed
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the border radius as needed
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminHomePage(),
                            ));
                      },
                      child: const Text(
                        'Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: AutofillHints.addressCityAndState,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,

                        elevation: 8, // Adjust the elevation as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the border radius as needed
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _getScreen(),
                            ));
                      },
                      child: const Text(
                        'Patient',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: AutofillHints.addressCityAndState,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,

                        elevation: 8, // Adjust the elevation as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the border radius as needed
                        ),
                      ),
                      onPressed: () async {
                        if (ap.isSignedIn == true) {
                          await ap.getDataFromSP().whenComplete(
                                () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TestPage(),
                                  ),
                                ),
                              );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Doctor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: AutofillHints.addressCityAndState,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RiverBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RiverPainter(),
      size: Size.infinite,
    );
  }
}

class RiverPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // final double riverWidth = 100.0;
    final double riverHeight = size.height * 0.3;
    final double yOffset = size.height * 0.7;

    Path path = Path();
    path.moveTo(0, yOffset);
    path.cubicTo(
      size.width * 0.2,
      yOffset + riverHeight * 0.5,
      size.width * 0.8,
      yOffset - riverHeight * 0.5,
      size.width,
      yOffset,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
