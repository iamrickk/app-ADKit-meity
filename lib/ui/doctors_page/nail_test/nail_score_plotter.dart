import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class NailScorePlotter extends StatefulWidget {
  final String userId;
  final String profileId;

  const NailScorePlotter({
    Key? key,
    required this.profileId,
    required this.userId,
  }) : super(key: key);

  @override
  State<NailScorePlotter> createState() => _NailScorePlotterState();
}

class _NailScorePlotterState extends State<NailScorePlotter> {
  late Future<List<QueryDocumentSnapshot?>> values;
  late int showingTooltipSpot;
  late List<DateTime> sortedDates;
  double sliderValue = 0;
  double currentHbVal = 0.0;

  @override
  void initState() {
    super.initState();
    values = fetchProfile();
    showingTooltipSpot = -1;
    sortedDates = [];
  }

  Future<List<QueryDocumentSnapshot?>> fetchProfile() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('profiles')
          .doc(widget.profileId)
          .collection('results')
          .where("type", isEqualTo: 'nail')
          .get();
      return snapshot.docs;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  List<DateTime> getSortedDates(List<QueryDocumentSnapshot?> snapshotData) {
    List<DateTime> dates = snapshotData
        .map((doc) => DateTime.fromMillisecondsSinceEpoch(
            (doc!['time'] as Timestamp?)?.millisecondsSinceEpoch ?? 0))
        .toList();
    dates.sort((a, b) => b.compareTo(a)); // Sort in descending order
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "All Nail Scores",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder<List<QueryDocumentSnapshot?>>(
            future: values,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No scores available.'));
              } else {
                sortedDates = getSortedDates(snapshot.data!);
                return Column(
                  children: [
                    const Text(
                      "Test Performed on : ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(22.0),
                    ),
                    SizedBox(
                      height: 80,
                      child: Column(
                        children: [
                          Slider(
                            value: sliderValue,
                            onChanged: (value) {
                              setState(() {
                                sliderValue = value;
                                if (snapshot.data != null &&
                                    snapshot.data!.isNotEmpty) {
                                  final index = value.toInt();
                                  final hbVal =
                                      (snapshot.data![index]!['hb_val']
                                              as double?) ??
                                          0.0;
                                  currentHbVal = hbVal;
                                }
                              });
                            },
                            min: 0,
                            max: sortedDates.length.toDouble() -
                                1, // Adjust the max value
                            divisions: sortedDates.length - 1,
                            label: DateFormat('dd/MM/yyyy')
                                .format(sortedDates[sliderValue.toInt()]),
                          ),
                          Text(
                            'Current Hb Value: ${currentHbVal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    AspectRatio(
                      aspectRatio: 2,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              spots:
                                  List.generate(snapshot.data!.length, (index) {
                                final doc = snapshot.data![index];
                                final date =
                                    DateTime.fromMillisecondsSinceEpoch(
                                  (doc!['time'] as Timestamp?)
                                          ?.millisecondsSinceEpoch ??
                                      0,
                                );
                                final xValue = sortedDates
                                        .indexOf(date)
                                        .toDouble() +
                                    index *
                                        0.1; // Add a small offset to x to avoid overlapping points
                                final yValue =
                                    (doc['hb_val'] as double?) ?? 0.0;
                                return FlSpot(xValue, yValue);
                              }),
                              isCurved: false,
                              dotData: const FlDotData(show: false),
                              color: Colors.red,
                            ),
                          ],
                          borderData: FlBorderData(
                              border: const Border(
                                  bottom: BorderSide(), left: BorderSide())),
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                              axisNameSize: 20.0,
                              drawBelowEverything: false,
                              axisNameWidget: Text(
                                "Date",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                              axisNameWidget: Text(
                                "Hb Value",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          showingTooltipIndicators: showingTooltipSpot != -1
                              ? [
                                  ShowingTooltipIndicators([
                                    LineBarSpot(
                                      LineChartBarData(
                                        spots: List.generate(
                                            snapshot.data!.length, (index) {
                                          final doc = snapshot.data![index];
                                          final date = DateTime
                                              .fromMillisecondsSinceEpoch(
                                            (doc!['time'] as Timestamp?)
                                                    ?.millisecondsSinceEpoch ??
                                                0,
                                          );
                                          final xValue = sortedDates
                                                  .indexOf(date)
                                                  .toDouble() +
                                              index *
                                                  0.1; // Add a small offset to x to avoid overlapping points
                                          final yValue =
                                              (doc['hb_val'] as double?) ?? 0.0;
                                          return FlSpot(xValue, yValue);
                                        }),
                                        isCurved: false,
                                        dotData: const FlDotData(show: false),
                                        color: Colors.red,
                                      ),
                                      showingTooltipSpot,
                                      FlSpot(
                                        showingTooltipSpot.toDouble(),
                                        (snapshot.data![showingTooltipSpot]![
                                                'hb_val'] as double?) ??
                                            0.0,
                                      ),
                                    ),
                                  ])
                                ]
                              : [],
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.blue,
                              tooltipRoundedRadius: 20.0,
                              fitInsideHorizontally: true,
                              tooltipMargin: 0,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map(
                                  (LineBarSpot touchedSpot) {
                                    const textStyle = TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    );
                                    return LineTooltipItem(
                                      snapshot.data![touchedSpot.spotIndex]![
                                              'hb_val']
                                          .toStringAsFixed(2),
                                      textStyle,
                                    );
                                  },
                                ).toList();
                              },
                            ),
                            handleBuiltInTouches: false,
                            touchCallback: (event, response) {
                              if (response?.lineBarSpots != null &&
                                  event is FlTapUpEvent) {
                                setState(() {
                                  final spotIndex =
                                      response?.lineBarSpots?[0].spotIndex ??
                                          -1;
                                  if (spotIndex == showingTooltipSpot) {
                                    showingTooltipSpot = -1;
                                  } else {
                                    showingTooltipSpot = spotIndex;
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
