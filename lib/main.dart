// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:kisan_mitra/ui/machine_output.dart';
import 'package:kisan_mitra/ui/seedPredictionScreen.dart';
import 'package:kisan_mitra/ui/weatherScreen.dart';
import 'package:kisan_mitra/widget/colors.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Kisan Mitra",
        themeMode: ThemeMode.system,
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const SeedPredictionScreen()
        // home: SplashScreen(
        //   seconds: 5,
        //   photoSize: 80,
        //   image: Image.asset("assets/logo.jpg"),
        //   useLoader: false,
        //   title: const Text(
        //     "Kisan Mitra",
        //     style: TextStyle(
        //       fontSize: 28,
        //       fontWeight: FontWeight.w700,
        //       color: redcolor,
        //       letterSpacing: 1,
        //       // fontStyle: FontStyle.italic,
        //     ),
        //   ),
        //   navigateAfterSeconds: WeatherScreen(),
        // ),
        );
  }
}
