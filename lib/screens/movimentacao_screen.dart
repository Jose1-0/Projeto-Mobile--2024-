import 'package:flutter/material.dart';
import 'package:meu_estoque_app/models/movimentacao.dart';
import 'package:meu_estoque_app/services/movimentacao_service.dart';
import 'package:meu_estoque_app/services/produto_service.dart'; // Importação do ProdutoService
import 'edit_movimentacao_screen.dart';

class MovimentacaoScreen extends StatefulWidget {
  @override
  _MovimentacaoScreenState createState() => _MovimentacaoScreenState();
}

class _MovimentacaoScreenState extends State<MovimentacaoScreen> {
  final MovimentacaoService _movimentacaoService = MovimentacaoService();
  final ProdutoService _produtoService = ProdutoService(); // Instância do ProdutoService
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
        builder: (context) => EditMovimentacaoScreen(movimentacao: movimentacao),
      ),
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

  // Exibir lista de compras
  void _exibirListaDeCompras(BuildContext context) async {
    final produtosParaCompra = await _produtoService.getProdutosParaCompra();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Lista de Compras'),
          content: SingleChildScrollView(
            child: ListBody(
              children: produtosParaCompra.isNotEmpty
                  ? produtosParaCompra.map(
                    (produto) => Text(
                    '${produto.nome} (Faltam ${produto.quantidade - produto.quantidade})'),
              ).toList()
                  : [Text('Nenhum produto precisa de compra.')],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  // Exibir produtos próximos ao vencimento
  void _exibirProdutosProximosAoVencimento(BuildContext context) async {
    final produtosProximosAoVencimento =
    await _produtoService.getProdutosProximosAoVencimento();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Produtos Próximos ao Vencimento'),
          content: SingleChildScrollView(
            child: ListBody(
              children: produtosProximosAoVencimento.isNotEmpty
                  ? produtosProximosAoVencimento.map(
                    (produto) => Text(
                    '${produto.nome} (Vencimento: ${produto.dataValidade})'),
              ).toList()
                  : [Text('Nenhum produto está próximo ao vencimento.')],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  // Exibir histórico de movimentações com filtro de data
  void _exibirHistoricoMovimentacao(BuildContext context) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (range != null) {
      final totais = await _movimentacaoService.getTotaisPorTipo(range);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Histórico de Movimentações'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total de Entradas: ${totais['entradas']}'),
                Text('Total de Saídas: ${totais['saidas']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fechar'),
              ),
            ],
          );
        },
      );
    }
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
          ElevatedButton(
            onPressed: () => _exibirListaDeCompras(context),
            child: Text('Ver Lista de Compras'),
          ),
          ElevatedButton(
            onPressed: () => _exibirProdutosProximosAoVencimento(context),
            child: Text('Ver Produtos Próximos ao Vencimento'),
          ),
          ElevatedButton(
            onPressed: () => _exibirHistoricoMovimentacao(context),
            child: Text('Histórico de Movimentações'),
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
