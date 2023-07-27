import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/pages/InfoMateria.dart';
import 'package:memoritze/pages/InitQuests.dart';
import 'package:memoritze/settings.dart';

// ignore: must_be_immutable
class InfoMyClass extends StatefulWidget {
  late int id_class;

  InfoMyClass({super.key, required int number}) {
    id_class = number;
  }

  @override
  State<InfoMyClass> createState() => _InfoMyClassState();
}

class _InfoMyClassState extends State<InfoMyClass> {
  //Para las funciones de la modificacion de clases//

  List<int> _selected = [];

  ConnectionDataBase dataBase = ConnectionDataBase();

  bool _showAccept = false;

  late ScrollController _scrollController = ScrollController();
  double _appBarStretchRatio = 0.0;

  void initQuest() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return InitQuest(IdsMaterials: _selected);
    }));
  }

  Widget initClassUniq = Container();
  @override
  void initState() {
    super.initState();
    chargerData();
    _scrollController.addListener(_updateAppBarStretchRatio);
    textColor = mySetting.getColorText();
  }

  void _updateAppBarStretchRatio() {
    _appBarStretchRatio = _scrollController.offset;
    print(_appBarStretchRatio);
  }

  void saveMaterial(context) async {
    _formKey.currentState!.validate();
    if (_nameMaterial.text.isEmpty) return;
    Navigator.pop(context);
    // ignore: await_only_futures
    await dataBase.createNewMateriaDB(_nameMaterial.text, widget.id_class);
    _nameMaterial.clear();
    chargerMaterial();
  }

  Future<void> initSettingMateria(int idMaterial) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InfoMateria(idMateria: idMaterial)));
    chargerMaterial();
    return;
  }

  void chargerMaterial() async {
    material = await dataBase.getMaterialClass(widget.id_class);
    //(child: ListView( children: materias,),);
    setState(() {
      chargeMaterial = true;
    }); //recargamos la pagina
  }

  void chargerData() async {
    print("iniciando");
    this.myClass = await dataBase.getClass(widget.id_class);
    setState(() {
      _charge = true;
    });
    chargerMaterial();
  }

  @override
  void dispose() {
    _nameEditController.dispose();
    _descriptionEditController.dispose();
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    _nameMaterial.dispose();
  }

  final TextEditingController _nameMaterial = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameEditController = TextEditingController();
  final TextEditingController _descriptionEditController =
      TextEditingController();

  bool chargeMaterial = false;

  late List<Map<String, dynamic>> myClass;
  late Widget myMaterialClass;
  List<Map<String, dynamic>> material = [];

  bool _charge = false;
  Setting mySetting = Setting();

  late ButtonStyle buttonStyle = ButtonStyle(
      iconColor: MaterialStatePropertyAll(mySetting.getColorText()),
      backgroundColor:
          MaterialStatePropertyAll(mySetting.getColorDrawerSecondary()));

  //COLORES
  late Color textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: mySetting.getBackgroundColor(),
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: mySetting.getColorDrawerSecondary(),
          ),
          body: !_charge
              ? Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          iconSize: 50,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: mySetting.getColorText(),
                          ),
                        ),
                        const Expanded(child: Text("")),
                      ],
                    ),
                    Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                      backgroundColor: mySetting.getBackgroundColor(),
                      valueColor:
                          AlwaysStoppedAnimation(mySetting.getColorText()),
                    ))),
                  ],
                )
              : Stack(
                  children: [
                    CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        appBarOfInfoMyClass(context),
                        SliverList.builder(
                            itemCount: material.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  if (index == 0)
                                    Divider(
                                      color: mySetting.getColorText(),
                                    ),
                                  ListTile(
                                    leading: Stack(
                                      children: [
                                        Transform.translate(
                                          offset: Offset(20.0, -27.0),
                                          child: Transform(
                                            transform: Matrix4.identity()
                                              ..rotateZ(4 / 20 * pi)
                                              ..scale(1.3),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: mySetting
                                                          .getColorsOpos(),
                                                      width: 0.5),
                                                  color:
                                                      mySetting.getColorPager(),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              height: 90,
                                              width: 40,
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(5.0, -23.0),
                                          child: Transform(
                                            transform: Matrix4.identity()
                                              ..rotateZ(3 / 20 * pi)
                                              ..scale(1.3),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: mySetting
                                                          .getColorsOpos(),
                                                      width: 0.5),
                                                  color:
                                                      mySetting.getColorPager(),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              height: 90,
                                              width: 40,
                                              child: Text(
                                                "${material[index]['Nombre']}",
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: mySetting
                                                        .getColorText(),
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    textColor: mySetting.getColorText(),
                                    iconColor: mySetting.getColorText(),
                                    title: Container(
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "   Cantidad de preguntas: ${material[index]['cantPreg']}",
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                          IconButton(
                                              onPressed: () {
                                                if (!_selected.any((element) =>
                                                    element ==
                                                    material[index]
                                                        ['ID_subclass'])) {
                                                  setState(() {
                                                    _selected.add(
                                                        material[index]
                                                            ['ID_subclass']);
                                                  });
                                                } else {
                                                  setState(() {
                                                    _selected.remove(
                                                        material[index]
                                                            ['ID_subclass']);
                                                  });
                                                }
                                              },
                                              icon: (_selected.any((element) =>
                                                      element ==
                                                      material[index]
                                                          ['ID_subclass']))
                                                  ? const Icon(Icons.check_box)
                                                  : const Icon(Icons.add_box)),
                                          IconButton(
                                              onPressed: () {
                                                initSettingMateria(
                                                    material[index]
                                                        ['ID_subclass']);
                                              },
                                              icon: const Icon(Icons.settings)),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          InitQuest(
                                                              IdsMaterials: [
                                                                material[index][
                                                                    'ID_subclass']
                                                              ])),
                                                );
                                              },
                                              icon:
                                                  const Icon(Icons.play_arrow))
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (index != material.length)
                                    Divider(
                                      color: mySetting.getColorText(),
                                    ),
                                ],
                              );
                            })
                      ],
                    ),
                    if (_selected.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.only(bottom: 30),
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: const MaterialStatePropertyAll(
                                  CircleBorder()),
                              iconColor: MaterialStatePropertyAll(
                                  mySetting.getColorText()),
                              iconSize: const MaterialStatePropertyAll(50),
                              backgroundColor: MaterialStatePropertyAll(
                                  mySetting.getColorsIconButton())),
                          onPressed: () => initQuest(),
                          child: const Icon(Icons.play_arrow_outlined),
                        ),
                      ),
                    if (_showAccept) initClassUniq,
                  ],
                ),
        ));
  }

  SliverAppBar appBarOfInfoMyClass(BuildContext context) {
    return SliverAppBar(
      elevation: 10,
      backgroundColor: mySetting.getColorDrawerSecondary(),
      pinned: true,
      leading: IconButton(
        color: mySetting.getColorText(),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: kBottomNavigationBarHeight,
        child: Row(
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 240),
              child: Text(
                this.myClass[0]['Nombre'],
                style: TextStyle(
                  color: mySetting.getColorText(),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Raleway",
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(child: Container()),
            AnimatedBuilder(
              animation: _scrollController,
              builder: (context, child) {
                double position = -125 + _scrollController.offset;
                if (position > 0) position = 0;
                return Transform.translate(
                  offset:
                      Offset(0, _scrollController.offset < 75 ? -50 : position),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.share, color: textColor)),
                      IconButton(
                          onPressed: () async {
                            await setClass(context);
                            chargerData();
                          },
                          icon: Icon(Icons.settings, color: textColor)),
                      IconButton(
                          onPressed: () {
                            generateNewMateria(context);
                          },
                          icon: Icon(Icons.add, color: textColor))
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
      expandedHeight: 150,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: AnimatedBuilder(
          animation: _scrollController,
          builder: (context, child) {
            double textWidth =
                130 * (_scrollController.offset) / kToolbarHeight;
            if (textWidth <= 0) textWidth = 0;
            double opacityText = (150 - _scrollController.offset) / 150;
            if (opacityText < 0) opacityText = 0;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Opacity(
                  opacity: opacityText,
                  child: Container(
                      child: Text(
                    "Descripcion: ${this.myClass[0]['Descripcion']} ",
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: mySetting.getColorText()),
                  )),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform.translate(
                        offset: Offset(textWidth, 0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                iconColor: MaterialStatePropertyAll(
                                    mySetting.getColorText()),
                                backgroundColor: MaterialStatePropertyAll(
                                    mySetting.getColorDrawerSecondary())),
                            onPressed: () {},
                            child: Row(
                              children: [
                                const Icon(Icons.share),
                                SizedBox(
                                  width: 80,
                                  child: Text(" Compartir",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: mySetting.getColorText())),
                                ),
                              ],
                            )),
                      ),
                      Transform.translate(
                        offset: Offset(textWidth, 0),
                        child: ElevatedButton(
                            style: buttonStyle,
                            onPressed: () async {
                              await setClass(context);
                              chargerData();
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.settings),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    " Configurar",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: mySetting.getColorText()),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Transform.translate(
                        offset: Offset(textWidth, 0),
                        child: ElevatedButton(
                            style: buttonStyle,
                            onPressed: () {
                              generateNewMateria(context);
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.add),
                                SizedBox(
                                    width: 80,
                                    child: Text("Agregar",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: mySetting.getColorText())))
                              ],
                            )),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> setClass(BuildContext context) {
    bool acceptName = true;
    bool acceptDescription = true;

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          _nameEditController.text = this.myClass[0]['Nombre'];
          _descriptionEditController.text = this.myClass[0]['Descripcion'];
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            titleTextStyle:
                TextStyle(color: mySetting.getColorText(), fontSize: 20),
            backgroundColor: mySetting.getBackgroundColor(),
            actionsOverflowAlignment: OverflowBarAlignment.center,
            iconColor: mySetting.getColorText(),
            title: const Text(
              "Configuración de clase",
              textAlign: TextAlign.center,
            ),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameEditController,
                    autofocus: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        acceptName = false;
                        return "Inserte un nombre valido";
                      }
                      acceptName = true;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        labelText: "Nombre de clase",
                        hoverColor: mySetting.getColorText(),
                        fillColor: mySetting.getColorText(),
                        focusColor: mySetting.getColorText(),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mySetting.getColorText())),
                        labelStyle: TextStyle(color: mySetting.getColorText())),
                    style: TextStyle(color: mySetting.getColorText()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _descriptionEditController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        acceptDescription = false;
                        return "Inserte un nombre valido";
                      }
                      acceptDescription = true;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "Descripcion de clase",
                        hoverColor: mySetting.getColorText(),
                        fillColor: mySetting.getColorText(),
                        focusColor: mySetting.getColorText(),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: mySetting.getColorText())),
                        labelStyle: TextStyle(color: mySetting.getColorText())),
                    style: TextStyle(color: mySetting.getColorText()),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(context);
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: mySetting.getColorText(),
                  )),
              IconButton(
                  onPressed: () async {
                    print(acceptDescription);
                    print(acceptName);
                    if (!(acceptName || acceptDescription)) {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              backgroundColor: mySetting.getBackgroundColor(),
                              title: Text(
                                "Inserte valores validos",
                                style:
                                    TextStyle(color: mySetting.getColorText()),
                              ),
                            );
                          }));
                      return;
                    }
                    await dataBase.changeInfoClass(_nameEditController.text,
                        _descriptionEditController.text, this.myClass[0]["ID"]);
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.check_circle,
                    color: mySetting.getColorText(),
                  )),
            ],
          );
        });
  }

  Future<dynamic> generateNewMateria(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: mySetting.getBackgroundColor(),
            iconColor: mySetting.getColorText(),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                    ),
                    child: TextFormField(
                      autofocus: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '¿Como sabremos que estamos estudiando?';
                        }
                        return null;
                      },
                      controller: _nameMaterial,
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
                        labelStyle: TextStyle(color: textColor),
                        hintStyle: TextStyle(color: textColor),
                        hintText: "Ejm: La peor materia :c",
                        hoverColor: mySetting.getColorText(),
                        labelText: "Nombre materia",
                        icon: Icon(
                          Icons.width_normal_rounded,
                          color: mySetting.getColorText(),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    minWidth: 700,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        color: mySetting.getColorText(),
                      ),
                      IconButton(
                        onPressed: () => saveMaterial(context),
                        icon: const Icon(Icons.check),
                        color: mySetting.getColorText(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
