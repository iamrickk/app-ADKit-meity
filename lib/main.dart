import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thefirstone/ui/home.dart';
import 'ui/home.dart';
import 'ui/home.dart';
import 'ui/login.dart';
import 'ui/login.dart';
import 'utils/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
 

class _MyAppState extends State<MyApp> {

 var ins;

  @override
  void initState() {
    
    super.initState();
  }




  
 _getScreen() {

   if(FirebaseAuth.instance!=null){
     if(FirebaseAuth.instance.currentUser!=null){
       if(!FirebaseAuth.instance.currentUser.uid.isEmpty)
         return HomePage();
     }
   }

   return LoginPage();

  
   
  } 

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Example Dialogflow Flutter',
      theme: new ThemeData(
        primaryColor: Colors.white,
        accentColor: Color(0xFFFCF0E7),
      ),
      debugShowCheckedModeBanner: false,
      home: _getScreen(),
    );
  }
}
