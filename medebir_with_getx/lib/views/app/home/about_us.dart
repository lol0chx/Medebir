import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.at, size: 28.0, color: Colors.purple),
                SizedBox(height: size.height * 0.02),
                Text("Made by developers \nFrom Unity University.", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.purple)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
