import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memoritze/Settings.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/partes/BarLeft.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// ignore: must_be_immutable
class SeeMyClass extends StatefulWidget {
  bool prepared = true;
  SeeMyClass({super.key, this.prepared = true});

  @override
  State<SeeMyClass> createState() => _SeeMyClassState();
}

class _SeeMyClassState extends State<SeeMyClass> {
  ConectioDataBase myData = ConectioDataBase();
  Setting mySetting = Setting();

  bool charging = true;
  late List<Map<String, dynamic>> infoClass;

  Future<bool> initApp() async {
    print("cargando informacion");
    if (Platform.isWindows) {
      print("Estoy en windows");
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    await myData.init();
    await mySetting.chargeSetting();

    setState(() {
      widget.prepared = true;
      print("changeEstate");
    });

    return true;
  }

  void initPage() async {
    if (!widget.prepared) {
      await initApp();
    }
    infoClass = await myData.getClass(-1);
    print(infoClass);
    setState(() {
      charging = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: mySetting.getBackgroundColor(),
        appBar: AppBar(
          title: const Text("Mis clases"),
          backgroundColor: mySetting.getColorDrawerSecundary(),
        ),
        drawer: const BarraLeft(),
        body: charging
            ? Center(
                child: Text(
                  "Estamos preparando todo para ti",
                  style: TextStyle(
                    fontSize: 20,
                    color: mySetting.getColorText(),
                  ),
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(10),
                child: (infoClass.isEmpty)
                    ? Center(
                        child: Text(
                          "Parece que aun no tenemos clases juntos",
                          style: TextStyle(
                            fontSize: 20,
                            color: mySetting.getColorText(),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: infoClass.length,
                        itemBuilder: (context, index) {
                          return AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            child: ListTile(
                              textColor: mySetting.getColorText(),
                              iconColor: mySetting.getColorText(),
                              subtitle: Text("Cantidad materias ${infoClass[index]['cantMateria']}"),
                              visualDensity: VisualDensity.compact,
                              title: Row(
                                children: [
                                  Text(
                                    "${infoClass[index]['Nombre']}",
                                    style: const TextStyle(
                                      fontSize: 20
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.delete))
                                ],
                              ),
                              onTap: () {},
                            ),
                          );
                        })),
      ),
    );
  }
}
