// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kisan_mitra/ui/machine_output.dart';
import 'package:kisan_mitra/widget/colors.dart';
import 'package:http/http.dart' as http;

class SeedPredictionScreen extends StatefulWidget {
  const SeedPredictionScreen({Key key}) : super(key: key);
  // final String temp;
  // final String humidity;

  @override
  _SeedPredictionScreenState createState() => _SeedPredictionScreenState();
}

class _SeedPredictionScreenState extends State<SeedPredictionScreen> {
  final TextEditingController _nitrogen = TextEditingController();
  final TextEditingController _potassium = TextEditingController();
  final TextEditingController _phosphorus = TextEditingController();
  final TextEditingController _temperature = TextEditingController();
  final TextEditingController _humidity = TextEditingController();
  final TextEditingController _ph = TextEditingController();
  final TextEditingController _rainfall = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   _temperature.text = widget.temp.toString();
  //   _humidity.text = widget.humidity.toString();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: const Icon(
        //     Icons.arrow_back,
        //     color: txtcolor,
        //   ),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 15,
          right: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              txtwidget(" Nitrogen"),
              txtfield(context, _nitrogen, "Enter The Nitrogen Value:40"),
              txtwidget(" Phosphorus"),
              txtfield(
                  context, _phosphorus, "Enter The Phosphorun Value eg:20"),
              txtwidget(" Potassium"),
              txtfield(context, _potassium, "Enter The Potassium Value eg:50"),
              txtwidget(" Temperature"),
              txtfield(
                  context, _temperature, "Enter The Temperature Value eg:20"),
              txtwidget(" Humidity"),
              txtfield(context, _humidity, "Enter The Humidity Value eg:50"),
              txtwidget(" pH"),
              txtfield(context, _ph, "Enter The pH Value between 1 to 8"),
              txtwidget(" Rainfall"),
              txtfield(
                  context, _rainfall, "Enter The Rainfall Value eg:102.33"),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 280,
                  child: TextButton(
                    onPressed: () {
                      machineData(
                          double.parse(
                              _nitrogen.text == "" ? "0" : _nitrogen.text),
                          double.parse(
                              _phosphorus.text == "" ? "0" : _phosphorus.text),
                          double.parse(
                              _potassium.text == "" ? "0" : _potassium.text),
                          double.parse(_temperature.text == ""
                              ? "0"
                              : _temperature.text),
                          double.parse(
                              _humidity.text == "" ? "0" : _humidity.text),
                          double.parse(_ph.text == "" ? "0" : _ph.text),
                          double.parse(
                              _rainfall.text == "" ? "0" : _rainfall.text));
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: greencolor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0))),
                    child: const Text(
                      "Enter",
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
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool fatching = false;
  Future machineData(double n, double p, double k, double temp, double hum,
      double ph, double rainfall) async {
    try {
      fatching = true;
      Uri uri = Uri.parse("https://agri-seed-prediction.herokuapp.com/predict");
      Map<String, dynamic> bodyData = {
        "N": n,
        "P": p,
        "K": k,
        "temperature": temp,
        "humidity": hum,
        "ph": ph,
        "rainfall": rainfall
      };
      await http.post(
        uri,
        body: json.encode([bodyData]),
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      ).then((http.Response response) {
        if (response.statusCode == 200) {
          var responsedata = json.decode(response.body);
          setState(() {
            name = responsedata['Predict Data'][0].toString();
          });
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MAchineOutputScreen(
                      name: name,
                    )),
          );
          fatching = false;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  String name = "";
}

Widget txtfield(
    BuildContext context, TextEditingController txtcontroller, String value) {
  return Container(
    margin: const EdgeInsets.only(
      top: 5,
      bottom: 5,
    ),
    padding: const EdgeInsets.only(
      left: 10,
      right: 10,
    ),
    alignment: Alignment.center,
    height: 55,
    width: MediaQuery.of(context).size.width * 0.90,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: greencolor,
        width: 2,
      ),
    ),
    child: TextFormField(
      textInputAction: TextInputAction.done,
      controller: txtcontroller,
      keyboardType: TextInputType.number,
      keyboardAppearance: Brightness.light,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      decoration: InputDecoration(border: InputBorder.none, hintText: value),
    ),
  );
}

Widget txtwidget(String name) {
  return Text(
    name,
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: greencolor,
      letterSpacing: 0.5,
    ),
  );
}
