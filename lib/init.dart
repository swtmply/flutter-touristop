import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:touristop/providers/user_location_provider.dart';
import 'package:touristop/screens/main/calendar_screen.dart';
import 'package:touristop/services/spots_service.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final SpotsService _spotsService = GetIt.I.get<SpotsService>();

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<UserLocationProvider>(context, listen: false)
            .setUserPosition(position);
      });
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // ignore: todo
        // TODO:
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Tests

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Transparent App Bar
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const CalendarScreen(),
    );
  }

  // Map Page

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Provider.of<UserLocationProvider>(context).userPosition != null
  //         ? const Center(child: MapSample())
  //         : const Center(child: CircularProgressIndicator()),
  //   );
  // }
}

class _DataTest extends StatelessWidget {
  const _DataTest({
    Key? key,
    required SpotsService spotsService,
  })  : _spotsService = spotsService,
        super(key: key);

  final SpotsService _spotsService;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _spotsService.spotsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Locations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return ListTile(
                    title: Text(data['name']),
                    subtitle: Text(
                        'Latitude: ${data['latitude']} : Longitude: ${data['longitude']}'),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
