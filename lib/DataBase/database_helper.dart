import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  // Crear una instancia de esta clase (patrón singleton)
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Obtener la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'informes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Crear la tabla de informes
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE informes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        universidad TEXT,
        tipo_publicacion TEXT,
        red_social TEXT,
        fecha TEXT,
        alcance INTEGER,
        interacciones INTEGER,
        enlace TEXT
      )
    ''');
  }

  // Método para insertar un informe en la base de datos
  Future<int> insertInforme(Map<String, dynamic> informe) async {
    Database db = await database;
    return await db.insert('informes', informe);
  }

  // Método para obtener todos los informes de la base de datos
  Future<List<Map<String, dynamic>>> getInformes() async {
    Database db = await database;
    return await db.query('informes');
  }
}
