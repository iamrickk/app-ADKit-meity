import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NailScoreAll extends StatefulWidget {
  final String userId;
  final String profileId;
  const NailScoreAll(
      {super.key, required this.userId, required this.profileId});

  @override
  State<NailScoreAll> createState() => _NailScoreAllState();
}

class _NailScoreAllState extends State<NailScoreAll> {
  late Future<List<QueryDocumentSnapshot?>> values;

  @override
  void initState() {
    super.initState();
    values = fetchProfile();
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
      // Handle errors, e.g., show an error message
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "All Nail Scores",
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.titleLarge,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            color: Colors.black,
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
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final dataItem =
                      snapshot.data![index]!.data() as Map<String, dynamic>?;
                  print(dataItem);

                  if (dataItem == null) {
                    // Handle the case where dataItem is null
                    return Container(); // Placeholder
                  }

                  double? hbValue = dataItem['hb_val'] as double?;
                  final testDate = DateTime.fromMillisecondsSinceEpoch(
                    (dataItem['time'] as Timestamp?)?.millisecondsSinceEpoch ??
                        0,
                  );
                  final formattedDate = DateFormat.yMd().format(testDate);
                  final formattedTime = DateFormat.jm().format(testDate);

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001 * index),
                    child: Card(
                      elevation: 4.0,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hb Value: ${hbValue?.toString() ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8.0),
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
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    ));
  }
}
