import '../database/database_helper.dart';
import '../models/categoria.dart';

class CategoriaService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> createCategoria(Categoria categoria) async {
    final db = await _databaseHelper.database;
    return await db.insert('Categoria', categoria.toMap());
  }

  Future<List<Categoria>> getCategorias() async {
    final db = await _databaseHelper.database;
    final res = await db.query('Categoria');
    return res.isNotEmpty ? res.map((c) => Categoria.fromMap(c)).toList() : [];
  }

  Future<int> updateCategoria(Categoria categoria) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Categoria',
      categoria.toMap(),
      where: 'id_categoria = ?',
      whereArgs: [categoria.id],
    );
  }

  Future<int> deleteCategoria(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'Categoria',
      where: 'id_categoria = ?',
      whereArgs: [id],
    );
  }
}
