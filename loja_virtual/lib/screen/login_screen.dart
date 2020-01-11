import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "CRIAR CONTA",
              style: TextStyle(fontSize: 15.0),
            ),
            textColor: Colors.white,
            onPressed: () {},
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "E-mail",
              ),
              keyboardType: TextInputType.emailAddress,
              validator: emailValidator,
            ),
            SizedBox(
              height: 16.0,
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Senha"),
              obscureText: true,
              validator: passwordValidator,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  "Esqueci minha senha",
                  textAlign: TextAlign.right,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 44.0,
              child: RaisedButton(
                child: Text(
                  "Entrar",
                  style: TextStyle(fontSize: 18.0),
                ),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (_formKey.currentState.validate()) {

                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  String emailValidator(String text) {
    if (text.isEmpty || !text.contains("@")){
      return "E-mail inválido";
    }
    return null;
  }

  String passwordValidator(String text) {
    if (text.isEmpty || text.length < 6){
      return "Senha inválida";
    }
    return null;
  }
}


