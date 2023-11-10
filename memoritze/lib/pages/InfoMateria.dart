// ignore_for_file: unnecessary_null_comparison, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
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

  FilePickerResult? myFilePickerPreg;
  FilePickerResult? myFilePickerResp;

  //Logica detras de la edicion de quest
  initEditQuest(int ubq) {
    //final TextEditingController listenableText = TextEditingController();
    PageController pageController = PageController();
    Map<String, dynamic> myPreg = infPregMateria[ubq];
    indexQuest = ubq;
    answerEdit.text = myPreg['Pregunta'];
    questEdit.text = myPreg['respuesta'];

    FilePickerResult? myImagePreg;
    FilePickerResult? myImageResp;

    bool chargedPreg = (myPreg['dirImagePreg'] == null) ? true : false;
    bool chargedResp = (myPreg['dirImageResp'] == null) ? true : false;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: setting.getColorNavSup(),
            title: Row(
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    pageController.dispose();
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
                    AnimatedBuilder(
                        animation: pageController,
                        builder: (context, child) {
                          return Row(
                            children: [
                              ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.black)),
                                  onPressed: () async {
                                    myImagePreg =
                                        await FilePicker.platform.pickFiles(
                                      dialogTitle:
                                          "Seleccione imagen a mostrar",
                                      type: FileType.custom,
                                      allowedExtensions: ['jpg', 'jpeg', 'png'],
                                    );
                                    if (myImagePreg == null) {
                                      setState(() {
                                        chargedPreg = true;
                                      });
                                    } else {
                                      setState(() {
                                        chargedPreg = false;
                                      });
                                    }
                                    pageController.notifyListeners();
                                  },
                                  child: const Icon(Icons.upload)),
                              Text(
                                (chargedPreg)
                                    ? "  Cargar imagen"
                                    : "  Cambiar imagen",
                                style: const TextStyle(color: Colors.white),
                              ),
                              Expanded(child: Container()),
                              if (!chargedPreg)
                                IconButton(
                                    onPressed: () async {
                                      if (await dataBase.eraseImage(
                                          myPreg["ID"], 0)) {
                                        chargePage();
                                        setState(() {
                                          chargedPreg = false;
                                        });
                                        myImagePreg = null;
                                      pageController.notifyListeners();
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: setting
                                                    .getColorDrawerSecondary(),
                                                content: const Text(
                                                  "parece que hubo un error al borrar la imagen",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              );
                                            });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ))
                            ],
                          );
                        }),
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
                    AnimatedBuilder(
                        animation: pageController,
                        builder: (context, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  myImageResp =
                                      await FilePicker.platform.pickFiles(
                                    dialogTitle: "Seleccione imagen a mostrar",
                                    type: FileType.custom,
                                    allowedExtensions: ['jpg', 'jpeg', 'png'],
                                  );
                                  if (myImageResp == null) {
                                    setState(() {
                                      chargedResp = true;
                                    });
                                  } else {
                                    setState(() {
                                      chargedResp = false;
                                    });
                                  }
                                  pageController.notifyListeners();
                                },
                                style: const ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.black)),
                                child: const Icon(Icons.upload),
                              ),
                              Text(
                                (chargedResp)
                                    ? "  Cargar imagen"
                                    : "  Cambiar imagen",
                                style: const TextStyle(color: Colors.white),
                              ),
                              Expanded(child: Container()),
                              if (!chargedResp)
                                IconButton(
                                    onPressed: () async {
                                      if (await dataBase.eraseImage(
                                          myPreg["ID"], 1)) {
                                        chargePage();
                                        myImageResp = null;
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: setting
                                                    .getColorDrawerSecondary(),
                                                content: const Text(
                                                  "parece que hubo un error al borrar la imagen",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              );
                                            });
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ))
                            ],
                          );
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () async {
                            pageController.dispose();
                            _formEditQuest.currentState!.validate();
                            if (answerEdit.text.isEmpty ||
                                questEdit.text.isEmpty) return;

                            myFilePickerPreg = myImagePreg;
                            myFilePickerResp = myImageResp;
                            saveChangeQuest();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.check_circle),
                          iconSize: 40,
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: () async {
                            pageController.dispose();
                            await dataBase
                                .deletedQuest(infPregMateria[indexQuest]['ID']);
                            setState(() {
                              pregunta.clear();
                              respuesta.clear();
                              chargePage();
                              Navigator.pop(context);
                            });
                          },
                          icon: const Icon(Icons.delete_outline),
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

  final _buttonPressController = StreamController<void>();
  void popWindow(){
      Navigator.pop(context);
  }

  void saveChangeQuest() async {
    await dataBase.setQuestID(infPregMateria[indexQuest]['ID'], answerEdit.text,
        questEdit.text, myFilePickerPreg, myFilePickerResp);
    chargePage();
    myFilePickerPreg = null;
    myFilePickerResp = null;
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
    _buttonPressController.close();
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
          actions: [IconButton(
                        style: buttonStyle,
                        onPressed: () {
                          setState(() {
                            positionButtonActivate = !positionButtonActivate;
                          });
                          eraseMaterial(context);
                        }, icon: const Icon(Icons.delete),
                      )],
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
        floatingActionButton: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          addQuest(context);
                        },
                        child: const Icon(Icons.add),
                      ),
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
                            Navigator.pop(context);
                            try {
                              await dataBase.deleteMateria(
                                  widget.idMateria, idClass);
                            } catch (e) {
                              print(e);
                            } finally {
                              popWindow();
                            }
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
    TextEditingController listenable = TextEditingController();
    FilePickerResult? dirImagePreg;
    bool imgPreg = false;
    FilePickerResult? dirImageResp;
    bool imgResp = false;
    return showDialog(
        barrierDismissible: false,
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
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            dirImagePreg = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'jpeg', 'png'],
                            );
                            if (dirImagePreg != null) {
                              listenable.notifyListeners();
                              setState(() {
                                imgPreg = true;
                              });
                            } else {
                              setState(() {
                                imgPreg = false;
                              });
                            }
                            // ignore: unrelated_type_equality_checks
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.black)),
                          child: const Icon(Icons.upload),
                        ),
                        Expanded(
                          child: AnimatedBuilder(
                              animation: listenable,
                              builder: (context, child) {
                                return Text(
                                    (!imgPreg)
                                        ? "  ¿Que tal subir una foto para tu pregunta?"
                                        : dirImagePreg!.paths[0].toString(),
                                    style:
                                        const TextStyle(color: Colors.white));
                              }),
                        )
                      ],
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
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            dirImageResp = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'jpeg', 'png'],
                            );
                            if (dirImageResp != null) {
                              listenable.notifyListeners();
                              setState(() {
                                imgResp = true;
                              });
                            } else {
                              setState(() {
                                imgResp = false;
                              });
                            }
                            // ignore: unrelated_type_equality_checks
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.black)),
                          child: const Icon(Icons.upload),
                        ),
                        Expanded(
                            child: AnimatedBuilder(
                          animation: listenable,
                          builder: (context, child) {
                            return Text(
                                (!imgResp)
                                    ? "  ¿Que tal subir una foto para tu pregunta?"
                                    : dirImageResp!.paths[0].toString(),
                                style: const TextStyle(color: Colors.white));
                          },
                        ))
                      ],
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
                              respuesta.text.toString(),
                              (dirImagePreg == null) ? null : dirImagePreg,
                              (dirImageResp == null) ? null : dirImageResp,
                            );
                            pregunta.clear();
                            respuesta.clear();
                            viewCreateNewQuest = false;
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            listenable.dispose();
                            chargePage();
                          },
                          icon: const Icon(Icons.check_circle),
                          iconSize: 40,
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: () {
                            pregunta.clear();
                            respuesta.clear();
                            Navigator.pop(context);
                            listenable.dispose();
                          },
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

          return GestureDetector(
            onTap: () => initEditQuest(index),
            child: Transform.scale(
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
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
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
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.of(context).size.width -
                                                  100),
                                      child: SizedBox(
                                        height: 60,
                                        child: Text(
                                          infPregMateria[index]['Pregunta'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                if (infPregMateria[index]['dirImagePreg'] != null)
                                  Container(
                                    width: 150,
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Image.file(File(
                                          infPregMateria[index]['dirImagePreg'])),
                                    ),
                                  )
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
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
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.of(context).size.width -
                                                  100),
                                      child: SizedBox(
                                        height: 60,
                                        child: Text(
                                          infPregMateria[index]['respuesta'],
                                          overflow: TextOverflow.clip,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (infPregMateria[index]['dirImageResp'] != null)
                                  SizedBox(
                                    height: 80,
                                    child: ClipRRect(
                                      borderRadius:
                                          const BorderRadius.all(Radius.circular(10)),
                                      child: Image.file(File(
                                          infPregMateria[index]['dirImageResp'])),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
