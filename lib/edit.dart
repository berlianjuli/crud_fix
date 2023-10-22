import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'models/jurusan.dart';

class Edit extends StatefulWidget {
  final Jurusan datajurusan;

  Edit({super.key,required this.datajurusan});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController _controllerJurusan=TextEditingController();
  @override
  void initState(){
    super.initState();
     _controllerJurusan.text=widget.datajurusan.namaJurusan;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Jurusan"),
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
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){
                  _EditStudent(context);
              }, child: Text("Submit"))
            ],
          ),
        ));
  }

  void _EditStudent(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    var id=widget.datajurusan.idJurusan;
    await http.put(
      Uri.parse("${URL_PREFIX}/api/jurusan/$id"),headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${token}',
      },
      body: {
        'name': _controllerJurusan.text,
      },
    );
    // Remove all existing routes until the Home.dart, then rebuild Home.
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}
