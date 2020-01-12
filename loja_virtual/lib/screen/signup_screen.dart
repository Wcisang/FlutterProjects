import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("criar conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(child: CircularProgressIndicator(),);
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Nome completo",
                    ),
                    validator: nameValidator,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _emailController,
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
                    controller: _addressController,
                    decoration: InputDecoration(hintText: "Endereço"),
                    validator: addressValidator,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(hintText: "Senha"),
                    obscureText: true,
                    validator: passwordValidator,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        "Criar conta",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Theme
                          .of(context)
                          .primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Map<String, dynamic> userData = {
                            "name": _nameController.text,
                            "email": _emailController.text,
                            "address": _addressController.text,
                          };
                          model.signUp(
                              userData, _passController.text, onSuccess,
                              onFailed);
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }

  void onSuccess() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("usuario criado com sucesso"),
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          duration: Duration(seconds: 2),)
    );
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.pop(context);
    });
  }

  void onFailed() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao criar usuario"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),)
    );
  }

  String emailValidator(String text) {
    if (text.isEmpty || !text.contains("@")) {
      return "E-mail inválido";
    }
    return null;
  }

  String passwordValidator(String text) {
    if (text.isEmpty || text.length < 6) {
      return "Senha inválida";
    }
    return null;
  }

  String nameValidator(String text) {
    if (text.isEmpty) {
      return "Nome inválido";
    }
    return null;
  }

  String addressValidator(String text) {
    if (text.isEmpty) {
      return "Endereço inválido";
    }
    return null;
  }
}
