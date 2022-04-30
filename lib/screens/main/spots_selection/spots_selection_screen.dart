import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:touristop/models/tourist_spot_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/services/spots_service.dart';

class SpotsSelection extends StatefulWidget {
  const SpotsSelection({Key? key}) : super(key: key);

  @override
  State<SpotsSelection> createState() => _SpotsSelectionState();
}

class _SpotsSelectionState extends State<SpotsSelection> {
  final SpotsService _spotsService = GetIt.I.get<SpotsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _spotsService.spotsStream(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SelectionFilter(),
                Expanded(
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      List<dynamic> openDates = data['openDates'];

                      var dates = Provider.of<DatesProvider>(context).dates;

                      for (var date in dates!) {
                        var result = openDates.firstWhere(
                            (day) =>
                                day == DateFormat('EE').format(date).toString(),
                            orElse: (() => null));

                        if (result != null) return Text(data['name']);
                      }

                      return const Text('');
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SelectionFilter extends StatelessWidget {
  const SelectionFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: const [
          Text(
            'Places to go to',
            style: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
