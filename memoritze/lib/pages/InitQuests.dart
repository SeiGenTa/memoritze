import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/settings.dart';

// ignore: must_be_immutable
class InitQuest extends StatefulWidget {
  // ignore: non_constant_identifier_names
  late List<int> IdsMaterials;
  InitQuest({super.key, required this.IdsMaterials});

  @override
  State<InitQuest> createState() => _InitQuestState();
}

class _InitQuestState extends State<InitQuest> {
  Random ra = Random();
  Setting setting = Setting();
  ConnectionDataBase dataBase = ConnectionDataBase();

  bool charged = false;
  bool seeResp = false;
  bool _showCaseEspecial = false;
  late final List<Map<String, dynamic>> myQuests;
  List<Map<String, int>> probQuest = [];
  int amountProbs = 0;
  late String pred;
  late String resp;
  late int myIndex;
  int lastQuest = -1;
  late String? dirImageQ;
  late String? dirImageA;

  int countResp = 0;

  void setPred() {
    int indexSelected = ra.nextInt(amountProbs);
    myIndex = probQuest[indexSelected]['index']!;
    if (lastQuest == myIndex) {
      return setPred();
    }

    countResp++;

    lastQuest = myIndex;

    setState(() {
      pred = myQuests[myIndex]['Pregunta'];
      resp = myQuests[myIndex]['respuesta'];
      dirImageQ = myQuests[myIndex]['dirImagePreg'];
      dirImageA = myQuests[myIndex]['dirImageResp'];
      charged = true;
    });
  }

  void chargeData() async {
    List<Map<String, dynamic>> myQuestTemp = [];
    for (int i = 0; i < widget.IdsMaterials.length; i++) {
      List<Map<String, dynamic>> quest =
          await dataBase.getQuests(widget.IdsMaterials[i]);
      myQuestTemp = myQuestTemp + quest;
    }

    myQuests = List.unmodifiable(myQuestTemp);

    if (myQuests.length < 2) {
      setState(() {
        _showCaseEspecial = true;
      });
      return;
    }

    for (int i = 0; i < myQuests.length; i++) {
      for (int j = 0; j < myQuests[i]['eval']; j++) {
        probQuest = probQuest +
            [
              {'index': i}
            ];
      }
    }
    amountProbs = probQuest.length;

    setPred();
  }

  void setUpEval(int indexQuest) {
    print("setUp");
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
    setPred();
  }

  void setDowEval(int indexQuest) {
    print("setDown");
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
    setPred();
  }

  Widget generate(pred, resp, dirImageQ, dirImageA) {
    return SlimyCardProp(
      firstText: pred,
      secondText: resp,
      showSecondText: false,
      width: MediaQuery.of(context).size.width - 100,
      height: MediaQuery.of(context).size.height - 250,
      colorCards: setting.getColorNavSup(),
      textColors: setting.getColorText(),
      firstImage: dirImageQ,
      secondImage: dirImageA,
      onUseButton: () {
        setState(() {
          seeResp = true;
        });
        print("si funciona");
      },
      key: ValueKey(countResp),
    );
  }

