// ignore: file_names
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:memoritze/settings.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/pages/SeeMyClass.dart';
import 'package:memoritze/partes/BarLeft.dart';

class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  Setting mySetting = Setting();
  final _formKey = GlobalKey<FormState>();

  ConectioDataBase _dataBase = ConectioDataBase();
  final nameClass = TextEditingController();
  final descriptionClass = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataBase.init();
  }

  @override
  void dispose() {
    super.dispose();
    nameClass.dispose();
    descriptionClass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: mySetting.getColorDrawer(),
            title: const Text('Añadir clases'),
          ),
          drawer: BarLeft(
            myContext: 2,
          ),
          backgroundColor: mySetting.getBackgroundColor(),
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            hoverColor: mySetting.getColorDrawerSecundary(),
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
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SeeMyClass()),
                                    (Route<dynamic> route) => false,
                                  );
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
          ])),
    );
  }
}
