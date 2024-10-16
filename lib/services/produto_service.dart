import '../database/database_helper.dart';
import '../models/produto.dart';

class ProdutoService {
  final DatabaseHelper _dbHelper =
      DatabaseHelper(); // Utiliza o construtor para obter a instância única

  Future<void> createProduto(Produto produto) async {
    final db = await _dbHelper.database;
    await db.insert('Produto', produto.toMap());
  }

  Future<List<Produto>> getProdutosByEstoque(int idEstoque) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Produto',
      where: 'id_estoque = ?',
      whereArgs: [idEstoque],
    );
    return List.generate(maps.length, (i) {
      return Produto.fromMap(maps[i]);
    });
  }

  Future<void> updateProduto(Produto produto) async {
    final db = await _dbHelper.database;
    await db.update(
      'Produto',
      produto.toMap(),
      where: 'id_produto = ?',
      whereArgs: [produto.id],
    );
  }

  Future<void> deleteProduto(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'Produto',
      where: 'id_produto = ?',
      whereArgs: [id],
    );
  }
}
