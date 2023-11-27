import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefirstone/ui/admin_panel/VerifiedDocPage/doctor_profile_page.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VerifiedDocPage extends StatefulWidget {
  const VerifiedDocPage({Key? key}) : super(key: key);

  @override
  _VerifiedDocPageState createState() => _VerifiedDocPageState();
}

class _VerifiedDocPageState extends State<VerifiedDocPage> {
  Future<List<QueryDocumentSnapshot>> fetchDoctors() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Doctors")
        .where("pending", isEqualTo: false)
        .get();
    return snapshot.docs;
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
                "Verified Doctors",
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
            // Image.asset(
            //   'assets/Doctor-placeholder-image.jpg',
            //   height: 100,
            //   fit: BoxFit.cover,
            // ),
            Expanded(
              child: FutureBuilder<List<QueryDocumentSnapshot>>(
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
                          var doctorData = snapshot.data![index].data()
                              as Map<String, dynamic>;
                          // bool isadded = false;
                          return Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorProfilePage(
                                        imgpath: doctorData["profilePic"],
                                        name: doctorData["firstname"]! +
                                            ' ' +
                                            doctorData['secondname'],
                                        speciality: doctorData["speciality"],
                                        phoneNumber: doctorData["phoneNumber"],
                                        address: doctorData['address'],
                                        email: doctorData['email'],
                                        pin: doctorData['pin'],
                                        state: doctorData['state'],
                                        city: doctorData['district'],
                                      ),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      doctorData["profilePic"] ?? ""),
                                ),
                                // print(doctorData["profile"]);
                                title: Center(
                                  child: Text(
                                    doctorData["firstname"] +
                                            ' ' +
                                            doctorData['secondname'] ??
                                        "",
                                    style: GoogleFonts.lato(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayLarge,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: 1.0,
                                        color: Colors.blue),
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
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              final Uri url = Uri(
                                                  scheme: 'tel',
                                                  path: doctorData[
                                                          "phoneNumber"] ??
                                                      "");
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              } else {
                                                print(
                                                    'Cannot launch the operation');
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
                                                  doctorData["address"] ?? "");
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
                                                  Map<String, String> params) {
                                                return params.entries
                                                    .map((MapEntry<String,
                                                                String>
                                                            e) =>
                                                        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                                    .join('&');
                                              }

                                              final Uri emailUri = Uri(
                                                scheme: 'mailto',
                                                path: doctorData["email"] ?? "",
                                                query:
                                                    encodeQueryParameters(<String,
                                                        String>{
                                                  'subject':
                                                      'Example Subject & Symbols are allowed!',
                                                  'body': 'Your Message!',
                                                }),
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
                                        ]),
                                  ],
                                ),
                                trailing: CircleAvatar(
                                  child: IconButton(
                                    onPressed: () {
                                      // send request wala part and notifications
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              'Confirm Remove Doctor'),
                                          content: const Text(
                                              'Are you sure you want to Remove this doctor?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Remove'),
                                              onPressed: () async {
                                                // Update the pending field of the doctor to false
                                                await FirebaseFirestore.instance
                                                    .collection("Doctors")
                                                    .doc(doctorData['uid'])
                                                    .update({"pending": true});

                                                // Show a success snackbar
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Doctor added successfully.'),
                                                  ),
                                                );

                                                // Refresh the list view to reflect the updated data
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                        CupertinoIcons.checkmark_alt),
                                    color: Colors.white,
                                  ),
                                ),
                              ));
                        },
                      );
                    }
                  }),
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
