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
  List<int> _selected = [];

  ConectioDataBase dataBase = ConectioDataBase();

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
  }

  void _updateAppBarStretchRatio() {
    setState(() {
      _appBarStretchRatio = _scrollController.offset;
    });
  }

  void createNewMateria() {
    setState(() {
      _showCreate = !_showCreate;
    });
  }

  void pressX() {
    setState(() {
      _showCreate = !_showCreate;
    });
    _nameMaterial.clear();
  }

  void saveMaterial() async {
    _formKey.currentState!.validate();
    if (_nameMaterial.text.isEmpty) return;
    setState(() {
      _showCreate = !_showCreate;
    });
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
    this.myClass = await dataBase.getClass(widget.id_class);
    setState(() {
      _charge = true;
    });
    chargerMaterial();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    _nameMaterial.dispose();
  }

  final TextEditingController _nameMaterial = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _showCreate = false;
  bool chargeMaterial = false;

  late List<Map<String, dynamic>> myClass;
  late Widget myMaterialClass;
  List<Map<String, dynamic>> material = [];

  bool _charge = false;
  Setting mySetting = Setting();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: mySetting.getBackgroundColor(),
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: mySetting.getColorDrawerSecundary(),
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
                        SliverAppBar(
                          elevation: 100,
                          pinned: true,
                          backgroundColor: mySetting.getColorDrawerSecundary(),
                          leading: IconButton(
                            iconSize: 50,
                            color: mySetting.getColorText(),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          expandedHeight: 200,
                          flexibleSpace: Container(
                            //decoration: const BoxDecoration(
                            //    image: DecorationImage(
                            //        fit: BoxFit.cover,
                            //        image: AssetImage(
                            //          "assets/img/fondoWhite.jpg", //!CONFIGURAR
                            //        ))),
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: (_appBarStretchRatio < 100)
                                                ? _appBarStretchRatio
                                                : 100,
                                          ),
                                          Container(
                                            alignment: Alignment.bottomLeft,
                                            height: (_appBarStretchRatio < 100)
                                                ? 100 -
                                                    (_appBarStretchRatio / 2)
                                                : 50,
                                            child: Text(
                                              this.myClass[0]['Nombre'],
                                              style: TextStyle(
                                                color: mySetting.getColorText(),
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Raleway",
                                              ),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Opacity(
                                          opacity: (_appBarStretchRatio > 120)
                                              ? 0
                                              : (120 - _appBarStretchRatio) /
                                                  120,
                                          child: Text(
                                            "Descripcion: ${this.myClass[0]['Descripcion']} ",
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                color:
                                                    mySetting.getColorText()),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      !(_appBarStretchRatio > 250)
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Container()),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    (_appBarStretchRatio < 100)
                                                        ? BorderRadius.circular(
                                                            10)
                                                        : BorderRadius.circular(
                                                            25)),
                                          ),
                                          elevation:
                                              MaterialStatePropertyAll(5),
                                          iconColor: MaterialStatePropertyAll(
                                              mySetting.getColorText()),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  mySetting.getColorPaper()),
                                        ),
                                        onPressed: () => setState(() {
                                          _showCreate = true;
                                        }),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.add),
                                            AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    (_appBarStretchRatio > 100)
                                                        ? 0
                                                        : 200,
                                              ),
                                              child: Text(
                                                "Agregar materia",
                                                style: TextStyle(
                                                  color:
                                                      mySetting.getColorText(),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
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
                                    textColor: mySetting.getColorText(),
                                    iconColor: mySetting.getColorText(),
                                    subtitle: Text(
                                      "   Cantidad de preguntas: ${material[index]['cantPreg']}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    title: Container(
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "  Materia:  ${material[index]['Nombre']}",
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
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () => initQuest(),
                          color: mySetting.getColorDrawerSecundary(),
                          iconSize: 50,
                          icon: const Icon(Icons.play_circle_fill),
                        ),
                      ),
                    if (_showCreate) createNewMaterial(context),
                    if (_showAccept) initClassUniq,
                  ],
                ),
        ));
  }

  Container createNewMaterial(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(48, 0, 0, 0),
        child: Container(
          color: mySetting.getBackgroundColor(),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height / 3,
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
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
                      labelStyle: TextStyle(color: mySetting.getColorText()),
                      hintStyle: TextStyle(color: mySetting.getColorText()),
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
                      onPressed: () => pressX(),
                      icon: const Icon(Icons.close),
                      color: mySetting.getColorText(),
                    ),
                    IconButton(
                      onPressed: () => saveMaterial(),
                      icon: const Icon(Icons.check),
                      color: mySetting.getColorText(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
