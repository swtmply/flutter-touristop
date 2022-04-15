import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:touristop/providers/user_location_provider.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  BitmapDescriptor? pinLocationIcon;

  @override
  void initState() {
    setCustomMapPin();
    super.initState();
  }

  // ignore: todo
  // TODO add custom markers
  void setCustomMapPin() {
    pinLocationIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
  }

  @override
  Widget build(BuildContext context) {
    LatLng userPosition = LatLng(
      Provider.of<UserLocationProvider>(context, listen: false)
          .userPosition!
          .latitude,
      Provider.of<UserLocationProvider>(context, listen: false)
          .userPosition!
          .longitude,
    );

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: userPosition,
          zoom: 14.4746,
          tilt: 59.440717697143555,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);

          // ignore: todo
          // TODO put this logic in a service
          // Adding pin location to every tourist spot
          QuerySnapshot snapshot =
              await FirebaseFirestore.instance.collection('spots').get();

          final data = snapshot.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            return Marker(
              markerId: MarkerId(data['name']),
              position: LatLng(data['latitude'], data['longitude']),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRose),
            );
          }).toList();

          setState(() {
            // Adding user location pin
            _markers = data.toSet();
            _markers.add(
              Marker(
                markerId: const MarkerId('user'),
                position: userPosition,
                icon: pinLocationIcon!,
              ),
            );
          });
        },
      ),
    );
  }

  // Animate Change of Location Reference
  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
