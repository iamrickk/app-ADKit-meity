import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class MySnackBars {
  /// failure
  static var failureSnackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'On Snap!',
      message: 'Wrong Credentials',
      contentType: ContentType.failure,
    ),
  );

  /// help
  static var nofound = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Oh Snap!',
      message: 'Admin Data Doesnot exist!',
      contentType: ContentType.help,
    ),
  );

  /// success
  static var incomplete = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Oh Snap!',
      message: 'Admin Data Is Incomplete!',
      contentType: ContentType.warning,
    ),
  );

  /// warning
  static var warningSnackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Warning!',
      message: 'You Have a warning for this message.\nPlease read carefully!',
      contentType: ContentType.warning,
    ),
  );

  static var doctorAdded = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Added!',
      message: 'Doctor Added Succesfully!',
      contentType: ContentType.success,
    ),
  );

  static var doctorAlreadyAdded = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Already Added!',
      message: 'This Doctor is already Added!',
      contentType: ContentType.success,
    ),
  );
}
