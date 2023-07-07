import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/pages/InfoMyClass.dart';
import 'package:memoritze/partes/BarLeft.dart';
import 'package:memoritze/settings.dart';

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

  bool optionErase = false;
  int idClassErase = 0;

  void initEraseClass(int idClass) {
    setState(() {
      idClassErase = idClass;
      optionErase = true;
    });
  }

  Future<bool> initApp() async {
    await myData.init();
    await mySetting.chargeSetting();

    setState(() {
      widget.prepared = true;
    });

    return true;
  }

  void initPage() async {
    if (!widget.prepared) {
      await initApp();
    }
    infoClass = await myData.getClass(-1);
    setState(() {
      charging = false;
      this.infoClass = infoClass;
    });
  }

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {

    if (!widget.prepared) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black38,
          body: Center(
            child: Image.asset('assets/img/myIcon.png'),
          ),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: mySetting.getBackgroundColor(),
        appBar: AppBar(
          title: const Text("Mis clases"),
          backgroundColor: mySetting.getColorDrawerSecundary(),
        ),
        drawer: BarLeft(
          myContext: 1,
        ),
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
            : Stack(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(10),
                      child: (infoClass.isEmpty)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Parece que aun no tenemos clases juntos",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: mySetting.getColorText(),
                                  ),
                                ),
                                Text(
                                  "¡Que tal agregar una CLASE!",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: mySetting.getColorText(),
                                  ),
                                ),
                                Text(
                                  "Entra al navBar",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: mySetting.getColorText(),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: infoClass.length,
                              itemBuilder: (context, index) {
                                return AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        border: Border.symmetric(
                                            horizontal: BorderSide(
                                                color:
                                                    mySetting.getColorText()))),
                                    child: ListTile(
                                      hoverColor: mySetting.getColorPaper(),
                                      textColor: mySetting.getColorText(),
                                      iconColor: mySetting.getColorText(),
                                      subtitle: Text(
                                          "Cantidad materias ${infoClass[index]['cantMateria']}"),
                                      visualDensity: VisualDensity.compact,
                                      title: Row(
                                        children: [
                                          Text(
                                            "${infoClass[index]['Nombre']}",
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          Expanded(child: Container()),
                                          IconButton(
                                              onPressed: () {
                                                initEraseClass(
                                                    infoClass[index]['ID']);
                                              },
                                              icon: const Icon(Icons.delete))
                                        ],
                                      ),
                                      onTap: () async {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InfoMyClass(
                                                        number: infoClass[index]
                                                            ['ID'])));
                                        infoClass = await myData.getClass(-1);
                                        setState(() {
                                          charging = false;
                                        });
                                      },
                                    ),
                                  ),
                                );
                              })),
                  if (optionErase)
                    Container(
                      color: Colors.black26,
                      alignment: Alignment.center,
                      child: Container(
                        //duration: const Duration(milliseconds: 500),
                        color: mySetting.getBackgroundColor(),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height / 3,
                              minWidth: MediaQuery.of(context).size.height / 2),
                          color: mySetting.getBackgroundColor(),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "¿Seguro que quieres eliminar esta clase?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: mySetting.getColorText(),
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    minWidth:
                                        MediaQuery.of(context).size.height / 2,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            idClassErase = 0;
                                            optionErase = false;
                                          });
                                        },
                                        icon: Icon(Icons.cancel),
                                        iconSize: 35,
                                        color: mySetting.getColorText(),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await myData
                                              .deletedClass(idClassErase);
                                          infoClass = await myData.getClass(-1);
                                          setState(() {
                                            charging = false;
                                            idClassErase = 0;
                                            optionErase = false;
                                          });
                                        },
                                        icon: Icon(Icons.check_circle),
                                        iconSize: 35,
                                        color: mySetting.getColorText(),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ),
                    )
                ],
              ),
      ),
    );
  }
}
