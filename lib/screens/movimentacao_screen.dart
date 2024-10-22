import 'package:flutter/material.dart';
import 'package:meu_estoque_app/models/movimentacao.dart';
import 'package:meu_estoque_app/services/movimentacao_service.dart';
import 'package:meu_estoque_app/services/produto_service.dart';
import 'edit_movimentacao_screen.dart';

class MovimentacaoScreen extends StatefulWidget {
  @override
  _MovimentacaoScreenState createState() => _MovimentacaoScreenState();
}

class _MovimentacaoScreenState extends State<MovimentacaoScreen> {
  final MovimentacaoService _movimentacaoService = MovimentacaoService();
  final ProdutoService _produtoService = ProdutoService();
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
            EditMovimentacaoScreen(movimentacao: movimentacao),
      ),
    ).then((value) {
      if (value != null && value == true) {
        _fetchMovimentacoes();
      }
    });
  }

  Future<void> _createMovimentacao() async {
    final newMovimentacao = Movimentacao(
      idProduto: 1,
      tipoMovimentacao: 'entrada',
      quantidade: 10,
      dataMovimentacao: DateTime.now().toIso8601String(),
      valorTotal: 100.0,
    );
    await _movimentacaoService.createMovimentacao(newMovimentacao);
    _fetchMovimentacoes();
  }

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
                  ? produtosParaCompra.map((produto) => Text(
                      '${produto.nome} (Faltam ${produto.quantidade - produto.quantidade})')).toList()
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
                  ? produtosProximosAoVencimento.map((produto) => Text(
                      '${produto.nome} (Vencimento: ${produto.dataValidade})')).toList()
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
        title: const Text(
          'Movimentações',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _createMovimentacao,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Adicionar Movimentação',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _exibirListaDeCompras(context),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: const Text('Ver Lista de Compras'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _exibirProdutosProximosAoVencimento(context),
              icon: const Icon(Icons.warning, color: Colors.white),
              label: const Text('Ver Produtos Próximos ao Vencimento'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _exibirHistoricoMovimentacao(context),
              icon: const Icon(Icons.history, color: Colors.white),
              label: const Text('Histórico de Movimentações'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _movimentacoes.isNotEmpty
                  ? ListView.builder(
                      itemCount: _movimentacoes.length,
                      itemBuilder: (context, index) {
                        final movimentacao = _movimentacoes[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              '${movimentacao.tipoMovimentacao} - ${movimentacao.quantidade} unidades',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              'Valor: ${movimentacao.valorTotal}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.deepPurple),
                                  onPressed: () {
                                    _navigateToEditScreen(movimentacao);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    await _movimentacaoService
                                        .deleteMovimentacao(movimentacao.id!);
                                    _fetchMovimentacoes();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'Nenhuma movimentação encontrada',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
