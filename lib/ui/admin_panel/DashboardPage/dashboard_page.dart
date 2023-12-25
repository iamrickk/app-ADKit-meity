import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefirstone/ui/options_page.dart';

import 'category_tab.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static AutoSizeGroup titleGrp = AutoSizeGroup();
  static AutoSizeGroup descGrp = AutoSizeGroup();
  static List<Map<String, dynamic>> categoryData = [
    {
      "imgLeft": 15.0,
      "imgBottom": -8.0,
      "imgHeight": 150.0,
      "imgPath": "assets/verified.jpg",
      "tabName": "Total Pending Request",
      "tabDesc": "Total Count of Pending Doctors",
      "color": Colors.teal[800],
    },
    {
      "imgLeft": 5.0,
      "imgBottom": 19.0,
      "imgHeight": 122.0,
      "imgPath": "assets/pending.png",
      "tabName": "Total Verified",
      "tabDesc": "Total Count of Verified Doctors",
      "color": Colors.deepPurpleAccent,
    },
    {
      "imgPath": "assets/test1.jpg",
      "imgHeight": 140.0,
      "imgLeft": 15.0,
      "imgBottom": 0.0,
      "tabName": "Total Patients Count",
      "tabDesc": "Total Patients Registered",
      "color": Colors.lightBlue[700],
    },
  ];
  List<String> value = [];
  int pendingDoctorCount = 0;
  int nonPendingDoctorCount = 0;
  int userCount = 0;
  @override
  void initState() {
    super.initState();
    countPendingAndNonPendingDoctors();
  }

  Future<void> countPendingAndNonPendingDoctors() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference doctorsRef = firestore.collection('Doctors');
    final CollectionReference userRef = firestore.collection("users");

    // Count pending doctors
    final pendingDoctorsQuery = doctorsRef.where('pending', isEqualTo: true);
    final pendingDoctorsSnapshot = await pendingDoctorsQuery.get();
    pendingDoctorCount = pendingDoctorsSnapshot.size;
    value.add(pendingDoctorCount.toString());

    // Count non-pending doctors
    final nonPendingDoctorsQuery =
        doctorsRef.where('pending', isEqualTo: false);
    final nonPendingDoctorsSnapshot = await nonPendingDoctorsQuery.get();
    nonPendingDoctorCount = nonPendingDoctorsSnapshot.size;
    value.add(nonPendingDoctorCount.toString());
    print(nonPendingDoctorCount);

    final countUserSnapshot = await userRef.get();
    userCount = countUserSnapshot.size;
    value.add(userCount.toString());

    // value.add("Rick");
    setState(() {}); // Update the UI
  }

  @override
  Widget build(BuildContext context) {
    return value.length != 3
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 0.0, 2.0, 4.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.31),
                          Text(
                            "Dashboard",
                            style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.blue,
                              // letterSpacing: 2.0,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05),
                          IconButton(
                            onPressed: () {},
                            color: Colors.blue,
                            icon: const Icon(CupertinoIcons.bell),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02),
                          IconButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => options_page(),
                                  ));
                            },
                            color: Colors.blue,
                            icon: const Icon(CupertinoIcons.arrow_right_square),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          var cat = categoryData[index];
                          return CategoryTab(
                            titleGrp: titleGrp,
                            descGrp: descGrp,
                            imgPath: cat["imgPath"],
                            imgBottom: cat["imgBottom"],
                            imgHeight: cat["imgHeight"],
                            imgLeft: cat["imgLeft"],
                            tabDesc: cat["tabDesc"],
                            tabName: cat["tabName"],
                            color: cat["color"],
                            // index : index,
                            count: value[index],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
