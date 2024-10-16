import 'package:flutter/material.dart';
import 'package:meu_estoque_app/models/produto.dart';
import 'package:meu_estoque_app/services/produto_service.dart';
import 'package:meu_estoque_app/models/estoque.dart';
import 'edit_produto_screen.dart';

class ProdutoScreen extends StatefulWidget {
  final Estoque estoque;

  ProdutoScreen({required this.estoque});

  @override
  _ProdutoScreenState createState() => _ProdutoScreenState();
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  final ProdutoService _produtoService = ProdutoService();
  List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _fetchProdutos();
  }

  Future<void> _fetchProdutos() async {
    final produtos =
        await _produtoService.getProdutosByEstoque(widget.estoque.id!);
    setState(() {
      _produtos = produtos;
    });
  }

  void _navigateToEditScreen(Produto produto) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditProdutoScreen(produto: produto)),
    ).then((value) {
      if (value != null && value == true) {
        _fetchProdutos(); // Atualiza a lista após editar
      }
    });
  }

  Future<void> _createProduto() async {
    final currentDateTime = DateTime.now().toIso8601String();
    final newProduto = Produto(
      idEstoque: widget.estoque.id!, // Usa o idEstoque do estoque atual
      codigoBarras: '0000000000000',
      nome: 'Novo Produto',
      quantidade: 100,
      quantidadeMinima: 10,
      dataCadastro: currentDateTime,
      valorPago: 10.0,
    );
    await _produtoService.createProduto(newProduto);
    _fetchProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos em ${widget.estoque.nome}'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _createProduto,
            child: Text('Adicionar Produto'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _produtos.length,
              itemBuilder: (context, index) {
                final produto = _produtos[index];
                return ListTile(
                  title: Text(produto.nome),
                  subtitle: Text(
                      'Preço: ${produto.valorPago} - Quantidade: ${produto.quantidade}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _navigateToEditScreen(produto);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _produtoService.deleteProduto(produto.id!);
                          _fetchProdutos();
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
