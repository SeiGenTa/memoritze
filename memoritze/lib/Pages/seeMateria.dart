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

  bool createNewQuest = false;
  final _formNewQuest = GlobalKey<FormState>();
  final pregunta = TextEditingController();
  final respuesta = TextEditingController();



  late List<Map<String, dynamic>> myQuests;

  static late Color background;
  static late Color textColor;

  @override
  void initState() {
    super.initState();
    background = setting.getBackgroundColor();
    textColor = setting.getColorText();
    chargePage();
  }

  void chargePage() async {
    myQuests = await database.getQuest(widget.idMateria);
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
                    //! Muesta de donde salen las preguntas
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black26,
                        child: ListView.builder(
                          itemCount: myQuests.length,
                          itemBuilder: ((context, index) {
                            return ListTile(
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
                          onPressed: () {},
                          icon: const Icon(Icons.delete),
                          iconSize: 40,
                        ),
                        const Expanded(child: Text('')),
                        IconButton(
                          onPressed: () => setState(() {
                            createNewQuest = true;
                          }) ,
                          icon: const Icon(Icons.add),
                          iconSize: 40,
                        ),
                        const Expanded(child: Text('')),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.check),
                          iconSize: 40,
                        ),
                        const Expanded(child: Text('')),
                      ],
                    ),
                  ],
                ),
                //!Vision en caso de creacion de clase
                if (createNewQuest)
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black26,
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width/4,
                          vertical: MediaQuery.of(context).size.height/4
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(40),
                            color: background,
                            child: Form(
                              key: _formNewQuest,
                              child: Column(
                                children: [
                                  Expanded(flex: 1,child: Container(),),
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
                              labelStyle:
                                  TextStyle(color: textColor),
                              hintStyle:
                                  TextStyle(color: textColor),
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
                                  Expanded(flex:3, child: Container()),
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
                              labelStyle:
                                  TextStyle(color: textColor),
                              hintStyle:
                                  TextStyle(color: textColor),
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
                                  Expanded(flex:3, child: Container()),
                                  Row(
                                    children: [
                                      Expanded(child: Container()),
                                      IconButton(
                                        onPressed: () =>setState(() {
                                            pregunta.clear();
                                            respuesta.clear();
                                            createNewQuest = false;
                                          })
                                        ,
                                        icon: const Icon(Icons.cancel),
                                        iconSize: 40,
                                        color: textColor,
                                      ),
                                      Expanded(child: Container()),
                                      IconButton(
                                        onPressed: (){
                                          _formNewQuest.currentState!.validate();
                                          if (pregunta.text.isEmpty || respuesta.text.isEmpty) return;
                                          database.createPreg(widget.idClass, widget.idMateria, pregunta.text.toString(), respuesta.text.toString());
                                          pregunta.clear();
                                          respuesta.clear();
                                          createNewQuest = false;
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
                          )
                          ),
                        ),
                ]
            ),
      ),
    );
  }
}
