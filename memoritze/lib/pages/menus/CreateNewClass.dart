import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/settings.dart';

class CreateClass extends StatefulWidget {
  CreateClass({super.key});

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  // Creamos un StreamController para emitir eventos y notificar a los observadores.
  StreamController<String> _controller = StreamController<String>();

  // Creamos un getter para el stream, para que los observadores puedan suscribirse a él.
  Stream<String> get stream => _controller.stream;

  Setting mySetting = Setting();
  final _formKey = GlobalKey<FormState>();

  ConnectionDataBase _dataBase = ConnectionDataBase();
  final nameClass = TextEditingController();
  final descriptionClass = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameClass.dispose();
    descriptionClass.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mySetting.getBackgroundColor(),
        appBar: AppBar(
          backgroundColor: mySetting.getColorNavSup(),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Stack(children: [
          ListView(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height / 10,
                          right: MediaQuery.of(context).size.height / 10,
                        ),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Todo ramo tiene un nombre';
                            }
                            return null;
                          },
                          controller: nameClass,
                          style: TextStyle(
                            fontSize: 15,
                            color: mySetting.getColorText(),
                          ),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: mySetting.getColorText(),
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: mySetting.getColorText(),
                              ),
                            ),
                            labelStyle:
                                TextStyle(color: mySetting.getColorText()),
                            hintStyle:
                                TextStyle(color: mySetting.getColorText()),
                            hintText:
                                "Un buen nombre organizara nuestro estudio",
                            hoverColor: mySetting.getColorText(),
                            labelText: "Nombre de la clase",
                            icon: Icon(
                              Icons.near_me,
                              color: mySetting.getColorText(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height / 10,
                          right: MediaQuery.of(context).size.height / 10,
                        ),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          minLines: 1,
                          maxLines: 5,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Debes añadir alguna descripcion, ¿no?";
                            }
                            return null;
                          },
                          controller: descriptionClass,
                          style: TextStyle(
                            fontSize: 15,
                            color: mySetting.getColorText(),
                          ),
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: mySetting.getColorText(),
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: mySetting.getColorText(),
                                ),
                              ),
                              labelStyle:
                                  TextStyle(color: mySetting.getColorText()),
                              hintStyle:
                                  TextStyle(color: mySetting.getColorText()),
                              hintText:
                                  "Esto es un cuestionario de una de mis clases favoritas",
                              labelText: "Descripcion",
                              icon: Icon(
                                Icons.description_sharp,
                                color: mySetting.getColorText(),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        alignment: Alignment.center,
                        child: IconButton(
                          color: mySetting.getColorText(),
                          iconSize: 30,
                          hoverColor: mySetting.getColorDrawerSecondary(),
                          icon: const Icon(
                            Icons.save,
                          ),
                          onPressed: () async {
                            _formKey.currentState!.validate();
                            bool validate = true;
                            if (nameClass.text.isEmpty) {
                              validate = false;
                            }
                            if (descriptionClass.text.isEmpty) {
                              validate = false;
                            }

                            if (validate) {
                              bool request = await _dataBase.createClass(
                                  nameClass.text, descriptionClass.text);
                              if (request) {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ))
            ],
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Text(
              "version: 0.${mySetting.version0.toString()}",
              style: TextStyle(color: mySetting.getColorText()),
            ),
          )
        ]));
  }
}
