import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefirstone/ui/doctors_page/accepted_patients_profile_page.dart';

class DoctorDashboard extends StatefulWidget {
  final String? doctorId;
  const DoctorDashboard({
    super.key,
    required this.doctorId,
  });

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  Future<List<QueryDocumentSnapshot?>> fetchUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Doctors') // Root collection: "Doctors"
        .doc(widget.doctorId) // Specific Doctors's document
        .collection(
            "User_list") // Subcollection under the user document: "profiles"
        .where('status', isEqualTo: 'accepted')
        .get();
    return snapshot.docs;
  }

  late Future<List<QueryDocumentSnapshot?>> docData;
  @override
  void initState() {
    super.initState();
    docData = fetchUsers();
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
                "Accepted Patients",
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
                future: docData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error : ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text(
                      'No Patients available.',
                      style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1.0,
                          color: Colors.black),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var doctorData = snapshot.data![index]!.data()
                            as Map<String, dynamic>;

                        return Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => AcceptPatientProfile(
                              //           userId: doctorData['user_id'],
                              //           profileId: doctorData['profile_id']),
                              //     ));
                            },
                            title: FutureBuilder<Map<String, dynamic>?>(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(doctorData['user_id'])
                                  .collection('profiles')
                                  .doc(doctorData['profile_id'])
                                  .get()
                                  .then((profileSnapshot) {
                                if (profileSnapshot.exists) {
                                  return profileSnapshot.data()
                                      as Map<String, dynamic>;
                                } else {
                                  if (kDebugMode) {
                                    print('User\'s profile data not found.');
                                  }
                                  return null;
                                }
                              }).catchError((error) {
                                // Handle any errors that may occur during the Firestore query
                                if (kDebugMode) {
                                  print(
                                      'Error fetching users profile data: $error');
                                }
                                return null;
                              }),
                              builder: (context, profileSnapshot) {
                                if (profileSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const LinearProgressIndicator(
                                    minHeight: 2.0,
                                  );
                                } else if (profileSnapshot.hasError) {
                                  return Text(
                                      'Error: ${profileSnapshot.error}');
                                } else {
                                  final profileData = profileSnapshot.data;
                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AcceptPatientProfile(
                                              userId: doctorData['user_id'],
                                              profileId:
                                                  doctorData['profile_id'],
                                              name:
                                                  "${profileData?['first_name'] ?? ''}  ${profileData?['second_name'] ?? ''}",
                                            ),
                                          ));
                                    },
                                    title: Center(
                                      child: Text(
                                        "Name : ${profileData?['first_name'] ?? ''} ${profileData?['second_name'] ?? ''}",
                                        style: GoogleFonts.lato(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .displayLarge,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: 1.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Gender : ${profileData?['gender'] ?? 'Gender Not Found'}",
                                          style: GoogleFonts.lato(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: 1.0,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "DOB : ${profileData?['dob'] ?? 'DOB Not Found'}",
                                          style: GoogleFonts.lato(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: 1.0,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                        icon: const Icon(Icons.pending),
                                        color: Colors.red,
                                        iconSize:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        onPressed: () {}),
                                  );
                                  // return Column(
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //   children: [

                                  //   ],
                                  // );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
