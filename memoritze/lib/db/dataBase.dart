import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDataBase {
  static final MyDataBase _instance = MyDataBase._internal();

  var initiated = false; //Esto indicara si esta iniciada

  bool getInitiated() {
    return initiated;
  }

  factory MyDataBase() {
    return _instance;
  }

  late Database _database;

  MyDataBase._internal();

  Future<void> init() async {
    Future<Database> database = openDatabase(
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
          FechPrio INTEGER
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
          respuesta TEXT,
          eval INTEGER,
          FOREIGN KEY (ID_subclass) REFERENCES materia(ID_subclass)
          FOREIGN KEY (ID_class) REFERENCES clase(ID)
          );
          ''');

        print("se creo la base de datos");
      },
      // Establece la versión. Esto ejecuta la función onCreate y proporciona una
      // ruta para realizar actualizacones y defradaciones en la base de datos.
      version: 1,
    );

    _database = await database;
    initiated = true;
  }

  bool createClass(String name, String description) {
    if (!_database.isOpen) {
      return false;
    }
    _database.insert("clase", {
      "Nombre": name,
      "Descripcion": description,
      "FechPrio": DateTime.now().difference(DateTime(1970)).inSeconds,
      "cantMateria": 0,
    });

    return true;
  }

  Future<bool> createNewMateriaDB(String name, int id) async {
    _database.insert("materia", {
      "ID": id,
      "Nombre": name,
      "FechPrio": DateTime.now().difference(DateTime(1970)).inSeconds,
      "cantPreg": 0,
    });
    List<Map<String, dynamic>> _myMateria = await getClassID(id);
    print(_myMateria[0]['cantMateria']);
    _database.update(
        "clase",
        {
          "cantMateria": _myMateria[0]['cantMateria'] + 1,
        },
        where: "ID = $id");

    return true;
  }

  Future<List<Map<String, dynamic>>> getmaterialClas(int id) async {
    return _database.query('materia',
        where: 'ID = ${id.toString()}', orderBy: 'FechPrio DESC');
  }

  Future<List<Map<String, dynamic>>> getQuest(int id) async {
    return await _database.query(
      'pregunta',
      where: 'ID_subclass = $id',
    );
  }

  Future<List<Map<String, dynamic>>> getSetting() async {
    return _database.query('setting');
  }

  void updatingSetting(int nightMode, int version, String language) {
    _database.insert("setting",
        {'NightMode': nightMode, 'Version': version, 'Lenguaje': language});
  }

  void changeSetting(int nightMode, int version, String language) {
    _database.update("setting",
        {'NightMode': nightMode, 'Version': version, 'Lenguaje': language});
  }

  Future<List<Map<String, dynamic>>> getClases() async {
    return _database.query('clase', orderBy: 'FechPrio DESC');
  }

  Future<List<Map<String, dynamic>>> getClassID(int id) async {
    return _database.query('clase', where: 'ID = ${id.toString()}');
  }

  Future<bool> deletedClass(int idClass) async {
    await _database.delete('clase', where: 'ID = ${idClass.toString()}');
    await _database.delete('materia', where: 'ID = ${idClass.toString()}');
    return true;
  }

  Future<void> closeDatabase() async {
    await _database.close();
  }
}
