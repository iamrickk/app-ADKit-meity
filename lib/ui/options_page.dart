import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thefirstone/ui/login.dart';
import 'package:thefirstone/ui/profiles.dart';


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
        return Profiles();
      }
    }
    // return Profiles();
    return LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RiverBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text('Role'
                      , style:
                  TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),)
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                      onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => _getScreen(),));
                      },
                      child: Text('Patient',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: AutofillHints.addressCityAndState,
                        letterSpacing: 2.0,
                      ),
                      ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    onPressed: (){},
                    child: Text('Doctor',
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

    final double riverWidth = 100.0;
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