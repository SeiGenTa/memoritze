// ignore: file_names
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/pages/InfoMateria.dart';
import 'package:memoritze/pages/InitQuests.dart';
import 'package:memoritze/pages/infoDeClases/ShareInfo.dart';
import 'package:memoritze/settings.dart';

// ignore: must_be_immutable
class InfoMyClass extends StatefulWidget {
  // ignore: non_constant_identifier_names
  late int id_class;

  InfoMyClass({super.key, required int number}) {
    id_class = number;
  }

  @override
  State<InfoMyClass> createState() => _InfoMyClassState();
}

class _InfoMyClassState extends State<InfoMyClass>
    with SingleTickerProviderStateMixin {
  final List<int> _selected = [];

  ConnectionDataBase dataBase = ConnectionDataBase();

  late final ScrollController _scrollController = ScrollController();

  void initQuest() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return InitQuest(IdsMaterials: _selected);
    }));
  }

  bool extend = true;

  Widget initClassUniq = Container();
  @override
  void initState() {
    super.initState();
    chargerData();
    _scrollController.addListener(_updateAppBarStretchRatio);
    textColor = mySetting.getColorText();
    _controllerAnimateAppBar = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animateAppBar =
        Tween(begin: 0.0, end: 1.0).animate(_controllerAnimateAppBar);
  }

  late final AnimationController _controllerAnimateAppBar;
  late final Animation<double> animateAppBar;

  void _updateAppBarStretchRatio() async {
    if (_scrollController.offset > 60 && extend == false) {
      _controllerAnimateAppBar.forward();
      extend = true;
    } else if (_scrollController.offset < 60 && extend == true) {
      _controllerAnimateAppBar.reverse();
      extend = false;
    }
  }

  void saveMaterial(context) async {
    _formKey.currentState!.validate();
    if (_nameMaterial.text.isEmpty) return;
    Navigator.pop(context);
    bool result =
        await dataBase.createNewMateriaDB(_nameMaterial.text, widget.id_class);
    if (result == false) {
      showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: mySetting.getColorNavSup(),
            titleTextStyle: const TextStyle(color: Colors.white),
            title: const Text("Ya existe una materia con ese nombre"),
          );
        }),
      );
    }
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
    myClass = await dataBase.getClass(widget.id_class);
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
    _controllerAnimateAppBar.dispose();
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
      iconColor: const MaterialStatePropertyAll(Colors.white),
      backgroundColor:
          MaterialStatePropertyAll(mySetting.getColorsIconButton()));

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
            backgroundColor: mySetting.getColorNavSup(),
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
                              return GestureDetector(
                                onTap: () {
                                  if (_selected.isEmpty) {
                                    return;
                                  }
                                  if (!_selected.any((element) =>
                                      element ==
                                      material[index]['ID_subclass'])) {
                                    setState(() {
                                      _selected
                                          .add(material[index]['ID_subclass']);
                                    });
                                  } else {
                                    setState(() {
                                      _selected.remove(
                                          material[index]['ID_subclass']);
                                    });
                                  }
                                },
                                onLongPress: () {
                                  if (!_selected.any((element) =>
                                      element ==
                                      material[index]['ID_subclass'])) {
                                    setState(() {
                                      _selected
                                          .add(material[index]['ID_subclass']);
                                    });
                                  } else {
                                    setState(() {
                                      _selected.remove(
                                          material[index]['ID_subclass']);
                                    });
                                  }
                                },
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                  shape: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: mySetting.getColorText())),
                                  leading: Stack(
                                    children: [
                                      Transform.translate(
                                        offset: const Offset(30.0, -5.0),
                                        child: Transform(
                                          transform: Matrix4.identity()
                                            ..rotateZ(4 / 20 * pi)
                                            ..scale(0.95),
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
                                        offset: Offset(15.0, -6.0),
                                        child: Transform(
                                          transform: Matrix4.identity()
                                            ..rotateZ(3 / 20 * pi)
                                            ..scale(0.95),
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
                                                  color:
                                                      mySetting.getColorText(),
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (_selected.any((element) =>
                                          element ==
                                          material[index]['ID_subclass']))
                                        const Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Icon(Icons.check_circle))
                                    ],
                                  ),
                                  textColor: mySetting.getColorText(),
                                  iconColor: mySetting.getColorText(),
                                  title: SizedBox(
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
                                              initSettingMateria(material[index]
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
                                            icon: const Icon(Icons.play_arrow))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                    AnimatedPositioned(
                      curve: Curves.easeInOut,
                      right: _selected.isEmpty ? -100 : 10,
                      bottom: 10,
                      duration: Duration(milliseconds: 500),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape:
                                const MaterialStatePropertyAll(CircleBorder()),
                            iconColor: MaterialStatePropertyAll(
                                mySetting.getColorText()),
                            iconSize: const MaterialStatePropertyAll(50),
                            backgroundColor: MaterialStatePropertyAll(
                                mySetting.getColorsIconButton())),
                        onPressed: () => initQuest(),
                        child: const Icon(Icons.play_arrow_outlined),
                      ),
                    ),
                  ],
                ),
        ));
  }

  // ignore: non_constant_identifier_names
