import 'package:flutter/material.dart';

import 'Screens/Welcome/welcome_screen.dart';
import 'Screens/login/body.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MyHomePage(title: 'Flutter Login'),
    );
  }
}
