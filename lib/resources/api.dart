// ignore_for_file: unused_catch_clause

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:translator/translator.dart';

class API {
  static String current_profile_id = "";
  static DocumentSnapshot? profileData;
  // static String _baseURL = 'https://c72173ad250f.ngrok.io/api';
  static Reference _firebaseStorageRef = FirebaseStorage.instance.ref();

  static Future<double?> processVideo(
      String filePath, String age, String gender, String type) async {
    var coll = await FirebaseFirestore.instance.collection('API_URL').get();
    String url = type == 'nail' ? coll.docs[0]['url'] : coll.docs[1]['url'];
    print(url + " " + filePath + " " + age + " " + gender);

    Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "URL": filePath,
        "UID": FirebaseAuth.instance.currentUser!.uid,
        "AGE": age,
        "GENDER": gender
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      if (response.body.contains("<!DOCTYPE html>")) {
        return null;
      }
      var body = jsonDecode(response.body);
      if (kDebugMode) {
        print(body['val'].toStringAsFixed(2));
      }

      return body['val'];
    }

    return null;
  }

  static Future<double?> dummy() async {
    String url = "https://mocki.io/v1/c9a3b173-a44f-4293-8672-d4d063431a60";

    Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (kDebugMode) {
        print(body['val']);
      }

      return double.parse(body['val']);
    }

    return null;
  }

  static UploadTask? uploadVideo(File file) {
    try {
      var storagePath = _firebaseStorageRef.child(
          'VideoG' +  DateTime.now().millisecondsSinceEpoch.toString());
      return storagePath.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
  
  static void addResult(double hb, String type) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("profiles")
        .doc(API.current_profile_id)
        .collection('results')
        .add({
      "hb_val": hb,
      "type": type,
      "time": DateTime.now(),
    });
  }
   static void saveSubQuestionResponse(String mainQuestion, String subQuestion,
      int groupId, int selectedOption) async {
    // Formulate a key for the subquestion using main question and group ID
    String subQuestionKey = "$mainQuestion-$groupId";
    print(FirebaseAuth.instance.currentUser!.uid);
    print(API.current_profile_id);

    // Save response to Firestore under users -> profiles -> results -> user_response
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("profiles")
        .doc(API.current_profile_id)
        .collection("results")
        .add({
      "main_question": mainQuestion, // Store the main question
      "sub_question_responses": {
        subQuestionKey: selectedOption,
        // Add more subquestions as needed
      },
    });
  }

  static void addChatbotResponse(double val) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("profiles")
        .doc(API.current_profile_id)
        .collection('chatbot_responses')
        .add({
      "risk-score": val,
      "time": DateTime.now(),
    });
  }

  static void addDoctorNames(Map<String, dynamic> doctorNames) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("profiles")
        .doc(API.current_profile_id)
        .collection(
            'doctor_names') // Change 'chatbot_responses' to 'doctor_names'
        .add({
      // "name": doctorNames['name'], // Store the list of doctor names
      // "speciality": doctorNames['speciality'],
      "phoneNumber": doctorNames['phoneNumber'],
      // "email": doctorNames['email'],
      // "address": doctorNames['address'],
      // "imgpath": doctorNames['imgpath'],
      // "time": DateTime.now(),
      "uid" : doctorNames['uid'],
    }); // Use SetOptions to merge the data with existing data if any
  }
  static void addUserNames(String phoneNumber,String uid) async {
    try {
      FirebaseFirestore.instance
          .collection('Doctors')
          .doc(uid) // Assuming phone number is the document ID
          .collection('User_list')
          .add({
          'user_id' : FirebaseAuth.instance.currentUser!.uid,
          'profile_id' : API.current_profile_id,
          'status' : "pending",
      });

      // Check if the query returned any results

    } catch (e) {
      if (kDebugMode) {
        print('Error adding user details to the new collection: $e');
      }
    }
  }

  static Future<bool> doesDoctorDataExist(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("profiles")
          .doc(API.current_profile_id)
          .collection('doctor_names')
          .where('phoneNumber',
              isEqualTo: phoneNumber) // Check for the specific value
          .get();

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
  

// bool doctorExists = await doesDoctorDataExist('DoctorPhoneNumberToCheck');
// if (doctorExists) {
//   // Data for the doctor exists, you can take appropriate action here
//   print('Doctor data exists');
// } else {
//   // Data for the doctor does not exist
//   print('Doctor data does not exist');
// }

  static Stream<QuerySnapshot> doctorsList() async* {
    yield* FirebaseFirestore.instance.collection('doctors').snapshots();
  }

  static Future<String> translate(
      String message, String fromLanguageCode, String toLanguageCode) async {
    final translation = await GoogleTranslator()
        .translate(message, from: fromLanguageCode, to: toLanguageCode);

    return translation.text;
  }
}
