import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      "imgLeft": 5.0,
      "imgBottom": 19.0,
      "imgHeight": 122.0,
      "imgPath": "assets/pending.png",
      "tabName": "Total Verified",
      "tabDesc": "Total Count of Verified Doctors",
      "color": Colors.deepPurpleAccent,
    },
    {
      "imgLeft": 15.0,
      "imgBottom": -8.0,
      "imgHeight": 150.0,
      "imgPath": "assets/verified.jpg",
      "tabName": "Total Pending Request",
      "tabDesc": "Top covid-19 symptoms",
      "color": Colors.teal[800],
    },
    {
      "imgPath": "assets/test1.jpg",
      "imgHeight": 140.0,
      "imgLeft": 15.0,
      "imgBottom": 0.0,
      "tabName": "Total Patients Count",
      "tabDesc": "How to prevent being a victim",
      "color": Colors.lightBlue[700],
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 0.0, 2.0, 4.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.32),
                    Text(
                      "Dashboard",
                      style: GoogleFonts.lato(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        color: Colors.blue,
                        // letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                    IconButton(
                      onPressed: () {},
                      color: Colors.blue,
                      icon: const Icon(CupertinoIcons.bell),
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
