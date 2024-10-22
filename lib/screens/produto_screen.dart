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
        title: Text(
          'Produtos em ${widget.estoque.nome}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple, // Cor do AppBar
        centerTitle: true, // Centraliza o título
        elevation: 4, // Sombra
        iconTheme: const IconThemeData(color: Colors.white), // Ícone de seta branco
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _createProduto,
              icon: const Icon(Icons.add, color: Colors.white), // Ícone de adicionar
              label: const Text(
                'Adicionar Produto',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // Cor do texto do botão
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Cor do botão
                minimumSize: const Size(double.infinity, 50), // Largura máxima
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                ),
              ),
            ),
            const SizedBox(height: 20), // Espaçamento entre botão e lista
            Expanded(
              child: _produtos.isNotEmpty
                  ? ListView.builder(
                      itemCount: _produtos.length,
                      itemBuilder: (context, index) {
                        final produto = _produtos[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Bordas arredondadas
                          ),
                          elevation: 3, // Elevação do Card
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              produto.nome,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                                'Preço: ${produto.valorPago} - Quantidade: ${produto.quantidade}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.deepPurple),
                                  onPressed: () {
                                    _navigateToEditScreen(produto);
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
