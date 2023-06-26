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
    List<Map<String, dynamic>> result = await myDataBase.getClases();
    int lent = result.length;
    if (lent == 0) {
      myBody = Center(
        child: Text(
          "Parece ser que aun no tenemos clases juntos",
          style: TextStyle(
            color: mySetting.getColorText(),
            fontSize: 15,
          ),
        ),
      );
    } else {
      List<Widget> myCarts = [];
      for (int i = 0; i < lent; i++) {
        myCarts.add(const SizedBox(height: 15));
        myCarts.add(
          ElevatedButton(
            onPressed: () async {
              print("Se entra al objeto ${result[i]['ID'].toString()}");
              bool recargarPagina = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SeeClass(number: result[i]['ID'])));
              if (recargarPagina == true) seeMyClass();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    mySetting.getColorDrawerSecundary())),
            child: Container(
              child: Row(
                children: [
                  Text(
                    "Nombre:  ",
                    style: TextStyle(
                      fontSize: 15,
                      color: mySetting.getColorText(),
                    ),
                  ),
                  Text(
                    result[i]['Nombre'].toString(),
                    style: TextStyle(
                      fontSize: 15,
                      color: mySetting.getColorText(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: Text("")),
                  Text(
                    "cantidad materia: ${result[i]['cantMateria']}",
                    style: TextStyle(
                      color: mySetting.getColorText(),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () => deleteClass(result[i]['ID']),
                    icon: const Icon(Icons.phonelink_erase_rounded),
                  )
                ],
              ),
            ),
          ),
        );
      }
      myBody = ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: myCarts,
      );
    }

    Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false; // Indicar que la carga ha finalizado
    });
  }

  // ignore: prefer_typing_uninitialized_variables
  late var myBody;

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
        body: isLoading
            ? const Center(
                child: Text("Estamos trabajando para usted"),
              )
            : Stack(
                children: [
                  myBody,
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "version: 0.${mySetting.version0.toString()}",
                      style: TextStyle(color: mySetting.getColorText()),
                    ),
                  ),
                  if (eraseClass)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black26,
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 3,
                          color: mySetting.getBackgroundColor(),
                          child: Column(
                            children: [
                              const Expanded(child: Text('')),
                              Text(
                                "¿Estas seguro de eliminar esta clase?",
                                style: TextStyle(
                                  color: mySetting.getColorText(),
                                ),
                              ),
                              const Expanded(child: Text('')),
                              Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  IconButton(
                                      color: mySetting.getColorText(),
                                      onPressed: () {
                                        setState(() {
                                          eraseClass = false;
                                        });
                                      },
                                      icon: const Icon(Icons.cancel_outlined)),
                                  const Expanded(child: Text('')),
                                  IconButton(
                                      color: mySetting.getColorText(),
                                      onPressed: () {
                                        acceptErase();
                                      },
                                      icon: const Icon(Icons.check)),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                              const Expanded(child: Text(''))
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
