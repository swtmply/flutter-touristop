import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:touristop/firebase_options.dart';
import 'package:touristop/init.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/user_location_provider.dart';
import 'package:touristop/services/spots_service.dart';

GetIt locator = GetIt.instance;

void setupSingletons() async {
  locator.registerLazySingleton<SpotsService>(() => SpotsService());
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupSingletons();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => UserLocationProvider()),
      ChangeNotifierProvider(create: (_) => DatesProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      home: const InitPage(),
    );
  }
}
