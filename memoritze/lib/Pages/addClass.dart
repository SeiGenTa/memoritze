// ignore: file_names
import 'package:flutter/material.dart';
import 'package:memoritze/partes/barraLeft.dart';
import 'package:memoritze/setting.dart';

class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  Setting mySetting = Setting();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nameClass = TextEditingController();
    final descriptionClass = TextEditingController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: mySetting.getColorDrawer(),
            title: const Text('Añadir clases'),
          ),
          drawer: const BarraLeft(),
          backgroundColor: mySetting.getBackgroundColor(),
          body: ListView(
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Todo ramo tiene un nombre';
                            }
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Debes añadir alguna descripcion, ¿no?";
                            }
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
                      Center(
                        child: IconButton(
                          hoverColor: mySetting.getColorDrawerSecundary(),
                          icon: Icon(
                            Icons.save_alt,
                            color: mySetting.getColorText(),
                          ),
                          onPressed: () {
                            _formKey.currentState!.validate();
                            bool validate = true;
                            if (nameClass.text.isEmpty) {
                              validate = false;
                            }
                            if (descriptionClass.text.isEmpty) {
                              validate = false;
                            }
                            print(
                                "la clase es validada: " + validate.toString());
                            print("name: " + nameClass.text);
                            print("descripcion: " + descriptionClass.text);
                          },
                        ),
                      )
                    ],
                  ))
            ],
          )),
    );
  }
}
