import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefirstone/ui/doctors_page/patient_page_doctor_view.dart';

class RequestPage extends StatefulWidget {
  final String? doctorId;
  const RequestPage({
    super.key,
    required this.doctorId,
  });

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  Future<List<QueryDocumentSnapshot?>> fetchUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Doctors') // Root collection: "Doctors"
        .doc(widget.doctorId) // Specific Doctors's document
        .collection(
            "User_list") // Subcollection under the user document: "profiles"
        .where('status', isEqualTo: 'pending')
        .get();
    return snapshot.docs;
  }

  void _showAddPatientAlert(BuildContext context, String profileid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Patient"),
          content: const Text("Do you want to add the patient?"),
          actions: [
            TextButton(
              onPressed: () async {
                // Add your logic for 'Yes' button press
                Navigator.of(context).pop(); // Close the alert box
                try {
                  // Assuming you have the patient's document ID and doctor's ID
                  // String patientDocId = "YOUR_PATIENT_DOCUMENT_ID";
                  // String doctorId = "YOUR_DOCTOR_ID";
                  print(profileid);
                  print(widget.doctorId);
                  // Get the reference to the user_list document
                  QuerySnapshot userSnapshot = await FirebaseFirestore.instance
                      .collection('Doctors')
                      .doc(widget.doctorId)
                      .collection("User_list")
                      .where('profile_id', isEqualTo: profileid)
                      .get();

                  print(userSnapshot);
                  // Update the "status" field to "accepted"
                  if (userSnapshot.docs.isNotEmpty) {
                    // Update the "status" field to "accepted" for the first matching document
                    DocumentReference userRef =
                        userSnapshot.docs.first.reference;
                    await userRef.update({"status": "accepted"});
                    setState(() {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => RequestPage(
                            doctorId: widget.doctorId,
                          ), // Replace with your page widget
                        ),
                      );
                    });

                    if (kDebugMode) {
                      print("Patient status updated to 'accepted'");
                    }
                  } else {
                    if (kDebugMode) {
                      print(
                          "No matching document found with the expected profile ID.");
                    }
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print("Error updating patient status: $e");
                  }
                }

                // Add code to handle 'Yes' action
                print("Patient will be added!");
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                // Add your logic for 'No' button press
                Navigator.of(context).pop(); // Close the alert box
                // Add code to handle 'No' action
                print("Canceled adding the patient.");
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
                Text(
                  "Pending Requests",
                  style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                ),
                IconButton(
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ,))
                    },
                    focusColor: Colors.blue,
                    autofocus: true,
                    hoverColor: Colors.blue,
                    highlightColor: Colors.blue,
                    icon: const Icon(CupertinoIcons.search)),
              ],
            ),
            // const SizedBox(
            //   height: 20.0,
            // ),
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
                    return const Text('No doctors available.');
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
                            onTap: () {},
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
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const PendingRequest(),
                                      //     ));
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
                                        icon: const Icon(
                                          CupertinoIcons.checkmark_alt,
                                        ),
                                        color: Colors.red,
                                        highlightColor: Colors.blue,
                                        iconSize:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        onPressed: () {
                                          setState(() {
                                            _showAddPatientAlert(context,
                                                doctorData['profile_id']);
                                          });
                                        }),
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
