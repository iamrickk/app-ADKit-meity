// Import necessary packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefirstone/ui/admin_panel/LogInPage/fade_animation.dart';
import 'package:thefirstone/ui/admin_panel/LogInPage/snackbar.dart';
import 'package:thefirstone/ui/admin_panel/navbar_page.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isFull = false;

  void loginUser() async {
    try {
      String id = idController.text.trim();
      String password = passwordController.text.trim();

      if (id.isNotEmpty && password.isNotEmpty) {
        // Check if an admin with the entered credentials exists in the Firestore collection
        QuerySnapshot adminSnapshot = await _firestore
            .collection('admin')
            .where('username', isEqualTo: id)
            .where('password', isEqualTo: password)
            .get();

        print(adminSnapshot.docs);
        if (adminSnapshot.docs.isNotEmpty) {
          // Admin with the entered credentials found
          UserCredential userCredential = await _auth
              .signInWithEmailAndPassword(email: id, password: password);

          // Check if the user is an admin (you may have a specific admin role in your Firestore)
          // For simplicity, this example assumes that all users are admins
          if (userCredential.user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NavbarPage()),
            );
          } else {
            // Handle the case where the user is not an admin
            ScaffoldMessenger.of(context)
                .showSnackBar(MySnackBars.failureSnackBar);
          }
        } else {
          // Admin with the entered credentials not found
          ScaffoldMessenger.of(context)
              .showSnackBar(MySnackBars.failureSnackBar);
        }
      } else {
        // Handle the case where email or password is empty
        ScaffoldMessenger.of(context).showSnackBar(MySnackBars.incomplete);
      }
    } catch (e) {
      // Handle authentication errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.failureSnackBar);
    } finally {
      setState(() {
        isFull = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 400,
                    width: width,
                    child: FadeAnimation(
                      1,
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/background.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    height: 400,
                    width: width + 20,
                    child: FadeAnimation(
                      1,
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/background-2.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                    1,
                    Text(
                      "Hi, Admin",
                      style: GoogleFonts.lato(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeAnimation(
                    1,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(196, 135, 198, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: idController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Username",
                                labelText: "Username",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeAnimation(
                    1,
                    Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color.fromRGBO(49, 39, 79, 1),
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                if (idController.text.isNotEmpty &&
                                    passwordController.text.isNotEmpty) {
                                  loginUser();
                                  print(idController.text);
                                  print(passwordController.text);
                                  setState(() {
                                    isFull = true;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(MySnackBars.incomplete);
                                }
                              },
                              color: Colors.white,
                              icon: isFull == true
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Icon(CupertinoIcons.checkmark_alt),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeAnimation(
                    1,
                    const Center(
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color.fromRGBO(196, 135, 198, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
