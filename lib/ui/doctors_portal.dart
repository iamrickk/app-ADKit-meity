import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
// import 'package:thefirstone/resources/api.dart';
import 'package:thefirstone/resources/auth_provider.dart';
import 'package:thefirstone/utils/snakcbar.dart';
import 'package:thefirstone/widgets/snack_bar.dart';

class doctors_portal extends StatefulWidget {
  const doctors_portal({super.key});

  @override
  State<doctors_portal> createState() => _doctors_portalState();
}

class _doctors_portalState extends State<doctors_portal> {
  final _phoneNumberController = TextEditingController();
  // final _otpController = TextEditingController();
  // Map<String, dynamic>? _userData;
  User? _currentUser;
  // bool _isVerified = false;
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
        timeout: const Duration(seconds: 100),
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

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _getUserProfiles(
      String uid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> profileQuerySnapshot =
          await FirebaseFirestore.instance
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

  static Future<void> addUserDetails(
      String userid, String profileid, String doctorId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Doctors')
          .doc(doctorId) // Assuming uid is the document ID
          .collection('User_list')
          .add({
        'user_id': userid,
        'profile_id': profileid,
        'status': "accepted",
      });

      // Check if the query returned any results
    } catch (e) {
      if (kDebugMode) {
        print('Error adding user details to the new collection: $e');
      }
    }
  }

