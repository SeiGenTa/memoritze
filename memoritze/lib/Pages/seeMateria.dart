import 'package:flutter/material.dart';
import 'package:memoritze/db/dataBase.dart';
import 'package:memoritze/setting.dart';

class SeeMateria extends StatefulWidget {
  late int idMateria;

  SeeMateria({super.key, required this.idMateria});

  @override
  State<SeeMateria> createState() => _SeeMateriaState();
}

class _SeeMateriaState extends State<SeeMateria> {
  Setting setting = Setting();
  MyDataBase database = MyDataBase();

  bool charging = true;

  late List<Map<String, dynamic>> myQuests;

  static late Color background;
  static late Color textColor;
  static late Color drawer;
  static late Color drawer2;

  @override
  void initState() {
    super.initState();
    background = setting.getBackgroundColor();
    textColor = setting.getColorText();
    drawer = setting.getColorDrawer();
    drawer2 = setting.getColorDrawerSecundary();
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
                  Container(
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
            : Column(
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
                        icon: Icon(Icons.delete),
                        iconSize: 40,
                      ),
                      const Expanded(child: Text('')),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        iconSize: 40,
                      ),
                      const Expanded(child: Text('')),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.check),
                        iconSize: 40,
                      ),
                      const Expanded(child: Text('')),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
