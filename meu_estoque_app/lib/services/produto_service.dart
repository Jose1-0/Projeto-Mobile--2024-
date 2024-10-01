import '../database/database_helper.dart';
import '../models/produto.dart';

class ProdutoService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> createProduto(Produto produto) async {
    final db = await _databaseHelper.database;
    return await db.insert('Produto', produto.toMap());
  }

  Future<List<Produto>> getProdutos() async {
    final db = await _databaseHelper.database;
    final res = await db.query('Produto');
    return res.isNotEmpty ? res.map((c) => Produto.fromMap(c)).toList() : [];
  }

  Future<int> updateProduto(Produto produto) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Produto',
      produto.toMap(),
      where: 'id_produto = ?',
      whereArgs: [produto.id],
    );
  }

  Future<int> deleteProduto(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'Produto',
      where: 'id_produto = ?',
      whereArgs: [id],
    );
  }
}