  static Future<void> addDoctorFromuserPov(String userid, String profileid,
      String phoneNumber, String doctorId) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .collection("profiles")
          .doc(profileid)
          .collection(
              'doctor_names') // Change 'chatbot_responses' to 'doctor_names'
          .add({
        // "name": doctorNames['name'], // Store the list of doctor names
        // "speciality": doctorNames['speciality'],
        "phoneNumber": phoneNumber,
        // "email": doctorNames['email'],
        // "address": doctorNames['address'],
        // "imgpath": doctorNames['imgpath'],
        // "time": DateTime.now(),
        "uid": doctorId,
      }); // U
      // Check if the query returned any results
    } catch (e) {
      if (kDebugMode) {
        print('Error adding user details to the new collection: $e');
      }
    }
  }

  Future<bool> doesDoctorDataExist(
      String userId, String profileId, String phoneNumber) async {
    print(phoneNumber);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("profiles")
          .doc(profileId)
          .collection('doctor_names')
          .where('phoneNumber',
              isEqualTo: phoneNumber) // Check for the specific value
          .get();
      print(querySnapshot.docs);
      if (querySnapshot.docs.isNotEmpty) {
        // Documents matching the condition exist
        if (kDebugMode) {
          print("yes, we have");
        }
        return true;
      } else {
        // No documents matching the condition found
        return false;
        // print('No Gynecologist doctors found.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking doctor data: $e');
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<FirebaseAuthProvider>(context, listen: false);

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context)
                    .size
                    .width, // Adjust the width as needed
                height: MediaQuery.of(context)
                    .size
                    .height, // Adjust the height as needed
                decoration: BoxDecoration(
                  color: Colors.blue[900], // Container background color
                  //
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    Stack(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(CupertinoIcons.left_chevron),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Text(
                        "Find Patient by Phone Number",
                        style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                      child: Text(
                        "Enter Phone Number",
                        style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 14.0,
                    ),
                    Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30.0), // Adjust the corner radius
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _focusNode.unfocus();
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                cursorColor: Colors.black,
                                controller: _phoneNumberController,

                                // autofocus: true,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: "Enter Phone Number",
                                    hintText: "+911234567890",
                                    hintStyle: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _show = false;
                                        _phoneNumberController.clear();
                                        setState(() {});
                                      },
                                    )),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0), // Adjust the corner radius
                              ),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      String phoneNumber =
                                          _phoneNumberController.text;
                                      int length = phoneNumber.length;
                                      if (phoneNumber.isNotEmpty) {
                                        if (length == 13) {
                                          await _verifyPhoneNumber(phoneNumber);
                                          _show = true;
                                          _user = false;
                                        } else {
                                          showSnackBar(context,
                                              "Enter Your Valid 10 digit Number.");
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.search),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (_verificatoinId != null && _show)
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(25.0),
                            child: Pinput(
                              length: 6,
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: focusedPinTheme,
                              submittedPinTheme: submittedPinTheme,
                              showCursor: true,

                              // textStyle: const TextStyle(
                              //     fontSize: 25.0, color: Colors.white),
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
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.white,
                            ),
                            child: IconButton(
                              color: Colors.blue,
                              hoverColor: Colors.orange,
                              icon: const Icon(CupertinoIcons.checkmark_alt),
                              onPressed: () {
                                String otp = otpCode!;
                                if (otp.isNotEmpty) {
                                  _signInWithOTP(otp);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (_currentUser != null && _show && _user)
                      Center(
                        child: Text(
                          "User Details",
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (_currentUser != null && _show && _user)
                      FutureBuilder<
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                        future: _getUserProfiles(_currentUser!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            List<QueryDocumentSnapshot<Map<String, dynamic>>>?
                                userProfiles = snapshot.data;

                            if (userProfiles == null || userProfiles.isEmpty) {
                              return const Card(
                                margin: EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text("User Not Found"),
                                ),
                              );
                            }
                            List<Map<String, dynamic>> profileDataList =
                                userProfiles
                                    .map((snapshot) => snapshot.data())
                                    .toList();

                            return Expanded(
                              child: ListView.builder(
                                itemCount: profileDataList.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> profileData =
                                      profileDataList[index];
                                  // print(profileDataList[index]);
                                  print(userProfiles[index].id);
                                  return Card(
                                    elevation: 5.0,
                                    margin: const EdgeInsets.all(10.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: InkWell(
                                      child: ListTile(
                                        title: Text(
                                          "${index + 1}. Name : ${profileData['first_name']}  ${profileData['second_name']}",
                                          style: GoogleFonts.lato(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .displayLarge,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "     Date-Of-Birth: ${profileData['dob']}"),
                                            Text(
                                                "     Gender: ${profileData['gender']}"),
                                            Text(
                                                "     Current User id : ${_currentUser!.uid}"),
                                          ],
                                        ),
                                        trailing: ElevatedButton(
                                          onPressed: () async {
                                            // Your functionality here
                                            //add the user from the doctor's pov
                                            bool isDoctorDataExist =
                                                await doesDoctorDataExist(
                                                    _currentUser!.uid,
                                                    userProfiles[index].id,
                                                    ap.doctorModel.phoneNumber);
                                            print(isDoctorDataExist);
                                            if (isDoctorDataExist) {
                                              // Code to execute if doctor data exists
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  MySnackBars.createSnackBar(
                                                      // context: context,
                                                      // message: 'Added The Doctor Succesfully',
                                                      // backgroundColor: Colors.blue.shade800,
                                                      // textColor: Colors.white,
                                                      // duration: const Duration(seconds: 4),
                                                      title: "Already Added!",
                                                      message:
                                                          "This User is already Added",
                                                      contentType:
                                                          ContentType.warning));
                                              print("Doctor data exists!");

                                              // You can add your code logic here for the true case
                                            } else {
                                              // Code to execute if doctor data doesn't exist
                                              print(
                                                  "Doctor data does not exist!");
                                              addUserDetails(
                                                _currentUser!.uid,
                                                userProfiles[index].id,
                                                ap.doctorModel.uid,
                                              );
                                              // add the doctor from the user's pov
                                              addDoctorFromuserPov(
                                                _currentUser!.uid,
                                                userProfiles[index].id,
                                                ap.doctorModel.phoneNumber,
                                                ap.doctorModel.uid,
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(MySnackBars
                                                      .createSnackBar(
                                                contentType:
                                                    ContentType.success,
                                                message:
                                                    "This User Added Succesfully!",
                                                title: "Succesfully Added!",
                                              ));

                                              // You can add your code logic here for the false case
                                            }

                                            print("Button pressed!");
                                          },
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                      onTap: () {
                                        // Handle onTap event
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) => UserDetails(
                                        //         indexPt: index,
                                        //         name:
                                        //             "${profileData['first_name']} ${profileData['second_name']}",
                                        //         gender:
                                        //             "${profileData['gender']}",
                                        //         uid: _currentUser!.uid,
                                        //         dob: "${profileData['dob']}",
                                        //       ),
                                        //     ));
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
                ))
          ],
        ),
      ),
    );
  }
}
