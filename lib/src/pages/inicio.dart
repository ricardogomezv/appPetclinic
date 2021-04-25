// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petclinic/model/VetModel.dart';


  Future fetchVet() async {
    var aux;
    var token = aux;
    var tokenAux = token.split('Bearer');
    var tokenCom = tokenAux[1].split('"');

    var tokenUser = tokenCom[0];

    Map<String, String> headers = await {"Authorization": 'Bearer $tokenUser'};
    print(headers);
    var request = http.Request(
        'GET', Uri.parse('http://192.168.56.1:19000/API/productsJSON'));
    request.bodyFields = {};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var product = await response.stream.bytesToString();
      var aux = product.split('{"productList":[');
      var aux2 = aux[1].split(']}');
      var data = aux2[0].split(RegExp(r'(?<=\}),(?=\{)'));
      
   
    } else {
      print(await response.stream.bytesToString());
    }
}

class Inicio extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Inicio> {
   Future<List<Product>> futureVet;

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
          child: FutureBuilder<List<Product>>(
            future: futureVet,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Center(child: CircularProgressIndicator());
              }
             if (snapshot.connectionState == ConnectionState.done
                  && snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }


              if (snapshot.connectionState == ConnectionState.done
                  && snapshot.hasData) {
                return _buildVetList(snapshot);
              }
              //  spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVetList(AsyncSnapshot<List<Product>> snapshot) {
    return ListView.separated(
        padding: EdgeInsets.all(16.0),
        itemCount: snapshot.data.length,
        itemBuilder: /*1*/ (context, i) {
          return ListTile(
            title: Text(snapshot.data[i].name + ' ' +
                snapshot.data[i].description),
            subtitle: Text(snapshot.data[i].id.toString()),
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
