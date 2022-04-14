import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class UserLocationProvider extends ChangeNotifier {
  Position? userPosition;

  void setUserPosition(Position newPosition) {
    userPosition = newPosition;
    notifyListeners();
  }
}
