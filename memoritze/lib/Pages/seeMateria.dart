// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:memoritze/db/dataBase.dart';
import 'package:memoritze/setting.dart';

// ignore: must_be_immutable
class SeeMateria extends StatefulWidget {
  late int idMateria;
  late int idClass;

  SeeMateria({super.key, required this.idMateria, required this.idClass});

  @override
  State<SeeMateria> createState() => _SeeMateriaState();
}

class _SeeMateriaState extends State<SeeMateria> {
  Setting setting = Setting();
  MyDataBase database = MyDataBase();

  bool charging = true;

  bool viewCreateNewQuest = false;
  final _formNewQuest = GlobalKey<FormState>();
  final pregunta = TextEditingController();
  final respuesta = TextEditingController();

  late Map<String, dynamic> myMateria;

  bool viewEraseMateria = false;

  bool viewSetPreg = false;
  final _formSetQuest = GlobalKey<FormState>();
  final setPregunta = TextEditingController();
  final setRespuesta = TextEditingController();
  int idQuest = 0;

  void initEditPreg(int idMyQuest) async {
    Map<String, dynamic> myQuest = await database.getQuestID(idMyQuest);
    setPregunta.text = myQuest['Pregunta'];
    setRespuesta.text = myQuest['respuesta'];
    idQuest = idMyQuest;
    setState(() {
      viewSetPreg = true;
    });
  }

  late List<Map<String, dynamic>> myQuests;

  static late Color background;
  static late Color textColor;
  static late Color drawerColor;

  @override
  void initState() {
    super.initState();
    background = setting.getBackgroundColor();
    textColor = setting.getColorText();
    drawerColor = setting.getColorDrawerSecundary();
    chargePage();
  }

