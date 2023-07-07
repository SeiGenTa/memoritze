import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/settings.dart';

// ignore: must_be_immutable
class InfoMateria extends StatefulWidget {
  late int idMateria;
  InfoMateria({super.key, required int this.idMateria});

  @override
  State<InfoMateria> createState() => _InfoMateriaState();
}

class _InfoMateriaState extends State<InfoMateria> {
  late int idClass;
  late List<Map<String, dynamic>> infPregMateria;
  late Map<String, dynamic> infMateria;
  ConectioDataBase dataBase = ConectioDataBase();
  Setting setting = Setting();

  bool charging = true;

  bool viewEraseMateria = false;
  final _formNewQuest = GlobalKey<FormState>();
  final pregunta = TextEditingController();
  final respuesta = TextEditingController();


  bool viewEditQuest = false;
  final _formEditQuest = GlobalKey<FormState>();
  final preguntaEdit = TextEditingController();
  final respuestaEdit = TextEditingController();
  int indexQuest = 0;
  bool viewCreateNewQuest = false;

  late Color textColor;

  Future<bool> chargePage() async {
    infPregMateria = await dataBase.getQuests(widget.idMateria);
    infMateria = await dataBase.getMaterialID(widget.idMateria);
    idClass = infMateria['ID'];
    setState(() {
      charging = false;
    });
    return true;
  }

  initEditQuest(int ubq) {
    Map<String, dynamic> myPreg = infPregMateria[ubq];
    indexQuest = ubq;
    preguntaEdit.text = myPreg['Pregunta'];
    respuestaEdit.text = myPreg['respuesta'];
    setState(() {
      viewEditQuest = true;
    });
  }

  void saveChangeQuest() {
    dataBase.setQuestID(infPregMateria[indexQuest]['ID'], preguntaEdit.text,
        respuestaEdit.text);
    chargePage();
    setState(() {
      viewEditQuest = false;
    });
  }

  saveEditQuest() {}

