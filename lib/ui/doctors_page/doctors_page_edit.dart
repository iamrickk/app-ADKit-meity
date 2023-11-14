import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/auth_provider.dart';

class DoctorsPageEdit extends StatefulWidget {
  const DoctorsPageEdit({super.key});

  @override
  State<DoctorsPageEdit> createState() => _DoctorsPageEditState();
}

class _DoctorsPageEditState extends State<DoctorsPageEdit> {
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final emailController = TextEditingController();
  final specialityController = TextEditingController();
  final addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context,listen: false);
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background_image.png'), fit: BoxFit.cover),
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
                                    icon: const Icon(CupertinoIcons.xmark),
                                    onPressed: () {
                                      // print('HI');
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
                                      child: Image(
                                          image: NetworkImage(ap.doctorModel.profilePic),
                                          fit: BoxFit.cover
                                      )),
                                ),
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
                                      )),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  style: const TextStyle(),
                                  // obscureText: true,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      labelText: "Second Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),


                                TextFormField(
                                  style: const TextStyle(),
                                  obscureText: true,
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
                                  obscureText: true,
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
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [

                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: const Color(0xff4c505b),
                                      child: IconButton(
                                          color: Colors.white,
                                          onPressed: () {

                                          },
                                          icon: const Icon(
                                            CupertinoIcons.checkmark_alt,
                                          )),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 40,
                                ),

                              ],
                            ),
                          )
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
}