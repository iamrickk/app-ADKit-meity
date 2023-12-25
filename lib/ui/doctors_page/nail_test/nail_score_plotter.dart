// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class NailScorePlotter extends StatefulWidget {
//   final String userId;
//   final String profileId;
//
//   const NailScorePlotter({
//     Key? key,
//     required this.profileId,
//     required this.userId,
//   }) : super(key: key);
//
//   @override
//   State<NailScorePlotter> createState() => _NailScorePlotterState();
// }
//
// class _NailScorePlotterState extends State<NailScorePlotter> {
//   List<Color> gradientColors = [
//     Colors.cyan,
//     Colors.blueAccent,
//   ];
//
//   late Future<List<QueryDocumentSnapshot?>> values;
//   late int showingTooltipSpot;
//   late List<DateTime> sortedDates;
//   double sliderValue = 0;
//   double currentHbVal = 0.0;
//   bool showAvg = false;
//
//   @override
//   void initState() {
//     super.initState();
//     values = fetchProfile();
//     showingTooltipSpot = -1;
//     sortedDates = [];
//   }
//
//   Future<List<QueryDocumentSnapshot?>> fetchProfile() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.userId)
//           .collection('profiles')
//           .doc(widget.profileId)
//           .collection('results')
//           .where("type", isEqualTo: 'nail')
//           .get();
//       return snapshot.docs;
//     } catch (e) {
//       print('Error fetching data: $e');
//       return [];
//     }
//   }
//
//   List<DateTime> getSortedDates(List<QueryDocumentSnapshot?> snapshotData) {
//     List<DateTime> dates = snapshotData
//         .map((doc) => DateTime.fromMillisecondsSinceEpoch(
//             (doc!['time'] as Timestamp?)?.millisecondsSinceEpoch ?? 0))
//         .toList();
//     dates.sort((a, b) => b.compareTo(a)); // Sort in descending order
//     return dates;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: const Text(
//             "All Nail Scores",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: FutureBuilder<List<QueryDocumentSnapshot?>>(
//             future: values,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Text('Error: ${snapshot.error}');
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text('No scores available.'));
//               } else {
//                 sortedDates = getSortedDates(snapshot.data!);
//                 return Column(
//                   children: [
//                     const Text(
//                       "Test Performed on : ",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.all(22.0),
//                     ),
//                     SizedBox(
//                       height: 80,
//                       child: Column(
//                         children: [
//                           Slider(
//                             value: sliderValue,
//                             onChanged: (value) {
//                               setState(() {
//                                 sliderValue = value;
//                                 if (snapshot.data != null &&
//                                     snapshot.data!.isNotEmpty) {
//                                   final index = value.toInt();
//                                   final hbVal =
//                                       (snapshot.data![index]!['hb_val']
//                                               as double?) ??
//                                           0.0;
//                                   currentHbVal = hbVal;
//                                 }
//                               });
//                             },
//                             min: 0,
//                             max: sortedDates.length.toDouble() -
//                                 1, // Adjust the max value
//                             divisions: sortedDates.length - 1,
//                             label: DateFormat('dd/MM/yyyy')
//                                 .format(sortedDates[sliderValue.toInt()]),
//                           ),
//                           Text(
//                             'Current Hb Value: ${currentHbVal.toStringAsFixed(2)}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.blueGrey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.1,
//                     ),
//                     const Text(
//                       "Graph Plot",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.all(25.0),
//                     ),
//                     AspectRatio(
//                       aspectRatio: 2,
//                       child: LineChart(
//                         LineChartData(
//                           lineBarsData: [
//                             LineChartBarData(
//                               spots:
//                                   List.generate(snapshot.data!.length, (index) {
//                                 final doc = snapshot.data![index];
//                                 final date =
//                                     DateTime.fromMillisecondsSinceEpoch(
//                                   (doc!['time'] as Timestamp?)
//                                           ?.millisecondsSinceEpoch ??
//                                       0,
//                                 );
//                                 final xValue = sortedDates
//                                         .indexOf(date)
//                                         .toDouble() +
//                                     index *
//                                         0.1; // Add a small offset to x to avoid overlapping points
//                                 final yValue =
//                                     (doc['hb_val'] as double?) ?? 0.0;
//                                 return FlSpot(xValue, yValue);
//                               }),
//                               isCurved: false,
//                               dotData: const FlDotData(show: false),
//                               color: Colors.red,
//                             ),
//                           ],
//                           borderData: FlBorderData(
//                               border: const Border(
//                                   bottom: BorderSide(), left: BorderSide())),
//                           gridData: const FlGridData(show: false),
//                           titlesData: const FlTitlesData(
//                             bottomTitles: AxisTitles(
//                               sideTitles: SideTitles(showTitles: true),
//                               axisNameSize: 20.0,
//                               drawBelowEverything: false,
//                               axisNameWidget: Text(
//                                 "Date",
//                                 textAlign: TextAlign.start,
//                                 style: TextStyle(
//                                   color: Colors.blue,
//                                   fontSize: 15.0,
//                                 ),
//                               ),
//                             ),
//                             leftTitles: AxisTitles(
//                               sideTitles: SideTitles(showTitles: false),
//                               axisNameWidget: Text(
//                                 "Hb Value",
//                                 textAlign: TextAlign.start,
//                                 style: TextStyle(
//                                   color: Colors.blue,
//                                   fontSize: 15.0,
//                                 ),
//                               ),
//                             ),
//                             topTitles: AxisTitles(
//                                 sideTitles: SideTitles(showTitles: false)),
//                             rightTitles: AxisTitles(
//                                 sideTitles: SideTitles(showTitles: false)),
//                           ),
//                           showingTooltipIndicators: showingTooltipSpot != -1
//                               ? [
//                                   ShowingTooltipIndicators([
//                                     LineBarSpot(
//                                       LineChartBarData(
//                                         spots: List.generate(
//                                             snapshot.data!.length, (index) {
//                                           final doc = snapshot.data![index];
//                                           final date = DateTime
//                                               .fromMillisecondsSinceEpoch(
//                                             (doc!['time'] as Timestamp?)
//                                                     ?.millisecondsSinceEpoch ??
//                                                 0,
//                                           );
//                                           final xValue = sortedDates
//                                                   .indexOf(date)
//                                                   .toDouble() +
//                                               index *
//                                                   0.1; // Add a small offset to x to avoid overlapping points
//                                           final yValue =
//                                               (doc['hb_val'] as double?) ?? 0.0;
//                                           return FlSpot(xValue, yValue);
//                                         }),
//                                         isCurved: false,
//                                         dotData: const FlDotData(show: false),
//                                         color: Colors.red,
//                                       ),
//                                       showingTooltipSpot,
//                                       FlSpot(
//                                         showingTooltipSpot.toDouble(),
//                                         (snapshot.data![showingTooltipSpot]![
//                                                 'hb_val'] as double?) ??
//                                             0.0,
//                                       ),
//                                     ),
//                                   ])
//                                 ]
//                               : [],
//                           lineTouchData: LineTouchData(
//                             enabled: true,
//                             touchTooltipData: LineTouchTooltipData(
//                               tooltipBgColor: Colors.blue,
//                               tooltipRoundedRadius: 20.0,
//                               fitInsideHorizontally: true,
//                               tooltipMargin: 0,
//                               getTooltipItems: (touchedSpots) {
//                                 return touchedSpots.map(
//                                   (LineBarSpot touchedSpot) {
//                                     const textStyle = TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.black,
//                                     );
//                                     return LineTooltipItem(
//                                       snapshot.data![touchedSpot.spotIndex]![
//                                               'hb_val']
//                                           .toStringAsFixed(2),
//                                       textStyle,
//                                     );
//                                   },
//                                 ).toList();
//                               },
//                             ),
//                             handleBuiltInTouches: false,
//                             touchCallback: (event, response) {
//                               if (response?.lineBarSpots != null &&
//                                   event is FlTapUpEvent) {
//                                 setState(() {
//                                   final spotIndex =
//                                       response?.lineBarSpots?[0].spotIndex ??
//                                           -1;
//                                   if (spotIndex == showingTooltipSpot) {
//                                     showingTooltipSpot = -1;
//                                   } else {
//                                     showingTooltipSpot = spotIndex;
//                                   }
//                                 });
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//

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
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blueAccent,
  ];

  late Future<List<QueryDocumentSnapshot?>> values;
  late int showingTooltipSpot;
  late List<DateTime> sortedDates;
  double sliderValue = 0;
  double currentHbVal = 0.0;
  bool showAvg = false;
  final String message = 'Slide the slidebar to get the recent test values!';

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
              color: Colors.blue,
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
                              right: 18,
                              left: 12,
                              top: 5,
                              bottom: 12,
                            ),
                            child: LineChart(
                              showAvg ? avgData() : mainData(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 34,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                showAvg = !showAvg;
                              });
                            },
                            child: Text(
                              'avg',
                              style: TextStyle(
                                fontSize: 12,
                                color: showAvg
                                    ? Colors.black.withOpacity(0.5)
                                    : Colors.black,
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    Widget text = const Text('DATE', style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '40K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
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
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 10,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 13,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
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
      lineTouchData: const LineTouchData(enabled: false),
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
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
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
