import 'package:flutter/cupertino.dart';

class DatesProvider extends ChangeNotifier {
  List<DateTime>? datesList;

  void setDatesList(List<DateTime> dates) {
    datesList = dates;
    notifyListeners();
  }
}
