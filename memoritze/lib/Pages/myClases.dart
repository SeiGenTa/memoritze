import 'package:flutter/material.dart';
import 'package:memoritze/Pages/seeClass.dart';
import 'package:memoritze/db/dataBase.dart';
import 'package:memoritze/partes/barraLeft.dart';
import 'package:memoritze/setting.dart';

class MyClasses extends StatefulWidget {
  const MyClasses({super.key});

  @override
  State<MyClasses> createState() => _MyClassesState();
}

class _MyClassesState extends State<MyClasses> {
  bool eraseClass = false;
  int deleteClas = 0;
  late List<Map<String, dynamic>> infClass;

  void deleteClass(id) {
    setState(() {
      deleteClas = id;
      eraseClass = true;
    });
  }

  void acceptErase() async {
    await myDataBase.deletedClass(deleteClas);
    seeMyClass();
    setState(() {
      eraseClass = false;
    });
  }

  bool isLoading = true;

  MyDataBase myDataBase = MyDataBase();
  Setting mySetting = Setting();


  Future<void> seeMyClass() async {
    infClass = await myDataBase.getClases();

    setState(() {
      isLoading = false; // Indicar que la carga ha finalizado
    });
  }

  @override
  void initState() {
    super.initState();
    seeMyClass();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: mySetting.getColorDrawer(),
          title: const Text('Mis Clases'),
        ),
        backgroundColor: mySetting.getBackgroundColor(),
        drawer: const BarraLeft(),
        body:
          Stack(
          children: [
            isLoading?
            //! Imagen al momento de cargar la parte visual
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: mySetting.getColorText(),
                  backgroundColor: mySetting.getBackgroundColor(),
                ),
              )
              :
              infClass.isEmpty?
              //! CASO EN QUE NO HAY CLASES
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: Text(
                    "No tenemos clases juntos aun",
                    style: TextStyle(
                      color: mySetting.getColorText(),
                    ),
                  ),
                )
              :
              //! CASO EN QUE SI HAY CLASES
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ScrollbarTheme(
                    data: ScrollbarThemeData(
                      thumbColor: MaterialStatePropertyAll(mySetting.getColorText()), // Establece el color del scroll
                    ),
                    child: ListView.builder(
                      itemCount: infClass.length,
                      itemBuilder: (context,index) {
                        // * AQUI ESTA TODA LA GENERACION
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(mySetting.getColorDrawerSecundary()),
                            ),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SeeClass(number: infClass[index]['ID']))
                                );
                                seeMyClass();
                            },
                            child:
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      "Nombre clase: ${infClass[index]['Nombre']}",
                                      style: TextStyle(
                                        color: mySetting.getColorText()
                                        ),
                                      ),
                                    Expanded(child: Container(),),
                                    Text(
                                      "Cantidad de materias: ${infClass[index]['cantMateria']}",
                                      style: TextStyle(
                                        color: mySetting.getColorText()
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      IconButton(
                                        onPressed: () => setState(() {
                                          deleteClas = infClass[index]['ID'];
                                          eraseClass = true;
                                        }),
                                        icon: const Icon(Icons.phonelink_erase))
                                  ],
                                ),
                              ),
                            ),
                        );
                      },),
                  ),
                ),
                //! MENSAJE DE BORRADO DE INFORMACION
                if (eraseClass)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black26,
                    alignment: Alignment.center,
                    child: Container(
                      color: mySetting.getBackgroundColor(),
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.height/2,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Expanded(child: Container()),
                          Text(
                            "¿Estas seguro de borrar esta clase?",
                            style: TextStyle(
                              color: mySetting.getColorText()
                            ),
                            ),
                          Expanded(child: Container()),
                          Row(
                            children: [
                              Expanded(child: Container()),
                              IconButton(
                                onPressed: () => setState(() {
                                  eraseClass = false;
                                }),
                                icon: const Icon(Icons.cancel),
                                iconSize: 50,
                                color: mySetting.getColorText(),
                                ),
                              Expanded(child: Container()),
                              IconButton(
                                onPressed: () => acceptErase(),
                                icon: const Icon(Icons.check_circle),
                                iconSize: 50,
                                color: mySetting.getColorText(),
                                ),
                              Expanded(child: Container())
                            ],
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                  )
          ],
        )
      ),
    );
  }
}
