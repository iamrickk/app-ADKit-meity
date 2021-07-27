import 'dart:io';
import 'package:customgauge/customgauge.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thefirstone/resources/api.dart';
import 'package:thefirstone/ui/form.dart';
import 'package:thefirstone/ui/login.dart';
// import '../utils/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _currentVideo;
  var height, weidth;
  String? downUrl;
  ImagePicker _imagePicker = ImagePicker();
  UploadTask? _uploadTask;

  Future _selectAndUploadVideo() async {
    final result = await _imagePicker.pickVideo(source: ImageSource.gallery);

    if (result == null) {
      setState(() {
        firstButtonText = 'No video was selected.';
      });
      return;
    }

    setState(() {
      firstButtonText = 'Uploading video...';
      _currentVideo = File(result.path);
    });

    _uploadTask = API.uploadVideo(_currentVideo!);
    setState(() {});

    if (_uploadTask == null) return;

    final snapshot = await _uploadTask!.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    print("Download Link: $url");
    setState(() {
      firstButtonText = 'Video uploaded. Add another from Gallery?';
      downUrl = url;
    });

    _getAPiResponse();
  }

  void _showGauge(double val) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Severity Meter'),
            content: Container(
              height: 200,
              child: Center(
                child: CustomGauge(
                  gaugeSize: 200,
                  minValue: 5,
                  maxValue: 20,
                  currentValue: val.roundToDouble(),
                  segments: [
                    GaugeSegment('Severely Anaemic', 5, Colors.red),
                    GaugeSegment('Moderate Risk', 5, Colors.yellow),
                    GaugeSegment('Healthy', 5, Colors.green),
                  ],
                  displayWidget: Text(
                    'Risk Factor',
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Color(0xFFBF828A),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          );
        });
  }

  // String hValue = "";

  Future _getAPiResponse() async {
    if (downUrl == null) return;

    double? data = await API.processVideo(downUrl!);

    // setState(() {
    //   hValue = "";
    //   hValue = "hemoglobin value is $data";
    // });

    _showGauge(data!);

    print("API response $data");
  }

  Future _recordVideo() async {
    _imagePicker
        .pickVideo(source: ImageSource.camera)
        .then((XFile? recordedVideo) async {
      if (recordedVideo != null && recordedVideo.path != null) {
        print(recordedVideo.path);
        setState(() {
          secondButtonText = 'Video is being saved...';
        });
        final result = await ImageGallerySaver.saveFile(recordedVideo.path);
        print(result);
        setState(() {
          secondButtonText = 'Video saved. Record Another?';
        });
      }
    });
  }

  String firstButtonText = 'Select Video from Gallery';
  String secondButtonText = 'Record a new video';
  double textSize = 22;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    weidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text("Hi,\nWelcome to Adkit",
                            style: TextStyle(
                              fontSize: textSize,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(25),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Card(
                          elevation: 10,
                          color: Theme.of(context).accentColor,
                          child: IconButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (route) => false);
                            },
                            icon: Icon(
                              Icons.logout,
                              color: Color(0xFFBF828A), //Color(0xFFBF828A),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * .08,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectAndUploadVideo();
                      // _showGauge(12);
                    },
                    child: Card(
                      elevation: 10,
                      child: Container(
                        color: Theme.of(context).accentColor,
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.video_library,
                          color: Color(0xFFBF828A),
                          size: 70,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(firstButtonText),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  GestureDetector(
                    onTap: () {
                      // _getAPiResponse();

                      _recordVideo();
                    },
                    child: Card(
                      elevation: 10,
                      child: Container(
                        color: Theme.of(context).accentColor,
                        padding: EdgeInsets.all(20),
                        child: Icon(
                          Icons.videocam,
                          color: Color(0xFFBF828A),
                          size: 70,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(secondButtonText),
                  SizedBox(
                    height: height * .05,
                  ),
                  _uploadTask != null
                      ? _uploadStatus(_uploadTask!)
                      : Offstage(),
                  // Text(hValue)
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DataForm()),
                  );
                },
                child: Container(
                  margin:
                      EdgeInsets.only(top: height * .80, left: weidth - 250),
                  height: 60,
                  width: 240,
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: Color(0xFFBF828A),
                    child: Container(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              "CHATBOT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          new Transform.translate(
                            offset: Offset(15.0, 0.0),
                            child: new Container(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                bottom: 5,
                                right: 25,
                              ),
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                splashColor: Colors.white,
                                color: Colors.white,
                                child: Icon(
                                  Icons.message,
                                  color: Color(0xFFBF828A),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DataForm()),
                                  );
                                },
                              ),
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFBF828A)),
                      backgroundColor: Theme.of(context).accentColor,
                    )
                  : Offstage(),
            );
          }
          return Offstage();
        });
  }
}
