import 'dart:async';

import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as location;

late location.LocationData _currentPosition;
String _address = "";
late GoogleMapController mapController;
late Marker marker;
var _location = location.Location();
late CameraPosition _cameraPosition =
    CameraPosition(target: LatLng(0, 0), zoom: 10.0);

LatLng _initialcameraposition = LatLng(0.5937, 0.9629);

Future<String> getLoc() async {
  bool _serviceEnabled;
  location.PermissionStatus _permissionGranted;

  _serviceEnabled = await _location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await _location.requestService();
    if (!_serviceEnabled) {
      return "null";
    }
  }

  _permissionGranted = await _location.hasPermission();
  if (_permissionGranted == location.PermissionStatus.denied) {
    _permissionGranted = await _location.requestPermission();
    if (_permissionGranted != location.PermissionStatus.granted) {
      return "null";
    }
  }
  String details = "";

  _currentPosition = await _location.getLocation();

  DateTime now = DateTime.now();

  details += "";
  details += DateFormat('EEE d MMM kk:mm:ss ').format(now);

  _initialcameraposition =
      LatLng(_currentPosition.latitude!, _currentPosition.longitude!);

  _getAddress(_currentPosition.latitude!, _currentPosition.longitude!)
      .then((value) {
    if (value.isNotEmpty) {
      final address = value.first;
      _address =
          "${address.street}, ${address.subLocality}, ${address.locality}, ${address.postalCode}, ${address.country}";
    } else {
      _address = "Unknown Address";
    }
  });
  details += "{}";
  details += _currentPosition.latitude.toString() +
      " , " +
      _currentPosition.longitude.toString();
  details += "{}";
  details += _address;

  return details;
}

Future<List<geocoding.Placemark>> _getAddress(double lat, double lng) async {
  final placemarks = await geocoding.placemarkFromCoordinates(lat, lng);
  return placemarks;
}
