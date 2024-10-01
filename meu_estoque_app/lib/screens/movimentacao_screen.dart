import 'package:flutter/material.dart';
import 'package:meu_estoque_app/models/movimentacao.dart';
import 'package:meu_estoque_app/services/movimentacao_service.dart';
import 'edit_movimentacao_screen.dart';

class MovimentacaoScreen extends StatefulWidget {
  @override
  _MovimentacaoScreenState createState() => _MovimentacaoScreenState();
}

class _MovimentacaoScreenState extends State<MovimentacaoScreen> {
  final MovimentacaoService _movimentacaoService = MovimentacaoService();
  List<Movimentacao> _movimentacoes = [];

  @override
  void initState() {
    super.initState();
    _fetchMovimentacoes();
  }

  Future<void> _fetchMovimentacoes() async {
    final movimentacoes = await _movimentacaoService.getMovimentacoes();
    setState(() {
      _movimentacoes = movimentacoes;
    });
  }

  void _navigateToEditScreen(Movimentacao movimentacao) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditMovimentacaoScreen(movimentacao: movimentacao)),
    ).then((value) {
      if (value != null && value == true) {
        _fetchMovimentacoes(); // Atualiza a lista após editar
      }
    });
  }

  Future<void> _createMovimentacao() async {
    final newMovimentacao = Movimentacao(
      idProduto: 1, // exemplo de idProduto, ajuste conforme necessário
      tipoMovimentacao: 'entrada',
      quantidade: 10,
      dataMovimentacao: DateTime.now().toIso8601String(),
      valorTotal: 100.0,
    );
    await _movimentacaoService.createMovimentacao(newMovimentacao);
    _fetchMovimentacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movimentações'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _createMovimentacao,
            child: Text('Adicionar Movimentação'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _movimentacoes.length,
              itemBuilder: (context, index) {
                final movimentacao = _movimentacoes[index];
                return ListTile(
                  title: Text(
                      '${movimentacao.tipoMovimentacao} - ${movimentacao.quantidade} unidades'),
                  subtitle: Text('Valor: ${movimentacao.valorTotal}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _navigateToEditScreen(movimentacao);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _movimentacaoService
                              .deleteMovimentacao(movimentacao.id!);
                          _fetchMovimentacoes();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
