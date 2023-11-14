import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';

import 'package:thefirstone/ui/profiles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  OtpPage(this.phone);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _verificationID;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.otpVerification),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: Text(
                  '${AppLocalizations.of(context)!.verify} +91-${widget.phone}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Pinput(
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                pinAnimationType: PinAnimationType.fade,
                onCompleted: (pin) async {
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(
                      PhoneAuthProvider.credential(
                          verificationId: _verificationID!, smsCode: pin),
                    )
                        .then((value) async {
                      if (value.user != null) {
                        _checkForDetais(value.user!.uid);
                      }
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    //  _scaffoldKey.currentState
                    //  .showSnackBar(SnackBar(content: Text('Invalid OTP')));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _checkForDetais(String uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Profiles()),
                  // value.exists ? HomePage() : PersonalDetails()),
                  (route) => false)
            });
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential authCredential) async {
          await FirebaseAuth.instance
              .signInWithCredential(authCredential)
              .then((value) async {
            if (value.user != null) {
              _checkForDetais(value.user!.uid);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verID, int? forceCodeResend) {
          setState(() {
            _verificationID = verID;
          });
        },
        codeAutoRetrievalTimeout: (String verID) {
          setState(() {
            _verificationID = verID;
          });
        },
        timeout: const Duration(seconds: 10));
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }
}
