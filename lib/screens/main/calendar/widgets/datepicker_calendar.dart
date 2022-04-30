import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/providers/dates_provider.dart';

class DatePickerCalendar extends StatelessWidget {
  const DatePickerCalendar(
      {Key? key, required this.controller, required this.datesProvider})
      : super(key: key);

  final DateRangePickerController controller;
  final DatesProvider datesProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: SfDateRangePicker(
        controller: controller,
        selectionMode: DateRangePickerSelectionMode.multiple,
        enablePastDates: false,
        showNavigationArrow: true,
        selectionShape: DateRangePickerSelectionShape.rectangle,
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          if (args.value is List<DateTime>) {
            datesProvider.setDatesList(args.value);
          }
        },
        headerStyle: const DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        headerHeight: 60,
      ),
    );
  }
}
