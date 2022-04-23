import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/providers/dates_provider.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<DatesProvider>(
          builder: ((context, value, child) => Row(
              children: value.dates != null
                  ? value.dates!
                      .map((date) => Text(date.toIso8601String()))
                      .toList()
                  : [])),
        ),
        SfDateRangePicker(
          viewSpacing: 20,
          headerStyle: const DateRangePickerHeaderStyle(
            textAlign: TextAlign.center,
          ),
          selectionMode: DateRangePickerSelectionMode.multiple,
          enablePastDates: false,
          selectionShape: DateRangePickerSelectionShape.rectangle,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            if (args.value is List<DateTime>) {
              Provider.of<DatesProvider>(context, listen: false)
                  .setDatesList(args.value);
            }
          },
        ),
      ],
    );
  }
}
