import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class nearby_hospitals_google_map_in extends StatefulWidget {
  const nearby_hospitals_google_map_in({super.key});

  @override
  State<nearby_hospitals_google_map_in> createState() =>
      _nearby_hospitals_google_map_inState();
}

class _nearby_hospitals_google_map_inState
    extends State<nearby_hospitals_google_map_in> {
  // created controller for displaying Google maps
  Completer<GoogleMapController> _controller = Completer();

  LatLng _initialPosition = LatLng(23.54526, 87.2895031);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.bestForNavigation));

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
    print(position.longitude);
    print(position.latitude);
  }

  final List<Marker> _markers = const <Marker>[
    Marker(
        markerId: MarkerId('1'),

        position: LatLng(23.539863436553247, 87.28929863798169),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: 'HealthWorld Hospital',
        )
    ),
    Marker(
        markerId: MarkerId('1'),

        position: LatLng(23.539441288573194,  87.298267808053),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: 'LifeCare Hospital',
        )
    ),
  ];
  GoogleMapController? mapController;
  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error" + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 15,
          ),
          // set markers on the google map after getting the
          // the hospitals address from the places API

          markers: Set<Marker>.of(_markers),
          // below line displays google map in our map
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          compassEnabled: true,
        ),
      ),
    );
  }
}
