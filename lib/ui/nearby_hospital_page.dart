import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/MapUtils.dart';
import '../utils/current_location.dart';

class nearby_hospital extends StatefulWidget {
  const nearby_hospital({Key? key}) : super(key: key);

  @override
  State<nearby_hospital> createState() => _nearby_hospitalState();
}

String currLoc = "";
var details = [];
String date_time = "", address = "";
var loc = [];

class _nearby_hospitalState extends State<nearby_hospital> {
  @override
  void initState() {
    super.initState();
    currentLoc();
  }

  Widget build(BuildContext context) {
    currentLoc();

    try {
      loc[0];
    } catch (e) {
      currentLoc();
    }
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                child: Text(AppLocalizations.of(context)!.nearbyHospitals,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),),
                //alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(25),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Container(
              // margin: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.2,
              color: const Color(0xFFBF828A),
              // width: MediaQuery.of(context).size.height * 0.5,
              // decoration: BoxDecoration(
              //     color: Colors.orange,
              //     borderRadius: BorderRadius.circular(10)),
              child: ElevatedButton(
                child: const Text(
                  "See nearby hospitals in GMap",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  currentLoc();

                  date_time = currLoc.split("{}")[0];
                  address = currLoc.split("{}")[2];
                  loc = currLoc.split("{}")[1].split(" , ");
                  setState(() {
                    currLoc;
                    date_time;
                    address;
                    loc;
                  });

                  MapUtils.openMap(
                      double.parse(loc[0]!), double.parse(loc[1]!));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void currentLoc() async {
    currLoc = await getLoc();
    date_time = currLoc.split("{}")[0];
    address = currLoc.split("{}")[2];
    loc = currLoc.split("{}")[1].split(" , ");
  }
}