  @override
  void initState() {
    super.initState();
    textColor = setting.getColorText();
    chargePage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pregunta.dispose();
    respuesta.dispose();
    preguntaEdit.dispose();
    respuestaEdit.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: setting.getColorDrawerSecundary(),
          title: Container(
            alignment: Alignment.topLeft,
            child: IconButton(
              iconSize: 50,
              color: setting.getColorText(),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        backgroundColor: setting.getBackgroundColor(),
        body: charging
            ? Stack(
                //!Pantalla de carga
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: setting.getColorText(),
                    ),
                  )
                ],
              )
            : Stack(
                children: [
                  //!Parte visual al cargar
                  Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: infPregMateria.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () => initEditQuest(index),
                                  hoverColor: setting.getColorPaper(),
                                  textColor: setting.getColorText(),
                                  title: Container(
                                    constraints: const BoxConstraints(
                                      maxHeight: 30,
                                    ),
                                    child: Text(
                                      infPregMateria[index]['Pregunta'],
                                      style: TextStyle(
                                        color: setting.getColorText(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  subtitle: Container(
                                    constraints: const BoxConstraints(
                                      maxHeight: 50,
                                    ),
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      infPregMateria[index]['respuesta'],
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                );
                              })),
                    ],
                  ),
                  if (viewCreateNewQuest)
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black26,
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height / 2,
                        ),
                        color: setting.getBackgroundColor(),
                        padding: EdgeInsets.all(30),
                        child: Form(
                          key: _formNewQuest,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //* INPUT DE PREGUNTA
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Debes colocar una buena pregunta.';
                                  }
                                  return null;
                                },
                                controller: pregunta,
                                maxLines: 5,
                                minLines: 1,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: textColor,
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: textColor,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: textColor,
                                    ),
                                  ),
                                  labelStyle: TextStyle(color: textColor),
                                  hintStyle: TextStyle(color: textColor),
                                  hintText:
                                      "Ejm: ¿cual es estado mas comun en las estrellas?",
                                  hoverColor: textColor,
                                  labelText: "Pregunta",
                                  icon: Icon(
                                    Icons.question_mark,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              //* INPUT DE RESPUESTA
                              TextFormField(
                                maxLines: 5,
                                minLines: 1,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Debes colocar una respuesta.';
                                  }
                                  return null;
                                },
                                controller: respuesta,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: textColor,
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: textColor,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: textColor,
                                    ),
                                  ),
                                  labelStyle: TextStyle(color: textColor),
                                  hintStyle: TextStyle(color: textColor),
                                  hintText:
                                      "Ejm: Debe ser la respuesta mas descriptiva o certera posible",
                                  hoverColor: textColor,
                                  labelText: "Respuesta",
                                  icon: Icon(
                                    Icons.question_answer,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () => setState(() {
                                      pregunta.clear();
                                      respuesta.clear();
                                      viewCreateNewQuest = false;
                                    }),
                                    icon: const Icon(Icons.cancel),
                                    iconSize: 40,
                                    color: textColor,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      _formNewQuest.currentState!.validate();
                                      if (pregunta.text.isEmpty ||
                                          respuesta.text.isEmpty) return;
                                      await dataBase.createPreg(
                                          idClass,
                                          widget.idMateria,
                                          pregunta.text.toString(),
                                          respuesta.text.toString());
                                      pregunta.clear();
                                      respuesta.clear();
                                      viewCreateNewQuest = false;
                                      chargePage();
                                    },
                                    icon: const Icon(Icons.check_circle),
                                    iconSize: 40,
                                    color: textColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (viewEraseMateria)
                    Container(
                      color: Colors.black26,
                      alignment: Alignment.center,
                      child: Container(
                        color: setting.getBackgroundColor(),
                        padding: EdgeInsets.all(20),
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height / 3,
                          minWidth: MediaQuery.of(context).size.width / 3,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "¿Estas seguro de querer eliminar esta materia?",
                                style: TextStyle(color: setting.getColorText()),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.of(context).size.width / 3,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () => setState(() {
                                        viewEraseMateria = false;
                                      }),
                                      icon: const Icon(Icons.cancel_rounded),
                                      color: setting.getColorText(),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await dataBase.deleteMateria(
                                            widget.idMateria, idClass);
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.check_circle),
                                      color: setting.getColorText(),
                                    )
                                  ],
                                ),
                              )
                            ]),
                      ),
                    ),
                  if (viewEditQuest)
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black26,
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height / 2,
                        ),
                        color: setting.getBackgroundColor(),
                        padding: EdgeInsets.all(30),
                        child: Form(
                          key: _formEditQuest,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //* INPUT DE PREGUNTA
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Debes colocar una buena pregunta.';
                                  }
                                  return null;
                                },
                                controller: preguntaEdit,
                                maxLines: 5,
                                minLines: 1,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: textColor,
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: textColor,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: textColor,
                                    ),
                                  ),
                                  labelStyle: TextStyle(color: textColor),
                                  hintStyle: TextStyle(color: textColor),
                                  hintText:
                                      "Ejm: ¿cual es estado mas comun en las estrellas?",
                                  hoverColor: textColor,
                                  labelText: "Pregunta",
                                  icon: Icon(
                                    Icons.question_mark,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              //* INPUT DE RESPUESTA
                              TextFormField(
                                maxLines: 5,
                                minLines: 1,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Debes colocar una respuesta.';
                                  }
                                  return null;
                                },
                                controller: respuestaEdit,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: textColor,
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: textColor,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: textColor,
                                    ),
                                  ),
                                  labelStyle: TextStyle(color: textColor),
                                  hintStyle: TextStyle(color: textColor),
                                  hintText:
                                      "Ejm: Debe ser la respuesta mas descriptiva o certera posible",
                                  hoverColor: textColor,
                                  labelText: "Respuesta",
                                  icon: Icon(
                                    Icons.question_answer,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () => setState(() {
                                      preguntaEdit.clear();
                                      respuestaEdit.clear();
                                      viewEditQuest = false;
                                    }),
                                    icon: const Icon(Icons.cancel),
                                    iconSize: 40,
                                    color: textColor,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await dataBase.deletedQuest(
                                          infPregMateria[indexQuest]['ID']);
                                      setState(() {
                                        pregunta.clear();
                                        respuesta.clear();
                                        chargePage();
                                        viewEditQuest = false;
                                      });
                                    },
                                    icon: Icon(Icons.delete_forever),
                                    iconSize: 40,
                                    color: textColor,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      _formEditQuest.currentState!.validate();
                                      if (preguntaEdit.text.isEmpty ||
                                          respuestaEdit.text.isEmpty) return;
                                      saveChangeQuest();
                                    },
                                    icon: const Icon(Icons.check_circle),
                                    iconSize: 40,
                                    color: textColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
        bottomNavigationBar: BottomAppBar(
          color: setting.getColorDrawerSecundary(),
          child: charging
              ? Container(
                  height: 0,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => setState(() {
                        viewEraseMateria = true;
                      }),
                      icon: Icon(
                        Icons.delete,
                        color: setting.getColorText(),
                      ),
                      iconSize: 40,
                    ),
                    IconButton(
                      onPressed: () => setState(() {
                        viewCreateNewQuest = true;
                      }),
                      icon: Icon(
                        Icons.add,
                        color: setting.getColorText(),
                      ),
                      iconSize: 40,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