//Diseño de appBarSuperior de la aplicacion
  SliverAppBar appBarOfInfoMyClass(BuildContext context) {
    return SliverAppBar(
      elevation: 10,
      backgroundColor: mySetting.getColorNavSup(),
      pinned: true,
      leading: IconButton(
        color: Colors.white,
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
                myClass[0]['Nombre'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Raleway",
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(child: Container()),
            AnimatedBuilder(
              animation: animateAppBar,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -50 * (1 - animateAppBar.value)),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () => showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return ShareFile(
                                  material: material,
                                  mySetting: mySetting,
                                  context: context,
                                  idClass: widget.id_class,
                                );
                              }),
                          icon: const Icon(Icons.share, color: Colors.white)),
                      IconButton(
                          onPressed: () async {
                            await setClass(context);
                            chargerData();
                          },
                          icon:
                              const Icon(Icons.settings, color: Colors.white)),
                      IconButton(
                          onPressed: () {
                            generateNewMateria(context);
                          },
                          icon: const Icon(Icons.add, color: Colors.white))
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
          animation: animateAppBar,
          builder: (context, child) {
            return Row(
              children: [
                Opacity(
                  opacity: (1 - animateAppBar.value),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width - 150,
                      child: Text(
                        "Descripcion: ${this.myClass[0]['Descripcion']} ",
                        overflow: TextOverflow.fade,
                        style: const TextStyle(color: Colors.white),
                      )),
                ),
                Transform.translate(
                  offset: Offset(200 * animateAppBar.value, 0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                iconColor:
                                    const MaterialStatePropertyAll(Colors.white),
                                backgroundColor: MaterialStatePropertyAll(
                                    mySetting.getColorsIconButton())),
                            onPressed: () => showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return ShareFile(
                                    material: material,
                                    mySetting: mySetting,
                                    context: context,
                                    idClass: widget.id_class,
                                  );
                                }),
                            child: const Row(
                              children: [
                                Icon(Icons.share),
                                SizedBox(
                                  width: 80,
                                  child: Text(" Compartir",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            )),
                        ElevatedButton(
                            style: buttonStyle,
                            onPressed: () async {
                              await setClass(context);
                              chargerData();
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.settings),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    " Configurar",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
                        ElevatedButton(
                            style: buttonStyle,
                            onPressed: () {
                              generateNewMateria(context);
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.add),
                                SizedBox(
                                    width: 80,
                                    child: Text("Agregar",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white)))
                              ],
                            ))
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

//Logica para modificar la informacion de una clase
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
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
            backgroundColor: mySetting.getColorNavSup(),
            actionsOverflowAlignment: OverflowBarAlignment.center,
            iconColor: Colors.white,
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
                    decoration: const InputDecoration(
                        labelText: "Nombre de clase",
                        prefixIconColor: Colors.white,
                        hoverColor: Colors.white,
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.white)),
                    style: const TextStyle(color: Colors.white),
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
                    decoration: const InputDecoration(
                        labelText: "Descripcion de clase",
                        hoverColor: Colors.white,
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.white)),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () async {
                    if (!(acceptName || acceptDescription)) {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              backgroundColor: mySetting.getBackgroundColor(),
                              title: const Text(
                                "Inserte valores validos",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }));
                      return;
                    }
                    await dataBase.changeInfoClass(_nameEditController.text,
                        _descriptionEditController.text, myClass[0]["ID"]);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  )),
            ],
          );
        });
  }

//Logica que permite la generacion de una nueva materia
  Future<dynamic> generateNewMateria(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: mySetting.getColorNavSup(),
            iconColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '¿Como sabremos que estamos estudiando?';
                      }
                      return null;
                    },
                    controller: _nameMaterial,
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
                      hintText: "Ejm: La peor materia :c",
                      hoverColor: Colors.white,
                      labelText: "Nombre materia",
                      icon: Icon(
                        Icons.width_normal_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () => saveMaterial(context),
                      icon: const Icon(Icons.check),
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