  void chargePage() async {
    myMateria = await database.getMateriaID(widget.idMateria);
    myQuests = await database.getQuests(widget.idMateria);
    setState(() {
      charging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: background,
        body: charging
            //! PANTALLA DE CARGA
            ? Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      iconSize: 50,
                      color: textColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: textColor,
                      ),
                    ),
                  )
                ],
              )
            //!Visual cuando se carga la pagina
            : Stack(
                //!Vision principal
                children: [
                    Column(
                      children: [
                        //! Boton regresar a la pagina anterior
                        Container(
                          color: drawerColor,
                          child: Row(children: [
                            IconButton(
                              iconSize: 50,
                              color: textColor,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                            Text(
                              "Materia: ${myMateria['Nombre']}",
                              style: TextStyle(
                                color: textColor,
                              ),
                            ),
                          ]),
                        ),
                        //! Muesta de donde salen las preguntas
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black26,
                            child: ListView.builder(
                              itemCount: myQuests.length,
                              itemBuilder: ((context, index) {
                                return ListTile(
                                  onTap: () =>
                                      initEditPreg(myQuests[index]['ID']),
                                  iconColor: textColor,
                                  textColor: textColor,
                                  title: Text(
                                      "Pregunta: ${myQuests[index]['Pregunta']}"),
                                  subtitle: Text(
                                      "Respuesta: ${myQuests[index]['respuesta']}"),
                                );
                              }),
                            ),
                          ),
                        ),
                        //! Botones inferiores
                        Row(
                          children: [
                            const Expanded(child: Text('')),
                            IconButton(
                              onPressed: () => setState(() {
                                viewEraseMateria = true;
                              }),
                              icon: Icon(
                                Icons.delete,
                                color: textColor,
                              ),
                              iconSize: 40,
                            ),
                            const Expanded(child: Text('')),
                            IconButton(
                              onPressed: () => setState(() {
                                viewCreateNewQuest = true;
                              }),
                              icon: Icon(
                                Icons.add,
                                color: textColor,
                              ),
                              iconSize: 40,
                            ),
                            const Expanded(child: Text('')),
                          ],
                        ),
                      ],
                    ),
                    //!Vision en caso de creacion de pregunta
                    if (viewCreateNewQuest)
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black26,
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 4,
                            vertical: MediaQuery.of(context).size.height / 4),
                        child: Center(
                            child: Container(
                          padding: const EdgeInsets.all(40),
                          color: background,
                          child: Form(
                            key: _formNewQuest,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                //* INPUT DE PREGUNTA
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Debes colocar una buena pregunta.';
                                    }
                                    return null;
                                  },
                                  controller: pregunta,
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
                                Expanded(flex: 3, child: Container()),
                                //* INPUT DE RESPUESTA
                                TextFormField(
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
                                Expanded(flex: 3, child: Container()),
                                Row(
                                  children: [
                                    Expanded(child: Container()),
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
                                    Expanded(child: Container()),
                                    IconButton(
                                      onPressed: () async {
                                        _formNewQuest.currentState!.validate();
                                        if (pregunta.text.isEmpty ||
                                            respuesta.text.isEmpty) return;
                                        await database.createPreg(
                                            widget.idClass,
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
                                    Expanded(child: Container()),
                                  ],
                                ),
                                Expanded(child: Container()),
                              ],
                            ),
                          ),
                        )),
                      ),
                    //! VISION SUPERPUESTA DE CUANDO QUIERAN BORRAR ALGO
                    if (viewEraseMateria)
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black26,
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 4,
                            vertical: MediaQuery.of(context).size.height / 4),
                        child: Container(
                          color: background,
                          child: Column(
                            children: [
                              Expanded(child: Container()),
                              Text(
                                "¿Quieres borrar esta materia por completo?",
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                              Expanded(child: Container()),
                              Row(
                                children: [
                                  Expanded(child: Container()),
                                  IconButton(
                                    onPressed: () => setState(() {
                                      viewEraseMateria = false;
                                    }),
                                    icon: const Icon(Icons.cancel),
                                    color: textColor,
                                    iconSize: 40,
                                  ),
                                  Expanded(child: Container()),
                                  IconButton(
                                    onPressed: () async {
                                      await database.deleteMateria(
                                          widget.idMateria, widget.idClass);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.check_circle),
                                    color: textColor,
                                    iconSize: 40,
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                        ),
                      ),
                    //! MODIFICADOR DE PREGUNTAS
                    if (viewSetPreg)
                      Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black26,
                          alignment: Alignment.center,
                          child: Container(
                            color: background,
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 2,
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Form(
                                key: _formSetQuest,
                                child: ListView(
                                  children: [
                                    Text(
                                      "Modificacion de la pregunta",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    //* INPUT DE PREGUNTA
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Debes colocar una buena pregunta.';
                                        }
                                        return null;
                                      },
                                      controller: setPregunta,
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    //* INPUT DE RESPUESTA
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Debes colocar una respuesta.';
                                        }
                                        return null;
                                      },
                                      controller: setRespuesta,
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
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: Container()),
                                        IconButton(
                                          onPressed: () => setState(() {
                                            pregunta.clear();
                                            respuesta.clear();
                                            viewSetPreg = false;
                                          }),
                                          icon: const Icon(Icons.cancel),
                                          iconSize: 40,
                                          color: textColor,
                                        ),
                                        Expanded(child: Container()),
                                        IconButton(
                                          onPressed: () async {
                                            _formSetQuest.currentState!
                                                .validate();
                                            if (setPregunta.text.isEmpty ||
                                                setRespuesta.text.isEmpty)
                                              return;
                                            await database.setQuestID(
                                                idQuest,
                                                setPregunta.text,
                                                setRespuesta.text);
                                            setState(() {
                                              pregunta.clear();
                                              respuesta.clear();
                                              chargePage();
                                              viewSetPreg = false;
                                            });
                                          },
                                          icon: const Icon(Icons.save_as),
                                          iconSize: 40,
                                          color: textColor,
                                        ),
                                        Expanded(child: Container()),
                                        IconButton(
                                          onPressed: () async {
                                            await database.deletedQuest(idQuest);
                                            setState(() {
                                              pregunta.clear();
                                              respuesta.clear();
                                              chargePage();
                                              viewSetPreg = false;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: textColor,
                                          ),
                                          iconSize: 40,
                                        ),
                                        const Expanded(child: Text('')),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                  ]),
      ),
    );
  }
}
