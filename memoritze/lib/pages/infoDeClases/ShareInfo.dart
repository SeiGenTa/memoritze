import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memoritze/dataBase/db.dart';
import 'package:memoritze/settings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareFile extends StatefulWidget {
  const ShareFile({
    super.key,
    required this.material,
    required this.mySetting,
    required this.context,
    required this.idClass,
  });

  final List<Map<String, dynamic>> material;
  final Setting mySetting;
  final BuildContext context;
  final int idClass;

  @override
  State<ShareFile> createState() => _ShareFileState();
}

class _ShareFileState extends State<ShareFile> {
  ConnectionDataBase myConnection = ConnectionDataBase();
  Setting mySetting = Setting();
  final List<int> _mySelects = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> mysVision = [];
    for (int i = 0; i < widget.material.length; i++) {
      final Widget obj = ListTile(
        leading: IconButton(
          onPressed: () {
            if (_mySelects.contains(widget.material[i]["ID_subclass"])) {
              setState(() {
                _mySelects.remove(widget.material[i]["ID_subclass"]);
              });
            } else {
              setState(() {
                _mySelects.add(widget.material[i]["ID_subclass"]);
              });
            }
          },
          icon: _mySelects.contains(widget.material[i]["ID_subclass"])
              ? const Icon(
                  Icons.check_box,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.check_box_outline_blank,
                  color: Colors.white,
                ),
        ),
        title: Text(
          widget.material[i]["Nombre"],
          style: const TextStyle(color: Colors.white),
        ),
      );
      mysVision.add(obj);
    }
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        IconButton(
            onPressed: () async {
              Map<String, dynamic> mapInfo =
                  await myConnection.createJson(widget.idClass, _mySelects);

              String myJson = json.encode(mapInfo);

              if (Platform.isWindows || Platform.isLinux) {
                var _dowloadDirectory = await getDownloadsDirectory();
                File myFIle =
                    File("${_dowloadDirectory!.path}/miMaterial.json");
                await myFIle.writeAsString(myJson);
                // ignore: use_build_context_synchronously
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: mySetting.getColorNavSup(),
                        content: const Text(
                          "Se a guardado en tu carpeta de descargas",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    });
                return;
              }

              var _tempDirectory = await getTemporaryDirectory();

              File myFIle = File("${_tempDirectory.path}/miMaterial.json");
              await myFIle.writeAsString(myJson);
              // ignore: deprecated_member_use

              // ignore: deprecated_member_use
              await Share.shareFiles(
                  ["${_tempDirectory.path}/miMaterial.json"]);

              //File mysCosas = File("${_tempDirectory?.path}/myJson.txt");
              //print((await mysCosas.readAsString()));
            },
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ))
      ],
      backgroundColor: widget.mySetting.getColorNavSup(),
      titlePadding: const EdgeInsets.all(0),
      title: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          const Text(
            "Compartir material",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      content: SingleChildScrollView(
        child: Column(children: mysVision),
      ),
    );
  }
}
