import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/screens/main/calendar/widgets/date_container.dart';

class SelectdDates extends StatelessWidget {
  const SelectdDates({Key? key, required this.controller}) : super(key: key);

  final DateRangePickerController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<DatesProvider>(
      builder: ((context, value, child) => Container(
            margin: const EdgeInsets.only(bottom: 24.0),
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: value.dates!.isNotEmpty
                  ? value.dates!
                      .map(
                        (date) => InkWell(
                          onTap: () {
                            value.removeDateFromList(date);
                            controller.notifyPropertyChangedListeners(
                                'selectedDates');
                          },
                          child: DateContainer(date: date),
                        ),
                      )
                      .toList()
                  : [
                      const Text(
                        'No selected dates',
                      ),
                    ],
            ),
          )),
    );
  }
}
