import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
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
  BitmapDescriptor? userLocationPin, spotLocationPin;

  @override
  void initState() {
    setCustomMapPin();
    super.initState();
  }

  // ignore: todo
  // TODO add custom markers
  Future<void> setCustomMapPin() async {
    userLocationPin = BitmapDescriptor.defaultMarker;
    spotLocationPin =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
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

          await _setMarkersToMap(userPosition);
        },
      ),
    );
  }

  Future<void> _setMarkersToMap(LatLng userPosition) async {
    final listTouristSpot = await _spotsService.listDocuments();

    setState(() {
      _markers = listTouristSpot
          .map((spot) => Marker(
                markerId: MarkerId(spot.name!),
                position: spot.position!,
                icon: spotLocationPin!,
              ))
          .toSet();
      // Adding user location pin
      _markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: userPosition,
          icon: userLocationPin!,
        ),
      );
    });
  }

  // Animate Change of Location Reference
  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
