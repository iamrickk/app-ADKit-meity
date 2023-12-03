import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thefirstone/resources/auth_provider.dart';
import 'package:thefirstone/ui/doctors_page/doctors_page_edit.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({super.key});

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<FirebaseAuthProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background_image.png'),
                  fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    // const SizedBox(
                    //   height: 20.0,
                    // ),
                    Stack(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(CupertinoIcons.left_chevron),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.black,
                            ),
                          ],
                        )
                      ],
                    ),
                    Center(
                      child: Text(
                        ap.doctorModel.firstname +
                            " " +
                            ap.doctorModel.secondname,
                        style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    // placing the image and beside the change wala option
                    Stack(
                      children: [
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: Image(
                                  image:
                                      NetworkImage(ap.doctorModel.profilePic),
                                  fit: BoxFit.cover)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// -- BUTTON
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DoctorsPageEdit(
                                      
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text('Edit Profile',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    // Menu item that will show details
                    // such as Name
                    // Phone Number
                    // Email
                    // Speciality
                    // Location Details
                    const SizedBox(
                      height: 10.0,
                    ),
                    ProfileMenuWidget(
                      title: ap.doctorModel.firstname +
                          " " +
                          ap.doctorModel.secondname,
                      icon: CupertinoIcons.profile_circled,
                    ),
                    const Divider(
                      thickness: 2.0,
                    ),
                    // const SizedBox(
                    //   height: 10.0,
                    // ),
                    ProfileMenuWidget(
                      title: ap.doctorModel.phoneNumber,
                      icon: CupertinoIcons.phone,
                    ),
                    const Divider(
                      thickness: 2.0,
                    ),
                    // const SizedBox(
                    //   height: 10.0,
                    // ),
                    ProfileMenuWidget(
                      title: ap.doctorModel.email,
                      icon: CupertinoIcons.mail,
                    ),
                    const Divider(
                      thickness: 2.0,
                    ),
                    // const SizedBox(
                    //   height: 10.0,
                    // ),
                    ProfileMenuWidget(
                      title: ap.doctorModel.speciality,
                      icon: const IconData(0xf533, fontFamily: 'MaterialIcons'),
                    ),
                    const Divider(
                      thickness: 2.0,
                    ),
                    // const SizedBox(
                    //   height: 10.0,
                    // ),
                    ProfileMenuWidget(
                      title: ap.doctorModel.address,
                      icon: CupertinoIcons.home,
                    ),
                    const Divider(
                      thickness: 2.0,
                    ),
                    ProfileMenuWidget(
                      title: ap.doctorModel.state,
                      icon: CupertinoIcons.location_solid,
                    ),
                    const Divider(
                      thickness: 2.0,
                    ),
                    ProfileMenuWidget(
                      title: ap.doctorModel.pin,
                      icon: CupertinoIcons.pin,
                    ),
                    const Divider(
                      thickness: 2.0,
                    ),
                    ProfileMenuWidget(
                      title: ap.doctorModel.district,
                      icon: CupertinoIcons.home,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ProfileMenuWidget extends StatelessWidget {
  String? title;
  IconData? icon;
  ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white,
        ),
        child: Icon(icon!, color: Colors.blue[400]),
      ),
      title: Text(
        title!,
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            color: Colors.black),
      ),
    );
  }
}
