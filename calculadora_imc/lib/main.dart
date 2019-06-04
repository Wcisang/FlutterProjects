import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  String _result = "";

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _globalKey = GlobalKey<FormState>();
      _result = "Calcule seu IMC";

    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      if (imc < 18.6) {
        _result = "Magrelaa (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        _result = "Peso Ideal (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        _result = "Levemente Acima do Peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        _result = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 34.9 && imc < 39.9) {
        _result = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 40) {
        _result = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora IMC"),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFields,
            )
          ],
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    size: 120.0,
                    color: Colors.green,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Peso (kg)",
                        labelStyle: TextStyle(color: Colors.green)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 25.0),
                    controller: weightController,
                    validator: (value) {
                      if (value.isEmpty) return "Insira seu peso";
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Altura (cm)",
                        labelStyle: TextStyle(color: Colors.green)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 25.0),
                    controller: heightController,
                    validator: (value) {
                      if (value.isEmpty) return "Insira sua altura";
                    },
                  ),
                  Container(
                    height: 70.0,
                    margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 20.0),
                    padding: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_globalKey.currentState.validate()) _calculate();
                      },
                      child: Text(
                        "Calcular",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    _result,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 25.0),
                  )
                ],
              ),
            )));
  }
}
