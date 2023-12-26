import 'dart:math';
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
  List<FlSpot> nailScoreData = [];
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blueAccent,
  ];

  late Future<List<QueryDocumentSnapshot?>> values;
  late int showingTooltipSpot;
  late List<DateTime> sortedDates;
  double sliderValue = 0;
  double currentHbVal = 0.0;
  double avg = 0.0;
  double arrlen = 0.0;
  double maxScore = 0.0;
  bool showAvg = false;
  final String message = 'Slide the slidebar to get the recent test values!\n\nClick on the graph plot to know the values!';

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

  void updateNailScoreData() {
    nailScoreData = [];
    final lastFiveItems = values.then((snapshot) {
      return snapshot.take(5);
    });
    var ind = 0.0;
    var sum = 0.0;
    var maxResultNailScore = 0.0;
    lastFiveItems.then((data) {
      for (final documentSnapshot in data) {
        if (documentSnapshot != null && documentSnapshot.data() != null) {
          final data = documentSnapshot!.data() as Map<String, dynamic>?;
          final double? nailScore = data!['hb_val'] as double?;
          final testDate = DateTime.fromMillisecondsSinceEpoch(
              (data['time'] as Timestamp?)?.millisecondsSinceEpoch ?? 0);
          final formattedDate = DateFormat.yMd().format(testDate);
          String resultNailString = nailScore!.toStringAsFixed(2);
          double resultNailScore = double.parse(resultNailString);
          sum += resultNailScore;
          maxResultNailScore = max(maxResultNailScore, resultNailScore);
          nailScoreData.add(FlSpot(ind++, resultNailScore));
        }
      }
      print(nailScoreData);
      maxScore = maxResultNailScore;
      arrlen = nailScoreData.length*1.0;
      if(nailScoreData.isNotEmpty) avg = sum/nailScoreData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    updateNailScoreData();
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
                    IconButton(
                      icon:
                          const Icon(Icons.info_outline), // Use a relevant icon
                      color: Colors.blue, // Adjust color to your theme
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16.0), // Round corners
                          ),
                          backgroundColor: Colors.white, // Background color
                          elevation: 10.0, // Shadow effect
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(20.0), // Spacing
                            child: Column(
                              children: [
                                Text(
                                  'Message', // Title
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6, // Adjust font style
                                ),
                                const SizedBox(
                                    height: 10.0), // Spacing between elements
                                Text(
                                  message, // Message content
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1, // Adjust font style
                                ),
                                const SizedBox(
                                    height: 20.0), // Spacing between elements
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(
                                          context), // Cancel button
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.blue, // Neutral color
                                          
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Implement your confirm action
                                        Navigator.pop(
                                            context); // Dismiss the sheet
                                      },
                                      child: const Text(
                                        'Confirm/Proceed',
                                        style: TextStyle(
                                          color: Colors.black, // Primary color
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
                    const Text(
                      "Graph Plot",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                    ),
                    Stack(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1.30,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 8,
                              left: 43,
                              top: 5,
                              bottom: 12,
                            ),
                            child: LineChart(
                              showAvg ? avgData() : mainData(),
                            ),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showAvg = !showAvg;
                              });
                            },
                            child: Text(
                              'AVG',
                              style: TextStyle(
                                fontSize: 14,
                                color: showAvg ? Colors.greenAccent : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: Padding(
            padding: EdgeInsets.all(1.25), // Adjust the value as needed
            child: Text(
              'TIME',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        leftTitles: AxisTitles(
          axisNameSize: 20,
          axisNameWidget: Text(
            'Hb VALUES',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: arrlen-1,
      minY: maxScore*0.6,
      maxY: maxScore*1.2,
      lineBarsData: [
        LineChartBarData(
          spots: nailScoreData,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: true),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: const FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          axisNameWidget: Padding(
            padding: EdgeInsets.all(1.5), // Adjust the value as needed
            child: Text(
              'TIME',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        leftTitles: AxisTitles(
          axisNameSize: 20,
          axisNameWidget: Text(
            'Hb VALUES',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: arrlen-1,
      minY: maxScore*0.6,
      maxY: maxScore*1.2,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, avg),
            FlSpot(arrlen-1, avg),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: Colors.greenAccent, end: Colors.green)
                  .lerp(0.2)!,
              ColorTween(begin: Colors.greenAccent, end: Colors.green)
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: Colors.greenAccent, end: Colors.green)
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: Colors.greenAccent, end: Colors.green)
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
