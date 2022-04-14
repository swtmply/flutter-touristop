import 'dart:async';

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
  final Set<Marker> _markers = Set();
  BitmapDescriptor? pinLocationIcon;

  @override
  void initState() {
    setCustomMapPin();
    super.initState();
  }

  void setCustomMapPin() async {
    pinLocationIcon =
        await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
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
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          setState(() {
            // Adding user location pin
            _markers.add(
              Marker(
                markerId: const MarkerId('user'),
                position: userPosition,
                icon: pinLocationIcon!,
              ),
            );

            // ignore: todo
            // TODO: Adding pin location to every tourist spot
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
