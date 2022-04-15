import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference _spots =
      FirebaseFirestore.instance.collection('spots');

  Future<void> addSpot(String name, double latitude, double longitude) {
    return _spots
        .add({'name': name, 'latitude': latitude, 'longitude': longitude})
        .then((value) => print('Spot Added'))
        .catchError((error) => print('Failed to add spot: $error'));
  }

  Stream<QuerySnapshot> spotsStream() {
    return _spots.snapshots();
  }
}
