import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/screens/main/calendar/widgets/datepicker_calendar.dart';
import 'package:touristop/screens/main/calendar/widgets/selected_dates.dart';
import 'package:touristop/screens/main/calendar/widgets/dates_confirm_button.dart';
import 'package:touristop/widgets/layout.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.selectedDates =
          Provider.of<DatesProvider>(context, listen: false).dates;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final datesProvider = context.watch<DatesProvider>();

    return AppLayout(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              'Select travel dates',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            DatePickerCalendar(
              controller: _controller,
              datesProvider: datesProvider,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Dates:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SelectdDates(controller: _controller),
              ],
            ),
            DatesConfirmButton(
                onPressed: () => Navigator.pushNamed(context, '/select-spots'))
          ],
        ),
      ),
    );
  }
}
