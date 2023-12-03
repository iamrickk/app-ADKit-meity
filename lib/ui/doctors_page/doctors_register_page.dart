import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thefirstone/resources/auth_provider.dart';

import '../../widgets/snack_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController phoneNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isTap = false;
  bool isFilled = false;

  Country country = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/register.png'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(CupertinoIcons.left_chevron),
                                    onPressed: () {
                                      // print('HI');
                                      Navigator.pop(context);
                                    },
                                    color: Colors.white,
                                  ),
                                ],
                              )
                            ],
                          ),
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.height * 0.2,
                          // ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            margin: const EdgeInsets.all(20.0),
                            child: DefaultTextStyle(
                              style: GoogleFonts.lato(
                                textStyle:
                                    Theme.of(context).textTheme.displayLarge,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              child: const Text(
                                "Welcome \n Back!",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 35, right: 35),
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black),
                                  controller: phoneNumber,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    labelText: "Phone Number",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                    ),
                                    prefixIcon: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          5.0, 12.0, 3.0, 6.0),
                                      child: InkWell(
                                        onTap: () {
                                          showCountryPicker(
                                              context: context,
                                              countryListTheme:
                                                  const CountryListThemeData(
                                                      bottomSheetHeight: 550),
                                              onSelect: (value) {
                                                setState(() {
                                                  country = value;
                                                });
                                              });
                                        },
                                        child: Text(
                                          "${country.flagEmoji} + ${country.phoneCode}",
                                          style: GoogleFonts.lato(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    suffixIcon: phoneNumber.text.length == 10
                                        ? IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                                CupertinoIcons.checkmark_alt))
                                        : null,
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
                                            if (phoneNumber.text.length == 10) {
                                              sendPhoneNumber();
                                            }

                                            setState(() {
                                              isTap = true;
                                              if (phoneNumber.text.length ==
                                                  10) {
                                                isFilled = true;
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(MySnackBars
                                                        .createSnackBar(
                                                  title: "Phone Number Invalid",
                                                  message:
                                                      "Enter the 10 Digit Phone Number",
                                                  contentType:
                                                      ContentType.warning,
                                                ));
                                              }
                                            });
                                          },
                                          highlightColor: Colors.amberAccent,
                                          icon: (isFilled == false)
                                              ? const Icon(
                                                  CupertinoIcons.checkmark_alt,
                                                )
                                              : const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    final ap = Provider.of<FirebaseAuthProvider>(context, listen: false);
    String phoneNo = phoneNumber.text.trim();
    ap.signInWithPhone(context, "+${country.phoneCode}$phoneNo");
  }
}
