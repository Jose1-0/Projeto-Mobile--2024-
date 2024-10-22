import 'package:flutter/material.dart'; // Para o DateTimeRange
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

  // Novo método: Buscar movimentações por intervalo de datas e calcular totais
  Future<Map<String, double>> getTotaisPorTipo(DateTimeRange? range) async {
    final db = await _databaseHelper.database;

    String? where;
    List<dynamic>? whereArgs;

    if (range != null) {
      where = 'data_movimentacao BETWEEN ? AND ?';
      whereArgs = [
        range.start.toIso8601String().split('T')[0],
        range.end.toIso8601String().split('T')[0],
      ];
    }

    final res = await db.query(
      'Movimentacao',
      where: where,
      whereArgs: whereArgs,
    );

    double totalEntradas = 0.0;
    double totalSaidas = 0.0;

    for (var mov in res) {
      final movimentacao = Movimentacao.fromMap(mov);
      if (movimentacao.tipoMovimentacao == 'entrada') {
        totalEntradas += movimentacao.valorTotal;
      } else if (movimentacao.tipoMovimentacao == 'saida') {
        totalSaidas += movimentacao.valorTotal;
      }
    }

    return {
      'entradas': totalEntradas,
      'saidas': totalSaidas,
    };
  }
}
