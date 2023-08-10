import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:thefirstone/model/doctorModel.dart';
import 'package:thefirstone/resources/auth_provider.dart';
import 'package:thefirstone/ui/doctors_portal.dart';
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

  File? image;

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
        body: SingleChildScrollView(
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                )
              : Column(
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
                                      borderRadius: BorderRadius.circular(100),
                                      child: const Image(
                                          image:
                                              AssetImage('assets/Doctors.jpg'), fit: BoxFit.cover
                                        ,))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
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
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: "First Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      style: const TextStyle(),
                      // obscureText: true,
                      controller: nameSecondController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        labelText: "Second Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    TextFormField(
                      style: const TextStyle(),
                      // obscureText: true,
                      controller: emailController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          // hintText: "Email",

                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      style: const TextStyle(),
                      // obscureText: true,
                      controller: specialityController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          // hintText: "Speciality",
                          labelText: "Speciality",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      style: const TextStyle(),
                      // obscureText: true,
                      controller: addressController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          // hintText: "Speciality",
                          labelText: "Address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () {
                          storeData();
                        },
                        child: const Text("Continue"),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // store the user data to database
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    DoctorModel doctorModel = DoctorModel(
        firstname: nameFirstController.text,
        secondname: nameSecondController.text,
        email: emailController.text.trim(),
        speciality: specialityController.text,
        profilePic: "",
        phoneNumber: "",
        uid: "",
        address: addressController.text);
    if (image != null) {
      ap.saveUserDataToFirebase(
        context: context,
        doctorModel: doctorModel,
        profilePic: image!,
        onSuccess: () {
          // store it locally
          //
          ap.saveUserDatatoSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const doctors_portal(),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
    } else {
      showSnackBar(context, "Please upload your Profile Photo");
    }
  }
}
