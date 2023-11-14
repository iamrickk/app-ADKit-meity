import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class UserDetails extends StatefulWidget {
  int? indexPt;
  String? name;
  String? gender;
  String? uid;
  String? dob;
  UserDetails(
      {super.key,
      required this.indexPt,
      required this.name,
      required this.gender,
      required this.uid,
      required this.dob});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _getUserDatas(
      String uid) async {
    try {
     QuerySnapshot<Map<String, dynamic>> profileQuerySnapshot =
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid) // Access the user document with UID
        .collection('profiles') // Access the 'profiles' collection under the user document
        .doc(uid) // Access a specific profile document (if needed)
        .collection('chatbot_responses') // Access the 'chatbot_responses' subcollection
        .get();

print(profileQuerySnapshot.docs);
return profileQuerySnapshot.docs;
    } catch (e) {
      print('Error fetching user profiles: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            // borderRadius: const BorderRadius.only(
            //   topLeft: Radius.circular(20.0), // Top left corner
            //   topRight: Radius.circular(20.0), // Top right corner
            // ),
            color: Colors.blue[900], // Background color
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(CupertinoIcons.left_chevron),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
                Center(
                  child: Card(
                    margin: const EdgeInsets.all(16.0),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Name : ${widget.name!}",
                            style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Gender: ${widget.gender}',
                            style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'uid: ${widget.uid}',
                            style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Date of Birth: ${widget.dob}',
                            style: GoogleFonts.lato(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  // margin: const EdgeInsets.all(16.0),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: FutureBuilder<
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                    future: _getUserDatas(widget.uid!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>?
                            userProfiles = snapshot.data;

                        if (userProfiles == null || userProfiles.isEmpty) {
                          return const ListTile(
                            title: Text("User Not Found"),
                          );
                        }
                        List<Map<String, dynamic>> profileDataList =
                            userProfiles
                                .map((snapshot) => snapshot.data())
                                .toList();

                        return Expanded(
                          child: ListView.builder(
                            itemCount: profileDataList.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> profileData =
                                  profileDataList[index];

                              return ListTile(
                                title: Text(
                                  "Risk Score : ${profileData['risk-score']}",
                                  style: GoogleFonts.lato(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  "Test On : ${profileData['time']}",
                                  style: GoogleFonts.lato(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
