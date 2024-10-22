import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;


  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'estoque.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Estoque (
        id_estoque INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        data_criacao DATE DEFAULT (date('now')),
        data_atualizacao DATE DEFAULT (date('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE Categoria (
        id_categoria INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Produto (
        id_produto INTEGER PRIMARY KEY AUTOINCREMENT,
        id_estoque INTEGER NOT NULL,
        id_categoria INTEGER,
        codigo_barras TEXT,
        nome TEXT NOT NULL,
        quantidade INTEGER DEFAULT 0,
        quantidade_minima INTEGER DEFAULT 0,
        data_validade DATE,
        data_cadastro DATE DEFAULT (date('now')),
        valor_pago REAL,
        FOREIGN KEY (id_estoque) REFERENCES Estoque(id_estoque) ON DELETE CASCADE,
        FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
      )
    ''');

    await db.execute('''
      CREATE TABLE Movimentacao (
        id_movimentacao INTEGER PRIMARY KEY AUTOINCREMENT,
        id_produto INTEGER NOT NULL,
        tipo_movimentacao TEXT NOT NULL,
        quantidade INTEGER NOT NULL,
        data_movimentacao DATE DEFAULT (date('now')),
        valor_total REAL,
        FOREIGN KEY (id_produto) REFERENCES Produto(id_produto) ON DELETE CASCADE
      )
    ''');
  }
}
