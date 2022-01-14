import 'package:flutter/material.dart';
import 'package:kisan_mitra/widget/colors.dart';
import 'package:translator/translator.dart';

class MAchineOutputScreen extends StatefulWidget {
  const MAchineOutputScreen({Key key, this.name}) : super(key: key);
  final String name;

  @override
  State<MAchineOutputScreen> createState() => _MAchineOutputScreenState();
}

class _MAchineOutputScreenState extends State<MAchineOutputScreen> {
  GoogleTranslator translator = GoogleTranslator();

  getTranslate() async {
    translator.translate(widget.name, to: 'hi').then((value) {
      if (value.text == 'mango') {
        setState(() {
          output = 'आम';
        });
      } else if (value.text == 'कबूतर के मटर') {
        setState(() {
          output = 'अरहर';
        });
      } else if (value.text == 'मोथबीन') {
        setState(() {
          output = 'मोठ दाल';
        });
      } else if (value.text == 'banana') {
        setState(() {
          output = 'केला';
        });
      } else if (value.text == 'jute') {
        setState(() {
          output = 'जूट';
        });
      } else {
        setState(() {
          output = value.text;
        });
      }
    });
  }

  String output = '';
  @override
  void initState() {
    super.initState();
    getTranslate();
  }

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: txtcolor,
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.50,
              width: MediaQuery.of(context).size.width * 0.90,
              child: Image.asset(
                "assets/ml_image/${widget.name}.jpg",
                fit: BoxFit.contain,
              ),
            ),
            Text(
              output,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: txtcolor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.name.toString(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: txtcolor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
