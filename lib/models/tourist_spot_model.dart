import 'package:google_maps_flutter/google_maps_flutter.dart';

class TouristSpot {
  final String? name;
  final LatLng? position;
  final List<String>? openDates;

  TouristSpot({this.openDates, this.name, this.position});
}
