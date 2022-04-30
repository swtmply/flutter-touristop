import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:touristop/providers/user_location_provider.dart';
import 'package:touristop/screens/main/calendar/calendar_screen.dart';
import 'package:touristop/screens/main/map/map_screen.dart';
import 'package:touristop/theme/colors.dart';
import 'package:touristop/widgets/tests/from_firebase.dart';

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
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              const Text('Location permission is required'),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/calendar');
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  primary: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
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

  // Database test

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: FromFirebase(),
  //   );
  // }
}
