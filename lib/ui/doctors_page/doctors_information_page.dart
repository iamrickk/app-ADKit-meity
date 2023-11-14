import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thefirstone/model/doctorModel.dart';
import 'package:thefirstone/resources/auth_provider.dart';
import 'package:thefirstone/ui/options_page.dart';
// import 'package:thefirstone/ui/doctors_portal.dart';
import 'package:thefirstone/utils/snakcbar.dart';

class doctorsInformation extends StatefulWidget {
  const doctorsInformation({super.key});

  @override
  State<doctorsInformation> createState() => _doctorsInformationState();
}

class _doctorsInformationState extends State<doctorsInformation> {
  // the data that will be stored in the database
  final nameFirstController = TextEditingController();
  final nameSecondController = TextEditingController();
  final emailController = TextEditingController();
  final specialityController = TextEditingController();
  final addressController = TextEditingController();
  final pinController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final countryController = TextEditingController();

  List<String> doctorSpecialties = [
    'Allergist',
    'Anesthesiologist',
    'Cardiologist',
    'Dentist',
    'Dermatologist',
    'Endocrinologist',
    'Gastroenterologist',
    'General Practitioner',
    'Geneticist',
    'Geriatrician',
    'Gynecologist',
    'Hematologist',
    'Immunologist',
    'Infectious Disease Specialist',
    'Internal Medicine Specialist',
    'Medical Geneticist',
    'Neonatologist',
    'Nephrologist',
    'Neurologist',
    'Obstetrician',
    'Oncologist',
    'Ophthalmologist',
    'Orthopedic Surgeon',
    'Otolaryngologist (ENT Specialist)',
    'Pathologist',
    'Pediatrician',
    'Physiatrist',
    'Plastic Surgeon',
    'Podiatrist',
    'Psychiatrist',
    'Pulmonologist',
    'Radiologist',
    'Rheumatologist',
    'Surgeon',
    'Thoracic Surgeon',
    'Urologist',
    'Vascular Surgeon',
    // Add more specialties as needed
  ];

  File? image;
  @override
  void initState() {
    super.initState();
  }

