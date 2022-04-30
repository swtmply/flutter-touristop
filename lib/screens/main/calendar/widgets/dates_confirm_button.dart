import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/theme/colors.dart';

class DatesConfirmButton extends StatelessWidget {
  final Function onPressed;
  const DatesConfirmButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final datesProvider = Provider.of<DatesProvider>(context);
    final datesIsempty = datesProvider.dates!.isEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            onPressed: datesIsempty ? null : () => onPressed(),
            style: TextButton.styleFrom(
              backgroundColor:
                  datesIsempty ? Colors.grey[300] : AppColors.primaryBlue,
              primary: datesIsempty ? Colors.grey[400] : Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
