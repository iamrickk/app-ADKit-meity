import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class API {
  static String _baseURL = 'https://d6fe3d202f13.ngrok.io/api';

  static Future<String?> processVideo(String filePath) async {
    String url = '$_baseURL/processVideo';

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
        // 'URL': filePath,
        'URL':
            "https://firebasestorage.googleapis.com/v0/b/adkit-demo.appspot.com/o/e7_n1.mp4?alt=media&token=3e7b8ccc-219b-43cb-a4c9-8f670ad60b17",
        // 'AGE': userData['age'].toString(),
        'AGE': "35",
        // 'GENDER': userData['gender'].toString() == "Male" ? "0" : "1",
        'GENDER': "0",
      }),
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body['val'].toString());

      return body['val'];
    }

    return null;
  }
}