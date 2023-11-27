import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefirstone/ui/doctors_page/nail_test/nail_score_all.dart';
import 'package:thefirstone/ui/doctors_page/nail_test/nail_score_plotter.dart';
import 'package:thefirstone/ui/doctors_page/palm_test/palm_score_all.dart';
import 'package:thefirstone/ui/doctors_page/palm_test/palm_score_plotter.dart';
import 'package:thefirstone/ui/doctors_page/risk_score/risk_score_all.dart';
import 'package:thefirstone/ui/doctors_page/risk_score/risk_score_plotter.dart';

class AcceptPatientProfile extends StatefulWidget {
  final String userId;
  final String profileId;
  final String name;
  final String dob;
  final String sex;

  const AcceptPatientProfile(
      {Key? key,
      required this.userId,
      required this.profileId,
      required this.name,
      required this.sex,
      required this.dob})
      : super(key: key);

  @override
  _AcceptPatientProfileState createState() => _AcceptPatientProfileState();
}

class GridItem {
  final String title;
  final String content;
  final int index;

  const GridItem({
    required this.title,
    required this.content,
    required this.index,
  });
}

class ListData {
  final String title;
  final List<GridItem> items;

  const ListData({
    required this.title,
    required this.items,
  });
}

class _AcceptPatientProfileState extends State<AcceptPatientProfile> {
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = getPages();
    print(pages);
  }

  int _calcAge(String dob) {
    DateTime dt = DateTime.parse(dob);
    Duration diff = DateTime.now().difference(dt);

    int age = (diff.inDays / 365).floor();

    return age;
  }

  List<Widget> getPages() {
    return [
      RiskScoreAll(profileId: widget.profileId, userId: widget.userId),
      RiskScorePlooter(profileId: widget.profileId, userId: widget.userId),
      PalmScoreAll(profileId: widget.profileId, userId: widget.userId),
      PalmScorePlotter(profileId: widget.profileId, userId: widget.userId),
      NailScoreAll(profileId: widget.profileId, userId: widget.userId),
      NailScorePlotter(profileId: widget.profileId, userId: widget.userId),
    ];
  }

  final List<ListData> _listData = [
    const ListData(title: 'Risk Score', items: [
      GridItem(
          title: 'Risk Score Results',
          content: 'See all the results of user',
          index: 0),
      GridItem(
          title: 'Visualize',
          content: 'See the plotted graph with data',
          index: 1),
    ]),
    const ListData(title: 'Palm Test', items: [
      GridItem(
          title: 'Palm Test Results',
          content: 'See all the results of user',
          index: 2),
      GridItem(
          title: 'Visualize',
          content: 'See the plotted graph with data',
          index: 3),
    ]),
    const ListData(title: 'Nail Test', items: [
      GridItem(
          title: 'Nail Test Results',
          content: 'See all the results of user',
          index: 4),
      GridItem(
          title: 'Visualize',
          content: 'See the plotted graph with data',
          index: 5),
    ]),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Test Results'),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${widget.name}',
                          style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.0,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          'Gender: ${widget.sex}',
                          style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.0,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          'Date of Birth: ${widget.dob}',
                          style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.0,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "Age : ${_calcAge(widget.dob).toString()}",
                          style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.0,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _listData.length,
                itemBuilder: (context, index) {
                  final listData = _listData[index];
                  print(pages[index]);
                  print(_listData.length);
                  print(index);

                  return Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 4.0,
                          offset: const Offset(0.0, 2.0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listData.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          children: listData.items
                              .map((item) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  pages[item.index]));
                                      print(item.index);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(8.0),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        color: Colors.blue.shade300,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            item.content,
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
