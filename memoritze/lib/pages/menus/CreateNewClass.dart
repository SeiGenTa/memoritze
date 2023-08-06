// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/settings.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({super.key});

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
    return AlertDialog(
      title: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              )),
          const Text(
            "Crear clase",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: mySetting.getColorNavSup(),
      actions: [],
      content: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Todo ramo tiene un nombre';
                          }
                          return null;
                        },
                        controller: nameClass,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: "Un buen nombre organizara nuestro estudio",
                          hoverColor: Colors.white,
                          labelText: "Nombre de la clase",
                          icon: Icon(
                            Icons.near_me,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
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
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                            hintText:
                                "Esto es un cuestionario de una de mis clases favoritas",
                            labelText: "Descripcion",
                            icon: Icon(
                              Icons.description_sharp,
                              color: Colors.white,
                            )),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        alignment: Alignment.center,
                        child: IconButton(
                          color: Colors.white,
                          iconSize: 30,
                          hoverColor: Colors.white.withOpacity(0.5),
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
                                Navigator.pop(context);
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor:
                                            mySetting.getColorNavSup(),
                                        title: const Text(
                                          "Ya existe una clase con ese nombre",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                                    });
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ))
            ],
          ))
        ],
      ),
    );
  }
}
