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
  List<int> selected = [];

  ConectioDataBase dataBase = ConectioDataBase();

  bool showAccept = false;

  void initQuest() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return InitQuest(IdsMaterials: selected);
    }));
  }

  Widget initClassUniq = Container();
  @override
  void initState() {
    super.initState();
    chargerData();
  }

  void createNewMateria() {
    setState(() {
      showCreate = !showCreate;
    });
  }

  void pressX() {
    setState(() {
      showCreate = !showCreate;
    });
    _nameMaterial.clear();
  }

  void saveMaterial() async {
    _formKey.currentState!.validate();
    if (_nameMaterial.text.isEmpty) return;
    setState(() {
      showCreate = !showCreate;
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
    return;
  }

  void chargerMaterial() async {
    material = await dataBase.getMaterialClass(widget.id_class);

    List<Widget> materials = [];

    for (int i = 0; i < material.length; i++) {
      materials.add(
        Container(
          margin: const EdgeInsets.only(
            top: 2,
          ),
          decoration: const BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(
            width: 1,
            color: Colors.grey,
          ))),
          child: ListTile(
            textColor: mySetting.getColorText(),
            hoverColor: mySetting.getColorDrawer(),
            title: Row(
              children: [
                const Text(
                  "Nombre materia:    ",
                ),
                Text(
                  material[i]['Nombre'],
                ),
                Expanded(child: Container()),
                //!Seccion donde se agrega o se quita quest
                if (selected.contains(material[i]['ID_subclass']))
                  //? esta selecionado para el cuestionar
                  IconButton(
                    color: mySetting.getColorText(),
                    onPressed: () {
                      selected.remove((material[i]['ID_subclass']));
                      setState(() {
                        chargerMaterial();
                      });
                    },
                    icon: const Icon(Icons.check_box),
                  )
                else
                  //? no esta selecionado para el cuestionar
                  IconButton(
                    color: mySetting.getColorText(),
                    onPressed: () {
                      selected.add(material[i]['ID_subclass']);
                      setState(() {
                        chargerMaterial();
                      });
                    },
                    icon: Icon(Icons.check_box_outline_blank),
                  ),
                IconButton(
                  color: mySetting.getColorText(),
                  onPressed: () async {
                    await initSettingMateria(material[i]['ID_subclass']);
                    chargerMaterial();
                  },
                  icon: const Icon(Icons.settings),
                ),
                IconButton(
                  color: mySetting.getColorText(),
                  onPressed: () {
                    print("iniciar quis");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InitQuest(
                              IdsMaterials: [material[i]['ID_subclass']])),
                    );
                  },
                  icon: const Icon(Icons.play_circle),
                ),
              ],
            ),
            subtitle:
                Text("Cantidad de preguntas:  ${material[i]['cantPreg']}"),
          ),
        ),
      );
    }
    myMaterialClass = Expanded(
      child: ListView(
        children: materials,
      ),
    );
    //(child: ListView( children: materias,),);
    setState(() {
      chargeMaterial = true;
    }); //recargamos la pagina
  }

  void chargerData() async {
    this.myClass = await dataBase.getClass(widget.id_class);
    setState(() {
      charge = true;
    });
    chargerMaterial();
  }

  final TextEditingController _nameMaterial = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool showCreate = false;
  bool chargeMaterial = false;

  late List<Map<String, dynamic>> myClass;
  late Widget myMaterialClass;
  List<Map<String, dynamic>> material = [];

  bool charge = false;
  Setting mySetting = Setting();

  @override
  Widget build(BuildContext context) {
    print(mySetting.hashCode);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: mySetting.getBackgroundColor(),
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: mySetting.getColorDrawerSecundary(),
          ),
          body: !charge
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
                    Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              color: mySetting.getColorDrawerSecundary(),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        myClass[0]['Nombre'].toString(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: mySetting.getColorText(),
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Expanded(child: Text(""))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Descripcion:",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: mySetting.getColorText(),
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          myClass[0]['Descripcion'].toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: mySetting.getColorText(),
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                100),
                                        child: ElevatedButton(
                                          onPressed: () => createNewMateria(),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    mySetting.getColorDrawer()),
                                          ),
                                          child: const Text(
                                              "Agregar Cuestionario"),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                              iconSize: 40,
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: mySetting.getColorText(),
                              ),
                            )
                          ],
                        ),
                        !chargeMaterial
                            ? const Center(
                                child: Text("No tenemos cuestionarios aqui"),
                              )
                            : myMaterialClass
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "version: 0.${mySetting.version0.toString()}",
                        style: TextStyle(color: mySetting.getColorText()),
                      ),
                    ),
                    if (selected.isNotEmpty)
                      Container(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () => initQuest(),
                          color: mySetting.getColorDrawerSecundary(),
                          iconSize: 50,
                          icon: Icon(Icons.play_circle_fill),
                        ),
                      ),
                    if (showCreate) createNewMaterial(context),
                    if (showAccept) initClassUniq,
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
