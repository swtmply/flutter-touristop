import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:touristop/providers/user_location_provider.dart';
import 'package:touristop/screens/main/calendar/calendar_screen.dart';
import 'package:touristop/screens/main/map_screen.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
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
        // ignore: todo
        // TODO
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
