import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memoritze/db/dataBase.dart';
import 'package:memoritze/setting.dart';

// ignore: must_be_immutable
class InitMyQuestsGame extends StatefulWidget {
  //* Cosas necesarias
  late List<int> myMaterials;

  InitMyQuestsGame({super.key, required this.myMaterials});

  @override
  State<InitMyQuestsGame> createState() => _InitMyQuestsGameState();
}

class _InitMyQuestsGameState extends State<InitMyQuestsGame> {
  MyDataBase dataBase = MyDataBase();

  Setting setting = Setting();

  bool isLoading = false;
  bool showRequest = false;
  List<Map<String, dynamic>> myQuest = [];
  List<Map<String, dynamic>> myInfos = [];

  int myIndex = 0;

  void chargerMyQuest() async {
    myInfos = [];

    for (int i = 0; i < widget.myMaterials.length; i++) {
      myQuest += await dataBase.getQuests(widget.myMaterials[i]);
      for (int j = 0; j < myQuest.length; j++) {
        for (int k = 0; k < myQuest[j]['eval']; k++) {
          myInfos += [
            {
              "id": j,
            }
          ];
        }
      }
    }

    prepareQuest();
  }

  void prepareQuest() {
    Random random = Random();
    myIndex = myInfos[random.nextInt(myInfos.length)]['id'];


    setState(() {
      isLoading = true;
    });
  }

  void cancelEvent() async {
    Navigator.pop(context);
  }

  void positiveRequest() async {
    dataBase.upDownEvalQuest(myQuest[myIndex]['ID'], -1);
    restoreState();
    if (myInfos.contains(myInfos[myIndex])) {
      int repetitions = myInfos
          .where((element) => element['id'] == myInfos[myIndex]["id"])
          .length;

      if (repetitions > 1) {
        myInfos.remove(myInfos[myIndex]);
      }
    }

    prepareQuest();
  }

  void negativeRequest() {
    dataBase.upDownEvalQuest(myQuest[myIndex]['ID'], 1);
    restoreState();
    if (myInfos.contains(myInfos[myIndex])) {
      int repetitions = myInfos
          .where((element) => element['id'] == myInfos[myIndex]["id"])
          .length;

      if (repetitions < 7) {
        myInfos.add(myInfos[myIndex]);
      }
    }

    prepareQuest();
  }

  void restoreState() {
    setState(() {
      isLoading = false;
      showRequest = false;
    });
  }

  @override
  void initState() {
    super.initState();
    chargerMyQuest();
  }

  Widget createBox(String text) {
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: setting.getColorPaper(), // Color de fondo del Container
          borderRadius: BorderRadius.circular(10), // Borde redondeado
          boxShadow: [
            BoxShadow(
              color:
                  Colors.grey.withOpacity(0.5), // Color y opacidad de la sombra
              spreadRadius: 5, // Radio de expansión de la sombra
              blurRadius: 7, // Desenfoque de la sombra
              offset: Offset(0, 3), // Desplazamiento de la sombra en X y Y
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(color: setting.getColorText()),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: setting.getColorDrawer(),
            body: !isLoading
                ? Stack(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          color: setting.getColorText(),
                          onPressed: () => cancelEvent(),
                          icon: const Icon(
                            Icons.cancel,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Expanded(child: Container()),
                            Text(
                              "Estamos preparando todo para la clase.",
                              style: TextStyle(color: setting.getColorText()),
                            ),
                            CircularProgressIndicator(
                              color: setting.getColorText(),
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      IconButton(
                        color: setting.getColorText(),
                        onPressed: () => cancelEvent(),
                        icon: const Icon(
                          Icons.cancel,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Expanded(child: Container()),
                            createBox(myQuest[myIndex]["Pregunta"]),
                            !showRequest
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      IconButton(
                                        color: setting.getColorText(),
                                        onPressed: () => setState(() {
                                          showRequest = true;
                                        }),
                                        icon: const Icon(Icons.remove_red_eye),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      createBox(myQuest[myIndex]["respuesta"]),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => negativeRequest(),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red),
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(30),
                                              alignment: Alignment.center,
                                              child: const Text(" Errada "),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => positiveRequest(),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green),
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(30),
                                              alignment: Alignment.center,
                                              child: const Text("Correcta"),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ],
                  )));
  }
}
