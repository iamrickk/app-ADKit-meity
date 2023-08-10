import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:thefirstone/ui/doctors_page/doctors_profile.dart';
import 'package:thefirstone/ui/doctors_page/user_details.dart';
import 'package:thefirstone/ui/options_page.dart';
import 'package:thefirstone/utils/snakcbar.dart';

import '../resources/auth_provider.dart';

class doctors_portal extends StatefulWidget {
  const doctors_portal({super.key});

  @override
  State<doctors_portal> createState() => _doctors_portalState();
}

class _doctors_portalState extends State<doctors_portal> {
  final _phoneNumberController = TextEditingController();
  final _otpController = TextEditingController();
  Map<String, dynamic>? _userData;
  User? _currentUser;
  bool _isVerified = false;
  String? _verificatoinId;
  final FocusNode _focusNode = FocusNode();
  bool _show = false;
  String? otpCode;
  bool _user = false;

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithCredential(phoneAuthCredential);
          setState(() {
            _currentUser = userCredential.user;
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          print('Phone number verification failed: ${error.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Handle code sent
          setState(() {
            _verificatoinId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle auto retrieval timeout
        },
        timeout: const Duration(seconds: 40),
      );
    } catch (e) {
      print('Error verifying phone number: $e');
    }
  }

  Future<void> _signInWithOTP(String otp) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificatoinId!,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      setState(() {
        _currentUser = FirebaseAuth.instance.currentUser;
        _user = true;
      });
    } catch (e) {
      print('Error signing in with OTP: $e');
    }
  }

  // Future<Map<String, dynamic>?> _getUserProfile(String uid) async {
  //   try {
  //     QuerySnapshot profileQuerySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(uid)
  //         .collection('profiles')
  //         .get();
  //
  //     if (profileQuerySnapshot.docs.isEmpty) {
  //       print('User profile not found');
  //       return null; // User's profile not found
  //     }
  //
  //     DocumentSnapshot profileSnapshot = profileQuerySnapshot.docs[1]; // Access the first document
  //     final data = profileSnapshot.data();
  //     print('Retrieved data: $data');
  //
  //     if (data is Map<String, dynamic>) {
  //       return data;
  //     } else {
  //       print('Error: Data is not in the expected format');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching user profile: $e');
  //     return null;
  //   }
  // }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _getUserProfiles(String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> profileQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('profiles')
          .get();

      return profileQuerySnapshot.docs;
    } catch (e) {
      print('Error fetching user profiles: $e');
      return [];
    }
  }




  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final BoxDecoration pinPutDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.white,
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Row(
                    children: [
                      // IconButton(
                      //   icon: const Icon(CupertinoIcons.left_chevron),
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                      //   color: Colors.black,
                      // ),4
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          "Hi, ${ap.doctorModel.firstname}",
                          style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              color: Colors.deepPurple),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.22,
                      ),
                      InkWell(
                        onTap: () {
                          // print('Hello');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DoctorProfile()));
                        }, // Call the function when tapped
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              ap.doctorModel.profilePic), // Your profile image
                          radius: 18.0,
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        radius: 18,
                        child: IconButton(
                            onPressed: () {
                              ap.userSignOut().then((value) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => options_page()),
                                      (Route<dynamic> route) => false,
                                );
                              });
                            },
                            icon: Icon(CupertinoIcons.arrow_right_square)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Container(
                          width: MediaQuery.of(context)
                              .size
                              .width, // Adjust the width as needed
                          height: MediaQuery.of(context).size.height *
                              0.8, // Adjust the height as needed
                          decoration: const BoxDecoration(
                            color: Colors.lightBlue, // Container background color
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20), // Top-left corner
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight:
                                  Radius.circular(20), // Top-right corner
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 14.0,
                              ),
                              Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0), // Adjust the corner radius
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    _focusNode.unfocus();
                                  },
                                  child: TextFormField(
                                    
                                    cursorColor: Colors.black,
                                    controller: _phoneNumberController,

                                    // autofocus: true,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        labelText: "Search by Phone Number",
                                        hintText: "+911234567890",
                                        hintStyle: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                        prefixIcon: Icon(Icons.search),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            _show = false;
                                            _phoneNumberController.clear();
                                            setState(() {});
                                          },
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Center(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0), // Adjust the corner radius
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: IconButton(
                                      onPressed: () async{
                                        String phoneNumber =
                                            _phoneNumberController.text;
                                        int length = phoneNumber.length;
                                        if (phoneNumber.isNotEmpty) {
                                          if(length == 13){
                                            await _verifyPhoneNumber(phoneNumber);
                                            _show = true;
                                            _user = false;
                                          }
                                          else{
                                            showSnackBar(context, "Enter Your Valid 10 digit Number.");
                                          }

                                        }

                                      },
                                      icon: const Icon(Icons.search),
                                    )
                                  ),
                                ),
                              ),
                              if (_verificatoinId != null && _show)
                                Column(
                                  children: [
                                    // TextField(
                                    //   controller: _otpController,
                                    //   decoration: const InputDecoration(
                                    //       labelText: "Enter OTP"),
                                    // ),
                                    Container(
                                      padding: EdgeInsets.all(25.0),
                                      child: PinPut(
                                        fieldsCount: 6,
                                        textStyle: const TextStyle(
                                            fontSize: 25.0, color: Colors.white),
                                        eachFieldWidth: 40.0,
                                        eachFieldHeight: 55.0,
                                        submittedFieldDecoration: pinPutDecoration,
                                        selectedFieldDecoration: pinPutDecoration,
                                        followingFieldDecoration: pinPutDecoration,
                                        pinAnimationType: PinAnimationType.fade,
                                        onSubmit: (value) {
                                          setState(() {
                                            otpCode = value;
                                          });
                                          print(otpCode);
                                        },
                                      ),
                                    ),
                                    Container(

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.0),
                                        color: Colors.white,
                                      ),
                                      child: IconButton(
                                        color: Colors.blue,
                                        hoverColor: Colors.orange,
                                        icon: Icon(CupertinoIcons.checkmark_alt),
                                        onPressed: (){
                                          String otp = otpCode!;
                                          if (otp.isNotEmpty) {
                                            _signInWithOTP(otp);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 10.0,),
                              if (_currentUser != null && _show && _user)
                                // FutureBuilder(
                                //   future: _getUserProfiles(_currentUser!.uid),
                                //   builder: (context, snapshot) {
                                //     if (snapshot.connectionState ==
                                //         ConnectionState.waiting) {
                                //       return const Center(
                                //         child:  CircularProgressIndicator(
                                //           color: Colors.purple,
                                //         ),
                                //       );
                                //     } else if (snapshot.hasError) {
                                //       return Text("Error: ${snapshot.error}");
                                //     } else {
                                //       // _userData =
                                //       //     snapshot.data as Map<String,dynamic>?;
                                //       List<QueryDocumentSnapshot<Map<String, dynamic>?>?>? userProfiles = snapshot.data;
                                //
                                //
                                //
                                //       // print(_userData);
                                //       print("Rick");
                                //       // List<Map<String, dynamic>> userProfiles = snapshot.data!;
                                //       if (_userData != null) {
                                //         return Card(
                                //           elevation: 5.0,
                                //           margin: const EdgeInsets.all(10.0),
                                //           shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(20.0), // Adjust the corner radius
                                //           ),
                                //           child: InkWell(
                                //             child: ListTile(
                                //               title: Center(
                                //                 child: Text("User Details",
                                //                   style: GoogleFonts.lato(
                                //                       textStyle: Theme.of(context)
                                //                           .textTheme
                                //                           .displayLarge,
                                //                       fontSize: 18,
                                //                       fontWeight: FontWeight.w400,
                                //                       fontStyle: FontStyle.normal,
                                //                       color: Colors.black),
                                //                 ),
                                //               ),
                                //               subtitle: Column(
                                //                 crossAxisAlignment:
                                //                     CrossAxisAlignment. center,
                                //                 children: [
                                //                   Text(
                                //                       "First Name: ${_userData['first_name']}"),
                                //                   Text(
                                //                       "Last Name: ${_userData['second_name']}"),
                                //                   Text(
                                //                       "Date-Of-Birth: ${_userData['dob']}"),
                                //                   Text("Phone Number: ${_phoneNumberController.text}"),
                                //
                                //                 ],
                                //               ),
                                //             ),
                                //             onTap: (){
                                //
                                //             },
                                //           ),
                                //         );
                                //       } else {
                                //         return  const Card(
                                //           margin:  EdgeInsets.all(10),
                                //           child: ListTile(
                                //             title: Text("User Not Found"),
                                //           ),
                                //         );
                                //       }
                                //     }
                                //   },
                                // )
                                FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                                  future: _getUserProfiles(_currentUser!.uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.purple,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else {
                                      List<QueryDocumentSnapshot<Map<String, dynamic>>>? userProfiles = snapshot.data;

                                      if (userProfiles == null || userProfiles.isEmpty) {
                                        return const Card(
                                          margin: EdgeInsets.all(10),
                                          child: ListTile(
                                            title: Text("User Not Found"),
                                          ),
                                        );
                                      }

                                      // Convert List<QueryDocumentSnapshot> to List<Map<String, dynamic>>
                                      List<Map<String, dynamic>> profileDataList = userProfiles
                                          .map((snapshot) => snapshot.data() as Map<String, dynamic>)
                                          .toList();

                                      return Expanded(
                                        child: ListView.builder(
                                          itemCount: profileDataList.length,
                                          itemBuilder: (context, index) {
                                            Map<String, dynamic> profileData = profileDataList[index];

                                            return Card(
                                              elevation: 5.0,
                                              margin: const EdgeInsets.all(10.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                              child: InkWell(
                                                child: ListTile(
                                                  title: Center(
                                                    child: Text(
                                                      "User Details",
                                                      style: GoogleFonts.lato(
                                                        textStyle: Theme.of(context).textTheme.displayLarge,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w400,
                                                        fontStyle: FontStyle.normal,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text("Patient Number : ${index+1}"),
                                                      Text("First Name: ${profileData['first_name']}"),
                                                      Text("Last Name: ${profileData['second_name']}"),
                                                      Text("Date-Of-Birth: ${profileData['dob']}"),
                                                      Text("Phone Number: ${_phoneNumberController.text}"),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  // Handle onTap event
                                                    Navigator.push(context,MaterialPageRoute(builder: (context) => userDetails(indexPt: index),));
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                )
                            ],
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
