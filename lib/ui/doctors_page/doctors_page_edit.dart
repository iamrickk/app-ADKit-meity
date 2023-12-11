import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../resources/auth_provider.dart';

class DoctorsPageEdit extends StatefulWidget {
  const DoctorsPageEdit({Key? key}) : super(key: key);

  @override
  State<DoctorsPageEdit> createState() => _DoctorsPageEditState();
}

class _DoctorsPageEditState extends State<DoctorsPageEdit> {
  late TextEditingController firstNameController;
  late TextEditingController secondNameController;
  late TextEditingController emailController;
  late TextEditingController specialityController;
  late TextEditingController addressController;
  late TextEditingController stateController;
  late TextEditingController pinCodeController;
  late TextEditingController districtController;

  File? pickedImage;

  @override
  void initState() {
    super.initState();
    final ap = Provider.of<AuthProvider>(context, listen: false);

    // Initialize controllers with actual values
    firstNameController = TextEditingController(text: ap.doctorModel.firstname);
    secondNameController =
        TextEditingController(text: ap.doctorModel.secondname);
    emailController = TextEditingController(text: ap.doctorModel.email);
    specialityController =
        TextEditingController(text: ap.doctorModel.speciality);
    addressController = TextEditingController(text: ap.doctorModel.address);
    stateController = TextEditingController(text: ap.doctorModel.state);
    pinCodeController = TextEditingController(text: ap.doctorModel.pin);
    districtController = TextEditingController(text: ap.doctorModel.district);
  }

  Future<void> updateDoctorInfo() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      await _firestore.collection('Doctors').doc(ap.doctorModel.uid).update({
        'firstname': firstNameController.text,
        'secondname': secondNameController.text,
        'email': emailController.text,
        'speciality': specialityController.text,
        'address': addressController.text,
        'state': stateController.text,
        'pin': pinCodeController.text,
        'district': districtController.text,
        if (pickedImage != null) 'profilePic': pickedImage?.path,
        // Add other fields as needed
      });

      // Update local doctorModel in AuthProvider
      // ap.updateDoctorModel(
      //   firstname: firstNameController.text,
      //   secondname: secondNameController.text,
      //   email: emailController.text,
      //   speciality: specialityController.text,
      //   address: addressController.text,
      //   state: stateController.text,
      //   pin: pinCodeController.text,
      //   district: districtController.text,
      //   phoneNumber : ap.doctorModel.phoneNumber,
      //   pending: ap.doctorModel.pending,
      //   uid : ap.doctorModel
      //   // Update other fields as needed
      
      // );

      // Show a success message or perform other actions after successful update
      if (kDebugMode) {
        print('Doctor information updated successfully!');
      }
    } catch (e) {
      // Handle errors, show an error message, or log the error
      if (kDebugMode) {
        print('Error updating doctor information: $e');
      }
    }
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          this.pickedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background_image.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
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
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: pickedImage != null
                                        ? Image.file(pickedImage!,
                                            fit: BoxFit.cover)
                                        : Image.network(
                                            ap.doctorModel.profilePic,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.yellow,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        // Handle image edit
                                        pickImage(context);
                                      },
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 35, right: 35),
                            child: Column(
                              children: [
                                TextFormField(
                                  style: const TextStyle(color: Colors.black),
                                  controller: firstNameController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    labelText: "First Name",
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
                                  controller: secondNameController,
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
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    labelText: "Email",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  readOnly: true, // Make it read-only
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  style: const TextStyle(),
                                  controller: specialityController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    labelText: "Speciality",
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
                                  controller: addressController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    labelText: "Address",
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
                                  controller: stateController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    labelText: "State",
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
                                  controller: pinCodeController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    labelText: "Pin Code",
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
                                  controller: districtController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    labelText: "City",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: const Color(0xff4c505b),
                                      child: IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          // Validate and submit the form
                                          if (validateForm()) {
                                            // Call your submit function here
                                            // Example: submitForm();
                                            updateDoctorInfo();
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.check,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Validate the form
  bool validateForm() {
    if (firstNameController.text.isEmpty ||
        secondNameController.text.isEmpty ||
        specialityController.text.isEmpty ||
        addressController.text.isEmpty ||
        stateController.text.isEmpty ||
        pinCodeController.text.isEmpty ||
        districtController.text.isEmpty) {
      // Show an error message or handle validation as needed
      // You can also use a Form widget for more structured validation
      return false;
    }
    return true;
  }
}
