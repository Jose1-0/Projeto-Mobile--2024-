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
        title: Text(
          'Produtos no Estoque: ${widget.estoque.nome}',
          style: const TextStyle(color: Colors.white),
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
              onPressed: _createProduto,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Adicionar Produto',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
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
            Expanded(
              child: _produtos.isNotEmpty
                  ? ListView.builder(
                      itemCount: _produtos.length,
                      itemBuilder: (context, index) {
                        final produto = _produtos[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              produto.nome,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text('Quantidade: ${produto.quantidade}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.deepPurple),
                                  onPressed: () {
                                    _navigateToEditProdutoScreen(produto);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await _produtoService.deleteProduto(produto.id!);
                                    _fetchProdutos();
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
                        'Nenhum produto encontrado',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
