import 'package:flutter/material.dart';
import 'package:meu_estoque_app/models/produto.dart';
import 'package:meu_estoque_app/services/produto_service.dart';

class EditProdutoScreen extends StatefulWidget {
  final Produto produto;

  EditProdutoScreen({required this.produto});

  @override
  _EditProdutoScreenState createState() => _EditProdutoScreenState();
}

class _EditProdutoScreenState extends State<EditProdutoScreen> {
  final ProdutoService _produtoService = ProdutoService();
  late TextEditingController _nomeController;
  late TextEditingController _precoController;
  late TextEditingController _quantidadeController;
  late TextEditingController _codigoBarrasController;
  late TextEditingController _quantidadeMinimaController;
  late TextEditingController _dataCadastroController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.produto.nome);
    _precoController =
        TextEditingController(text: widget.produto.valorPago.toString());
    _quantidadeController =
        TextEditingController(text: widget.produto.quantidade.toString());
    _codigoBarrasController =
        TextEditingController(text: widget.produto.codigoBarras);
    _quantidadeMinimaController =
        TextEditingController(text: widget.produto.quantidadeMinima.toString());
    _dataCadastroController =
        TextEditingController(text: widget.produto.dataCadastro);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _quantidadeController.dispose();
    _codigoBarrasController.dispose();
    _quantidadeMinimaController.dispose();
    _dataCadastroController.dispose();
    super.dispose();
  }

  Future<void> _updateProduto() async {
    final updatedProduto = Produto(
      id: widget.produto.id,
      idEstoque: widget.produto.idEstoque,
      codigoBarras: _codigoBarrasController.text,
      nome: _nomeController.text,
      quantidade: int.parse(_quantidadeController.text),
      quantidadeMinima: int.parse(_quantidadeMinimaController.text),
      dataCadastro: _dataCadastroController.text,
      valorPago: double.parse(_precoController.text),
      idCategoria: widget.produto.idCategoria,
      dataValidade: widget.produto.dataValidade,
    );
    await _produtoService.updateProduto(updatedProduto);
    Navigator.pop(
        context, true); // Retorna true para indicar que a edição foi concluída
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _precoController,
              decoration: InputDecoration(labelText: 'Preço'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quantidadeController,
              decoration: InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _codigoBarrasController,
              decoration: InputDecoration(labelText: 'Código de Barras'),
            ),
            TextField(
              controller: _quantidadeMinimaController,
              decoration: InputDecoration(labelText: 'Quantidade Mínima'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _dataCadastroController,
              decoration: InputDecoration(labelText: 'Data de Cadastro'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProduto,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
