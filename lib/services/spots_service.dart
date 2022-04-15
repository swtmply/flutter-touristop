import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:touristop/models/tourist_spot_model.dart';

class SpotsService {
  final CollectionReference _spots =
      FirebaseFirestore.instance.collection('spots');

  Stream<QuerySnapshot> spotsStream() {
    return _spots.snapshots();
  }

  Future<DocumentSnapshot> getSpotById(String id) {
    return _spots.doc(id).get();
  }

  Future<List<TouristSpot>> listDocuments() async {
    QuerySnapshot snapshot = await _spots.get();

    return snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      return TouristSpot(
        name: data['name'],
        position: LatLng(
          data['latitude'],
          data['longitude'],
        ),
      );
    }).toList();
  }
}
