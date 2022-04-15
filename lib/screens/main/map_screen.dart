import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:touristop/models/tourist_spot_model.dart';
import 'package:touristop/providers/user_location_provider.dart';
import 'package:touristop/services/spots_service.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  final SpotsService _spotsService = GetIt.I.get<SpotsService>();

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

          final listTouristSpot = await _spotsService.listDocuments();

          setState(() {
            _markers = listTouristSpot
                .map((spot) => Marker(
                      markerId: MarkerId(spot.name!),
                      position: spot.position!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRose),
                    ))
                .toSet();
            // Adding user location pin
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
