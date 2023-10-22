import 'dart:convert' as convert;
import 'package:crud_fix/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? teks;
  String? token;
  var controllerNama = TextEditingController();
  var controllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Form"),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                controller: controllerNama,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: controllerPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  
                  labelText: 'Password',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (controllerNama.text != "" && controllerPassword.text != "") {
                      token = await _login();

                      if (token != "") {
                        // Obtain shared preferences.
                        saveToken(token);
                        Navigator.push(context, MaterialPageRoute(builder: ((context) => Home())));
                      }
                    }else{
                       warning(context);
                    }
                  },
                  child: Text("Login"))
            ],
          ),
        ),
      ),
    );
  }

  saveToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<String?> _login() async {
    try {
      var response = await http.post(
        Uri.parse("${URL_PREFIX}/api/auth/login"),
        body: {
          'email': controllerNama.text,
          'password': controllerPassword.text,
          'device_name': 'android'
        },
      );
      if (response.statusCode == 200) {
        return convert.jsonDecode(response.body); //give token
      }
    } on Exception catch (_) {
      warning(context);
    }
    return "";
  }

  warning(BuildContext context) {
// set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text("Username dan Password salah"),
      actions: [
        ElevatedButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
// show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
