import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:provider/provider.dart';
import 'package:thefirstone/ui/doctors_page/doctors_information_page.dart';
import 'package:thefirstone/ui/options_page.dart';

import 'package:thefirstone/ui/test_page.dart';

import '../../resources/auth_provider.dart';
import '../../utils/snakcbar.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
//   final defaultPinTheme = PinTheme(
//   width: 56,
//   height: 56,
//   textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
//   decoration: BoxDecoration(
//     border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
//     borderRadius: BorderRadius.circular(20),
//   ),
// );
  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<FirebaseAuthProvider>(context, listen: true).isLoading;
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
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Container(
                      width: 200,
                      height: 200,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple.shade50,
                      ),
                      child: Image.asset(
                        "assets/login.png",
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Verification",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Enter the OTP send to your phone number",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Pinput(
                    //   length: 6,
                    //   showCursor: true,
                    //   defaultPinTheme: PinTheme(
                    //     width: 60,
                    //     height: 60,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       border: Border.all(
                    //         color: Colors.purple.shade200,
                    //       ),
                    //     ),
                    //     textStyle: const TextStyle(
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    //   onCompleted: (value) {
                    //     setState(() {
                    //       otpCode = value;
                    //     });
                    //   },
                    // ),
                    Container(
                      padding: const EdgeInsets.all(25.0),
                      child: Pinput(
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        showCursor: true,
                        // textStyle: const TextStyle(
                        //     fontSize: 25.0, color: Colors.black),
                        // eachFieldWidth: 40.0,
                        // eachFieldHeight: 55.0,
                        // submittedFieldDecoration: pinPutDecoration,
                        // selectedFieldDecoration: pinPutDecoration,
                        // followingFieldDecoration: pinPutDecoration,
                        pinAnimationType: PinAnimationType.fade,
                        onCompleted: (value) {
                          setState(() {
                            otpCode = value;
                          });
                          print(otpCode);
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xff4c505b),
                        child: IconButton(
                          icon: const Icon(
                            CupertinoIcons.checkmark_alt,
                          ),
                          highlightColor: Colors.amberAccent,
                          onPressed: () {
                            if (otpCode != null) {
                              verifyOtp(context, otpCode!);
                            } else {
                              showSnackBar(context, "Enter 6-Digit code");
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Didn't receive any code?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Resend New Code",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // verify otp
  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<FirebaseAuthProvider>(context, listen: false);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () async {
        // checking whether user exists in the database
        ap.checkExistingUser().then(
          (userExists) {
            // print('User exists: $userExists');
            if (userExists) {
              // User exists in our app
              ap.getDataFromFirestore().then(
                (userData) {
                  // print('User data: $userData!');
                  // print("${userData.pending}");
                  bool isPending = userData.pending;
                  // print('Is pending: $isPending');
                  if (isPending) {
                    // Show a dialog indicating that the submission is under process
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Submission Under Process'),
                          content: const Text(
                            'Your submission is under process. We will contact you soon.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => options_page(),
                                    ),
                                    (route) => false);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Navigate to the TestPage
                    ap.saveUserDatatoSP().then(
                          (value) => ap.setSignIn().then(
                                (value) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TestPage(),
                                  ),
                                  (route) => false,
                                ),
                              ),
                        );
                    // print("yes i am");
                  }
                },
              );
            } else {
              // New user
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const doctorsInformation(),
                ),
                (route) => false,
              );
            }
          },
        );
      },
    );
  }
}
