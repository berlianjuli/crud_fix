import 'dart:async';
import 'dart:io';
import 'package:crud_fix/edit.dart';
import 'package:flutter/material.dart';
import 'package:crud_fix/models/jurusan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'config.dart';
import 'package:crud_fix/create.dart';
import 'package:shared_preferences/shared_preferences.dart';

late String token;

class Home extends StatefulWidget {
  Home({super.key});
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  bool isError = false;
  late Future<List<Jurusan>?> jurusan;
  final studentListKey = GlobalKey<HomeState>();
  @override
  void initState() {
    super.initState();
    jurusan = getJurusan();
  }

  Future<List<Jurusan>?> getJurusan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;

    final response =
        await http.get(Uri.parse("${URL_PREFIX}/api/jurusan"), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token}',
    });
    //final response = await http.get(Uri.parse("${URL_PREFIX}/api/jurusan"));

    if (response.statusCode == 200) {
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      final items = jsonResponse["data"].cast<Map<dynamic, dynamic>>();
      List<Jurusan> jurusan = items.map<Jurusan>((json) {
        return Jurusan.fromJson(json);
      }).toList();

      return jurusan;
    } else {
      isError = true;
    }
    return null;
  }

  void _deleteStudent(context, idJurusan) async {
    //await http.delete(Uri.parse("${URL_PREFIX}/api/jurusan/$idJurusan"));
    await http.delete(
      Uri.parse("${URL_PREFIX}/api/jurusan/$idJurusan"),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${token}',
      },
    );
    setState(() {
      jurusan = getJurusan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: studentListKey,
      appBar: AppBar(
        title: Text('Jurusan'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Logout"),
                value: "logout",
              )
            ],
            onSelected: (value) async {
              if (value == "logout") {
                _logout(token);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Jurusan>?>(
          future: jurusan,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
// By default, show a loading spinner.
            if (!snapshot.hasData) {
              if (!isError)
                return CircularProgressIndicator();
              else
                return Text("No Data");
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.work),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text("Edit"),
                              value: "edit",
                            ),
                            PopupMenuItem(
                              child: Text("Delete"),
                              value: "delete",
                            ),
                          ];
                        },
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              var datajurusan =
                                  new Jurusan(data.idJurusan, data.namaJurusan);
                              return Edit(datajurusan: datajurusan);
                            })));
                          } else if (value == "delete") {
                            _deleteStudent(context, data.idJurusan);
                          }
                        },
                      ),
                      title: Text(
                        data.namaJurusan,
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
//aksi
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: ((context) => Create())))
              .then(onGoBack);
        },
      ),
    );
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      jurusan = getJurusan();
    });
  }

    void _logout(token) async {
    await http.post(
      Uri.parse("${URL_PREFIX}/api/auth/logout"),
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${token}',
      },
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }
}
