// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:memoritze/settings.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ConnectionDataBase {
  static final ConnectionDataBase _instance = ConnectionDataBase._internal();

  bool getInitiated() {
    return _initiated;
  }

  factory ConnectionDataBase() {
    return _instance;
  }

  ConnectionDataBase._internal();

  bool _initiated = false;

  Future<Database> _connect() async {
    return await openDatabase(join(await getDatabasesPath(), 'memoritzeDB.db'));
  }

  void _close(Database myDataBase) {
    myDataBase.close();
  }

  Future<void> init() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    Database database = await openDatabase(
        // Establece la ruta a la base de datos.
        join(await getDatabasesPath(), 'memoritzeDB.db'),
        // Cuando la base de datos se crea por primera vez, crea una tabla para almacenar nuestra info
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE setting (
            NightMode INTEGER,
            Version INTEGER,
            Lenguaje TEXT
          );
        ''');
      // Ejecuta la sentencia CREATE TABLE en la base de datos
      await db.execute('''
          CREATE TABLE clase (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            cantMateria INTEGER,
            Nombre TEXT,
            Descripcion TEXT,
            FechPrio INTEGER,
            IsFav INTEGER
          );
          ''');

      await db.execute('''
          CREATE TABLE materia (
          ID INTEGER,
          ID_subclass INTEGER PRIMARY KEY AUTOINCREMENT,
          cantPreg INTEGER,
          Nombre TEXT,
          FechPrio INTEGER,
          FOREIGN KEY (ID) REFERENCES clase(ID)
          );
          ''');

      await db.execute('''
          CREATE TABLE pregunta (
          ID INTEGER PRIMARY KEY AUTOINCREMENT,
          ID_class INTEGER,
          ID_subclass INTEGER,
          Pregunta TEXT,
          dirImagePreg TEXT,
          respuesta TEXT,
          dirImageResp TEXT,
          eval INTEGER,
          FOREIGN KEY (ID_subclass) REFERENCES materia(ID_subclass)
          FOREIGN KEY (ID_class) REFERENCES clase(ID)
          );
          ''');
    },
        // Establece la versión. Esto ejecuta la función onCreate y proporciona una
        // ruta para realizar actualizacones y defradaciones en la base de datos.
        version: 1);
    _initiated = true;
    _close(database);
  }

  Future<Map<String, dynamic>> getSetting() async {
    Database data = await _connect();
    List<Map<String, dynamic>> inf = await data.query('setting');
    if (inf.isEmpty) {
      var inValueTheme = (ThemeMode.system == ThemeMode.dark) ? 1 : 0;
      data.insert("setting",
          {'NightMode': inValueTheme, 'Version': 18, 'Lenguaje': "Esp"});
      _close(data);
      return {'NightMode': inValueTheme, 'Version': 18, 'Lenguaje': "Esp"};
    }
    _close(data);
    return inf[0];
  }

  Future<bool> changeSetting(
      int nightMode, int version, String language) async {
    //Actualizacion de la base de datos desde la version 0.16
    Map<String, dynamic> config = await getSetting();
    Database data = await _connect();
    if (config['Version'] < 17) {
      print("Se actualizo el data base de 16 a 17");
      await data.execute('''
        ALTER TABLE clase
        ADD COLUMN IsFav INTEGER;
      ''');
      await data.update("clase", {"IsFav": 0});
    }
    if (config['Version'] < 18) {
      print("Se actualizo la dataBase a la version 18");
      await data.execute('''
        ALTER TABLE pregunta
        ADD COLUMN dirImagePreg TEXT
        ''');
      await data.execute('''
        ALTER TABLE pregunta
        ADD COLUMN dirImageResp TEXT
        ''');
    }
    data.update("setting",
        {'NightMode': nightMode, 'Version': version, 'Lenguaje': language});
    _close(data);
    return true;
  }

  Future<bool> changeInfoClass(
      String newName, String newDescription, int id) async {
    Database data = await _connect();
    data.update("clase", {"Nombre": newName, "Descripcion": newDescription},
        where: "ID == $id");
    _close(data);
    return true;
  }

  Future<bool> createClass(String name, String description) async {
    Database data = await _connect();
    var exist = await data.query("clase", where: "Nombre = '$name'");
    if (exist.isNotEmpty) {
      return false;
    }
    data.insert("clase", {
      "Nombre": name,
      "Descripcion": description,
      "FechPrio": DateTime.now().difference(DateTime(1970)).inSeconds,
      "cantMateria": 0,
      "IsFav": 0,
    });
    _close(data);
    return true;
  }

  Future<List<Map<String, dynamic>>> getClassFav() async {
    Database data = await _connect();
    late List<Map<String, dynamic>> info;
    info =
        await data.query('clase', orderBy: 'FechPrio DESC', where: "IsFav = 1");
    _close(data);
    return info;
  }

  Future<List<Map<String, dynamic>>> getClass(int id) async {
    Database data = await _connect();
    late List<Map<String, dynamic>> info;
    if (id != -1) {
      info = await data.query('clase',
          where: 'ID = ${id.toString()}', orderBy: 'FechPrio DESC');
      data = await _connect();
      await data.update("clase",
          {"FechPrio": DateTime.now().difference(DateTime(1970)).inSeconds},
          where: "ID = $id");
    } else {
      info = await data.query('clase', orderBy: 'FechPrio DESC');
    }

    _close(data);
    return info;
  }

  Future<bool> createNewMateriaDB(String name, int id) async {
    List<Map<String, dynamic>> myMateria = await getClass(id);
    Database data = await _connect();
    var exist =
        await data.query("materia", where: "Nombre = '$name' ;ID = '$id'");
    if (exist.isNotEmpty) {
      return false;
    }
    await data.insert("materia", {
      "ID": id,
      "Nombre": name,
      "FechPrio": DateTime.now().difference(DateTime(1970)).inSeconds,
      "cantPreg": 0,
    });
    await data.update(
      "clase",
      {
        "cantMateria": myMateria[0]['cantMateria'] + 1,
      },
      where: "ID = ${myMateria[0]['ID']}",
    );
    _close(data);
    return true;
  }

  Future<List<Map<String, dynamic>>> getMaterialClass(int id) async {
    Database data = await _connect();
    List<Map<String, dynamic>> inf = await data.query('materia',
        where: 'ID = ${id.toString()}', orderBy: 'FechPrio DESC');
    _close(data);
    return inf;
  }

  Future<Map<String, dynamic>> getMaterialID(int id) async {
    Database data = await _connect();
    List<Map<String, dynamic>> inf = await data.query('materia',
        where: 'ID_subclass = ${id.toString()}', orderBy: 'FechPrio DESC');
    _close(data);
    return inf[0];
  }

  Future<List<Map<String, dynamic>>> getQuests(int idMateria) async {
    Database data = await _connect();
    List<Map<String, dynamic>> myRequest = await data.query('pregunta',
        where: 'ID_subclass = ${idMateria.toString()}');
    _close(data);
    return myRequest;
  }

  Future<bool> deletedClass(int idClass) async {
    Database data = await _connect();
    var myMaterials =
        await data.query('materia', where: 'ID = ${idClass.toString()}');
    for (int i = 0; i < myMaterials.length; i++) {
      await deleteMateria(
          myMaterials[i]['ID_subclass'] as int, myMaterials[i]['ID'] as int);
    }
    data = await _connect();
    await data.delete('clase', where: 'ID = ${idClass.toString()}');
    _close(data);
    return true;
  }

  Future<bool> deleteMateria(int id, int idClass) async {
    List<Map<String, dynamic>> myClass = await getClass(idClass);
    Database data = await _connect();
    print(await data.update(
        "clase",
        {
          "cantMateria": myClass[0]['cantMateria'] - 1,
        },
        where: "ID = $idClass"));

    var myInfo =
        await data.query('pregunta', where: 'ID_subclass = ${id.toString()}');
    for (int i = 0; i < myInfo.length; i++) {
      await deletedQuest(myInfo[i]["ID"] as int);
    }
    data = await _connect();
    await data.delete("materia", where: 'ID_subclass = $id');
    _close(data);
    return true;
  }

  Future<bool> createPreg(
      int idClass,
      int idMateria,
      String pregunta,
      String respuesta,
      FilePickerResult? dirPreg,
      FilePickerResult? dirResp) async {
    Database data = await _connect();
    List<Map<String, Object?>> pregs = await data.query('pregunta',
        where: "Pregunta = ? and ID_subclass = ?",
        whereArgs: [pregunta, idMateria]);

    if (pregs.isNotEmpty) {
      return false;
    }

    Directory dirSaveImage = await getApplicationDocumentsDirectory();
    Random random = Random();

    //Logica para cargar imagenes
    String? directionNewImageQuest;
    if (dirPreg != null) {
      await Directory("${dirSaveImage.path.toString()}/Memoritze")
          .create(recursive: true);
      String myExtension = extension(dirPreg.paths[0].toString());

      directionNewImageQuest =
          "${dirSaveImage.path}/Memoritze/${random.nextInt(99999999)}$myExtension";

      File filePreg = File(dirPreg.files.single.path as String);
      await filePreg.copy("$directionNewImageQuest");
      print("se guardo en $directionNewImageQuest");
    }
    String? directionNewImageAnswer;
    if (dirResp != null) {
      await Directory("${dirSaveImage.path.toString()}/Memoritze")
          .create(recursive: true);
      directionNewImageAnswer =
          "${dirSaveImage.path}/Memoritze/${random.nextInt(99999999)}";
      File filePreg = File(dirResp.files.single.path as String);
      filePreg.copy(directionNewImageAnswer);
      print("se guardo en $directionNewImageAnswer");
    }

    List<Map<String, dynamic>> materia = await data.query('materia',
        where: 'ID_subclass = ${idMateria.toString()}',
        orderBy: 'FechPrio DESC');
    await data.insert("pregunta", {
      "ID_class": idClass,
      "ID_subclass": idMateria,
      "Pregunta": pregunta,
      "respuesta": respuesta,
      "eval": 4,
      "dirImagePreg":
          (directionNewImageQuest == null) ? null : directionNewImageQuest,
      "dirImageResp":
          (directionNewImageAnswer == null) ? null : directionNewImageAnswer
    });

    await data.update(
      "materia",
      {"cantPreg": materia[0]['cantPreg'] + 1},
      where: "ID_subclass = $idMateria",
    );
    _close(data);
    return true;
  }

  Future<bool> deletedQuest(int id) async {
    Database data = await _connect();
    Map<String, dynamic> myQuest =
        (await data.query('pregunta', where: 'ID = $id'))[0];

    //Borramos las imagenes
    String? dirResp = myQuest['dirImageResp'];
    String? dirPreg = myQuest['dirImagePreg'];
    if (dirResp != null) {
      try {
        File respFile = File(dirResp);
        respFile.delete();
      } catch (e) {
        print(e);
      }
    }
    if (dirPreg != null) {
      try {
        File respFile = File(dirPreg);
        respFile.delete();
      } catch (e) {
        print(e);
      }
    }

    Map<String, dynamic> myMateria = (await data.query('materia',
        where: 'ID_subclass = ${myQuest['ID_subclass'].toString()}',
        orderBy: 'FechPrio DESC'))[0];
    await data.update(
        "materia",
        {
          "cantPreg": myMateria['cantPreg'] - 1,
        },
        where: "ID_subclass = ${myQuest['ID_subclass']}");

    await data.delete('pregunta', where: 'ID = ${id.toString()}');
    _close(data);
    return true;
  }

  Future<bool> setQuestID(int id, String newPreg, String newResp,
      FilePickerResult? newImagePreg, FilePickerResult? newImageResp) async {
    Directory dirSaveImage = await getApplicationDocumentsDirectory();

    Database data = await _connect();
    var myQuest = (await data.query("pregunta", where: "ID = $id"))[0];

    String? directionNewImageQuest;
    Random random = Random();
    if (newImagePreg != null) {
      try {
        File respFile = File(myQuest["dirImagePreg"] as String);
        print(await respFile.delete());
      } catch (e) {
        print(e);
      }
      data = await _connect();
      String myExtension = extension(newImagePreg.paths[0].toString());

      directionNewImageQuest =
          "${dirSaveImage.path}/Memoritze/${random.nextInt(99999999)}$myExtension";
      await data.update('pregunta', {"dirImagePreg": directionNewImageQuest},
          where: 'ID = ${id.toString()}');
      data = await _connect();
      await Directory("${dirSaveImage.path.toString()}/Memoritze")
          .create(recursive: true);

      File filePreg = File(newImagePreg.files.single.path as String);
      await filePreg.copy("$directionNewImageQuest");
      print("se guardo en $directionNewImageQuest");
    }
    if (newImageResp != null) {
      data = await _connect();

      try {
        File respFile = File(myQuest["dirImageResp"] as String);
        print(await respFile.delete());
      } catch (e) {
        print(e);
      }
      String myExtension = extension(newImageResp.paths[0].toString());

      directionNewImageQuest =
          "${dirSaveImage.path}/Memoritze/${random.nextInt(99999999)}$myExtension";

      await data.update('pregunta', {"dirImageResp": directionNewImageQuest},
          where: 'ID = ${id.toString()}');
      await Directory("${dirSaveImage.path.toString()}/Memoritze")
          .create(recursive: true);

      File filePreg = File(newImageResp.files.single.path as String);
      await filePreg.copy("$directionNewImageQuest");
      print("se guardo en $directionNewImageQuest");
    }
    data = await _connect();
    await data.update('pregunta', {"Pregunta": newPreg, "respuesta": newResp},
        where: 'ID = ${id.toString()}');

    _close(data);
    return false;
  }

  Future<bool> upDownEvalQuest(int id, int change) async {
    Database data = await _connect();
    Map<String, dynamic> myQuest =
        (await data.query('pregunta', where: 'ID = ${id.toString()}'))[0];

    if (change > 0) {
      await data.update("pregunta", {"eval": min(myQuest['eval'] + change, 7)},
          where: 'ID = $id');
    } else {
      await data.update("pregunta", {"eval": max(myQuest['eval'] + change, 1)},
          where: 'ID = $id');
    }

    _close(data);
    return true;
  }

  Future<Map<String, dynamic>> createJson(
      int idClass, List<int> listIndex, bool onlyText) async {
    Map<String, dynamic> myClass = (await getClass(idClass))[0];
    Setting mySetting = Setting();
    var myJson = {
      "versionCreate": mySetting.version0,
      "name": myClass["Nombre"],
    };
    var material = [];
    for (int i = 0; i < listIndex.length; i++) {
      Map<String, dynamic> myMaterial = (await getMaterialID(listIndex[i]));
      Database data = await _connect();
      List<Map<String, dynamic>> myQuests = await data.query('pregunta',
          where: 'ID_subclass = ${listIndex[i].toString()}',
          columns: ["Pregunta", "respuesta", "dirImagePreg", "dirImageResp"]);
      _close(data);

      List<Map<String, dynamic>> InfoPregs = [];

      for (int i = 0; i < myQuests.length; i++) {
        Map<String, dynamic> quest = myQuests[i];

        InfoPregs.add({
          "Pregunta": quest["Pregunta"],
          "respuesta": quest["respuesta"],
          "filePreg": (quest["dirImagePreg"] != null)
              ? {
                  "file": await File(quest["dirImagePreg"]).readAsBytes(),
                  "extension": extension(quest["dirImagePreg"]),
                }
              : null,
          "fileResp": (quest["dirImageResp"] != null)
              ? {
                  "file": await File(quest["dirImageResp"]).readAsBytes(),
                  "extension": extension(quest["dirImageResp"]),
                }
              : null,
        });
      }
      material.add({
        "name_materia": myMaterial["Nombre"],
        "preguntas": InfoPregs,
      });
    }
    myJson.addAll({"Material": material});

    return myJson;
  }

  Future<String> chargeNewInfoV18(Map<String, dynamic> info) async {
    String name = info["name"];
    print("name ${info["name"]}");
    try {
      await createClass(name, "Actualizar");
    } catch (e) {
      print(e);
      return "ocurrio un error al crear la materia";
    }

    Database data = await _connect();
    late Map<String, Object?> infoClass;
    try {
      infoClass = (await data.query("clase", where: "Nombre = '$name'"))[0];
    } catch (e) {
      print(e);
      return "hubo un problema al querer fitrar la informacion";
    }

    int idClass = infoClass['ID'] as int;
    var material = info["Material"];

    late var directionDocument;
    try {
      directionDocument = await getApplicationDocumentsDirectory();
    } catch (e) {
      print(e);
      return "parece que tenemos error al querer almacenar imagenes";
    }

    Random random = Random();

    for (int i = 0; i < material.length; i++) {
      String nameMateria = material[i]["name_materia"];
      await createNewMateriaDB(nameMateria, idClass);

      Database data = await _connect();
      final int IdMateria = (await data.query("materia",
          where: "Nombre = '$nameMateria'"))[0]['ID_subclass'] as int;
      _close(data);

      List<dynamic> myQuests = material[i]["preguntas"];

      for (int j = 0; j < myQuests.length; j++) {
        await createPreg(idClass, IdMateria, myQuests[j]["Pregunta"] as String,
            myQuests[j]["respuesta"] as String, null, null);

        if (myQuests[j]["fileResp"] != null) {
          String myExt = myQuests[j]["fileResp"]["extension"];
          List<dynamic> myData = myQuests[j]["fileResp"]["file"];

          String path =
              "${directionDocument.path}/Memoritze/${random.nextInt(99999999)}$myExt";

          File myNewFile = File(path);
          myNewFile.writeAsBytesSync(List<int>.from(myData));
          data = await _connect();
          data.update("pregunta", {"dirImageResp": path},
              where: "Pregunta = ?", whereArgs: [myQuests[j]["Pregunta"]]);
        }
        if (myQuests[j]["filePreg"] != null) {
          String myExt = myQuests[j]["filePreg"]["extension"];
          List<dynamic> myData = myQuests[j]["filePreg"]["file"];

          String path =
              "${directionDocument.path}/Memoritze/${random.nextInt(99999999)}$myExt";

          File myNewFile = File(path);
          myNewFile.writeAsBytesSync(List<int>.from(myData));
          data = await _connect();
          data.update("pregunta", {"dirImagePreg": path},
              where: "Pregunta = ?", whereArgs: [myQuests[j]["Pregunta"]]);
        }
      }
    }
    return "Carga exitosa";
  }

  Future<String> chargeNewInfo(Map<String, dynamic> info) async {
    if (info.keys.toString() != "(versionCreate, name, Material)") {
      return "Algo anda mal con el archivo";
    }
    if (info["versionCreate"] < 16 || 18 < info["versionCreate"]) {
      return "La version de creacion no es valida";
    }
    if (info["versionCreate"] == 18) {
      return chargeNewInfoV18(info);
    }

    String name = info["name"];
    await createClass(name, "Actualizar");

    Database data = await _connect();
    Map<String, Object?> infoClass =
        (await data.query("clase", where: "Nombre = '$name'"))[0];

    int idClass = infoClass['ID'] as int;
    var material = info["Material"];

    for (int i = 0; i < material.length; i++) {
      String nameMateria = material[i]["name_materia"];
      await createNewMateriaDB(nameMateria, idClass);

      Database data = await _connect();
      final int IdMateria = (await data.query("materia",
          where: "Nombre = '$nameMateria'"))[0]['ID_subclass'] as int;
      _close(data);

      List<dynamic> myQuests = material[i]["preguntas"];
      for (int j = 0; j < myQuests.length; j++) {
        await createPreg(idClass, IdMateria, myQuests[j]["Pregunta"] as String,
            myQuests[j]["respuesta"] as String, null, null);
      }
    }
    return "Carga exitosa";
  }

  Future<bool> joinFavorite(int id) async {
    Database data = await _connect();
    List<Map<String, Object?>> myData =
        await data.query("clase", where: "ID = $id");
    if (myData.length != 1) {
      print("error aqui");
      return false;
    }
    int isFav = myData[0]['IsFav'] as int;
    // ignore: unrelated_type_equality_checks
    await data.update("clase", {"IsFav": (isFav + 1) % 2}, where: "ID = $id");
    _close(data);
    return true;
  }

  Future<bool> eraseImage(int idQuest, int idImage) async {
    if (idImage > 1 || idImage < 0) {
      return false;
    }
    Database data = await _connect();
    var resp = (await data.query("pregunta", where: "ID = $idQuest"));
    if (resp.length != 1) {
      return false;
    }
    _close(data);
    var myQuest = resp[0];

    String? miImage =
        myQuest[(idImage == 0) ? "dirImagePreg" : "dirImageResp"] as String?;

    if (miImage != null) {
      try {
        File respFile = File(
            myQuest[(idImage == 0) ? "dirImagePreg" : "dirImageResp"]
                as String);
        print(await respFile.delete());
      } catch (e) {
        print(e);
        return false;
      }
    }
    data = await _connect();
    data.update(
        "pregunta", {(idImage == 0) ? "dirImagePreg" : "dirImageResp": null},
        where: "ID = $idQuest");
    _close(data);
    return true;
  }
}
