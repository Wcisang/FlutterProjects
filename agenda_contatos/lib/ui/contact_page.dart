import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum OrderOptions { orderaz, orderza }

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _useEdited = false;
  Contact _editContact;
  final _nameFocus = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editContact = Contact();
    } else {
      _editContact = Contact.fromMap(widget.contact.toMap());
      nameController.text = _editContact.name;
      emailController.text = _editContact.email;
      phoneController.text = _editContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            _editContact.name ?? "Novo contato",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
          onPressed: () {
            if (_editContact.name != null && _editContact.name.isNotEmpty) {
              Navigator.pop(context, _editContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _editContact.img != null
                              ? FileImage(File(_editContact.img))
                              : AssetImage("images/person.png"))),
                ),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera)
                      .then((data) {
                    if (data == null) return;
                    setState(() {
                      _editContact.img = data.path;
                    });
                  });
                },
              ),
              TextField(
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  labelText: "Nome",
                ),
                onChanged: (text) {
                  _useEdited = true;
                  setState(() {
                    _editContact.name = text;
                  });
                },
                controller: nameController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                onChanged: (text) {
                  _useEdited = true;
                  _editContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Phone",
                ),
                onChanged: (text) {
                  _useEdited = true;
                  _editContact.phone = text;
                },
                keyboardType: TextInputType.phone,
                controller: phoneController,
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<bool> _requestPop() {
    if (_useEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
