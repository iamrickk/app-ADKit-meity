import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RiskScorePlooter extends StatefulWidget {
  final String userId;
  final String profileId;

  const RiskScorePlooter(
      {Key? key, required this.userId, required this.profileId})
      : super(key: key);

  @override
  State<RiskScorePlooter> createState() => _RiskScorePlooterState();
}

class _RiskScorePlooterState extends State<RiskScorePlooter> {
  late Future<List<QueryDocumentSnapshot?>> values;

  List<FlSpot> riskScoreData = [];
  bool showPlot = false;

  @override
  void initState() {
    super.initState();
    values = fetchProfile();
  }

  Future<List<QueryDocumentSnapshot?>> fetchProfile() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('profiles')
        .doc(widget.profileId)
        .collection('chatbot_responses')
        .orderBy('time', descending: true)
        .limit(5)
        .get();
    return snapshot.docs;
  }

  void updateRiskScoreData() {
    riskScoreData = [];
    final lastFiveItems = values.then((snapshot) {
      return snapshot.take(5);
    });
    var ind = 0.0;
    lastFiveItems.then((data) {
      for (final documentSnapshot in data) {
        if (documentSnapshot != null && documentSnapshot.data() != null) {
          final data = documentSnapshot.data() as Map<String, dynamic>?;
          final double? riskScore = data!['risk-score'] as double?;
          final testDate = DateTime.fromMillisecondsSinceEpoch(
              (data['time'] as Timestamp?)?.millisecondsSinceEpoch ?? 0);
          final formattedDate = DateFormat.yMd().format(testDate);
          riskScoreData.add(FlSpot(ind++, riskScore!));
        }
      }
      print(riskScoreData);
      setState(() {
        showPlot = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Risk Score Plot",
            style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.titleLarge,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                color: Colors.black),
          ),
        ),
        body: FutureBuilder<List<QueryDocumentSnapshot?>>(
          future: values,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No risk scores available.'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final dataItem = snapshot.data![index]!.data()
                              as Map<String, dynamic>?;

                          if (dataItem == null) {
                            // Handle the case where dataItem is null (e.g., show an error message)
                            return Container(); // Placeholder
                          }

                          double? riskScore = dataItem['risk-score'] as double?;
                          final testDate = DateTime.fromMillisecondsSinceEpoch(
                              (dataItem['time'] as Timestamp?)
                                      ?.millisecondsSinceEpoch ??
                                  0);
                          final formattedDate =
                              DateFormat.yMd().format(testDate);
                          final formattedTime =
                              DateFormat.jm().format(testDate);

                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            elevation: 4.0,
                            shadowColor: Colors.grey.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Risk Score: ${riskScore?.toString() ?? 'N/A'}",
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Text(
                                    "Test Date: ${formattedDate.toString()}",
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "Time: ${formattedTime.toString()}",
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: updateRiskScoreData,
                      child: const Text('Visualize Risk Score Plot'),
                    ),
                    Visibility(
                      visible: showPlot,
                      child: SizedBox(
                        height: 350.0,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: riskScoreData,
                                // isCurved: true,
                                dotData: const FlDotData(
                                  show: true,
                                ),
                              ),
                            ],
                            gridData: FlGridData(
                              show: true,
                              drawHorizontalLine: true,
                              drawVerticalLine: true,
                              getDrawingVerticalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 1,
                                );
                              },
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            titlesData: const FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                  axisNameSize: 20,
                                  drawBelowEverything: true,
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                  )),
                              // bottomTitle: AxisTitle(
                              //   text: 'Date',
                              //   textStyle: const TextStyle(
                              //     color: Colors.grey,
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              //   margin: 8,
                              // ),
                              leftTitles: AxisTitles(
                                  axisNameSize: 5,
                                  drawBelowEverything: false,
                                  sideTitles: SideTitles(
                                    showTitles: false,
                                  )),
                              // leftTitle: AxisTitle(
                              //   text: 'Risk Score',
                              //   textStyle: const TextStyle(
                              //     color: Colors.grey,
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              //   margin: 8,
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
