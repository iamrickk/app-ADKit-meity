import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thefirstone/ui/user_pov_doctor/doctor_profile_view_page.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifiedDocPage extends StatefulWidget {
  const VerifiedDocPage({Key? key}) : super(key: key);

  @override
  _VerifiedDocPageState createState() => _VerifiedDocPageState();
}

class _VerifiedDocPageState extends State<VerifiedDocPage> {
  late List<QueryDocumentSnapshot> originalDoctorList = [];
  late List<QueryDocumentSnapshot> filteredList = [];

  // Controllers for search fields
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Doctors")
        .where("pending", isEqualTo: false)
        .get();

    setState(() {
      originalDoctorList = snapshot.docs;
      filteredList = List.from(originalDoctorList);
    });
  }

  void filterDoctors() {
    String name = nameController.text.toLowerCase();
    String pin = pinController.text;
    String phone = phoneController.text;
    String district = districtController.text.toLowerCase();
    print("Hello");
    print(pinController.text);

    setState(() {
      filteredList = originalDoctorList.where((doctor) {
        var data = doctor.data() as Map<String, dynamic>;
        print(data);
        return data['firstname'].toString().toLowerCase().contains(name) &&
            data['pin'].toString().contains(pin) &&
            data['phoneNumber'].toString().toLowerCase().contains(phone) &&
            data['district'].toString().toLowerCase().contains(district);
      }).toList();
    });
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
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.26,
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.showDoctors,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: Colors.blue,
                    ),
                  ),
                ),

                // CircleAvatar(
                //   backgroundColor: Colors.blue,
                //   foregroundColor: Colors.white,
                //   child: IconButton(
                //     onPressed: () {},
                //     color: Colors.white,
                //     icon: const Icon(Icons.search),
                //   ),
                // )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            // Center(
            //   child: Text(
            //     "Filter Your Search",
            //     style: GoogleFonts.lato(
            //       textStyle: Theme.of(context).textTheme.displayLarge,
            //       fontSize: 15,
            //       fontWeight: FontWeight.w600,
            //       fontStyle: FontStyle.normal,
            //       color: Colors.blue,
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 20.0,
            // ),
            // Image.asset(
            //   'assets/Doctor-placeholder-image.jpg',
            //   height: 100,
            //   fit: BoxFit.cover,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: nameController,
                      onChanged: (value) => filterDoctors(),
                      decoration: const InputDecoration(
                        labelText: 'Search by Name',
                        prefixIcon: Icon(Icons.person),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: pinController,
                      onChanged: (value) => filterDoctors(),
                      decoration: const InputDecoration(
                        labelText: 'Search by Pincode',
                        prefixIcon: Icon(Icons.password),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: phoneController,
                      onChanged: (value) => filterDoctors(),
                      decoration: const InputDecoration(
                        labelText: 'Search by Phone',
                        prefixIcon: Icon(Icons.phone),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: districtController,
                      onChanged: (value) => filterDoctors(),
                      decoration: const InputDecoration(
                        labelText: 'Search by City',
                        prefixIcon: Icon(Icons.location_city),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  // ... repeat the same pattern for other text fields
                ],
              ),
            ),
            Expanded(
                child: filteredList.isEmpty
                    ? const Center(child: Text('No doctors available.'))
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          var doctorData = filteredList[index].data()
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
                                      builder: (context) => userPovDoctor(
                                        imgpath: doctorData["profilePic"],
                                        name: doctorData["firstname"]! +
                                            ' ' +
                                            doctorData['secondname'],
                                        speciality: doctorData["speciality"],
                                        phoneNumber: doctorData["phoneNumber"],
                                        address: doctorData['address'],
                                        email: doctorData['email'],
                                        uid: doctorData['uid'],
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
                                    },
                                    icon: const Icon(
                                        CupertinoIcons.checkmark_alt),
                                    color: Colors.blue,
                                  ),
                                ),
                              ));
                        },
                      )),
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
