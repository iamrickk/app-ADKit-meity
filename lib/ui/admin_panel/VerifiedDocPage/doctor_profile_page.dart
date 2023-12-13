import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DoctorProfilePage extends StatefulWidget {
  final String? imgpath;
  final String? name;
  final String? speciality;
  final String? phoneNumber;
  final String? address;
  final String? email;
  final String? pin;
  final String? state;
  final String? city;

  const DoctorProfilePage({
    super.key,
    required this.imgpath,
    required this.name,
    required this.speciality,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.pin,
    required this.state,
    required this.city,
  });

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  late bool isadded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.name);
    // print("Hello");
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
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
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                                Text(
                                  widget.phoneNumber ?? '',
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 1.0,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                                Text(
                                  widget.address ?? '',
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 1.0,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
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
                                      query: encodeQueryParameters(<String,
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
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    child: const Icon(
                                      Icons.email,
                                      color: Color(0xFFBF828A),
                                    ),
                                    radius: 20,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                                Text(
                                  widget.email ?? '',
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 1.0,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {},
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    child: const Icon(
                                      Icons.pin,
                                      color: Color(0xFFBF828A),
                                    ),
                                    radius: 20,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                                Text(
                                  "Pin :  ${widget.pin ?? ''}",
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 1.0,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {},
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    child: const Icon(
                                      Icons.add_business_rounded,
                                      color: Color(0xFFBF828A),
                                    ),
                                    radius: 20,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                                Text(
                                  "State :  ${widget.state ?? ''}",
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 1.0,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {},
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    child: const Icon(
                                      Icons.add_business_rounded,
                                      color: Color(0xFFBF828A),
                                    ),
                                    radius: 20,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                ),
                                Text(
                                  "City :  ${widget.city ?? ''}",
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: 1.0,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        // CircleAvatar(
                        //   radius: 25.0,
                        //   child: IconButton(
                        //     onPressed: () {
                        //       isadded == true
                        //           ? MySnackBars.createSnackBar(
                        //               // context: context,
                        //               // message: 'Doctor Already Added',
                        //               // backgroundColor: Colors.blue.shade800,
                        //               // textColor: Colors.white,
                        //               // duration: const Duration(seconds: 4),
                        //               title : "Already Added!",
                        //               contentType: ContentType.success,
                        //               message: "This Doctor is already added!"
                        //             )
                        //           : MySnackBars.createSnackBar(
                        //               // context: context,
                        //               // message: 'Added The Doctor Succesfully',
                        //               // backgroundColor: Colors.blue.shade800,
                        //               // textColor: Colors.white,
                        //               // duration: const Duration(seconds: 4),
                        //               title: "Added!",
                        //               contentType: ContentType.success,
                        //               message: "Doctor Added Succesfull!",
                        //             );
                        //       setState(() {
                        //         isadded = true;
                        //       });
                        //     },
                        //     icon: isadded
                        //         ? const Icon(CupertinoIcons.checkmark_alt)
                        //         : const Icon(Icons.add),
                        //     color: Colors.white,
                        //     iconSize: 30.0,
                        //   ),
                        // )
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