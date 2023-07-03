import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/settings.dart';

// ignore: must_be_immutable
class InitQuest extends StatefulWidget {
  late List<int> IdsMaterials;
  InitQuest({super.key, required this.IdsMaterials});

  @override
  State<InitQuest> createState() => _InitQuestState();
}

class _InitQuestState extends State<InitQuest> {
  Random ra = Random();
  Setting setting = Setting();
  ConectioDataBase dataBase = ConectioDataBase();

  bool charged = false;
  bool seeResp = false;
  late final List<Map<String, dynamic>> myQuests;
  List<Map<String, int>> probQuest = [];
  int amountProbs = 0;
  late String preg;
  late String resp;
  late int myIndex;

  void setPreg() {
    int indexSelected = ra.nextInt(amountProbs);
    myIndex = probQuest[indexSelected]['index']!;
    print(myIndex);
    setState(() {
      preg = myQuests[myIndex]['Pregunta'];
      resp = myQuests[myIndex]['respuesta'];
      charged = true;
    });
    print(preg);
  }

  void chargeData() async {
    List<Map<String, dynamic>> myQuestTemp = [];
    for (int i = 0; i < widget.IdsMaterials.length; i++) {
      List<Map<String, dynamic>> quest =
          await dataBase.getQuests(widget.IdsMaterials[i]);
      myQuestTemp = myQuestTemp + quest;
    }

    myQuests = List.unmodifiable(myQuestTemp);

    for (int i = 0; i < myQuests.length; i++) {
      for (int j = 0; j < myQuests[i]['eval']; j++) {
        probQuest = probQuest +
            [
              {'index': i}
            ];
      }
    }
    amountProbs = probQuest.length;

    setPreg();
  }

  void setUpEval(int indexQuest) {
    int amountQuest =
        (probQuest.where((element) => element['index'] == indexQuest).toList())
            .length;
    if (amountQuest != 7) {
      probQuest.add({'index': indexQuest});
      amountProbs++;
      dataBase.upDownEvalQuest(myQuests[indexQuest]['ID'], 1);
    }
    setState(() {
      charged = false;
      seeResp = false;
    });
    setPreg();
  }

  void setDowEval(int indexQuest) {
    List<Map<String, int>> amountQuest =
        (probQuest.where((element) => element['index'] == indexQuest).toList());
    if (amountQuest.length != 1) {
      probQuest.remove(amountQuest[0]);
      amountProbs--;
      dataBase.upDownEvalQuest(myQuests[indexQuest]['ID'], -1);
    }
    setState(() {
      charged = false;
      seeResp = false;
    });
    setPreg();
  }

  @override
  void initState() {
    super.initState();
    chargeData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: setting.getBackgroundColor(),
          toolbarHeight: 0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
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
            !charged
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: setting.getColorText(),
                      ),
                    ),
                  )
                : Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(child: Container()),
                        AnimatedContainer(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: setting.getColorPaper(),
                          ),
                          duration: const Duration(seconds: 2),
                          child: Text(preg,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        if (!seeResp)
                          IconButton(
                            onPressed: () => setState(() {
                              seeResp = true;
                            }),
                            icon: const Icon(Icons.remove_red_eye),
                            color: setting.getColorText(),
                          ),
                        if (seeResp)
                          AnimatedContainer(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: setting.getColorPaper(),
                            ),
                            duration: const Duration(seconds: 2),
                            child: Text(resp,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        const SizedBox(
                          height: 40,
                        ),
                        if (seeResp)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.all(30)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
                                  onPressed: () {
                                    setUpEval(myIndex);
                                  },
                                  child: Text("Falla..")),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.all(30)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  onPressed: () {
                                    setDowEval(myIndex);
                                  },
                                  child: const Text("Acerté!")),
                            ],
                          ),
                        Expanded(child: Container()),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
