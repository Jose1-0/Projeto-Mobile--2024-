import '../database/database_helper.dart';
import '../models/movimentacao.dart';

class MovimentacaoService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> createMovimentacao(Movimentacao movimentacao) async {
    final db = await _databaseHelper.database;
    return await db.insert('Movimentacao', movimentacao.toMap());
  }

  Future<List<Movimentacao>> getMovimentacoes() async {
    final db = await _databaseHelper.database;
    final res = await db.query('Movimentacao');
    return res.isNotEmpty
        ? res.map((c) => Movimentacao.fromMap(c)).toList()
        : [];
  }

  Future<int> updateMovimentacao(Movimentacao movimentacao) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Movimentacao',
      movimentacao.toMap(),
      where: 'id_movimentacao = ?',
      whereArgs: [movimentacao.id],
    );
  }

  Future<int> deleteMovimentacao(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'Movimentacao',
      where: 'id_movimentacao = ?',
      whereArgs: [id],
    );
  }
}
