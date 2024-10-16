import 'package:meu_estoque_app/database/database_helper.dart';
import 'package:meu_estoque_app/models/estoque.dart';

class EstoqueService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> createEstoque(Estoque estoque) async {
    final db = await _databaseHelper.database;
    return await db.insert('Estoque', estoque.toMap());
  }

  Future<List<Estoque>> getEstoques() async {
    final db = await _databaseHelper.database;
    final res = await db.query('Estoque');
    return res.isNotEmpty ? res.map((c) => Estoque.fromMap(c)).toList() : [];
  }

  Future<int> updateEstoque(Estoque estoque) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Estoque',
      estoque.toMap(),
      where: 'id_estoque = ?',
      whereArgs: [estoque.id],
    );
  }

  Future<int> deleteEstoque(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'Estoque',
      where: 'id_estoque = ?',
      whereArgs: [id],
    );
  }
}
