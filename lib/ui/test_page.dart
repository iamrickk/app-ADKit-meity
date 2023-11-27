import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thefirstone/ui/doctors_page/my_dashboard_page.dart';
import 'package:thefirstone/ui/doctors_page/patient_Dashboard_data.dart';
import 'package:thefirstone/ui/doctors_page/slide_design_test_page.dart';
import 'package:thefirstone/ui/doctors_portal.dart';
import 'package:thefirstone/ui/options_page.dart';

import '../resources/auth_provider.dart';
import 'doctors_page/doctors_profile.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
  );
  int _currentPage = 0;
  static List<Map<String, dynamic>> categoryData = [
    {
      "imgLeft": 5.0,
      "imgBottom": 19.0,
      "imgHeight": 122.0,
      "imgPath": "assets/pending.png",
      "tabName": "Hi Doctor!",
      "tabDesc": "Hope You are having a good day!",
      "color": Colors.deepPurpleAccent,
    },
    {
      "imgLeft": 15.0,
      "imgBottom": -8.0,
      "imgHeight": 150.0,
      "imgPath": "assets/verified.jpg",
      "tabName": "Total pending",
      "tabDesc": "Total count of Pending Requests",
      "color": Colors.teal[800],
    },
    {
      "imgPath": "assets/test1.jpg",
      "imgHeight": 140.0,
      "imgLeft": 15.0,
      "imgBottom": 0.0,
      "tabName": "Total Accepted",
      "tabDesc": "Total count of Accepted Requests",
      "color": Colors.lightBlue[700],
    },
  ];
  static AutoSizeGroup titleGrp = AutoSizeGroup();
  static AutoSizeGroup descGrp = AutoSizeGroup();
  late final docId;
  Future<List<QueryDocumentSnapshot?>> fetchUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Doctors') // Root collection: "Doctors"
        .doc(docId) // Specific Doctors's document
        .collection(
            "User_list") // Subcollection under the user document: "profiles"
        .where('status', isEqualTo: 'pending')
        .get();
    return snapshot.docs;
  }

  Future<List<QueryDocumentSnapshot?>> fetchUsers1() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Doctors') // Root collection: "Doctors"
        .doc(docId) // Specific Doctors's document
        .collection(
            "User_list") // Subcollection under the user document: "profiles"
        .where('status', isEqualTo: 'accepted')
        .get();
    return snapshot.docs;
  }

  late Future<List<QueryDocumentSnapshot?>> docData;
  late Future<List<QueryDocumentSnapshot?>> docData1;
  late AuthProvider ap;

  List<int> value = [0];
  var values;
  var values1;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
    ap = Provider.of<AuthProvider>(context, listen: false);
    docId = ap.doctorModel.uid;
    docData = fetchUsers();
    docData1 = fetchUsers1();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(ap.doctorModel.uid);
    return Scaffold(
      backgroundColor:
          Colors.blue[900], // Background color of the entire screen
      body: Column(
        children: [
          // Manual App Bar
          Container(
            color: Colors.blue[900],
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Row(
              children: [
                const SizedBox(width: 15.0),
                Text(
                  "Hi, ${ap.doctorModel.firstname}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DoctorProfile(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 15.0,
                    backgroundImage: NetworkImage(
                      ap.doctorModel.profilePic,
                    ),
                    // Add your image asset path here
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  color: Colors.white,
                  onPressed: () {
                    // Add your notifications button functionality here
                  },
                ),
                IconButton(
                    onPressed: () {
                      ap.userSignOut().then((value) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => options_page()),
                          (Route<dynamic> route) => false,
                        );
                      });
                    },
                    color: Colors.white,
                    icon: const Icon(CupertinoIcons.arrow_right_square)),
                FutureBuilder<List<QueryDocumentSnapshot?>>(
                  future: docData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Display a loading indicator while fetching data
                      return const CircularProgressIndicator(); // You can replace this with your own loading widget
                    } else if (snapshot.hasError) {
                      // Display an error message if there's an error
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Display the length of the fetched users
                      values1 = snapshot.data?.length ?? 0;
                      value.add(values1);
                      return Container();
                    }
                  },
                ),
                FutureBuilder<List<QueryDocumentSnapshot?>>(
                  future: docData1,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Display a loading indicator while fetching data
                      return const CircularProgressIndicator(); // You can replace this with your own loading widget
                    } else if (snapshot.hasError) {
                      // Display an error message if there's an error
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Display the length of the fetched users
                      values = snapshot.data?.length ?? 0;
                      value.add(values);
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
          // Blue Background Slider
          Container(
            color: Colors.blue[900], // Adjust color as needed
            height: MediaQuery.of(context).size.height * 0.2,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: 3, // Number of slides
                  itemBuilder: (BuildContext context, int index) {
                    // You can customize each slide here
                    var cat = categoryData[index];
                    // print(cat);
                    // print(cat["tabDesc"]);
                    // print(index);
                    return Card(
                      elevation: 5, // Adjust for elevation
                      margin: const EdgeInsets.all(16.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0),
                          bottom: Radius.circular(20.0),
                        ),
                      ),
                      child: Center(
                        child: SlideTab(
                          titleGrp: titleGrp,
                          descGrp: descGrp,
                          imgPath: cat["imgPath"],
                          imgBottom: cat["imgBottom"],
                          imgHeight: cat["imgHeight"],
                          imgLeft: cat["imgLeft"],
                          tabDesc: cat["tabDesc"],
                          tabName: cat["tabName"],
                          color: cat["color"],
                          numbers: value[index],
                          pageno: index,
                        ),
                      ),
                    );
                  },
                ),
                // Dot Indicator
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16,
                  child: _buildDotIndicator(),
                ),
              ],
            ),
          ),
          // White Elevated Container (70% of the screen height)
          Expanded(
            child: Card(
              margin: EdgeInsets.zero, // Remove any default card margin
              color: Colors.white,
              elevation: 10, // Adjust for elevation

              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'My Dashboard',
                        style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          color: Colors.blue,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    // Your Content Goes Here
                    ListItem(
                      title: 'Accepted Request',
                      content:
                          'Here you will get all the patients that you have accepted.',
                      actionButtonText: 'View Request',
                      actionButton: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorDashboard(
                                doctorId: ap.doctorModel.uid,
                              ),
                            ));
                      },
                    ),
                    ListItem(
                      title: 'Pending Request',
                      content:
                          'Here you will get all the request that patients have sent you.',
                      actionButtonText: 'View Request',
                      actionButton: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestPage(
                                doctorId: ap.doctorModel.uid,
                              ),
                            ));
                      },
                    ),
                    ListItem(
                      title: 'Search Patient',
                      content:
                          'Having Problem finding the patient? Search the patient by their phone number.',
                      actionButtonText: 'Search',
                      actionButton: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const doctors_portal(),
                            ));
                      },
                    ),
                    // Three Options for Product-Level Design
                    // _buildProductOption(
                    //   title: '',
                    //   description: 'Details of the current patients.',
                    //   imageUrl: 'assets/test1.jpg',
                    //   onPressed: () {
                    //     // Add functionality to navigate to Product 1 page
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => DoctorDashboard(
                    //             doctorId: ap.doctorModel.uid,
                    //           ),
                    //         ));
                    //   },
                    // ),
                    // _buildProductOption(
                    //   title: 'Pending Request',
                    //   description: 'The current requests of the patients.',
                    //   imageUrl: 'assets/test3.jpg',
                    //   onPressed: () {
                    //     // Add functionality to navigate to Product 2 page
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => RequestPage(
                    //             doctorId: ap.doctorModel.uid,
                    //           ),
                    //         ));
                    //   },
                    // ),
                    // _buildProductOption(
                    //   title: 'Search',
                    //   description: 'Search the patient by phone number.',
                    //   imageUrl: 'assets/search.jpg',
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => const doctors_portal(),
                    //         ));
                    //     // Add functionality to navigate to Product 3 page
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3, // Number of slides
        (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            height: 8.0,
            width: _currentPage == index ? 15.0 : 7.0, // Adjusted width
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? Colors.blue
                  : Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductOption({
    required String title,
    required String description,
    required String imageUrl,
    required Function onPressed,
  }) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.18,
        child: Card(
          elevation: 7,
          margin: const EdgeInsets.all(10.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 10.0),
            child: ListTile(
              leading: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width *
                    0.3, // Adjust the width as needed
                height: MediaQuery.of(context).size.width *
                    0.2, // Adjust the height as needed
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                description,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  const ListItem({
    Key? key,
    required this.title,
    required this.content,
    required this.actionButtonText,
    required this.actionButton,
  }) : super(key: key);

  final String title;
  final String content;
  final String actionButtonText;
  final VoidCallback actionButton;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade300,
            Colors.blue.shade500,
            Colors.blue.shade700,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4.0,
            offset: const Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: _toggleExpand,
                  icon: Icon(
                    _isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _isExpanded,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text(
                widget.content,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
            child: ElevatedButton(
              onPressed: widget.actionButton,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4.0,
              ),
              child: Text(
                widget.actionButtonText,
                style: GoogleFonts.lato(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 1.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
