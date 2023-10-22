import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final _controllerJurusan = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tambah Jurusan"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _controllerJurusan,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nama Jurusan',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    _createStudent(context);
                  },
                  child: Text("Submit"))
            ],
          ),
        ));
  }

  void _createStudent(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    /*await http.post(
      Uri.parse("${URL_PREFIX}/api/jurusan/"),
      body: {
        'name': _controllerJurusan.text,
      },
    );*/
    await http.post(
      Uri.parse("${URL_PREFIX}/api/jurusan/"),
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${token}',
      },
      body: {
        'name': _controllerJurusan.text,
      },
    );

    // Remove all existing routes until the Home.dart, then rebuild Home.
    Navigator.pop(context);
  }
}
