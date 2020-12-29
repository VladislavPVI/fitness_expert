import 'package:fit_master/Screens/Welcome/components/background.dart';
import 'package:fit_master/Screens/trainingplan/trainings_screen.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("\nFITNESS\nEXPERT",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                textAlign: TextAlign.center),
            Image.asset('assets/images/back.png', height: size.height * 0.45),
            MaterialButton(
              color: Color(0xFF035AA6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0),
                  side: BorderSide(color: Colors.red[900])),
              child: const Text('Training plans',
                  style: TextStyle(fontSize: 25, color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return TrainingScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
