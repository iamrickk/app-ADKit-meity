// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
// run with `flutter run --no-sound-null-safety` for testing
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thefirstone/resources/api.dart';
import 'package:thefirstone/ui/choose_nail_palm.dart';
import 'package:thefirstone/ui/language_select.dart';
import 'package:thefirstone/ui/login.dart';
import 'package:thefirstone/ui/nearby_hospital_google_map_in.dart';
import 'package:thefirstone/ui/requested_doctor/requested_doctor.dart';
import 'package:thefirstone/ui/trend_graph.dart';
// import 'package:thefirstone/ui/trend_graph.dart';
import 'package:thefirstone/ui/user_pov_doctor/doctors.dart';
import 'package:thefirstone/utils/MapUtils.dart';
import 'package:thefirstone/utils/current_location.dart';
import 'firestore_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _currentVideo;
  var height, width;
  String? downUrl;
  ImagePicker _imagePicker = ImagePicker();
  UploadTask? _uploadTask;
  bool? isPregnant;
  DocumentSnapshot? userData;
  String? appType;
  late TextEditingController ageControler;
  String gender = "1";
  String? firstButtonText;
  String? secondButtonText;
  double textSize = 22;
  String currLoc = "";
  var details = [];
  String date_time = "", address = "";
  var loc = [];
  // Define your segment ranges

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        firstButtonText = AppLocalizations.of(context)!.selectVideo;
        secondButtonText = AppLocalizations.of(context)!.recordVideo;
      });
    });
    ageControler = TextEditingController();
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .get()
    //     .then((value) {
    //   setState(() {
    //     userData = value;

    //   });
    // });
    userData = API.profileData;
    gender = userData!['gender'] == "Male" ? "1" : "0";
    super.initState();
    currentLoc();
  }

  int selectedRadio = 0;
  Color color1 = Colors.red;
  Color color2 = Colors.black;

  showPregnancyDialog() async {
    //userData!['gender'] == "Female"
    if (gender == "0") {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.pregnancy),
          content: Text(AppLocalizations.of(context)!.isPregnant),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isPregnant = true;
                });
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFBF828A)),
              ),
              child: Text(
                AppLocalizations.of(context)!.yes,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isPregnant = false;
                });
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFBF828A)),
              ),
              child: Text(
                AppLocalizations.of(context)!.no,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  Future<void> showPersonalDetailsDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          // int selectedRadio = 0;
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ignore: unnecessary_new
                    new GestureDetector(
                      onTap: () {
                        gender = "1";
                        setState(() {
                          color2 = Colors.black;
                          color1 = Colors.red;
                        });
                      },
                      child: Text("Male", style: TextStyle(color: color1)),
                    ),
                    GestureDetector(
                      onTap: () {
                        gender = "0";
                        setState(() {
                          color1 = Colors.black;
                          color2 = Colors.red;
                        });
                      },
                      child: Text("Female", style: TextStyle(color: color2)),
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: "Enter age"),
                      keyboardType: TextInputType.number,
                      controller: ageControler,
                    ),
                    TextButton(
                      child: const Text(
                        'ok',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueAccent),
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  Future _selectAndUploadVideo() async {
    final type = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NailOrPalm()));
    if (type == null) return;

    // await showPersonalDetailsDialog();
    await showPregnancyDialog();

    var result = await _imagePicker.pickVideo(source: ImageSource.gallery);

    if (result == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FirestoreForm()),
    );

    //print("Download Link: $url");

    setState(() {
      appType = type;
      firstButtonText = AppLocalizations.of(context)!.uploadingVideo;
      _currentVideo = File(result.path);
    });

    _uploadTask = API.uploadVideo(_currentVideo!);
    setState(() {});

    if (_uploadTask == null) {
      print("error......................");
      return;
    }

    final snapshot = await _uploadTask!.whenComplete(() {});

    final url = await snapshot.ref.getDownloadURL();

    setState(() {
      firstButtonText = AppLocalizations.of(context)!.processing;
      downUrl = url;
    });

    await _getAPiResponse();

    setState(() {
      firstButtonText = AppLocalizations.of(context)!.selectVideo;
    });
  }

  void _showGauge(double val, int age) {
    var verdict;
    var color;
    List<double> hbRanges = [];
    var normalRange = [];

    if (age <= 5) {
      hbRanges.add(7 - 3);
      hbRanges.add(10 - 7);
      hbRanges.add(11 - 10);
      hbRanges.add(16 - 11);
      normalRange.add(11);
      normalRange.add(16);
      if (val < 7) {
        verdict = AppLocalizations.of(context)!.severelyAnaemic;
        color = Colors.red;
      } else if (val >= 7 && val < 10) {
        verdict = AppLocalizations.of(context)!.moderatelyAnaemic;
        color = Colors.orange;
      } else if (val >= 10 && val < 11) {
        verdict = AppLocalizations.of(context)!.mildlyAnaemic;
        color = const Color(0xFFF6C21A);
      } else {
        verdict = AppLocalizations.of(context)!.nonAnaemic;
        color = Colors.green;
      }
    } else if (age > 5 && age <= 11) {
      hbRanges.add(8 - 3);
      hbRanges.add(11 - 8);
      hbRanges.add(11.5 - 11);
      hbRanges.add(16 - 11.5);
      normalRange.add(11.5);
      normalRange.add(16);
      if (val < 8) {
        verdict = AppLocalizations.of(context)!.severelyAnaemic;
        color = Colors.red;
      } else if (val >= 8 && val < 11) {
        verdict = AppLocalizations.of(context)!.moderatelyAnaemic;
        color = Colors.orange;
      } else if (val >= 11 && val < 11.5) {
        verdict = AppLocalizations.of(context)!.mildlyAnaemic;
        color = const Color(0xFFF6C21A);
      } else {
        verdict = AppLocalizations.of(context)!.nonAnaemic;
        color = Colors.green;
      }
    } else if (age > 11 && age < 15) {
      hbRanges.add(8 - 3);
      hbRanges.add(11 - 8);
      hbRanges.add(12 - 11);
      hbRanges.add(16 - 12);
      normalRange.add(12);
      normalRange.add(16);
      if (val < 8) {
        verdict = AppLocalizations.of(context)!.severelyAnaemic;
        color = Colors.red;
      } else if (val >= 8 && val < 11) {
        verdict = AppLocalizations.of(context)!.moderatelyAnaemic;
        color = Colors.orange;
      } else if (val >= 11 && val < 12) {
        verdict = AppLocalizations.of(context)!.mildlyAnaemic;
        color = const Color(0xFFF6C21A);
      } else {
        verdict = AppLocalizations.of(context)!.nonAnaemic;
        color = Colors.green;
      }
    } else {
      if (userData!['gender'] == "Female") {
        if (isPregnant!) {
          hbRanges.add(7 - 3);
          hbRanges.add(10 - 7);
          hbRanges.add(11 - 10);
          hbRanges.add(16 - 11);
          normalRange.add(11);
          normalRange.add(16);
          if (val < 7) {
            verdict = AppLocalizations.of(context)!.severelyAnaemic;
            color = Colors.red;
          } else if (val >= 7 && val < 10) {
            verdict = AppLocalizations.of(context)!.moderatelyAnaemic;
            color = Colors.orange;
          } else if (val >= 10 && val < 11) {
            verdict = AppLocalizations.of(context)!.mildlyAnaemic;
            color = const Color(0xFFF6C21A);
          } else {
            verdict = AppLocalizations.of(context)!.nonAnaemic;
            color = Colors.green;
          }
        } else {
          hbRanges.add(8 - 3);
          hbRanges.add(11 - 8);
          hbRanges.add(12 - 11);
          hbRanges.add(16 - 12);
          normalRange.add(12);
          normalRange.add(16);
          if (val < 8) {
            verdict = AppLocalizations.of(context)!.severelyAnaemic;
            color = Colors.red;
          } else if (val >= 8 && val < 11) {
            verdict = AppLocalizations.of(context)!.moderatelyAnaemic;
            color = Colors.orange;
          } else if (val >= 11 && val < 12) {
            verdict = AppLocalizations.of(context)!.mildlyAnaemic;
            color = const Color(0xFFF6C21A);
          } else {
            verdict = AppLocalizations.of(context)!.nonAnaemic;
            color = Colors.green;
          }
        }
      } else {
        hbRanges.add(8 - 3);
        hbRanges.add(11 - 8);
        hbRanges.add(13 - 11);
        hbRanges.add(16 - 13);
        normalRange.add(13);
        normalRange.add(16);
        if (val < 8) {
          verdict = AppLocalizations.of(context)!.severelyAnaemic;
          color = Colors.red;
        } else if (val >= 8 && val < 11) {
          verdict = AppLocalizations.of(context)!.moderatelyAnaemic;
          color = Colors.orange;
        } else if (val >= 11 && val < 13) {
          verdict = AppLocalizations.of(context)!.mildlyAnaemic;
          color = const Color(0xFFF6C21A);
        } else {
          verdict = AppLocalizations.of(context)!.nonAnaemic;
          color = Colors.green;
        }
      }
    }
    // Define your segment ranges
    final List<GaugeRange> segments = [
      GaugeRange(
        startValue: 3, // Start value of the segment
        endValue: hbRanges[0], // End value of the segment
        color: const Color(0xFFFF0000), // Red color
      ),
      GaugeRange(
        startValue: hbRanges[0], // Start value of the segment
        endValue: hbRanges[1], // End value of the segment
        color: const Color(0xFFFFA500), // Orange color
      ),
      GaugeRange(
        startValue: hbRanges[1], // Start value of the segment
        endValue: hbRanges[2], // End value of the segment
        color: const Color(0xFFF6C21A), // Yellow color
      ),
      GaugeRange(
        startValue: hbRanges[2], // Start value of the segment
        endValue: hbRanges[3], // End value of the segment
        color: const Color(0xFF008000), // Green color
      ),
    ];

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.verdict),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(
                //   // This widget will be based on Gender.
                //   // Haven't factored it in right now for testing.
                //   child: CustomGauge(
                //     gaugeSize: 200,
                //     minValue: 3,
                //     maxValue: 16,
                //     currentValue: double.parse(val.toStringAsFixed(1)),
                //     segments: [
                //       GaugeSegment(
                //           AppLocalizations.of(context)!.severelyAnaemic,
                //           hbRanges[0],
                //           Colors.red),
                //       GaugeSegment(
                //           AppLocalizations.of(context)!.moderatelyAnaemic,
                //           hbRanges[1],
                //           Colors.orange),
                //       GaugeSegment(AppLocalizations.of(context)!.mildlyAnaemic,
                //           hbRanges[2], const Color(0xFFF6C21A)),
                //       GaugeSegment(AppLocalizations.of(context)!.nonAnaemic,
                //           hbRanges[3], Colors.green),
                //     ],
                //     showMarkers: false,

                //     displayWidget: Text(
                //       '${AppLocalizations.of(context)!.haemoglobin} (gm/dl)',
                //       style: const TextStyle(
                //         fontSize: 12.0,
                //       ),
                //     ),
                //   ),
                // ),
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 200, // Mediaquery.of(context).size.height
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 3,
                          maximum: 16,
                          showLabels: false,
                          showTicks: false,
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 3,
                              endValue: hbRanges[0],
                              color: const Color(0xFFFF0000), // Red color
                            ),
                            GaugeRange(
                              startValue: hbRanges[0],
                              endValue: hbRanges[1],
                              color: const Color(0xFFFFA500), // Orange color
                            ),
                            GaugeRange(
                              startValue: hbRanges[1],
                              endValue: hbRanges[2],
                              color: const Color(0xFFF6C21A), // Yellow color
                            ),
                            GaugeRange(
                              startValue: hbRanges[2],
                              endValue: hbRanges[3],
                              color: const Color(0xFF008000), // Green color
                            ),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value: double.parse(val.toStringAsFixed(1)),
                              needleColor: Colors.black,
                              enableAnimation: true,
                            ),
                          ],
                          // Use annotations to display additional information
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              positionFactor: 0.5,
                              widget: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '${AppLocalizations.of(context)!.haemoglobin} (gm/dl)',
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Center(
                  child: Text(
                    "${AppLocalizations.of(context)!.normalRange}: ${normalRange[0]} - ${normalRange[1]} gm/dl",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    verdict,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                verdict == AppLocalizations.of(context)!.nonAnaemic
                    ? const SizedBox()
                    : const Text(
                        "Next Steps:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                const SizedBox(
                  height: 5,
                ),
                _advise(verdict)
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFFBF828A),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.ok,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget _advise(String type) {
    if (type == AppLocalizations.of(context)!.severelyAnaemic) {
      return Text(
        AppLocalizations.of(context)!.adviceSevere,
        style: const TextStyle(fontSize: 14),
      );
    } else if (type == AppLocalizations.of(context)!.moderatelyAnaemic) {
      return Text(
        AppLocalizations.of(context)!.adviceModerate,
        style: const TextStyle(fontSize: 14),
      );
    } else if (type == AppLocalizations.of(context)!.mildlyAnaemic) {
      return Text(
        AppLocalizations.of(context)!.adviceMild,
        style: const TextStyle(fontSize: 14),
      );
    } else {
      return Text(
        AppLocalizations.of(context)!.adviceSafe,
        style: const TextStyle(fontSize: 14),
      );
    }
  }

  int _calcAge(String dob) {
    DateTime dt = DateTime.parse(dob);
    Duration diff = DateTime.now().difference(dt);

    int age = (diff.inDays / 365).floor();

    return age;
  }

  Future _getAPiResponse() async {
    if (downUrl == null) return;

    int age = _calcAge(userData!['dob']);

    var data =
        await API.processVideo(downUrl!, age.toString(), gender, appType!);

    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error"),
      ));
    } else {
      API.addResult(data, appType!);
      _showGauge(data, age);

      print("API response $data");
    }
  }

  Future _recordVideo() async {
    final type = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NailOrPalm()));
    print("app_type $type");

    if (type == null) return;

    // await showPersonalDetailsDialog();
    await showPregnancyDialog();

    var result = null;

    _imagePicker
        .pickVideo(source: ImageSource.camera)
        .then((XFile? recordedVideo) async {
      if (recordedVideo != null && recordedVideo.path != null) {
        print(recordedVideo.path);
        result = recordedVideo;
        await ImageGallerySaver.saveFile(recordedVideo.path);

        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FirestoreForm()),
        );

        //userData!['gender'] == "Female"

        setState(() {
          appType = type;
          secondButtonText = AppLocalizations.of(context)!.uploadingVideo;
          _currentVideo = File(result.path);
        });

        _uploadTask = API.uploadVideo(_currentVideo!);
        setState(() {});

        if (_uploadTask == null) return;

        final snapshot = await _uploadTask!.whenComplete(() {});
        final url = await snapshot.ref.getDownloadURL();
        print("Download Link: $url");

        setState(() {
          secondButtonText = AppLocalizations.of(context)!.processing;
          downUrl = url;
        });

        await _getAPiResponse();

        setState(() {
          secondButtonText = AppLocalizations.of(context)!.recordVideo;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    currentLoc();

    try {
      loc[0];
    } catch (e) {
      currentLoc();
    }
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Text(
                              "${AppLocalizations.of(context)!.hi(userData!['first_name'])},\n${AppLocalizations.of(context)!.welcome}",
                              style: TextStyle(
                                fontSize: textSize,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.symmetric(vertical: 25),
                        ),
                        Container(
                          // margin: EdgeInsets.all(20),
                          child: Card(
                            elevation: 10,
                            color: Theme.of(context).colorScheme.secondary,
                            child: IconButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LanguageSelect()));
                                setState(() {
                                  firstButtonText = null;
                                  secondButtonText = null;
                                });
                              },
                              icon: const Icon(
                                Icons.language,
                                color: Color(0xFFBF828A), //Color(0xFFBF828A),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // margin: EdgeInsets.all(20),
                          child: Card(
                            elevation: 10,
                            color: Theme.of(context).colorScheme.secondary,
                            child: IconButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.logout,
                                color: Color(0xFFBF828A), //Color(0xFFBF828A),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * .06,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: width * 0.4,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _selectAndUploadVideo();
                                    // _showGauge(11.2, 5);
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(builder: (context) => TrendGraph()),
                                    // );
                                  },
                                  child: Card(
                                    elevation: 10,
                                    child: Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      padding: const EdgeInsets.all(20),
                                      child: const Icon(
                                        Icons.video_library,
                                        color: Color(0xFFBF828A),
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  firstButtonText ??
                                      AppLocalizations.of(context)!.selectVideo,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width * 0.4,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _recordVideo();
                                  },
                                  child: Card(
                                    elevation: 10,
                                    child: Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      padding: const EdgeInsets.all(20),
                                      child: const Icon(
                                        Icons.videocam,
                                        color: Color(0xFFBF828A),
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  secondButtonText ??
                                      AppLocalizations.of(context)!.recordVideo,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: width * .4,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => const TrendGraph()),
                                    );
                                  },
                                  child: Card(
                                    elevation: 10,
                                    child: Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      padding: const EdgeInsets.all(20),
                                      child: const Icon(
                                        Icons.auto_graph,
                                        color: Color(0xFFBF828A),
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.showTrend,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width * .4,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const VerifiedDocPage()),
                                    );
                                  },
                                  child: Card(
                                    elevation: 10,
                                    child: Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      padding: const EdgeInsets.all(20),
                                      child: const Icon(
                                        Icons.medical_services,
                                        color: Color(0xFFBF828A),
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.showDoctors,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: height * 0.06,
                    // ),

                    _uploadTask != null
                        ? _uploadStatus(_uploadTask!)
                        : const Offstage(),
                    // Text(hValue)
                    SizedBox(
                      height: height * .02,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: width * .4,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    currentLoc();

                                    date_time = currLoc.split("{}")[0];
                                    address = currLoc.split("{}")[2];
                                    loc = currLoc.split("{}")[1].split(" , ");
                                    setState(() {
                                      currLoc;
                                      date_time;
                                      address;
                                      loc;
                                    });

                                    MapUtils.openMap(double.parse(loc[0]!),
                                        double.parse(loc[1]!));
                                  },
                                  child: Card(
                                    elevation: 10,
                                    child: Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      padding: const EdgeInsets.all(20),
                                      child: const Icon(
                                        Icons.medical_information_outlined,
                                        color: Color(0xFFBF828A),
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.showHospitals,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width * .4,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const nearby_hospitals_google_map_in()),
                                    );
                                  },
                                  child: Card(
                                    elevation: 10,
                                    child: Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      padding: const EdgeInsets.all(20),
                                      child: const Icon(
                                        Icons.local_hospital_outlined,
                                        color: Color(0xFFBF828A),
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.nearbyHospitals,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: width * .4,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const requestedDocPage(),
                                        ));
                                  },
                                  child: Card(
                                    elevation: 10,
                                    child: Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      padding: const EdgeInsets.all(20),
                                      child: const Icon(
                                        Icons.medical_information_outlined,
                                        color: Color(0xFFBF828A),
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.requestDoctor,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  void currentLoc() async {
    currLoc = await getLoc();
    date_time = currLoc.split("{}")[0];
    address = currLoc.split("{}")[2];
    loc = currLoc.split("{}")[1].split(" , ");
  }

  Widget _uploadStatus(UploadTask task) {
    return StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, AsyncSnapshot<TaskSnapshot> snapshot) {
          if (snapshot.hasData) {
            TaskSnapshot event = snapshot.data!;
            TaskState state = event.state;
            double progressPercent =
                event != null ? event.bytesTransferred / event.totalBytes : 0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: (state == TaskState.running)
                  ? LinearProgressIndicator(
                      value: progressPercent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFBF828A)),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    )
                  : const Offstage(),
            );
          }
          return const Offstage();
        });
  }
}
