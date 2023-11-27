import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../resources/api.dart';

class requestedDocPage extends StatefulWidget {
  const requestedDocPage({Key? key}) : super(key: key);

  @override
  _requestedDocPageState createState() => _requestedDocPageState();
}

class _requestedDocPageState extends State<requestedDocPage> {
  late List<Map<String, dynamic>?> originalDoctorList;

  @override
  void initState() {
    super.initState();
    originalDoctorList = [];
  }

  // Fetch doctors from Firestore
  Future<List<Map<String, dynamic>?>> fetchDoctors() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("profiles")
        .doc(API.current_profile_id)
        .collection('doctor_names')
        .get();

    List<Map<String, dynamic>?> doctors = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      String doctorId = doc['uid'];
      print(doctorId);
      Map<String, dynamic>? doctorDetails = await fetchDoctorDetails(doctorId);
      doctors.add(doctorDetails);
    }
    print("RIck");
    print(doctors);
    return doctors;
  }

  // Fetch detailed doctor information from the "Doctors" collection
  Future<Map<String, dynamic>?> fetchDoctorDetails(String doctorId) async {
    DocumentSnapshot doctorSnapshot = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(doctorId)
        .get();
    // print(doctorSnapshot.exists);
    // print(doctorId);
    if (doctorSnapshot.exists) {
      Map<String, dynamic>? data =
          doctorSnapshot.data() as Map<String, dynamic>?;
      // print("printing data");
      // print(data);
      if (data != null) {
        return Map<String, dynamic>.from(data);
      }
    }
    return null;
  }

  // Navigate to search page
  void _navigateToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorSearchPage(
          doctorList: originalDoctorList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Requested Doctors",
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
            // CircleAvatar(
            //   backgroundColor: Colors.blue,
            //   child: IconButton(
            //     icon: const Icon(Icons.search),
            //     onPressed: _navigateToSearchPage,
            //   ),
            // ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>?>>(
                future: fetchDoctors(),
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
                        var doctorData = snapshot.data![index] ?? {};

                        print(doctorData);
                        return Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              // Handle doctor profile navigation
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(doctorData["profilePic"] ?? ""),
                            ),
                            title: Center(
                              child: Text(
                                doctorData['firstname'] +
                                    " " +
                                    doctorData['secondname'],
                                style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.displayLarge,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 1.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  doctorData["speciality"] ?? "",
                                  style: GoogleFonts.lato(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: 1.0,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final Uri url = Uri(
                                          scheme: 'tel',
                                          path: doctorData["phoneNumber"] ?? "",
                                        );
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url);
                                        } else {
                                          print('Cannot launch the operation');
                                        }
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        child: const Icon(
                                          Icons.call,
                                          color: Color(0xFFBF828A),
                                        ),
                                        radius: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    InkWell(
                                      onTap: () {
                                        openGoogleMapsForLocationSearch(
                                          doctorData["address"] ?? "",
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        child: const Icon(
                                          Icons.location_pin,
                                          color: Color(0xFFBF828A),
                                        ),
                                        radius: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    InkWell(
                                      onTap: () async {
                                        String? encodeQueryParameters(
                                          Map<String, String> params,
                                        ) {
                                          return params.entries
                                              .map(
                                                (MapEntry<String, String> e) =>
                                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
                                              )
                                              .join('&');
                                        }

                                        final Uri emailUri = Uri(
                                          scheme: 'mailto',
                                          path: doctorData["email"] ?? "",
                                          query: encodeQueryParameters(
                                            <String, String>{
                                              'subject':
                                                  'Example Subject & Symbols are allowed!',
                                              'body': 'Your Message!',
                                            },
                                          ),
                                        );
                                        try {
                                          await launchUrl(emailUri);
                                        } catch (e) {
                                          print(e.toString());
                                        }
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        child: const Icon(
                                          Icons.email,
                                          color: Color(0xFFBF828A),
                                        ),
                                        radius: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: CircleAvatar(
                              child: IconButton(
                                onPressed: () {
                                  // send request wala part and notifications
                                },
                                icon: const Icon(CupertinoIcons.checkmark_alt),
                                color: Colors.blue,
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
          ],
        ),
      ),
    );
  }
}

class DoctorSearchPage extends StatefulWidget {
  final List<Map<String, dynamic>?> doctorList;

  const DoctorSearchPage({
    Key? key,
    required this.doctorList,
  }) : super(key: key);

  @override
  _DoctorSearchPageState createState() => _DoctorSearchPageState();
}

class _DoctorSearchPageState extends State<DoctorSearchPage> {
  late List<Map<String, dynamic>?> filteredDoctorList;

  @override
  void initState() {
    super.initState();
    filteredDoctorList = widget.doctorList;
    print(filteredDoctorList);
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredDoctorList = widget.doctorList;
      });
    } else {
      setState(() {
        filteredDoctorList = widget.doctorList.where((doctor) {
          return doctor?['firstname']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ??
              false;
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: filterDoctors,
                decoration: const InputDecoration(
                  labelText: 'Search Added doctors',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDoctorList.length,
                itemBuilder: (context, index) {
                  var doctorData = filteredDoctorList[index] ?? {};
                  print(doctorData);
                  print("Hello");
                  return Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      onTap: () {
                        // Handle doctor profile navigation
                      },
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(doctorData["profilePic"] ?? ""),
                      ),
                      title: Center(
                        child: Text(
                          doctorData['firstname'] ?? "",
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 1.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            doctorData["speciality"] ?? "",
                            style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final Uri url = Uri(
                                    scheme: 'tel',
                                    path: doctorData["phoneNumber"] ?? "",
                                  );
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    print('Cannot launch the operation');
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  child: const Icon(
                                    Icons.call,
                                    color: Color(0xFFBF828A),
                                  ),
                                  radius: 18,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              InkWell(
                                onTap: () {
                                  openGoogleMapsForLocationSearch(
                                    doctorData["address"] ?? "",
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Color(0xFFBF828A),
                                  ),
                                  radius: 18,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              InkWell(
                                onTap: () async {
                                  String? encodeQueryParameters(
                                      Map<String, String> params) {
                                    return params.entries
                                        .map(
                                          (MapEntry<String, String> e) =>
                                              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
                                        )
                                        .join('&');
                                  }

                                  final Uri emailUri = Uri(
                                    scheme: 'mailto',
                                    path: doctorData["email"] ?? "",
                                    query: encodeQueryParameters(
                                      <String, String>{
                                        'subject':
                                            'Example Subject & Symbols are allowed!',
                                        'body': 'Your Message!',
                                      },
                                    ),
                                  );
                                  try {
                                    await launchUrl(emailUri);
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  child: const Icon(
                                    Icons.email,
                                    color: Color(0xFFBF828A),
                                  ),
                                  radius: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: CircleAvatar(
                        child: IconButton(
                          onPressed: () {
                            // send request wala part and notifications
                          },
                          icon: const Icon(CupertinoIcons.checkmark_alt),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void openGoogleMapsForLocationSearch(String query) async {
  final String url = 'https://www.google.com/maps/search/?api=1&query=$query';
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}
