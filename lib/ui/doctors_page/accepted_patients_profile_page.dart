import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AcceptPatientProfile extends StatefulWidget {
  final String userId;
  final String profileId;
  final String name;
  const AcceptPatientProfile({
    super.key,
    required this.userId,
    required this.profileId,
    required this.name,
  });

  @override
  State<AcceptPatientProfile> createState() => _AcceptPatientProfileState();
}

class _AcceptPatientProfileState extends State<AcceptPatientProfile> {
  Future<List<QueryDocumentSnapshot?>> fetchProfile() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users') // Root collection: "Doctors"
        .doc(widget.userId) // Specific Doctors's document
        .collection('profiles')
        .doc(widget.profileId)
        .collection('chatbot_responses')
        .orderBy('time', descending: true)
        .get();
    return snapshot.docs;
  }

  late Future<List<QueryDocumentSnapshot?>> values;

  @override
  void initState() {
    super.initState();
    values = fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          const SizedBox(
            height: 15.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.name,
              style: GoogleFonts.lato(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: FutureBuilder<List<QueryDocumentSnapshot?>>(
                future: values,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No doctors available.');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var patientData = snapshot.data![index]!.data()
                            as Map<String, dynamic>;
                        DateTime now = patientData['time'].toDate();
                        return Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(
                                "Risk-Score : ${patientData['risk-score']}"),
                            subtitle: Text("Test on : ${now.toString()}"),
                          ),
                        );
                      },
                    );
                  }
                }),
          )
        ],
      )),
    );
  }
}
