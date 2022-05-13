import 'package:flutter/cupertino.dart';

class DatesProvider extends ChangeNotifier {
  List<DateTime>? _datesList = [];

  List<DateTime>? get dates => _datesList;

  void setDatesList(List<DateTime> dates) {
    _datesList = dates;
    notifyListeners();
  }

  void removeDateFromList(DateTime date) {
    _datesList?.remove(date);
    notifyListeners();
  }
}
