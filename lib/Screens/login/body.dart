import 'dart:convert';

import 'package:fit_master/Screens/Welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkAccess();
  }

  checkAccess() async {
    final storedRefreshToken = await secureStorage.read(key: 'access_token');
    if (storedRefreshToken != null) {
      try {
        var res = await http.get(
            'http://192.168.31.119:3000/app/rest/v2/entities/sec\$Role',
            headers: {
              "Authorization": 'Bearer ' + storedRefreshToken.toString()
            });
        if (res.statusCode == 200) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WelcomeScreen(),
              ));
        }
      } catch (e) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WelcomeScreen(),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      controller: usernameController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (val) => val.length == 0 ? 'Enter Name' : null,
    );

    final passwordField = TextFormField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (val) => val.length == 0 ? 'Enter Password' : null,
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF035AA6),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (formKey.currentState.validate()) {
            String username = 'fitnessexpertback-9oDcPOY6';
            String password =
                '7c2e5ed39148a217307db30c8056a4da32cff956c9e7f5c627ea99b596be83ad';

            String basicAuth =
                'Basic ' + base64Encode(utf8.encode('$username:$password'));

            var res = await http.post(
                'http://192.168.31.119:3000/app/rest/v2/oauth/token',
                body: {
                  "grant_type": 'password',
                  "username": usernameController.text,
                  "password": passwordController.text
                },
                headers: {
                  "Authorization": basicAuth,
                  "Content-Type": 'application/x-www-form-urlencoded'
                });
            if (res.statusCode==200) {
              await secureStorage.write(
                  key: 'access_token',
                  value: json.decode(res.body)['access_token']);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ));
            }
            else {
              usernameController.clear();
              passwordController.clear();
              formKey.currentState.validate();
            }


          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
            color: Colors.white,
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 400,
                      child: Image.asset(
                        "assets/images/back.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    //SizedBox(height: 45.0),
                    emailField,
                    SizedBox(height: 25.0),
                    passwordField,
                    SizedBox(
                      height: 35.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            )),
      ),
    ));
  }
}
