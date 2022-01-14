// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kisan_mitra/ui/seedPredictionScreen.dart';
import 'package:kisan_mitra/widget/colors.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  WeatherScreen({Key key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Location location = Location();
  double locationLat = 20.5937;
  double locationLong = 78.9629;
  List weatherList;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        getWeatherData(locationLat.toString(), locationLong.toString());
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();

    locationLat = _locationData?.latitude;
    locationLong = _locationData?.longitude;
    getWeatherData(locationLat.toString(), locationLong.toString());
  }

  Future getWeatherData(String lat, String long) async {
    weatherList = [];
    try {
      Uri uri = Uri.parse(
          "https://api.weatherbit.io/v2.0/current?lat=$lat&lon=$long&key=$value");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        setState(() {
          weatherList = decodeData['data'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    double windSpeed = weatherList == null ? 0 : weatherList[0]['wind_spd'];
    // Size sizes =  MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          "Kisan Mitra",
          style: TextStyle(
            fontSize: 30,
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold,
            color: redcolor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 2,
              child: weatherList == null
                  ? const Image(
                      image: AssetImage("assets/logo.jpg"),
                      fit: BoxFit.contain,
                    )
                  : Image(
                      image: NetworkImage(
                          "https://www.weatherbit.io/static/img/icons/${weatherList[0]['weather']['icon']}.png"),
                      fit: BoxFit.contain,
                    ),
            ),
            Text(
              "${weatherList == null ? "" : weatherList[0]['weather']['description']}",
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: txtcolor,
                letterSpacing: 0.5,
              ),
            ),
            Expanded(
              flex: 6,
              child: weatherWidget(
                  context,
                  "${weatherList == null ? "0 C" : weatherList[0]['temp']}",
                  "${weatherList == null ? "0" : weatherList[0]['rh']}%",
                  "${weatherList == null ? "0" : windSpeed.round()} km/h",
                  "${weatherList == null ? "" : weatherList[0]['city_name']}"),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: SizedBox(
                  height: 60,
                  width: 300,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SeedPredictionScreen(
                              // temp: weatherList[0]['temp'].toString(),
                              // humidity: weatherList[0]['rh'].toString(),
                              ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: greencolor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0))),
                    child: const Text(
                      "Seed Prediction By ML",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: txtcolor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Image.network(
//                                 "https://www.weatherbit.io/static/img/icons/" +
//                                     data['weather']['icon'] +
//                                     ".png"),

Widget weatherWidget(context, value1, value2, value3, value4) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Row(
        children: [
          weatherData(value1, "Temperature", context),
          weatherData(value2, "Humidity", context)
        ],
      ),
      Row(
        children: [
          weatherData(value3, "Wind Speed", context),
          weatherData(value4, "Location", context)
        ],
      ),
    ],
  );
}

Widget weatherData(String value, String name, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.46,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          // ignore: prefer_const_constructors
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: txtcolor,
          ),
        ),
        // ignore: prefer_const_constructors
        SizedBox(
          height: 10,
        ),
        Text(
          name,
          // ignore: prefer_const_constructors
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: greencolor,
            letterSpacing: 0.5,
          ),
        )
      ],
    ),
  );
}
