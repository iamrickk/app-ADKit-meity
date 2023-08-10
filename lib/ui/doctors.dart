import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefirstone/resources/api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../resources/auth_provider.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({Key? key}) : super(key: key);

  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  Future<List<QueryDocumentSnapshot>> fetchDoctors() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection("Doctors").get();
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
                AppLocalizations.of(context)!.nearbyDoctors,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
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
                        child:  CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No doctors available.');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var doctorData = snapshot.data![index].data() as Map<String, dynamic>;
                        return Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child:  ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(doctorData["profilePic"] ?? ""),
                            ),
                            // print(doctorData["profile"]);
                            title: Text( doctorData["firstname"] ?? "",
                                                       style: GoogleFonts.lato(
                                                           textStyle: Theme.of(context)
                                                               .textTheme
                                                               .displayLarge,
                                                           fontSize: 20,
                                                           fontWeight: FontWeight.w400,
                                                           fontStyle: FontStyle.normal,
                                                           letterSpacing: 1.0,
                                                           color: Colors.blue),
                                                     ),
                            subtitle: Text( doctorData["speciality"]?? "",
                              style: GoogleFonts.lato(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .displayLarge,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 1.0,
                                  color: Colors.black),
                            ),
                            trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                  children: [
                              Container(
                                                        padding: const EdgeInsets.fromLTRB(
                                                            0.0, 8.0, 2.0, 5.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.center,
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                final Uri url = Uri(
                                                                    scheme: 'tel',
                                                                    path: doctorData
                                                                        ["phoneNumber"]?? "");
                                                                if (await canLaunchUrl(url)) {
                                                                  await launchUrl(url);
                                                                } else {
                                                                  print(
                                                                      'Cannot launch the operation');
                                                                }
                                                              },
                                                              child: CircleAvatar(
                                                                backgroundColor:
                                                                    Theme.of(context)
                                                                        .accentColor,
                                                                child: const Icon(
                                                                  Icons.call,
                                                                  color: Color(0xFFBF828A),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 10.0),
                                                            InkWell(
                                                              onTap: () {
                                                                openGoogleMapsForLocationSearch(
                                                                    doctorData
                                                                        ["address"] ?? "");
                                                              },
                                                              child: CircleAvatar(
                                                                backgroundColor:
                                                                    Theme.of(context)
                                                                        .accentColor,
                                                                child: const Icon(
                                                                  Icons.location_pin,
                                                                  color: Color(0xFFBF828A),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 10.0),
                                                            InkWell(
                                                              onTap: () async {
                                                                String? encodeQueryParameters(
                                                                    Map<String, String>
                                                                        params) {
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
                                                                      encodeQueryParameters(<
                                                                          String, String>{
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
                                                                backgroundColor:
                                                                    Theme.of(context)
                                                                        .accentColor,
                                                                child: const Icon(
                                                                  Icons.email,
                                                                  color: Color(0xFFBF828A),
                                                                ),
                                                              ),
                                                            ),

                                  ]
                            ),
                          ),
                          ]
                        )
                          )
                        );
                      },


                    );
                    }
                }
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