  // for selecting the image

  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Fill The Application"),
        ),
        body: SingleChildScrollView(
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Center(
                        child: Stack(
                          children: [
                            SizedBox(
                                width: 160,
                                height: 160,
                                child: image == null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: const Image(
                                          image:
                                              AssetImage('assets/Doctors.jpg'),
                                          fit: BoxFit.cover,
                                        ))
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image(
                                          image: FileImage(image!),
                                        ))),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.yellow),
                                child: IconButton(
                                  icon: const Icon(CupertinoIcons.pen),
                                  onPressed: () {
                                    // print('hi');
                                    selectImage();
                                  },
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: nameFirstController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          labelText: "First Name",
                          labelStyle: const TextStyle(
                              color: Colors.black87), // Color of the label text
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black), // Color of the border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.grey
                                    .shade400), // Color of the border when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors
                                    .blue), // Color of the border when focused
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: nameSecondController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          labelText: "Second Name",
                          labelStyle: const TextStyle(
                              color: Colors.black87), // Color of the label text
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black), // Color of the border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.grey
                                    .shade400), // Color of the border when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors
                                    .blue), // Color of the border when focused
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          labelText: "Email",
                          labelStyle: const TextStyle(
                              color: Colors.black87), // Color of the label text
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black), // Color of the border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.grey
                                    .shade400), // Color of the border when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors
                                    .blue), // Color of the border when focused
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: specialityController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          labelText: "Speciality",
                          labelStyle: const TextStyle(
                              color: Colors.black87), // Color of the label text
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black), // Color of the border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.grey
                                    .shade400), // Color of the border when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors
                                    .blue), // Color of the border when focused
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: addressController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          labelText: "Address",
                          labelStyle: const TextStyle(
                              color: Colors.black87), // Color of the label text
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black), // Color of the border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.grey
                                    .shade400), // Color of the border when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors
                                    .blue), // Color of the border when focused
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        controller: pinController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          labelText: "Pin",
                          labelStyle: const TextStyle(
                              color: Colors.black87), // Color of the label text
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black), // Color of the border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.grey
                                    .shade400), // Color of the border when not focused
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors
                                    .blue), // Color of the border when focused
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      // TextFormField(
                      //   style: const TextStyle(color: Colors.black),
                      //   controller: stateController,
                      //   decoration: InputDecoration(
                      //     filled: true,
                      //     fillColor: Colors.grey.shade100,
                      //     labelText: "State",
                      //     labelStyle: const TextStyle(
                      //         color: Colors.black87), // Color of the label text
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(20),
                      //       borderSide: const BorderSide(
                      //           color: Colors.black), // Color of the border
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(20),
                      //       borderSide: BorderSide(
                      //           color: Colors.grey
                      //               .shade400), // Color of the border when not focused
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(20),
                      //       borderSide: const BorderSide(
                      //           color: Colors
                      //               .blue), // Color of the border when focused
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 30.0,
                      // ),
                      // TextFormField(
                      //   style: const TextStyle(color: Colors.black),
                      //   controller: districtController,
                      //   decoration: InputDecoration(
                      //     filled: true,
                      //     fillColor: Colors.grey.shade100,
                      //     labelText: "City",
                      //     labelStyle: const TextStyle(
                      //         color: Colors.black87), // Color of the label text
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(20),
                      //       borderSide: const BorderSide(
                      //           color: Colors.black), // Color of the border
                      //     ),
                      //     enabledBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(20),
                      //       borderSide: BorderSide(
                      //           color: Colors.grey
                      //               .shade400), // Color of the border when not focused
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(20),
                      //       borderSide: const BorderSide(
                      //           color: Colors
                      //               .blue), // Color of the border when focused
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 30.0,
                      // ),
                      CSCPicker(
                        layout: Layout.vertical,
                        onCountryChanged: (country) {
                          // print('Selected Country : $country');
                          // countryController.text = country;
                        },
                        onStateChanged: (state) {
                          if (state != null) {
                            stateController.text = state;
                            print('Selected Country : $state');
                          }
                        },
                        onCityChanged: (city) {
                          if (city != null) {
                            districtController.text = city;
                          }
                        },
                        countryDropdownLabel: "*Country",
                        stateDropdownLabel: "*State",
                        cityDropdownLabel: "*City",
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: () {
                            storeData();
                          },
                          child: const Text("Submit"),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // store the user data to database
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    // Check if any of the fields is empty
    if (nameFirstController.text.isEmpty ||
        nameSecondController.text.isEmpty ||
        emailController.text.trim().isEmpty ||
        specialityController.text.isEmpty ||
        addressController.text.isEmpty ||
        pinController.text.isEmpty ||
        stateController.text.isEmpty ||
        districtController.text.isEmpty) {
      showAlertDialog(context, 'All fields must be filled.');
      return;
    }
    DoctorModel doctorModel = DoctorModel(
      firstname: nameFirstController.text,
      secondname: nameSecondController.text,
      email: emailController.text.trim(),
      speciality: specialityController.text,
      profilePic: "",
      phoneNumber: "",
      uid: "",
      address: addressController.text,
      pin: pinController.text,
      state: stateController.text,
      district: districtController.text,
      pending: true,
    );
    if (image != null) {
      ap.saveUserDataToFirebase(
        context: context,
        doctorModel: doctorModel,
        profilePic: image!,
        onSuccess: () {
          // store it locally
          //
          // ap.saveUserDatatoSP().then(
          //       (value) => ap.setSignIn().then(
          //             (value) => Navigator.pushAndRemoveUntil(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => const ThankYouPage(),
          //                 ),
          //                 (route) => false),
          //           ),
          //     );
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ThankYouPage(),
              ),
              (route) => false);
        },
      );
    } else {
      showSnackBar(context, "Please upload your Profile Photo");
    }
  }
}

class ThankYouPage extends StatefulWidget {
  const ThankYouPage({super.key});

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => options_page(),
                          ),
                          (route) => false);
                    },
                    child: const Text("Thank You!")),
                const Text(
                  'Your Application is under process. We will contact you soon!',
                  style: TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alert'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
