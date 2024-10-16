import 'package:flutter/material.dart';
import 'package:meu_estoque_app/models/estoque.dart';
import 'package:meu_estoque_app/models/produto.dart';
import 'package:meu_estoque_app/services/produto_service.dart';
import 'edit_produto_screen.dart';

class EstoqueProdutosScreen extends StatefulWidget {
  final Estoque estoque;

  EstoqueProdutosScreen({required this.estoque});

  @override
  _EstoqueProdutosScreenState createState() => _EstoqueProdutosScreenState();
}

class _EstoqueProdutosScreenState extends State<EstoqueProdutosScreen> {
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

  void _navigateToEditProdutoScreen(Produto produto) {
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
      idEstoque: widget.estoque.id!,
      codigoBarras: '123456789',
      nome: 'Novo Produto',
      quantidade: 0,
      quantidadeMinima: 1,
      dataCadastro: currentDateTime,
      valorPago: 0.0,
    );
    await _produtoService.createProduto(newProduto);
    _fetchProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos no Estoque: ${widget.estoque.nome}'),
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
                  subtitle: Text('Quantidade: ${produto.quantidade}'),
                  onTap: () {
                    _navigateToEditProdutoScreen(produto);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await _produtoService.deleteProduto(produto.id!);
                      _fetchProdutos();
                    },
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
