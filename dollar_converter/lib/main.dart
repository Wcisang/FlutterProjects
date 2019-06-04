import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=c71f6309";

void main() async {
  runApp(MaterialApp(home: Home(),
  theme: ThemeData(
    hintColor: Colors.amber,
    primaryColor: Colors.white,
  ),));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  TextEditingController realController = TextEditingController();
  TextEditingController dolarController = TextEditingController();
  TextEditingController euroController = TextEditingController();

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar /this.euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro*this.euro).toStringAsFixed(2);
    dolarController.text = (euro*this.euro / this.dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return getLoadingData();
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return getErrorData();
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return getSuccessData(dolar, euro);
                }
                break;
            }
          }),
    );
  }

  Widget getSuccessData(double dolar, double euro) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(
            Icons.monetization_on,
            size: 150.0,
            color: Colors.amber,
          ),
          Divider(),
          buildTextFields("Real", "R\$", realController, _realChanged),
          Divider(),
          buildTextFields("Dolar", "US\$", dolarController, _dolarChanged),
          Divider(),
          buildTextFields("Euro", "€", euroController, _euroChanged)
        ],
      ),
    );
  }
  
  Widget buildTextFields(String label, String prefix, TextEditingController controller, Function f) {
    return TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.amber,
          ),
          border: OutlineInputBorder(),
          prefixText: prefix
      ),
      style: TextStyle(
          color: Colors.amber,
          fontSize: 25.0
      ),
      controller: controller,
      onChanged: f,
    );
  }

  Widget getLoadingData() {
    return Center(
      child: Text(
        "Carregando Dados...",
        style: TextStyle(color: Colors.amber, fontSize: 25.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget getErrorData() {
    return Center(
      child: Text(
        "Erro ao carregar dados :(",
        style: TextStyle(color: Colors.amber, fontSize: 25.0),
        textAlign: TextAlign.center,
      ),
    );
  }
}
