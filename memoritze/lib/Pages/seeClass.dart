import 'package:flutter/material.dart';
import 'package:memoritze/db/dataBase.dart';
import 'package:memoritze/setting.dart';

// ignore: must_be_immutable
class SeeClass extends StatefulWidget {
  late int id_class;

  SeeClass({super.key, required int number}) {
    id_class = number;
  }

  @override
  State<SeeClass> createState() => _SeeClassState();
}

class _SeeClassState extends State<SeeClass> {
  List<int> selected = [];

  MyDataBase dataBase = MyDataBase();

  bool showAccept = false;

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

  void initSettinMateria(int idMaterial) {}

  void chargerMaterial() async {
    material = await dataBase.getmaterialClas(widget.id_class);

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
                    icon: Icon(Icons.check_box),
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
                  onPressed: () =>
                      initSettinMateria(material[i]['ID_subclass']),
                  icon: Icon(Icons.settings),
                ),
                IconButton(
                  color: mySetting.getColorText(),
                  onPressed: () {},
                  icon: Icon(Icons.play_circle),
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
      child: Scrollbar(
        child: ListView(
          children: materials,
        ),
      ),
    );
    //(child: ListView( children: materias,),);
    setState(() {
      chargeMaterial = true;
    }); //recargamos la pagina
  }

  void chargerData() async {
    this.myClass = await dataBase.getClassID(widget.id_class);
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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: mySetting.getBackgroundColor(),
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(48, 0, 0, 0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.width / 3,
            color: mySetting.getBackgroundColor(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(child: Text('')),
                    Form(
                      key: _formKey,
                      child: TextFormField(
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
                          labelStyle:
                              TextStyle(color: mySetting.getColorText()),
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
                    const Expanded(child: Text('')),
                    Row(
                      children: [
                        const Expanded(child: Text('')),
                        IconButton(
                          onPressed: () => pressX(),
                          icon: const Icon(Icons.close),
                          color: mySetting.getColorText(),
                        ),
                        const Expanded(child: Text('')),
                        IconButton(
                          onPressed: () => saveMaterial(),
                          icon: const Icon(Icons.check),
                          color: mySetting.getColorText(),
                        ),
                        const Expanded(child: Text(''))
                      ],
                    ),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void initQuest() {}
}
