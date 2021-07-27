import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class API {
  static String _baseURL = 'https://82ec4d5e7aac.ngrok.io/api';
  static Reference _firebaseStorageRef = FirebaseStorage.instance.ref();

  static Future<String?> processVideo(String filePath) async {
    String url = '$_baseURL/processVideo';
    print(url);

    // DocumentSnapshot userData = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .get();

    Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "URL":
            "https://firebasestorage.googleapis.com/v0/b/adkit-demo.appspot.com/o/e7_n1.mp4?alt=media&token=3e7b8ccc-219b-43cb-a4c9-8f670ad60b17",
        "AGE": "35",
        "GENDER": "0"
      }),
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body['val'].toStringAsFixed(2));

      return body['val'].toStringAsFixed(2);
    }

    return null;
  }

  static UploadTask? uploadVideo(File file) {
    try {
      var storagePath = _firebaseStorageRef.child(
          'VideoG' + new DateTime.now().millisecondsSinceEpoch.toString());
      return storagePath.putFile(file);
    } on FirebaseException catch (e) {
      print(e.message);
      return null;
    }
  }
}
