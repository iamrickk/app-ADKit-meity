import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../resources/api.dart';

class TrendGraph extends StatefulWidget {

  const TrendGraph({
    super.key
  });

  @override
  _TrendGraphState createState() => _TrendGraphState();
}

class _TrendGraphState extends State<TrendGraph> {
  DocumentSnapshot? userData;

  @override
  void initState() {
    userData = API.profileData;
    super.initState();
  }

  int _calcAge(String dob) {
    DateTime dt = DateTime.parse(dob);
    Duration diff = DateTime.now().difference(dt);
    int age = (diff.inDays / 365).floor();
    return age;
  }

  List<FlSpot> _normalRange(int age) {
    double normalVal;
    if (age <= 5) {
      normalVal = 11;
    } else if (age > 5 && age <= 11) {
      normalVal = 11.5;
    } else if (age > 11 && age < 15) {
      normalVal = 12;
    } else {
      if (userData!['gender'] == "Female") {
        normalVal = 12;
      } else {
        normalVal = 13;
      }
    }
    return [FlSpot(1, normalVal), FlSpot(12, normalVal)];
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'J';
        break;
      case 2:
        text = 'F';
        break;
      case 3:
        text = 'M';
        break;
      case 4:
        text = 'A';
        break;
      case 5:
        text = 'M';
        break;
      case 6:
        text = 'J';
        break;
      case 7:
        text = 'J';
        break;
      case 8:
        text = 'A';
        break;
      case 9:
        text = 'S';
        break;
      case 10:
        text = 'O';
        break;
      case 11:
        text = 'N';
        break;
      case 12:
        text = 'D';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color:Color(0xff68737d),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

    String text;
    if (value % 2 != 0){
      text = value.toStringAsFixed(0);
    }
    else {
      text = '';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Card(
                    elevation: 10,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .secondary,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFBF828A), //Color(0xFFBF828A),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    AppLocalizations.of(context)!.trendGraph,
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 30,
              // ),
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.5,
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 50),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(18),
                  ),
                  // color: Color(0xff232d37),
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  // color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 24, bottom: 12),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("profiles")
                        .doc(API.current_profile_id)
                        .collection('results')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) =>
                    snapshot.hasData && userData != null
                        ? LineChart(
                      mainData(snapshot.data!.docs),
                    )
                        : const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFBF828A)),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  LineChartData mainData(List<dynamic> plotData) {
    return LineChartData(
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: Text(
            AppLocalizations.of(context)!.month,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameSize: 20,
          axisNameWidget: Text(
            '${AppLocalizations.of(context)!.haemoglobin} (gm/dl)',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 28,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
      ),

      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          if (value % 2 == 0) {
            return const FlLine(
              strokeWidth: 0,
            );
          }
          return const FlLine(
            color:  Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color:  Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      minX: 1,
      maxX: 12,
      minY: 3,
      maxY: 16,
      lineBarsData: [
        LineChartBarData(
          spots: plotData.map((data) {
            double hb_val = data['hb_val'].toDouble();
            int month = DateTime.fromMicrosecondsSinceEpoch(
                    data['time'].microsecondsSinceEpoch)
                .toLocal()
                .month;
            return FlSpot(month.toDouble(), hb_val);
          }).toList(),
          color: const Color(0xFFBF828A),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
        ),
        LineChartBarData(
          spots: _normalRange(_calcAge(userData!['dob'])),
          // isCurved: true,
          color: Colors.green,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
        ),
      ],
    );
  }
}