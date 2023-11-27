// ignore_for_file: unnecessary_null_comparison

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefirstone/resources/api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../widgets/snack_bar.dart';

class userPovDoctor extends StatefulWidget {
  final String? imgpath;
  final String? name;
  final String? speciality;
  final String? phoneNumber;
  final String? address;
  final String? email;
  final String? uid;

  const userPovDoctor({
    super.key,
    required this.imgpath,
    required this.name,
    required this.speciality,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.uid,
  });

  @override
  _userPovDoctorState createState() => _userPovDoctorState();
}

class _userPovDoctorState extends State<userPovDoctor> {
  late bool isadded = false;
  static bool doctorExists = false;

  @override
  void initState() {
    super.initState();
    // print(widget.name);
    // print("Hello");
    print(widget.uid);
    checkfortheval().then((result) {
      setState(() {
        doctorExists = result;
      });
    });
    print(doctorExists);
  }

  Future<bool> checkfortheval() async {
    bool check = await API.doesDoctorDataExist(widget.phoneNumber ?? '');
    return check;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Blue upper one-third

            Container(
              color: Colors.blue.shade800,
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(widget.imgpath ?? ' '),
                    ),
                  ),
                ],
              ),
            ),

            // White lower two-thirds
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Doctor details
                        Text(
                          widget.name ?? '',
                          style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.0,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          'Specialist : ${widget.speciality ?? ''}',
                          style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1.0,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 16.0),

                        // Other details (you can customize as needed)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                final Uri url = Uri(
                                    scheme: 'tel',
                                    path: widget.phoneNumber ?? "");
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
                                radius: 20,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            InkWell(
                              onTap: () {
                                openGoogleMapsForLocationSearch(
                                    widget.address ?? "");
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                child: const Icon(
                                  Icons.location_pin,
                                  color: Color(0xFFBF828A),
                                ),
                                radius: 20,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            InkWell(
                              onTap: () async {
                                String? encodeQueryParameters(
                                    Map<String, String> params) {
                                  return params.entries
                                      .map((MapEntry<String, String> e) =>
                                          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                      .join('&');
                                }

                                final Uri emailUri = Uri(
                                  scheme: 'mailto',
                                  path: widget.email ?? "",
                                  query: encodeQueryParameters(<String, String>{
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
                                    Theme.of(context).colorScheme.secondary,
                                child: const Icon(
                                  Icons.email,
                                  color: Color(0xFFBF828A),
                                ),
                                radius: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        CircleAvatar(
                          radius: 25.0,
                          child: IconButton(
                            onPressed: () async {
                              if (doctorExists) {
                                // Data for the doctor exists, you can take appropriate action here
                                setState(() {
                                  isadded = true;
                                });

                                print(doctorExists);
                                print("Rick");
                                print(isadded);
                              } else {
                                // Data for the doctor does not exist
                                API.addDoctorNames({
                                  // 'name': widget.name ?? '',
                                  // 'speciality': widget.speciality ?? '',
                                  'phoneNumber': widget.phoneNumber ?? '',
                                  // 'email': widget.email ?? '',
                                  // 'address': widget.address ?? '',
                                  // 'imgpath': widget.imgpath ?? '',
                                  // 'time': DateTime.now(),
                                  'uid': widget.uid!,
                                });
                                API.addUserNames(
                                  widget.phoneNumber ?? '',
                                  widget.uid! == null
                                      ? 'error'
                                      : widget.uid ?? '',
                                );
                                setState(() {
                                  doctorExists = true;
                                });
                              }

                              isadded == true
                                  ? ScaffoldMessenger.of(context)
                                      .showSnackBar(MySnackBars.createSnackBar(
                                      // context: context,
                                      // message: 'Doctor Already Added',
                                      // backgroundColor: Colors.blue.shade800,
                                      // textColor: Colors.white,
                                      // duration: const Duration(seconds: 4),
                                      contentType: ContentType.help,
                                      message: "This Doctor is Already Added!",
                                      title: "Already Added!",
                                    ))
                                  : ScaffoldMessenger.of(context)
                                      .showSnackBar(MySnackBars.createSnackBar(
                                      // context: context,
                                      // message: 'Added The Doctor Succesfully',
                                      // backgroundColor: Colors.blue.shade800,
                                      // textColor: Colors.white,
                                      // duration: const Duration(seconds: 4),
                                      title: "Succesfully Added!",
                                      message: "This Doctor succesfully Added",
                                      contentType: ContentType.success,
                                    ));
                              print('hello');
                              print(widget.uid);
                            },
                            icon: isadded
                                ? const Icon(CupertinoIcons.checkmark_alt)
                                : const Icon(Icons.add),
                            color: Colors.white,
                            iconSize: 30.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
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
