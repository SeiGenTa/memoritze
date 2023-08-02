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
  late final ScrollController _scrollController;

  late int idClass;
  late List<Map<String, dynamic>> infPregMateria;
  late Map<String, dynamic> infMateria;
  ConnectionDataBase dataBase = ConnectionDataBase();
  Setting setting = Setting();

  bool charging = true;

  bool viewEraseMateria = false;
  final _formNewQuest = GlobalKey<FormState>();
  final pregunta = TextEditingController();
  final respuesta = TextEditingController();

  final _formEditQuest = GlobalKey<FormState>();
  final answerEdit = TextEditingController();
  final questEdit = TextEditingController();
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

  //Logica detras de la edicion de quest
  initEditQuest(int ubq) {
    Map<String, dynamic> myPreg = infPregMateria[ubq];
    indexQuest = ubq;
    answerEdit.text = myPreg['Pregunta'];
    questEdit.text = myPreg['respuesta'];

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: setting.getColorNavSup(),
            title: Row(
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    answerEdit.clear();
                    questEdit.clear();
                    Navigator.pop(context);
                  }),
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                ),
              ],
            ),
            content: Form(
              key: _formEditQuest,
              child: SingleChildScrollView(
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
                      controller: answerEdit,
                      maxLines: 5,
                      minLines: 1,
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
                        hintText:
                            "Ejm: ¿cual es estado mas comun en las estrellas?",
                        hoverColor: Colors.white,
                        labelText: "Pregunta",
                        icon: Icon(
                          Icons.question_mark,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                      controller: questEdit,
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
                        hintText:
                            "Ejm: Debe ser la respuesta mas descriptiva o certera posible",
                        hoverColor: Colors.white,
                        labelText: "Respuesta",
                        icon: Icon(
                          Icons.question_answer,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () async {
                            _formEditQuest.currentState!.validate();
                            if (answerEdit.text.isEmpty ||
                                questEdit.text.isEmpty) return;
                            saveChangeQuest();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.check_circle),
                          iconSize: 40,
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: () async {
                            await dataBase
                                .deletedQuest(infPregMateria[indexQuest]['ID']);
                            setState(() {
                              pregunta.clear();
                              respuesta.clear();
                              chargePage();
                              Navigator.pop(context);
                            });
                          },
                          icon: const Icon(Icons.delete_forever),
                          iconSize: 40,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void saveChangeQuest() {
    dataBase.setQuestID(
        infPregMateria[indexQuest]['ID'], answerEdit.text, questEdit.text);
    chargePage();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    textColor = setting.getColorText();
    chargePage();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    // TODO: implement dispose
    super.dispose();
    pregunta.dispose();
    respuesta.dispose();
    answerEdit.dispose();
    questEdit.dispose();
  }

  bool positionButtonActivate = false;

  @override
  Widget build(BuildContext context) {
    double heightPage = MediaQuery.of(context).size.height - kToolbarHeight;

    var buttonStyle = ButtonStyle(
        backgroundColor:
            MaterialStatePropertyAll(setting.getColorsIconButton()),
        minimumSize: const MaterialStatePropertyAll(Size(50, 50)),
        shape: const MaterialStatePropertyAll(CircleBorder()));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight,
          backgroundColor: setting.getColorNavSup(),
          shape: BorderDirectional(
              bottom: BorderSide(color: setting.getColorText(), width: 0.4)),
          leading: Container(
            alignment: Alignment.topLeft,
            child: IconButton(
              color: Colors.white,
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
                              controller: _scrollController,
                              itemCount: infPregMateria.length,
                              itemBuilder: (context, index) {
                                return cartsOfQuests(heightPage, index);
                              })),
                    ],
                  ),
                  if (positionButtonActivate)
                    GestureDetector(
                      onTap: () => setState(() {
                        positionButtonActivate = false;
                      }),
                    ),
                  AnimatedPositioned(
                      curve: Curves.easeInCirc,
                      right: 10,
                      bottom: positionButtonActivate ? 140 : 20,
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          setState(() {
                            positionButtonActivate = !positionButtonActivate;
                          });
                          eraseMaterial(context);
                        },
                        child: const Icon(Icons.delete),
                      )),
                  AnimatedPositioned(
                      curve: Curves.easeInCirc,
                      right: 10,
                      bottom: positionButtonActivate ? 80 : 20,
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          addQuest(context);
                          setState(() {
                            positionButtonActivate = !positionButtonActivate;
                          });
                        },
                        child: Icon(Icons.add),
                      )),
                  Positioned(
                    right: 10,
                    bottom: 20,
                    child: ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        setState(() {
                          positionButtonActivate = !positionButtonActivate;
                        });
                      },
                      child: AnimatedCrossFade(
                        firstCurve: Curves.bounceInOut,
                        secondCurve: Curves.bounceInOut,
                        crossFadeState: positionButtonActivate
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                        firstChild: const Icon(Icons.more_horiz),
                        secondChild: const Icon(Icons.more_vert),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  //Logica de como borrar la materia en la que estas
  Future<dynamic> eraseMaterial(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: setting.getColorNavSup(),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "¿Estas seguro de querer eliminar esta materia?",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width / 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await dataBase.deleteMateria(
                                widget.idMateria, idClass);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.check_circle),
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: () => setState(() {
                            viewEraseMateria = false;
                          }),
                          icon: const Icon(Icons.cancel_rounded),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ]),
          );
        });
  }

  // Logica detras de agregar preguntas y el diseño de esta
  Future<dynamic> addQuest(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: setting.getColorNavSup(),
            content: Form(
              key: _formNewQuest,
              child: SingleChildScrollView(
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
                        hintText:
                            "Ejm: ¿cual es estado mas comun en las estrellas?",
                        hoverColor: Colors.white,
                        labelText: "Pregunta",
                        icon: Icon(
                          Icons.question_mark,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                        hintText:
                            "Ejm: Debe ser la respuesta mas descriptiva o certera posible",
                        hoverColor: Colors.white,
                        labelText: "Respuesta",
                        icon: Icon(
                          Icons.question_answer,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () async {
                            _formNewQuest.currentState!.validate();
                            if (pregunta.text.isEmpty || respuesta.text.isEmpty)
                              return;
                            await dataBase.createPreg(
                                idClass,
                                widget.idMateria,
                                pregunta.text.toString(),
                                respuesta.text.toString());
                            pregunta.clear();
                            respuesta.clear();
                            viewCreateNewQuest = false;
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            chargePage();
                          },
                          icon: const Icon(Icons.check_circle),
                          iconSize: 40,
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: () => setState(() {
                            pregunta.clear();
                            respuesta.clear();
                            Navigator.pop(context);
                          }),
                          icon: const Icon(Icons.cancel),
                          iconSize: 40,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  //! Aqui podremos ver el diseño de las cartas de las preguntas además de su logia
  AnimatedBuilder cartsOfQuests(double sizeScroll, int index) {
    return AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          double scaleWidget;

          if (_scrollController.offset + 50 > (220) * (index + 1)) {
            scaleWidget = ((220) * (index + 1) - _scrollController.offset) / 50;
          } else if (_scrollController.offset + sizeScroll + 120 <
              (220) * (index + 1)) {
            scaleWidget =
                -((220) * (index) - (_scrollController.offset + sizeScroll)) /
                    (100);
          } else {
            scaleWidget = 1;
          }

          return Transform.scale(
            scale: scaleWidget,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: 200,
              child: Card(
                elevation: 2,
                color: setting.getColorNavSup(),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                            child: Text(
                              "Pregunta:",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            child: Text(
                              infPregMateria[index]['Pregunta'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                            child: Text(
                              "Respuesta:",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            child: Text(
                              infPregMateria[index]['respuesta'],
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onPressed: () => initEditQuest(index),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
