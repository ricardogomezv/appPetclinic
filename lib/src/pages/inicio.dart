// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petclinic/model/VetModel.dart';
import '../../storage.dart';
var aux35;

getProducts() async {
  var tokenUser = await storage.read(key: 'token');
  var tokenUser1 = tokenUser.split('"}');
  var tokenUser2 = tokenUser1[0].split('"');
  tokenUser = tokenUser2[1];
  print("getting");

  var data = await http.post("http://192.168.0.231:19000/API/productsJSON",
      body: {}, headers: {"Authorization": '$tokenUser'});

  var jsonData = json.decode(data.body);

  return jsonData;
}

Future fetchVet() async {
  var tokenUser = await storage.read(key: 'token');
  var tokenUser1 = tokenUser.split('"}');
  var tokenUser2 = tokenUser1[0].split('"');
  tokenUser = tokenUser2[1];
  Map<String, String> headers = await {"Authorization": '$tokenUser'};
  print(headers);
  var request = http.Request(
      'GET', Uri.parse('http://192.168.56.1:19000/API/productsJSON'));
  request.bodyFields = {};
  request.headers.addAll(headers);
  print("aqui1");
  http.StreamedResponse response = await request.send();
  print("aqui2");
  if (response.statusCode == 200) {
    var product = await response.stream.bytesToString();
    var aux = product.split('{"productList":[');
    var aux2 = aux[1].split(']}');
    var data = aux2[0].split(RegExp(r'(?<=\}),(?=\{)'));
    print(data);
    aux35 = request;
  } else {
    print("aqui4");
    print(await response.stream.bytesToString());
  }
}

class Inicio extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Inicio> {
  Future<dynamic> futureVet;

  @override
  void initState() {
    super.initState();
    futureVet = fetchVet();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vet API',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        
        body: Center(
          child: FutureBuilder(
            future: getProducts(),
            builder: (context, snapshot) {
              print("aqui: $snapshot");
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                print("aqui6");
                return _buildVetList(snapshot);
              }
              //  spinner.
              print("aqui7");
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVetList(AsyncSnapshot<dynamic> snapshot) {
    return ListView.separated(
      padding: EdgeInsets.all(16.0),
      itemCount: snapshot.data['productList'].length,
      itemBuilder: /*1*/ (context, i) {
        return ListTile(
          title: Text(snapshot.data['productList'][i]['name'] +
              ' : ' +
              snapshot.data['productList'][i]['description']),
          //Text(snapshot.data[i].name + ' ' + snapshot.data[i].description),
          subtitle: Text(snapshot.data['productList'][i]['id'].toString()),
          trailing: Icon(Icons.pets_outlined),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          indent: 20,
          endIndent: 20,
        );
      },
    );
  }
}