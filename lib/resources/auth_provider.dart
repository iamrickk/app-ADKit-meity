import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thefirstone/utils/snakcbar.dart';

import '../model/doctorModel.dart';
import '../ui/doctors_page/doctors_otp_screen.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isloading = false;
  bool get isLoading => _isloading;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String? _uid;
  String get uid => _uid!;
  DoctorModel? _doctorModel;
  DoctorModel get doctorModel => _doctorModel!;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("isSignedIn") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // sign in with phone
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    print(phoneNumber);
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) {
          throw Exception(error.message);
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(verificationId: verificationId),
              ));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 10),
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  // verify OTP
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isloading = true;
    notifyListeners();
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;

      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
      _isloading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  //database operation
  //checking if the user exists or not

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("Doctors").doc(_uid).get();
    if (snapshot.exists) {
      print("USER EXISTS");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required DoctorModel doctorModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isloading = true;
    notifyListeners();
    try {
      // uploading the image to the firebase storage
      await storeFielToStorage("profilePic/_uid", profilePic).then((value) {
        doctorModel.profilePic = value;
        doctorModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        doctorModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
      });
      _doctorModel = doctorModel;

      // uploading to the database
      await _firebaseFirestore
          .collection("Doctors")
          .doc(_uid)
          .set(doctorModel.toMap())
          .then((value) {
        onSuccess();
        _isloading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isloading = false;
      notifyListeners();
    }
  }

  Future<String> storeFielToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getDataFromFirestore() async {
    await _firebaseFirestore
        .collection("Doctors")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _doctorModel = DoctorModel(
          address: snapshot['address'],
          email: snapshot['email'],
          firstname: snapshot['firstname'],
          phoneNumber: snapshot['phoneNumber'],
          profilePic: snapshot['profilePic'],
          secondname: snapshot['secondname'],
          speciality: snapshot['speciality'],
          uid: snapshot['uid'],
          
          );

      _uid = doctorModel.uid;
    });
  }

  // storing the data locally sharepreference
  Future saveUserDatatoSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("doctor_model", jsonEncode(doctorModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("doctor_model") ?? '';
    _doctorModel = DoctorModel.fromMap(jsonDecode(data));
    _uid = _doctorModel!.uid;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }
  static Stream<QuerySnapshot> doctorsList() async* {
    yield* FirebaseFirestore.instance.collection("Doctors").snapshots();
  }
}