  @override
  void initState() {
    super.initState();
    chargeData();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Bloquea orientación vertical
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: setting.getBackgroundColor(),
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
            _showCaseEspecial
                ? Center(
                    child: Text(
                      "Parece que te faltan preguntas para iniciar este cuestionario",
                      style: TextStyle(
                          color: setting.getColorText(),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                : !charged
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: setting.getColorText(),
                          ),
                        ),
                      )
                    : SafeArea(
                        child: Column(
                        children: [
                          if (charged)
                            SlimyCardProp(
                              firstText: pred,
                              secondText: resp,
                              showSecondText: false,
                              width: MediaQuery.of(context).size.width - 100,
                              height: MediaQuery.of(context).size.height - 250,
                              colorCards: setting.getColorNavSup(),
                              textColors: setting.getColorText(),
                              firstImage: dirImageQ,
                              secondImage: dirImageA,
                              onUseButton: () {
                                setState(() {
                                  seeResp = true;
                                });
                                print("si funciona");
                              },
                              key: ValueKey(countResp),
                            ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: seeResp ? 1 : 0,
                                  child: ElevatedButton(
                                      style: const ButtonStyle(
                                        padding: MaterialStatePropertyAll(
                                            EdgeInsets.all(20)),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.green),
                                      ),
                                      onPressed: () {
                                        if (seeResp) setDowEval(myIndex);
                                      },
                                      child: const Text("Acertado")),
                                ),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: seeResp ? 1 : 0,
                                  child: ElevatedButton(
                                      style: const ButtonStyle(
                                        padding: MaterialStatePropertyAll(
                                            EdgeInsets.all(20)),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.red),
                                      ),
                                      onPressed: () {
                                        if (seeResp) setUpEval(myIndex);
                                      },
                                      child: const Text("  Erronea  ")),
                                )
                              ],
                            ),
                          )
                        ],
                      ))
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SlimyCardProp extends StatefulWidget {
  final Function()? onUseButton;

  late String firstText;
  late String secondText;
  late bool showSecondText;
  late double width;
  late double height;
  late Color colorCards;
  late Color textColors;
  late Color colorButton;
  late Color colorIconButton;
  late double separated;
  late double iconSize;
  EdgeInsets margin = const EdgeInsets.all(20);
  late String? firstImage;
  late String? secondImage;

  SlimyCardProp({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.showSecondText,
    required this.width,
    required this.height,
    required this.colorCards,
    required this.textColors,
    required this.firstImage,
    required this.secondImage,
    EdgeInsets? padding,
    this.onUseButton,
    this.colorButton = Colors.white,
    this.colorIconButton = Colors.black,
    this.separated = 20.0,
    this.iconSize = 40,
  }) {
    if (padding != null) {
      this.margin = padding;
    }
  }

  @override
  State<SlimyCardProp> createState() => _SlimyCardPropState();
}

class _SlimyCardPropState extends State<SlimyCardProp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late final Animation<double> _generateAnimation;

  late final Animation<double> _curveAnimation;

  late String firstText;
  late String secondText;
  late bool showSecondText;
  late double width;
  late double height;
  late Color colorCards;
  late Color textColors;
  late EdgeInsets padding;
  late Color colorButton;
  late Color colorIconButton;
  late double iconSize;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300), value: 0);
    firstText = widget.firstText;
    secondText = widget.secondText;
    showSecondText = widget.showSecondText;
    width = widget.width;
    height = widget.height;
    colorCards = widget.colorCards;
    textColors = widget.textColors;
    padding = widget.margin;
    colorButton = widget.colorButton;
    colorIconButton = widget.colorIconButton;
    _generateAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _curveAnimation =
        CurvedAnimation(parent: _generateAnimation, curve: Curves.easeOut);
    iconSize = widget.iconSize;
    super.initState();
  }

  @override
  void dispose() {
    _controller.reset();
    _controller.dispose();
    super.dispose();
  }

  void activateButton() {
    if (_controller.value == 1) {
      return;
    }
    widget.onUseButton?.call();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _curveAnimation,
        builder: (context, child) {
          return SizedBox(
            height: height,
            child: Stack(
              children: [
                Transform.translate(
                  offset: Offset(
                      0,
                      height / 4 +
                          (widget.separated / 2 + height / 4) *
                              _curveAnimation.value),
                  child: Container(
                    alignment: Alignment.center,
                    width: width,
                    height: height / 2 - widget.separated / 2,
                    padding: padding,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: colorCards,
                      border: Border.all(color: Colors.white),
                    ),
                    child: SingleChildScrollView(
                      padding: padding,
                      child: Column(
                        children: [
                          Text(
                            secondText,
                            style: TextStyle(color: textColors, fontSize: 20),
                          ),
                          if (widget.secondImage != null)
                            Image.file(File(widget.secondImage!))
                        ],
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      0, height / 4 - (height / 4) * _curveAnimation.value),
                  child: Container(
                    alignment: Alignment.center,
                    width: width,
                    height: height / 2 - widget.separated / 2,
                    padding: padding,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: colorCards,
                      border: Border.all(color: Colors.white),
                    ),
                    child: SingleChildScrollView(
                      padding: padding,
                      child: Column(
                        children: [
                          Text(
                            firstText,
                            style: TextStyle(color: textColors, fontSize: 20),
                          ),
                          if (widget.firstImage != null)
                            Image.file(File(widget.firstImage!))
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: width / 2 - iconSize / 2,
                  bottom: 0,
                  child: Opacity(
                    opacity: (1 - _generateAnimation.value),
                    child: ElevatedButton(
                      onPressed: () {
                        activateButton();
                      },
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStatePropertyAll(Size(iconSize, iconSize)),
                        iconColor: MaterialStatePropertyAll(colorIconButton),
                        backgroundColor: MaterialStatePropertyAll(colorButton),
                      ),
                      child: Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
